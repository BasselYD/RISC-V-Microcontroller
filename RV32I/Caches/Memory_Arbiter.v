module Memory_Arbiter #(parameter BLOCK_SIZE = 32) (
    input   wire    clk,
    input   wire    rst,

    //  I-CACHE INTERFACE
    input   wire     [31:0]                     inst_memAddress,
    input   wire                                inst_memRead,
    output  reg     [(BLOCK_SIZE*8) - 1:0]      inst_memReadData,
    output  reg                                 inst_memBusy,

    //  D-CACHE INTERFACE
    input   wire    [31:0]                      data_memAddress,
    input   wire                                data_memRead,
    output  reg     [(BLOCK_SIZE*8) - 1:0]      data_memReadData,
    input   wire                                data_memWrite,
    input   wire    [(BLOCK_SIZE*8) - 1:0]      data_memWriteData,
    output  reg                                 data_memBusy,

    // PERIPHERAL INTERFACE
    input   wire    [31:0]                      instrM,
    input   wire    [31:0]                      peripheral_memAddress,
    input   wire                                peripheral_memRead,
    output  reg     [31:0]                      peripheral_memReadData,
    input   wire                                peripheral_memWrite,
    input   wire    [31:0]                      peripheral_memWriteData,
    input   wire    [2:0]                       peripheral_strobe,
    output  reg                                 peripheral_memBusy,
    output  reg                                 peripheral_flush,


    //  AHB ADAPTER INTERFACE
    input   wire    [31:0]      rdata,
    input   wire                ready,
    input   wire    [1:0]       HTRANS,

    output  reg     [31:0]      addr,
    output  reg                 write,
    output  reg     [31:0]      wdata,
    output  reg     [1:0]       transfer
);

localparam NUM_BLOCKS = (BLOCK_SIZE >> 2);

reg [2:0]  requests;  // {Peripheral, Data, Inst}.
reg [2:0]  active_request;

reg [31:0]  inst_address_reg, data_address_reg, peripheral_address_reg, peripheral_wdata_reg;
reg [(BLOCK_SIZE*8) - 1:0] wdata_reg;
reg [2:0]   strobe_reg;
reg         rw_reg, peripheral_rw_reg;

reg [31:0] servicedInstr;

reg [3:0] counter;

wire [31:0] temp_rdata;

always @ (posedge clk or negedge rst) begin
    if (~rst) begin
        inst_address_reg <= 0;
        data_address_reg <= 0;
        strobe_reg       <= 0;
        rw_reg           <= 0;
        requests         <= 0;
        wdata_reg        <= 0;
        peripheral_address_reg  <= 0;
        peripheral_rw_reg       <= 0;
        peripheral_wdata_reg    <= 0;
        servicedInstr <= 0;
    end
    else begin
        if (inst_memRead /*&& ~(|active_request)*/) begin
            inst_address_reg <= inst_memAddress;
            requests[0] <= 1;
        end
        //else begin
        //    requests[0] <= 0;
        //end

        if ((data_memRead || data_memWrite) /*&& ~(|active_request)*/) begin
            data_address_reg <= data_memAddress;
            rw_reg           <= (data_memWrite && ~data_memRead);
            wdata_reg        <= data_memWriteData;

            requests[1] <= 1;
        end
        //else begin
        //    requests[1] <= 0;
        //end

        if ((peripheral_memRead || peripheral_memWrite)  && ~peripheral_memBusy && (instrM != servicedInstr) /*&& ~|{active_request[1],active_request[0]}*/) begin
            servicedInstr <= instrM;
            peripheral_address_reg <= peripheral_memAddress;
            peripheral_rw_reg   <= (peripheral_memWrite && ~peripheral_memRead);
            peripheral_wdata_reg    <= peripheral_memWriteData;
            strobe_reg <= peripheral_strobe;

            requests[2] <= 1;
        end
        //else begin
        //    requests[2] <= 0;
        //end
    end
end

