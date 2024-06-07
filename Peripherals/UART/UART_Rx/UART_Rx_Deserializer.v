module UART_Rx_Deserializer (
    input       wire                     Deser_En, 
    input       wire                     Sampled_Bit, 
    input       wire                     CLK,  
    input       wire                     RST,
    output      reg         [7:0]        P_DATA
);

reg         [7:0]        SR;


always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                SR <= 8'b0000_0000;
                P_DATA <= 8'b0000_0000;
            end
        else
            begin
		P_DATA <= SR;
                if (Deser_En)
                    begin
                        SR <= SR >> 1;
                        SR[7] <= Sampled_Bit;
                    end
            end
    end

endmodule
