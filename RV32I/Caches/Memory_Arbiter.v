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
    input   wire    [31:0]                      data_memWriteData,
    input   wire    [2:0]                       data_strobe,
    output  reg                                 data_memBusy,


    //  AHB ADAPTER INTERFACE
    input   wire    [31:0]      rdata,
    input   wire                ready,
    input   wire    [1:0]       HTRANS,

    output  reg     [31:0]      addr,
    output  reg                 write,
    output  reg     [31:0]      wdata,
    output  reg     [2:0]       transfer
);

localparam NUM_BLOCKS = (BLOCK_SIZE >> 2);

reg [1:0]  requests;  // {Data, Inst}.

reg [31:0]  inst_address_reg, data_address_reg, wdata_reg;
reg [2:0]   strobe_reg;
reg         rw_reg;

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
    end
    else begin
        if (inst_memRead) begin
            inst_address_reg <= inst_memAddress;
            requests[0] <= 1;
        end
        else begin
            requests[0] <= 0;
        end

        if (data_memRead || data_memWrite) begin
            data_address_reg <= data_memAddress;
            strobe_reg       <= data_strobe;
            rw_reg           <= (data_memWrite && ~data_memRead);
            wdata_reg        <= data_memWriteData;

            requests[1] <= 1;
        end
        else begin
            requests[1] <= 0;
        end
    end
end

always @(*) begin
    if (requests[0]) begin
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
    else begin
        if (requests[1] && (~|HTRANS)) begin
            addr     =  data_address_reg;
            write    =  rw_reg;
            wdata    =  wdata_reg;
            transfer =  2;   //  Change to depend on strobe.
        end
        else begin
            addr     =  0;
            write    =  0;
            wdata    =  0;
            transfer =  0; 
        end
    end
end

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        counter <= 0;
        inst_memReadData <= 0;
    end
    else begin
        if (counter == 0 && requests[0] && (~|HTRANS)) begin
            counter <= 1;
            //inst_memReadData <= 0;
        end
    
        if (counter == NUM_BLOCKS && ready) begin
            inst_memBusy <= 0;
            counter <= 0;
        end
        else begin
            inst_memBusy <= 1;
            if (counter != 0 && ready) begin
                counter <= counter + 1;
            end
        end  
        
        if (counter != 0) begin
            inst_memReadData <= inst_memReadData | (temp_rdata << ((NUM_BLOCKS - counter ) << 5));
        end
    end
    
end

assign temp_rdata = {rdata[7:0], rdata[15:8], rdata[23:16], rdata[31:24]};

endmodule