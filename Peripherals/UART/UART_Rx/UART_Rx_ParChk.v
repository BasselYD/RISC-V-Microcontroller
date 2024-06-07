module UART_Rx_ParChk (
    input       wire                     Par_Chk_En,
    input       wire                     Sampled_Bit,
    input       wire        [7:0]        P_DATA,
    input       wire                     PAR_TYP,
    input       wire        [7:0]        Prescale,
    input       wire        [7:0]        Edge_Cnt,
    input       wire                     CLK,  
    input       wire                     RST,
    output      reg                      Par_Err
);

reg    Calculated_Parity;


always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            Par_Err <= 0;
        else    
            begin
                if (Par_Chk_En && (Edge_Cnt == ((Prescale >> 1) + 2)))
                    begin
                        Par_Err <= (Sampled_Bit != Calculated_Parity);
                    end
            end
    end


always @ (*)
    begin
        if (!PAR_TYP)
            Calculated_Parity = ^P_DATA;
        else
            Calculated_Parity = ~^P_DATA;
    end



endmodule


