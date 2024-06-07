module UART_Rx_FSM (
    input       wire                     RX_IN,
    input       wire                     PAR_EN,
    input       wire        [7:0]        Prescale,
    input       wire        [7:0]        Edge_Cnt,
    input       wire        [3:0]        Bit_Cnt,
    input       wire                     Par_Err,
    input       wire                     Strt_Glitch,
    input       wire                     Stp_Err,
    input       wire                     CLK,  
    input       wire                     RST,
    output      reg                      Count_En,
    output      reg                      Data_Samp_En,
    output      reg                      Par_Chk_En,
    output      reg                      Strt_Chk_En,
    output      reg                      Stp_Chk_En,
    output      reg                      Deser_En,
    output      reg                      Data_Valid
);

reg     [2:0]       current_state, next_state;

localparam IDLE             =   3'b000,
           START            =   3'b001,
           RECEIVE_DATA     =   3'b010,
           PARITY           =   3'b011,
           STOP             =   3'b100,
           CHECK            =   3'b101;



always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            current_state <= IDLE;
        else
            current_state <= next_state; 
    end


always @ (*)
    begin
        case (current_state)
            IDLE :
                begin
                    if (!RX_IN)
                        next_state = START;
                    else
                        next_state = IDLE;
                end

            START :
                begin
                    if (Bit_Cnt == 1 && !Strt_Glitch)
                        next_state = RECEIVE_DATA;
                    else if (Bit_Cnt == 1 && Strt_Glitch)
                        next_state = IDLE;
                    else
                        next_state = START;
                end

            RECEIVE_DATA :
                begin
                    if (Bit_Cnt == 9 && PAR_EN)
                        next_state = PARITY;
                    else if (Bit_Cnt == 9 && !PAR_EN)
                        next_state = STOP;
                    else
                        next_state = RECEIVE_DATA;
                end
            
            PARITY :
                begin
                    if (Bit_Cnt == 10)
                        next_state = STOP;
                    else
                        next_state = PARITY;
                end

            STOP :
                begin
                    if (Bit_Cnt == 10 && Edge_Cnt == ((Prescale >> 1) + 2))
                        next_state = CHECK;
                    else if (Bit_Cnt == 9 && Edge_Cnt == ((Prescale >> 1) + 2))
                        next_state = CHECK;
                    else
                        next_state = STOP;
                end

            CHECK : next_state = IDLE;

	    default : next_state = IDLE;
                
        endcase
    end



always @ (*)
    begin
        case (current_state)
            IDLE :
                begin
                    if (!RX_IN)
                        begin
                            Count_En = 1'b1;
                            Data_Samp_En = 1'b1;
                            
                            Strt_Chk_En = 1'b0;
                            Par_Chk_En = 1'b0;
                            Stp_Chk_En = 1'b0;
                            Deser_En = 1'b0;
                            Data_Valid = 1'b0;
                        end
                    else
                        begin
                            Count_En = 1'b0;
                            Data_Samp_En = 1'b0;

                            Strt_Chk_En = 1'b0;
                            Par_Chk_En = 1'b0;
                            Stp_Chk_En = 1'b0;
                            Deser_En = 1'b0;
                            Data_Valid = 1'b0;
                        end
                end

            START :
                begin
                    Count_En = 1'b1;
                    Data_Samp_En = 1'b1;
                    Strt_Chk_En = 1'b1;

                    Par_Chk_En = 1'b0;
                    Stp_Chk_En = 1'b0;
                    Deser_En = 1'b0;
                    Data_Valid = 1'b0;
                end

            RECEIVE_DATA :
                begin
                    Count_En = 1'b1;
                    Data_Samp_En = 1'b1;

                    if (Edge_Cnt == ((Prescale >> 1) + 2))
                        Deser_En = 1'b1;
                    else
                        Deser_En = 1'b0;
                    
                    Strt_Chk_En = 1'b0;
                    Par_Chk_En = 1'b0;
                    Stp_Chk_En = 1'b0;                       
                    Data_Valid = 1'b0;
                end
            
            PARITY :
                begin
                    Count_En = 1'b1;
                    Data_Samp_En = 1'b1;
                    Par_Chk_En = 1'b1;

                    Strt_Chk_En = 1'b0;
                    Stp_Chk_En = 1'b0; 
                    Deser_En = 1'b0;                      
                    Data_Valid = 1'b0;
                end

            STOP :
                begin
                    Count_En = 1'b1;
                    Data_Samp_En = 1'b1;
                    Stp_Chk_En = 1'b1;
                                            
                    Strt_Chk_En = 1'b0;
                    Par_Chk_En = 1'b0;
                    Deser_En = 1'b0;                      
                    Data_Valid = 1'b0;
                end

            CHECK : 
                begin
                    Count_En = 1'b0;
                    Data_Samp_En = 1'b0;
                    Stp_Chk_En = 1'b0;               
                    Strt_Chk_En = 1'b0;
                    Par_Chk_En = 1'b0;
                    Deser_En = 1'b0; 

                    if (!Stp_Err && !Par_Err)
                        Data_Valid = 1'b1;
                    else
                        Data_Valid = 1'b0;
                end

	    default : 
		begin
		    Count_En = 1'b0;
                    Data_Samp_En = 1'b0;
                    Strt_Chk_En = 1'b0;
                    Par_Chk_En = 1'b0;
                    Stp_Chk_En = 1'b0;
                    Deser_En = 1'b0;
                    Data_Valid = 1'b0;
		end
                
        endcase
    end


endmodule
