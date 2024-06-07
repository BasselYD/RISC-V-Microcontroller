module EX_MEM_Reg (
    //Control Unit - Execute
    input       wire                    RegWriteE,
    input       wire        [2:0]       ResultSrcE,
    input       wire                    MemWriteE,
    input       wire                    MemReadE,
    input       wire        [2:0]       StrobeE,
    input       wire                    isPeripheralE,
    input       wire        [4:0]       Rs1E,
    input       wire        [4:0]       Rs2E,

    input       wire        [31:0]      ALUResultE,
    input       wire        [31:0]      WriteDataE,
    input       wire        [4:0]       RdE,
    input       wire        [31:0]      ExtImmE,
    input       wire        [31:0]      PcTargetE,
    input       wire        [31:0]      PCPlus4E,
    input       wire        [31:0]      csrDataE,
    input       wire        [31:0]      InstrE,

    input       wire                    clk,
    input       wire                    rst,
    input       wire                    FLUSH,
    input       wire                    EN, 

    //Control Unit - Memory
    output      reg                     RegWriteM,
    output      reg         [2:0]       ResultSrcM,
    output      reg                     MemWriteM,
    output      reg                     MemReadM,
    output      reg         [2:0]       StrobeM,
    output      reg                     isPeripheralM,
    output      reg         [4:0]       Rs1M,
    output      reg         [4:0]       Rs2M,
 
    output      reg         [31:0]      InstrM,
    output      reg         [31:0]      ALUResultM,
    output      reg         [31:0]      WriteDataM,
    output      reg         [4:0]       RdM,
    output      reg         [31:0]      ExtImmM,
    output      reg         [31:0]      PcTargetM,
    output      reg         [31:0]      PCPlus4M,
    output      reg         [31:0]      csrDataM
);
    

always @ (posedge clk or negedge rst)
    begin
        if (!rst)
            begin
                RegWriteM   <=   0;
                ResultSrcM  <=   0;
                MemWriteM   <=   0;
                MemReadM    <=   0;
                StrobeM     <=   0;
                isPeripheralM <= 0;
                Rs1M        <=   0;
                Rs2M        <=   0;

                ALUResultM  <=   0;
                WriteDataM  <=   0;
                RdM         <=   0;
                ExtImmM     <=   0;
                PcTargetM   <=   0;
                PCPlus4M    <=   0;
                csrDataM    <=   0;
                InstrM <= 0;
            end
        else if (FLUSH) begin
                RegWriteM   <=   0;
                ResultSrcM  <=   0;
                MemWriteM   <=   0;
                MemReadM    <=   0;
                StrobeM     <=   0;
                isPeripheralM <= 0;
                Rs1M        <=   0;
                Rs2M        <=   0;

                ALUResultM  <=   0;
                WriteDataM  <=   0;
                RdM         <=   0;
                ExtImmM     <=   0;
                PcTargetM   <=   0;
                PCPlus4M    <=   0;
                csrDataM    <=   0;
                InstrM <= 0;
        end
        else
            begin
                if (EN)
                    begin
                        RegWriteM   <=   RegWriteE;
                        ResultSrcM  <=   ResultSrcE;
                        MemWriteM   <=   MemWriteE;
                        MemReadM    <=   MemReadE;
                        StrobeM     <=   StrobeE;
                        isPeripheralM <= isPeripheralE;
                        Rs1M        <=   Rs1E;
                        Rs2M        <=   Rs2E;

                        ALUResultM  <=   ALUResultE;
                        WriteDataM  <=   WriteDataE;
                        RdM         <=   RdE;
                        ExtImmM     <=   ExtImmE;
                        PcTargetM   <=   PcTargetE;
                        PCPlus4M    <=   PCPlus4E;
                        csrDataM    <=   csrDataE;
                        InstrM <= InstrE;
                    end
            end
    end


endmodule
