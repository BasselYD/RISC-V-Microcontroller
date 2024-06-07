module UART_Tx_ParCalc (
    input       wire       [7:0]        P_DATA,
    input       wire                    DATA_VALID,
    input       wire                    PAR_TYP,
    input       wire                    CLK,
    output      reg                     Parity_Bit
);

always @ (posedge CLK)
    begin
        if (DATA_VALID && !PAR_TYP)
            Parity_Bit <= ^P_DATA;
        else if (DATA_VALID && PAR_TYP)
            Parity_Bit <= ~^P_DATA;
    end

endmodule
