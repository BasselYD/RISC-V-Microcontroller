module UART_Tx_TOP (
    input              [7:0]        P_DATA_TOP,
    input                           DATA_VALID_TOP,
    input                           PAR_EN_TOP,
    input                           PAR_TYP_TOP,
    input                           CLK_TOP,
    input                           RST_TOP,
    output                          TX_OUT_TOP,
    output                          Busy_TOP
);

wire    Ser_Done;
wire    Ser_En;
wire    S_DATA;
wire    Parity_Bit;

wire        [2:0]        Mux_Sel;

UART_Tx_FSM FSM (
    .DATA_VALID(DATA_VALID_TOP),
    .Ser_Done(Ser_Done),
    .PAR_EN(PAR_EN_TOP),
    .CLK(CLK_TOP),
    .RST(RST_TOP),
    .Ser_En(Ser_En),
    .Mux_Sel(Mux_Sel),
    .Busy(Busy_TOP)
);

UART_Tx_Serializer Serializer (
    .P_DATA(P_DATA_TOP),
    .Ser_En(Ser_En),
    .CLK(CLK_TOP),
    .RST(RST_TOP),
    .Ser_Done(Ser_Done),
    .S_DATA(S_DATA)
);

UART_Tx_ParCalc ParCalc (
    .P_DATA(P_DATA_TOP),
    .DATA_VALID(DATA_VALID_TOP),
    .PAR_TYP(PAR_TYP_TOP),
    .CLK(CLK_TOP),
    .Parity_Bit(Parity_Bit)
);

UART_Tx_MUX MUX (
    .Mux_Sel(Mux_Sel),
    .S_DATA(S_DATA),
    .Parity_Bit(Parity_Bit),
    .TX_OUT(TX_OUT_TOP)
);


endmodule
