module PCTargetAdder (
    input       wire        [31:0]      PCE,
    input       wire        [31:0]      ExtImmE,
    output      wire        [31:0]      PcTargetE
);

assign      PcTargetE   =   PCE + ExtImmE;

endmodule
