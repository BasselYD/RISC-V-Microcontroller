module ID_EX_Reg (
    //Control Unit - Decode
    input       wire                    RegWriteD,
    input       wire        [2:0]       ResultSrcD,
    input       wire                    MemWriteD,
    input       wire                    JumpD,
    input       wire                    JumpTypeD,
    input       wire                    BranchD,
    input       wire        [2:0]       BranchTypeD,
    input       wire        [2:0]       ALUControlD,
    input       wire                    ALUSrcD,
    input       wire        [1:0]       SLTControlD,
    input       wire        [2:0]       StrobeD,

    //RF - Decode
    input       wire        [31:0]      RD1D,
    input       wire        [31:0]      RD2D,

    //Instruction - Decode
    input       wire        [31:0]      PCD,
    input       wire        [4:0]       Rs1D,
    input       wire        [4:0]       Rs2D,
    input       wire        [4:0]       RdD,
    input       wire        [31:0]      ExtImmD,
    input       wire        [31:0]      PCPlus4D,

    input       wire                    RST,
    input       wire                    CLK,
    input       wire                    FLUSH,

    //Control Unit - Execute
    output      reg                     RegWriteE,
    output      reg         [2:0]       ResultSrcE,
    output      reg                     MemWriteE,
    output      reg                     JumpE,
    output      reg                     JumpTypeE,
    output      reg                     BranchE,
    output      reg         [2:0]       BranchTypeE,
    output      reg         [2:0]       ALUControlE,
    output      reg                     ALUSrcE,
    output      reg         [1:0]       SLTControlE,
    output      reg         [2:0]       StrobeE,

    //RF - Execute
    output      reg         [31:0]      RD1E,
    output      reg         [31:0]      RD2E,

    //Instruction - Execute
    output      reg         [4:0]       Rs1E,
    output      reg         [4:0]       Rs2E,
    output      reg         [4:0]       RdE,
    output      reg         [31:0]      ExtImmE,

    output      reg         [31:0]      PCE,
    output      reg         [31:0]      PCPlus4E
);

always @ (posedge CLK or negedge RST)
    begin
        if (FLUSH | !RST)
            begin
                RegWriteE <= 0;
                ResultSrcE <= 0;
                MemWriteE <= 0;
                JumpE <= 0;
                JumpTypeE <= 0;
                BranchE <= 0;
                BranchTypeE <= 0;
                ALUControlE <= 0;
                ALUSrcE <= 0;
                SLTControlE <= 0;
                StrobeE <= 0;

                RD1E <= 0;
                RD2E <= 0;

                PCE <= 0;
                Rs1E <= 0;
                Rs2E <= 0;
                RdE <= 0;
                ExtImmE <= 0;
                PCPlus4E <= 0;
            end
        else
            begin
                RegWriteE <= RegWriteD;
                ResultSrcE <= ResultSrcD;
                MemWriteE <= MemWriteD;
                JumpE <= JumpD;
                JumpTypeE <= JumpTypeD;
                BranchE <= BranchD;
                BranchTypeE <= BranchTypeD;
                ALUControlE <= ALUControlD;
                ALUSrcE <= ALUSrcD;
                SLTControlE <= SLTControlD;
                StrobeE <= StrobeD;

                RD1E <= RD1D;
                RD2E <= RD2D;

                PCE <= PCD;
                Rs1E <= Rs1D;
                Rs2E <= Rs2D;
                RdE <= RdD;
                ExtImmE <= ExtImmD;
                PCPlus4E <= PCPlus4D;
            end
    end
    
endmodule
