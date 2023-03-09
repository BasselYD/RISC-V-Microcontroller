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
            00      :       Y   =   I0;

            01      :       Y   =   I1;

            10      :       Y   =   I2;

            11      :       Y   =   I3;

            default :       Y   =   I0;
        endcase
    end


endmodule
