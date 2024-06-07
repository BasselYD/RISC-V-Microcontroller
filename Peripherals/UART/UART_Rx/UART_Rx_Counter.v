module UART_Rx_Counter (
    input       wire                     Count_En,
    input       wire        [7:0]        Prescale,
    input       wire                     CLK,  
    input       wire                     RST,
    output      reg         [7:0]        Edge_Cnt,
    output      reg         [3:0]        Bit_Cnt
);

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Edge_Cnt <= 8'b00000000;
                Bit_Cnt  <= 4'b0000;
            end
        else
            begin
                if (Count_En)
                    begin
                        Edge_Cnt <= Edge_Cnt + 1;
                        if (Edge_Cnt == Prescale)
                            begin
                                Bit_Cnt <= Bit_Cnt + 1;
                                Edge_Cnt <= 5'b00000001;
                            end
                    end
                else
                    begin
                        Edge_Cnt <= 5'b00000000;
                        Bit_Cnt  <= 4'b0000;
                    end
            end
    end

endmodule
