module AHB_Master (
    //  Clock and Reset.
    input   wire            HCLK,
    input   wire            HRESETn,

    //  Processor Interface.
    input   wire    [31:0]  addr,
    input   wire            write,
    input   wire    [31:0]  wdata,
    input   wire     [1:0]  transfer,
    output  reg     [31:0]  rdata,
    output  reg             ready,

    //  AHB Interface.
    input   wire    [31:0]  HRDATA,
    input   wire            HRESP,
    input   wire            HREADY,

    output  reg     [31:0]  HADDR,
    output  reg             HWRITE,
    output  reg     [31:0]  HWDATA,
    output  reg     [2:0]   HSIZE,
    output  reg     [1:0]   HTRANS,
    output  reg     [2:0]   HBURST,
    output  reg     [3:0]   HPROT
);

localparam  IDLE    = 4'b0000,
            BUSREQ  = 4'b0001,
            NSEQRD  = 4'b0010,
            SEQRD   = 4'b0011,
            LASTRD  = 4'b0100,
            RDWAIT  = 4'b0101,
            NSEQWR  = 4'b0110,
            SEQWR   = 4'b0111,
            LASTWR  = 4'b1000,
            WRWAIT  = 4'b1001;

reg [3:0]   currentState, nextState;
reg [1:0]   transfer_reg;
reg [31:0]  addr_reg, wdata_reg;
reg [2:0]   counter;
wire        burstComplete;

always @ (posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        currentState <= IDLE;
    end
    else begin
        currentState <= nextState;
    end
end


always @ (*) begin
    case (currentState) 
        IDLE    :   begin
                        if (transfer != 0 && ~write) begin
                            nextState = NSEQRD;
                        end
                        else if (transfer != 0 && write) begin
                            nextState = NSEQWR;
                        end
                        else begin
                            nextState = IDLE;
                        end
                    end

        NSEQRD  :   begin 
                        if (HREADY && ~HRESP) begin
                            if (transfer_reg == 1 || transfer_reg == 2) begin 
                                nextState = SEQRD;  //  I-Cache or D-Cache.
                            end
                            else begin
                                nextState = RDWAIT; //  Peripherals.
                            end 
                        end
                        else begin
                            nextState = NSEQRD;
                        end
                    end

        SEQRD   :   begin
                        if (burstComplete) begin
                            nextState = RDWAIT;
                        end
                        else begin
                            nextState = SEQRD;
                        end
                    end

        RDWAIT  :   begin
                        if (HREADY && ~HRESP) begin
                            nextState = IDLE;
                        end
                        else begin
                            nextState = RDWAIT;
                        end
                    end

        NSEQWR  :   begin
                        if (HREADY && ~HRESP) begin
                            if (transfer_reg == 2) begin 
                                nextState = SEQWR;  //  D-Cache.
                            end
                            else begin
                                nextState = WRWAIT; //  Peripherals.
                            end 
                        end
                        else begin
                            nextState = NSEQWR;
                        end
                    end

        SEQWR   :   begin
                        if (burstComplete) begin
                            nextState = WRWAIT;
                        end
                        else begin
                            nextState = SEQWR;
                        end
                    end

        WRWAIT  :   begin
                        if (HREADY && ~HRESP) begin  
                            nextState = IDLE; 
                        end
                        else begin
                            nextState = WRWAIT;
                        end
                    end

        default :   begin
                        nextState = IDLE; 
                    end


    endcase
end

always @ (*) begin
    rdata = HRDATA;
    HPROT = 4'b0011;    //  PROT not supported, this value is recommended by ARM.
    case (currentState) 
        IDLE    :   begin
                        HADDR  = 32'b0;
                        HWRITE = 0;
                        HWDATA = 32'b0;
                        HTRANS = 0; //  IDLE.
                        HSIZE  = 3'b010;
                        HBURST = 3'b000;
                        
                        ready = 0;
                    end

        NSEQRD  :   begin
                        HADDR  = addr_reg;
                        HWRITE = 0;
                        HWDATA = 32'b0;
                        HTRANS = 2'b10; //  NONSEQ.
                        HSIZE  = 3'b010;
                        if (transfer_reg == 1 || transfer_reg == 2) begin   //  I-Cache or D-Cache.
                            HBURST = 3'b101;                                //  INCR8  
                        end
                        else begin  //  Peripherals.
                            HBURST = 3'b000;
                        end
                        ready = (HREADY && ~HRESP);
                    end

        SEQRD   :   begin
                        HADDR  = addr_reg;
                        HWRITE = 0;
                        HWDATA = 32'b0;
                        HTRANS = 2'b11;     //  SEQ.
                        HSIZE  = 3'b010;
                        HBURST = 3'b101;    //  INCR8  
                        ready = (HREADY && ~HRESP); 
                    end

        RDWAIT  :   begin
                        HADDR  = 0;
                        HWRITE = 0;
                        HWDATA = 32'b0;
                        HTRANS = 2'b00;     //  IDLE.
                        HSIZE  = 3'b010;
                        HBURST = 3'b000;
                        ready = (HREADY && ~HRESP);
                    end
        
        NSEQWR  :   begin
                        HADDR  = addr_reg;
                        HWRITE = 1;
                        HWDATA = 0;
                        HTRANS = 2'b10; //  NONSEQ.
                        HSIZE  = 3'b010;
                        if (transfer_reg == 2) begin    //  D-Cache.
                            HBURST = 3'b101;            //  INCR8  
                        end
                        else begin  //  Peripherals.
                            HBURST = 3'b000;
                        end
                        ready = (HREADY && ~HRESP);
                    end

        SEQWR   :   begin
                        HADDR  = addr_reg;
                        HWRITE = 1;
                        HWDATA = wdata;
                        HTRANS = 2'b10;     //  SEQ.
                        HSIZE  = 3'b010;
                        HBURST = 3'b101;    //  INCR8  
                        ready = (HREADY && ~HRESP);
                    end

        WRWAIT  :   begin
                        HADDR  = 0;
                        HWRITE = 0;
                        HWDATA = wdata;
                        HTRANS = 2'b00; //  IDLE.
                        HSIZE  = 3'b010;
                        HBURST = 3'b000;
                        ready = (HREADY && ~HRESP);
                    end

        default :   begin
                        HADDR  = 32'b0;
                        HWRITE = 0;
                        HWDATA = 32'b0;
                        HTRANS = 0; //  IDLE.
                        HSIZE  = 3'b010;
                        HBURST = 3'b000;
                        
                        ready = 0;
                    end

    endcase
end

always @ (posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        transfer_reg <= 0;
        addr_reg <= 0;
        //wdata_reg <= 0;
        counter <= 0;
    end
    else if (currentState == IDLE && transfer != 0) begin
        transfer_reg <= transfer;
        addr_reg <= addr;
        //if (write) begin
        //    wdata_reg <= wdata;
        //end
        counter <= 0;
    end
    else if (nextState == SEQRD || nextState == SEQWR) begin
        if ((HREADY && ~HRESP)) begin
            addr_reg <= addr_reg + 4;
            counter <= counter + 1;
        end
    end
end
assign burstComplete = (counter == 7);

endmodule