always @(*) begin
    peripheral_memReadData = 0;

    if (requests[0] && active_request[0]) begin  //  I-Cache Request.
        addr     =  inst_address_reg;
        write    =  0;
        wdata    =  0;
        if ((~|HTRANS)) begin
            transfer =  1;   
        end
        else begin
            transfer =  0;  
        end
    end
    else if (requests[1] && active_request[1]) begin //  D-Cache Request.
        addr     =  data_address_reg;
        write    =  rw_reg;
        //wdata    =  wdata_reg;
        
        if ((~|HTRANS)) begin
            transfer =  2;  // Write/Read Cache Line. 
            //transfer =  rw_reg ? 2 : 3;  // Write/Read Cache Line. 
        end
        else begin
            transfer =  0; 
        end
    end
    else if (active_request[2]) begin //  Peripheral Request.
        addr     =  peripheral_address_reg;
        write    =  peripheral_rw_reg;
        if ((~|HTRANS)) begin
            transfer =  3;  // Write/Read from Peripheral. 
            //transfer =  rw_reg ? 4 : 5;  // Write/Read from Peripheral. 
        end
        else begin
            transfer =  0; 
        end
        //peripheral_memBusy = ~ready; //&& (~|HTRANS)

        wdata = 0;
        peripheral_memReadData = 0;
        case (strobe_reg)
            //lb/sb
            3'b000          :       begin
                                        if (peripheral_rw_reg)
                                            wdata[7:0] = peripheral_wdata_reg[7:0];
                                        else 
                                            peripheral_memReadData = {{24{rdata[7]}}, rdata[7:0]};
                                    end

            //lh/sh
            3'b001          :       begin
                                        if (peripheral_rw_reg)
                                            wdata[15:0] = peripheral_wdata_reg[15:0];
                                        else 
                                            peripheral_memReadData = {{16{rdata[15]}}, rdata[15:0]};
                                    end

            //lw/sw
            3'b010          :       begin
                                        if (peripheral_rw_reg)
                                            wdata = peripheral_wdata_reg;               
                                        else 
                                            peripheral_memReadData = rdata;
                                    end

            //lbu
            3'b100          :       begin
                                        peripheral_memReadData = {{24{1'b0}}, rdata[7:0]};
                                    end

            //lhu
            3'b101          :       begin
                                        peripheral_memReadData = {{16{1'b0}}, rdata[15:0]};
                                    end
        endcase
    end
    else begin
        addr     =  0;
        write    =  0;
        wdata    =  0;
        transfer =  0; 
        peripheral_memReadData = 0;
    end
end

always @ (*) begin
    if (requests[0]) begin
        inst_memBusy = ~(counter == (NUM_BLOCKS+1) && ready);
    end
    else begin
        inst_memBusy = 0;
    end

    if (requests[1]) begin
        data_memBusy = ~(counter == (NUM_BLOCKS+1) && ready && ~requests[0]);
    end
    else begin
        data_memBusy = 0;
    end


    peripheral_memBusy = requests[2];//active_request[2] && (~ready || (|HTRANS));
    //if (requests[2]) begin
    //    peripheral_memBusy = active_request[2];
    //end
    //else begin
    //    peripheral_memBusy = 0;
    //end
end

//always @(*) begin
//    if (requests[0] && ~(|active_request))
//        active_request = {1'b0,1'b0,1'b1};
//    else if (requests[1] && ~(|active_request))
//        active_request = {1'b0,1'b1,1'b0};
//    else if (requests[2] && ~(|active_request) /*&& ~data_memBusy && ~inst_memBusy*/)
//        active_request = {requests[2],1'b0,1'b0};
//
//    else if (active_request[0])
//        active_request = {1'b0,1'b0,requests[0]};
//    else if (active_request[1])
//        active_request = {1'b0,requests[1],1'b0};
//    else if (active_request[2])
//        active_request = {~peripheral_flush,1'b0,1'b0};
//
//    else
//        active_request = 3'b0;
//end

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        counter <= 0;
        inst_memReadData <= 0;
        data_memReadData <= 0;
        active_request <= 0;
        peripheral_flush <= 0;
    end
    else begin
        if (requests[0] && ~(|active_request))
            active_request[0] <= 1;
        else if (requests[1] && ~(|active_request))
            active_request[1] <= 1;
        else if (requests[2] && ~(|active_request) && ~peripheral_flush/*&& ~data_memBusy && ~inst_memBusy*/) begin
            active_request[2] <= 1;
            //requests[2] <= 0;
        end

        if (requests[0] && active_request[0]) begin
            if (counter == 0 && (~|HTRANS)) begin
                counter <= 1;
                inst_memReadData <= 0;
            end
        
            if (counter == (NUM_BLOCKS+1) && ready) begin
                //inst_memBusy <= 0;
                //inst_memReadData <= 0;
                counter <= 0;
                requests[0] <= 0;
                active_request[0] <= 0;
            end
            else begin
                //inst_memBusy <= 1;
                if (counter != 0 && ready) begin
                    counter <= counter + 1;
                end
            end  
            
            if (counter != 0) begin
                inst_memReadData <= inst_memReadData | (temp_rdata << ((NUM_BLOCKS - counter + 1) << 5));
            end
        end

        else if (requests[1] && active_request[1]) begin
            if (counter == 0 && (~|HTRANS)) begin
                counter <= 1;
                data_memReadData <= 0;
            end
        
            if (counter == (NUM_BLOCKS+1) && ready) begin
                //data_memBusy <= 0;\
                //data_memReadData <= 0;
                counter <= 0;
                requests[1] <= 0;
                active_request[1] <= 0;
            end
            else begin
                //data_memBusy <= 1;
                if (counter != 0 && ready) begin
                    counter <= counter + 1;
                end
            end  
            
            if (counter != 0 && ready) begin
                if (rw_reg) begin
                    wdata <= (wdata_reg & (32'hFFFFFFFF << ((NUM_BLOCKS - counter) << 5))) >> ((NUM_BLOCKS - counter) << 5);
                end
                else begin
                    data_memReadData <= data_memReadData | (temp_rdata << ((NUM_BLOCKS - counter + 1) << 5));
                end
            end   
        end

        //if (peripheral_flush) 
        if (active_request[2]) begin
            //requests[2] <= 0;
            if (ready && (~|HTRANS)) begin
                //if (!((peripheral_memRead || peripheral_memWrite)))
                requests[2] <= 0;
                active_request[2] <= 0;
                peripheral_flush <= 1;
            end
        end
        else begin
            peripheral_flush <= 0;
        end
        
    end
    
end

//assign peripheral_flush = active_request[2] && ready && (~|HTRANS);

assign temp_rdata = {rdata[7:0], rdata[15:8], rdata[23:16], rdata[31:24]};

endmodule