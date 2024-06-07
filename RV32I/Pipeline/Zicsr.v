module Zicsr (
    input  wire          clk,
    input  wire          reset,
    
    input  wire  [11:0]  index,
    input  wire  [31:0]  data,
    input  wire  [1:0]   opcode,
    input  wire          mret,

    input  wire          exception,
    input  wire  [3:0]   exceptionType,
    input  wire  [31:0]  exceptionPC,
    
    input  wire          NMI,
    input  wire          timerInterrupt,
    input  wire  [15:0]  externalInterrupts,
    input  wire          stalled,

    output reg           interrupt_reg,
    output reg   [31:0]  csrData,
    output wire  [31:0]  nextPC
);

//  CSR Indices. 
localparam  MSTATUS   = 12'h300,
            MISA      = 12'h301,
            MIE       = 12'h304,
            MTVEC     = 12'h305,
            MSCRATCH  = 12'h340,
            MEPC      = 12'h341,
            MCAUSE    = 12'h342,
            MTVAL     = 12'h343,
            MIP       = 12'h344,
            MVENDORID = 12'hF11,
            MARCHID   = 12'hF12,
            MIMPID    = 12'hF13,
            MHARTID   = 12'hF14;



//  mie Register Indices.
localparam  mie_MSIE = 3,
            mie_MTIE = 7,
            mie_MEIE = 11;

//  mstatus Register Indices.
localparam  mstatus_MIE = 3,
            mstatus_MPIE = 7;

localparam  RW = 2'b01,
            RS = 2'b10,
            RC = 2'b11;

reg     [31:0]  mstatus, mie, mtvec, mepc, mcause, mtval, mip, mscratch;
reg     [31:0]  mstatus_c, mie_c, mtvec_c, mepc_c, mcause_c, mtval_c, mip_c, mscratch_c;

wire    [31:0]  mvendorid, marchid, mimpid, mhartid;
wire    [31:0]  misa;

reg  NMI_reg, NMI_return;
reg interrupt;
reg  [4:0] currentInterrupt, currentInterrupt_reg;
integer i;

