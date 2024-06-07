module UART_Rx_StrtChk (
    input       wire                     Strt_Chk_En,
    input       wire                     Sampled_Bit,
    input       wire        [7:0]        Prescale,
    input       wire        [7:0]        Edge_Cnt,
    input       wire                     CLK,  
    input       wire                     RST,
    output      reg                      Strt_Glitch
);

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            Strt_Glitch <= 0;
        else
            begin
                if (Strt_Chk_En && (Edge_Cnt == ((Prescale >> 1) + 2)))
                    Strt_Glitch <= (Sampled_Bit != 0);
            end
    end


endmodule