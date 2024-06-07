module UART_Rx_Sampler (
    input       wire                     RX_IN,
    input       wire                     Sample_En,
    input       wire        [7:0]        Prescale,
    input       wire        [7:0]        Edge_Cnt,
    input       wire                     CLK,  
    input       wire                     RST,
    output      reg                      Sampled_Bit
);

wire    [3:0]    Mid;
reg              Val1, Val2, Val3;
wire             Majority_comb;

assign Mid = Prescale[7:1];

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Val1 <= 0;
                Val2 <= 0;
                Val3 <= 0;
            end
        else if (Edge_Cnt == Mid - 1)
            Val1 <= RX_IN;
        else if (Edge_Cnt == Mid)
            Val2 <= RX_IN;
        else if (Edge_Cnt == Mid + 1)
            begin
                Val3 <= RX_IN;
                Sampled_Bit <= Majority_comb;
            end
    end

assign Majority_comb = (Val1 & Val2) | (Val1 & Val3) | (Val2 & Val3);

endmodule