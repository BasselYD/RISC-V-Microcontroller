module PCPlus4Adder (
    input       wire        [31:0]      PCF,
    output      wire        [31:0]      PCPlus4F
);

assign      PCPlus4F   =   PCF + 4;

endmodule
