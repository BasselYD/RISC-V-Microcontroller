module UART_Tx_Serializer (
    input       wire       [7:0]        P_DATA,
    input       wire                    Ser_En,
    input       wire                    CLK,
    input       wire                    RST,
    output      wire                    Ser_Done,
    output      reg                     S_DATA
);

reg     [7:0]       Shift_Register;
reg     [3:0]       Counter;

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Shift_Register <= 8'b00000000;
                S_DATA <= 1'b0;
                Counter <= 0;
            end
        else
            begin
                if (Ser_Done)
                    Counter <= 0;
                else if (Ser_En)
                    begin
                        Counter <= Counter + 1; 
                        if (Counter != 0)
                        begin
                            {Shift_Register[6:0], S_DATA} <= Shift_Register;
                            //Shift_Register[7] <= 0;
                            //Counter <= Counter + 1; 
                        end
                    end
                
                
                else if (!Ser_En)
                    begin
                        Shift_Register <= 8'b00000000;
                        S_DATA <= 1'b0;
                        Counter <= 1'b0;
                    end
            end
    end

always @ (*)
    begin
        if (Ser_En && Counter == 0)
                    begin
                        Shift_Register = P_DATA;
                        //S_DATA = Shift_Register[0];
                        //Counter = Counter + 1;
                    end
    end

assign Ser_Done = (Counter == 4'b1001);



endmodule
