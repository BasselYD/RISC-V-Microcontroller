module Mux_2to1(
    input       wire    [31:0]      I0,
    input       wire    [31:0]      I1,
    input       wire                SEL,
    output      wire    [31:0]      Y
);

assign  Y   =   SEL ?   I1 : I0;

endmodule
