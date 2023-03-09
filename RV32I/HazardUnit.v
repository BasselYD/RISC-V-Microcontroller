module HazardUnit (
    input       wire        [4:0]       Rs1D,
    input       wire        [4:0]       Rs2D,
    input       wire        [4:0]       Rs1E,
    input       wire        [4:0]       Rs2E,
    input       wire        [4:0]       RdE,
    input       wire                    PCSrcE,
    input       wire        [2:0]       ResultSrcE,
    input       wire        [4:0]       RdM,
    input       wire                    RegWriteM,
    input       wire        [4:0]       RdW,
    input       wire                    RegWriteW,
    input       wire                    RST,

    output      wire                    StallF,
    output      wire                    StallD,
    output      wire                    FlushD,
    output      wire                    FlushE,
    output      reg         [1:0]       ForwardAE,
    output      reg         [1:0]       ForwardBE
);

wire    lwStall;

always @ (*)
    begin

        //Data Forward from MEM Stage (Operand A)
        if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0))
            ForwardAE = 2'b10;

        //Data Forward from WB Stage (Operand A)
        else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0))
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;

        //Data Forward from MEM Stage (Operand B)
        if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0))
            ForwardBE = 2'b10;

        //Data Forward from WB Stage (Operand B)
        else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0))
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end


assign  lwStall =   ((Rs1D == RdE) || (Rs2D == RdE)) && (ResultSrcE == 3'b001);

assign  StallD  =   lwStall;
assign  StallF  =   lwStall;

assign  FlushD  =   PCSrcE | ~RST;
assign  FlushE  =   PCSrcE | lwStall | ~RST;
    
endmodule
