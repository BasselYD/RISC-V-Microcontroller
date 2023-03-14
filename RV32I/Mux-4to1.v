module Mux_4to1(
    input       wire    [31:0]      I0,
    input       wire    [31:0]      I1,
    input       wire    [31:0]      I2,
    input       wire    [31:0]      I3,
    input       wire    [1:0]       SEL,
    output      reg     [31:0]      Y
);

always @ (*)
    begin
        case (SEL)
            2'b00      :       Y   =   I0;

            2'b01      :       Y   =   I1;

            2'b10      :       Y   =   I2;

            2'b11      :       Y   =   I3;

            default :       Y   =   I0;
        endcase
    end


endmodule
