`timescale 1ns/1ps

module Test_tb;


reg              HCLK;
reg              HRESETn;
reg              PCLK;
reg              PRESETn;
reg              NMI;
reg [15:0]       externalInterrupts;

reg             UART_RX;
wire            UART_TX;
wire            UART_Busy;
wire    [7:0]   PORTA;
wire    [7:0]   PORTB;
wire    [7:0]   PORTC;
wire    [7:0]   PORTD;


initial begin

    HCLK = 0;
    HRESETn = 0;
    PCLK = 0;
    PRESETn = 0;

    NMI = 0;
    externalInterrupts = 0;
    
    #20
    HRESETn = 1;
    PRESETn = 1;
    #20

    //#800
    //NMI = 1;
    //#10
    //NMI = 0;
    //#285
    //externalInterrupts = 5;
    //#200
    //externalInterrupts = 0;

    #100000;

    $stop;
end


// Clock generation
always #5  HCLK = ~HCLK;
always #10 PCLK = ~PCLK;


System_Top DUT (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .NMI(NMI),
    .externalInterrupts(externalInterrupts),
    .UART_RX(UART_RX),
    .UART_TX(UART_TX),
    .UART_Busy(UART_Busy),
    .PORTA(PORTA),
    .PORTB(PORTB),
    .PORTC(PORTC),
    .PORTD(PORTD)
);


endmodule