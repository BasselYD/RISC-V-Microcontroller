module MEM_WB_Reg (
    //Control Unit - Memory
    input       wire                    RegWriteM,
    input       wire        [2:0]       ResultSrcM,

    input       wire        [31:0]      ALUResultM,
    input       wire        [31:0]      ReadDataM,
    input       wire        [4:0]       RdM,
    input       wire        [31:0]      ExtImmM,
    input       wire        [31:0]      PcTargetM,
    input       wire        [31:0]      PCPlus4M,

    input       wire                    CLK,
    input       wire                    RST,

    //Control Unit - WriteBack
    output      reg                     RegWriteW,
    output      reg         [2:0]       ResultSrcW,

    output      reg         [31:0]      ALUResultW,
    output      reg         [31:0]      ReadDataW,
    output      reg         [4:0]       RdW,
    output      reg         [31:0]      ExtImmW,
    output      reg         [31:0]      PcTargetW,
    output      reg         [31:0]      PCPlus4W
);
    

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                RegWriteW   <=   0;
                ResultSrcW  <=   0;

                ALUResultW  <=   0;
                ReadDataW   <=   0;
                RdW         <=   0;
                ExtImmW     <=   0;
                PcTargetW   <=   0;
                PCPlus4W    <=   0;
            end
        else
            begin
                RegWriteW   <=   RegWriteM;
                ResultSrcW  <=   ResultSrcM;

                ALUResultW  <=   ALUResultM;
                ReadDataW   <=   ReadDataM;
                RdW         <=   RdM;
                ExtImmW     <=   ExtImmM;
                PcTargetW   <=   PcTargetM;
                PCPlus4W    <=   PCPlus4M;
            end
    end


endmodule

