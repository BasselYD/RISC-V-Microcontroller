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
    input       wire        [31:0]      csrDataM,

    input       wire                    clk,
    input       wire                    rst,
    input       wire                    EN, 

    //Control Unit - WriteBack
    output      reg                     RegWriteW,
    output      reg         [2:0]       ResultSrcW,

    output      reg         [31:0]      ALUResultW,
    output      reg         [31:0]      ReadDataW,
    output      reg         [4:0]       RdW,
    output      reg         [31:0]      ExtImmW,
    output      reg         [31:0]      PcTargetW,
    output      reg         [31:0]      PCPlus4W,
    output      reg         [31:0]      csrDataW
);
    

always @ (posedge clk or negedge rst)
    begin
        if (!rst)
            begin
                RegWriteW   <=   0;
                ResultSrcW  <=   0;

                ALUResultW  <=   0;
                ReadDataW   <=   0;
                RdW         <=   0;
                ExtImmW     <=   0;
                PcTargetW   <=   0;
                PCPlus4W    <=   0;
                csrDataW    <=   0;
            end
        else
            begin
                if (EN)
                    begin
                        RegWriteW   <=   RegWriteM;
                        ResultSrcW  <=   ResultSrcM;

                        ALUResultW  <=   ALUResultM;
                        ReadDataW   <=   ReadDataM;
                        RdW         <=   RdM;
                        ExtImmW     <=   ExtImmM;
                        PcTargetW   <=   PcTargetM;
                        PCPlus4W    <=   PCPlus4M;
                        csrDataW    <=   csrDataM;
                    end
            end
    end


endmodule

