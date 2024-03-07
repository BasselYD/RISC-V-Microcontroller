module Mux_8to1(
    input       wire    [31:0]      I0,
    input       wire    [31:0]      I1,
    input       wire    [31:0]      I2,
    input       wire    [31:0]      I3,
    input       wire    [31:0]      I4,
    input       wire    [31:0]      I5,
    input       wire    [31:0]      I6,
    input       wire    [31:0]      I7,
    input       wire    [2:0]       SEL,
    output      reg     [31:0]      Y
);

always @ (*)
    begin
        case (SEL)
            3'b000      :       Y   =   I0;

            3'b001      :       Y   =   I1;

            3'b010      :       Y   =   I2;

            3'b011      :       Y   =   I3;

            3'b100      :       Y   =   I4;

            3'b101      :       Y   =   I5;

            3'b110      :       Y   =   I6;

            3'b111      :       Y   =   I7;

            default  :       Y   =   I0;
        endcase
    end


endmodule

