module IF_ID_Reg (
    input       wire       [31:0]       InstrF,
    input       wire       [31:0]       PCF,
    input       wire       [31:0]       PCPlus4F,
    input       wire                    CLK,
    input       wire                    FLUSH,
    input       wire                    EN, 
    output      reg        [31:0]       InstrD,
    output      reg        [31:0]       PCD,
    output      reg        [31:0]       PCPlus4D
);

always @ (posedge CLK or posedge FLUSH)
    begin
        if (FLUSH)
            begin
                InstrD <= 0;
                PCD <= 0;
                PCPlus4D <= 0;
            end
        else
            begin
                if (EN)
                    begin
                        InstrD <= InstrF;
                        PCD <= PCF;
                        PCPlus4D <= PCPlus4F;
                    end
            end
    end

endmodule
