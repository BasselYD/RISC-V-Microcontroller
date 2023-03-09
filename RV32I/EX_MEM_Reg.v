module EX_MEM_Reg (
    //Control Unit - Execute
    input       wire                    RegWriteE,
    input       wire        [2:0]       ResultSrcE,
    input       wire                    MemWriteE,
    input       wire        [2:0]       StrobeE,

    input       wire        [31:0]      ALUResultE,
    input       wire        [31:0]      WriteDataE,
    input       wire        [4:0]       RdE,
    input       wire        [31:0]      ExtImmE,
    input       wire        [31:0]      PcTargetE,
    input       wire        [31:0]      PCPlus4E,

    input       wire                    CLK,
    input       wire                    RST,

    //Control Unit - Memory
    output      reg                     RegWriteM,
    output      reg         [2:0]       ResultSrcM,
    output      reg                     MemWriteM,
    output      reg         [2:0]       StrobeM,

    output      reg         [31:0]      ALUResultM,
    output      reg         [31:0]      WriteDataM,
    output      reg         [4:0]       RdM,
    output      reg         [31:0]      ExtImmM,
    output      reg         [31:0]      PcTargetM,
    output      reg         [31:0]      PCPlus4M
);
    

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                RegWriteM   <=   0;
                ResultSrcM  <=   0;
                MemWriteM   <=   0;
                StrobeM     <=   0;

                ALUResultM  <=   0;
                WriteDataM  <=   0;
                RdM         <=   0;
                ExtImmM     <=   0;
                PcTargetM   <=   0;
                PCPlus4M    <=   0;
            end
        else
            begin
                RegWriteM   <=   RegWriteE;
                ResultSrcM  <=   ResultSrcE;
                MemWriteM   <=   MemWriteE;
                StrobeM     <=   StrobeE;

                ALUResultM  <=   ALUResultE;
                WriteDataM  <=   WriteDataE;
                RdM         <=   RdE;
                ExtImmM     <=   ExtImmE;
                PcTargetM   <=   PcTargetE;
                PCPlus4M    <=   PCPlus4E;
            end
    end


endmodule
