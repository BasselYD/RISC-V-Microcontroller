module UART_Tx_MUX (
    input      wire       [2:0]         Mux_Sel,
    input      wire                     S_DATA,
    input      wire                     Parity_Bit,
    output     reg                      TX_OUT
);

parameter IDLE            = 3'b000,
          START           = 3'b001,
          TRANSMIT_DATA   = 3'b010,
          PARITY          = 3'b011,
          STOP            = 3'b100;

always @ (*)
    case (Mux_Sel)
        IDLE:            TX_OUT = 1'b1;

        START:           TX_OUT = 1'b0;

        TRANSMIT_DATA:   TX_OUT = S_DATA;

        PARITY:          TX_OUT = Parity_Bit;

        STOP:            TX_OUT = 1'b1;

    endcase

endmodule
