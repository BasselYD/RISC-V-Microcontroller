module HazardUnit (
    input       wire        [4:0]       Rs1D,
    input       wire        [4:0]       Rs2D,
    input       wire        [4:0]       Rs1E,
    input       wire        [4:0]       Rs2E,
    input       wire        [4:0]       Rs1M,
    input       wire        [4:0]       Rs2M,
    input       wire        [4:0]       RdE,
    input       wire                    PCSrcE,
    input       wire        [2:0]       ResultSrcE,
    input       wire        [2:0]       ResultSrcM,
    input       wire        [2:0]       ResultSrcW,
    input       wire        [4:0]       RdM,
    input       wire                    RegWriteM,
    input       wire        [4:0]       RdW,
    input       wire                    RegWriteW,
    input       wire                    rst,

    output      wire                    StallF,
    output      wire                    StallD,
    output      wire                    FlushD,
    output      wire                    FlushE,
    output      reg         [2:0]       ForwardAE,
    output      reg                     ForwardACSR,
    output      reg         [2:0]       ForwardBE,
    output      reg                     ForwardBCSR,
    output      reg                     ForwardRs1,
    output      reg                     ForwardRs2,
    output      reg                     LSForward
);

wire    lwStall;

always @ (*)
    begin

        //Data Forward from MEM Stage (Operand A)
        if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0))
            begin
                if (ResultSrcM == 3'b011)
                    ForwardAE = 3'b011;

                else if (ResultSrcM == 3'b100)
                    ForwardAE = 3'b100;

                else if (ResultSrcM == 3'b101) begin
                    ForwardAE = 3'b111;
                    ForwardACSR = 0;
                end

                else
                    ForwardAE = 3'b010;
            end

        //Data Forward from WB Stage (Operand A)
        else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0))
            begin
                if (ResultSrcW == 3'b011)
                    ForwardAE = 3'b101;

                else if (ResultSrcW == 3'b100)
                    ForwardAE = 3'b110;

                else if (ResultSrcW == 3'b101) begin
                    ForwardAE = 3'b111;
                    ForwardACSR = 1;
                end
                    
                else
                    ForwardAE = 3'b001;
            end
            
        else
            ForwardAE = 3'b000;


        //Data Forward from MEM Stage (Operand B)
        if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0))
            begin
                if (ResultSrcM == 3'b011)
                    ForwardBE = 3'b011;

                else if (ResultSrcM == 3'b100)
                    ForwardBE = 3'b100;

                else if (ResultSrcM == 3'b101) begin
                    ForwardBE = 3'b111;
                    ForwardBCSR = 0;
                end

                else
                    ForwardBE = 3'b010;
            end

        //Data Forward from WB Stage (Operand B)
        else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0))
            begin
                if (ResultSrcW == 3'b011)
                    ForwardBE = 3'b101;

                else if (ResultSrcW == 3'b100)
                    ForwardBE = 3'b110;

                else if (ResultSrcW == 3'b101) begin
                    ForwardBE = 3'b111;
                    ForwardBCSR = 1;
                end    

                else
                    ForwardBE = 3'b001;
            end
            
        else
            ForwardBE = 3'b000;



        if (((Rs1D == RdW) && RegWriteW) && (Rs1D != 0) && (ResultSrcW == 3'b010))
            ForwardRs1 = 1;

        else    
            ForwardRs1 = 0;


        if (((Rs2D == RdW) && RegWriteW) && (Rs2D != 0) && (ResultSrcW == 3'b010))
            ForwardRs2 = 1;

        else    
            ForwardRs2 = 0;

        if (((Rs1M == RdW) || (Rs2M == RdW)) && (ResultSrcW == 3'b001))
            LSForward = 1;
        else
            LSForward = 0;

    end


assign  lwStall =   ((Rs1D == RdE) || (Rs2D == RdE)) && (ResultSrcE == 3'b001);

assign  StallD  =   lwStall;
assign  StallF  =   lwStall;
assign  FlushD  =   PCSrcE | ~rst;
assign  FlushE  =   PCSrcE | lwStall | ~rst;

    
endmodule