always @ (*) begin
    if (mstatus[mstatus_MIE]) begin
        if (|externalInterrupts & mie[mie_MEIE]) begin
            interrupt = 1;
            currentInterrupt = 31;
            for (i = 31; i >= 16; i = i - 1) begin
                if ((externalInterrupts[i-16] == 1'b1) && mie[i]) begin
                    currentInterrupt = i;
                end
            end
        end
        else if (mip[mie_MSIE] & mie[mie_MSIE]) begin
            interrupt = 1;
            currentInterrupt = 3;
        end
        else if (timerInterrupt & mie[mie_MTIE]) begin
            interrupt = 1;
            currentInterrupt = 7;
        end
        else begin
            interrupt = 0;
            currentInterrupt = 0;
        end
    end
    else begin
        interrupt = 0;
        currentInterrupt = 0;
    end 
end

always @ (posedge clk or negedge reset) begin
    if (!reset) begin
        interrupt_reg <= 0;
        currentInterrupt_reg <= 0;
        NMI_reg <= 0;
        NMI_return <= 1;
    end
    else begin
        interrupt_reg <= ((NMI & NMI_return) | interrupt);
        currentInterrupt_reg <= currentInterrupt;

        NMI_reg <= NMI & NMI_return;
        if (NMI)
            NMI_return <= 0;
        if (mret) 
            NMI_return <= 1;        
    end
end


always @ (*) begin
    
    //                   MPP                 MPIE                        MIE
    mstatus_c = {19'b0, 2'b11, 3'b0, mstatus[mstatus_MPIE], 3'b0, mstatus[mstatus_MIE], 3'b0}; 

    mie_c = mie;
    mip_c = mip;    
    mscratch_c = mscratch;
    mtvec_c = mtvec;
    mtval_c = mtval;
    mcause_c = mcause;
    mepc_c = mepc;
    mtval_c = mtval;
    
    case (index)
        MSTATUS     :   begin
                            csrData = mstatus; 
                        end

        MISA        :   begin
                            csrData = misa;
                        end

        MIE         :   begin
                            csrData = {mie[31:16], 4'b0, mie[mie_MEIE], 3'b0, mie[mie_MTIE], 3'b0, mie[mie_MSIE], 3'b0};
                        end

        MTVEC       :   begin
                            csrData = mtvec; 
                        end

        MSCRATCH    :   begin
                            csrData = mscratch;
                        end

        MEPC        :   begin
                            csrData = mepc;  
                        end

        MCAUSE      :   begin
                            csrData = mcause;  
                        end

        MTVAL       :   begin
                            csrData = mtval;  
                        end

        MIP         :   begin
                            csrData = mip;  
                        end

        MVENDORID   :   begin
                            csrData = mvendorid;
                        end

        MARCHID     :   begin
                            csrData = marchid;  
                        end

        MIMPID      :   begin
                            csrData = mimpid;
                        end

        MHARTID     :   begin
                            csrData = mhartid;
                        end

        default     :   begin
                            csrData = 32'b0;
                        end
        endcase

    if (mret | NMI_reg | exception | interrupt_reg) begin
        if (mret) begin
            mstatus_c[mstatus_MIE]  = mstatus[mstatus_MPIE];
            mstatus_c[mstatus_MPIE] = 1'b1;

            mip_c = mip;
            if (NMI_reg)
                mip_c[0] = 0;
            else if (interrupt_reg) 
                mip_c[currentInterrupt_reg] = 0;
            else
                mip_c = mip;
        end
        else if (NMI_reg && ~stalled) begin
            if (~stalled) begin
                mepc_c = {exceptionPC[31:2], 2'b0};
                mtval_c = 32'b0;
    
                mstatus_c[mstatus_MPIE] = mstatus[mstatus_MIE];
                mstatus_c[mstatus_MIE] = 1'b0;

                mip_c[0] = 1;
            end
            else begin
                mepc_c = mepc;
                mtval_c = mtval;
                mstatus_c = mstatus;
                mip_c = mip;
            end
            mcause_c[31] = 1;
            mcause_c[30:0] = 0;
        end
        else if (interrupt_reg) begin
            if (~stalled) begin
                mepc_c = {exceptionPC[31:2], 2'b0};
                mtval_c = 32'b0;
    
                mstatus_c[mstatus_MPIE] = mstatus[mstatus_MIE];
                mstatus_c[mstatus_MIE] = 1'b0;

                mip_c[currentInterrupt_reg] = 1;
            end
            else begin
                mepc_c = mepc;
                mtval_c = mtval;
                mstatus_c = mstatus;
                mip_c = mip;
            end
            mcause_c[31] = 1;
            mcause_c[30:0] = currentInterrupt_reg;
        end
        else begin
            if (~stalled) begin
                mepc_c = {exceptionPC[31:2], 2'b0};
                mtval_c = 32'b0;
            end
            else begin
                mepc_c = mepc;
                mtval_c = mtval;
            end
            mcause_c[31] = 0;
            mcause_c[30:0] = exceptionType;
        end
    end


    else if (|opcode) begin
        case (index)
        MSTATUS     :   begin
                            csrData = mstatus;
                            case (opcode)
                                RW      : mstatus_c = data;
                                RS      : mstatus_c = mstatus_c | data;
                                RC      : mstatus_c = mstatus_c & ~data;
                                default : mstatus_c = mstatus;
                            endcase    
                        end

        MISA        :   begin
                            csrData = misa;
                        end

        MIE         :   begin
                            csrData = {mie[31:16], 4'b0, mie[mie_MEIE], 3'b0, mie[mie_MTIE], 3'b0, mie[mie_MSIE], 3'b0};
                            case (opcode)
                                RW      : mie_c = data;
                                RS      : mie_c = mie_c | data;
                                RC      : mie_c = mie_c & ~data;
                                default : mie_c = mie;
                            endcase    
                        end

        MTVEC       :   begin
                            csrData = mtvec;
                            case (opcode)
                                RW      : mtvec_c = data;
                                RS      : mtvec_c = mtvec_c | data;
                                RC      : mtvec_c = mtvec_c & ~data;
                                default : mtvec_c = mtvec;
                            endcase    
                        end

        MSCRATCH    :   begin
                            csrData = mscratch;
                            case (opcode)
                                RW      : mscratch_c = data;
                                RS      : mscratch_c = mscratch_c | data;
                                RC      : mscratch_c = mscratch_c & ~data;
                                default : mscratch_c = mscratch;
                            endcase    
                        end

        MEPC        :   begin
                            csrData = mepc;
                            case (opcode)
                                RW      : mepc_c[31:2] = data[31:2];
                                RS      : mepc_c[31:2] = mepc_c[31:2] | data[31:2];
                                RC      : mepc_c[31:2] = mepc_c[31:2] & ~data[31:2];
                                default : mepc_c[31:2] = mepc[31:2];
                            endcase    
                        end

        MCAUSE      :   begin
                            csrData = mcause;
                            case (opcode)
                                RW      : mcause_c = data;
                                RS      : mcause_c = mcause_c | data;
                                RC      : mcause_c = mcause_c & ~data;
                                default : mcause_c = mcause;
                            endcase    
                        end

        MTVAL       :   begin
                            csrData = mtval;
                            case (opcode)
                                RW      : mtval_c = data;
                                RS      : mtval_c = mtval_c | data;
                                RC      : mtval_c = mtval_c & ~data;
                                default : mtval_c = mtval;
                            endcase    
                        end

        MIP         :   begin
                            csrData = mip;
                            mip_c = mip;
                            case (opcode)
                                RW      : mip_c[mie_MSIE] = data[mie_MSIE];
                                RS      : mip_c[mie_MSIE] = mip_c[mie_MSIE] | data[mie_MSIE];
                                RC      : mip_c[mie_MSIE] = mip_c[mie_MSIE] & ~data[mie_MSIE];
                                default : mip_c = mip;
                            endcase    
                        end

        MVENDORID   :   begin
                            csrData = mvendorid;
                        end

        MARCHID     :   begin
                            csrData = marchid;  
                        end

        MIMPID      :   begin
                            csrData = mimpid;
                        end

        MHARTID     :   begin
                            csrData = mhartid;
                        end

        default     :   begin
                            csrData = 32'b0;
                        end
        endcase
    end

    else begin
        //                   MPP                 MPIE                        MIE
        mstatus_c = {19'b0, 2'b11, 3'b0, mstatus[mstatus_MPIE], 3'b0, mstatus[mstatus_MIE], 3'b0};  
        
        mie_c = mie;
        mip_c = mip;    
        mscratch_c = mscratch;
        mtvec_c = mtvec;
        mtval_c = mtval;
        mcause_c = mcause;
        mepc_c = mepc;
        mtval_c = mtval;
        csrData = 0;
    end

    
end 

always @ (posedge clk or negedge reset) begin
    if (!reset) begin
        mstatus <= 0;
        mie <= 0;
        mtvec[31:2] <= 30'h3C00;
        mtvec[1:0] <= 2'b01;    //  Vectored by default.
        mepc <= 0;
        mcause <= 0;
        mtval <= 0;
        mip <= 0;
        mscratch <= 0;
    end
    else begin
        mstatus <= mstatus_c;
        mie <= mie_c;
        mtvec <= mtvec_c;
        mepc <= mepc_c;
        mcause <= mcause_c;
        mtval <= mtval_c;
        mip <= mip_c;
        mscratch <= mscratch_c;
    end
end


assign nextPC = (mcause_c[31]) ? ({mtvec[31:2], 2'b0} + (mcause_c[4:0] << 2)) : {mtvec[31:2], 2'b0};

//                     XLEN=32    I (Base)   M Extension
assign misa = 32'b0 | (1 << 30) | (1 << 8) | (1 << 12);
assign mvendorid = 32'b0;
assign marchid = 32'b0;
assign mhartid = 32'b0;
assign mimpid = {31'b0, 1'b1};


endmodule