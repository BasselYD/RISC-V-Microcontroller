module UART_Tx_FSM (
    input       wire                    DATA_VALID,
    input       wire                    Ser_Done,
    input       wire                    PAR_EN,
    input       wire                    CLK,
    input       wire                    RST,
    output      reg                     Ser_En,
    output      reg        [2:0]        Mux_Sel,
    output      reg                     Busy
);

parameter IDLE            = 3'b000,
          START           = 3'b001,
          TRANSMIT_DATA   = 3'b010,
          PARITY          = 3'b011,
          STOP            = 3'b100;

reg     [2:0]      current_state, next_state;

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                current_state <= IDLE;
            end
        else
            begin
                current_state <= next_state;
            end
    end


always @ (*)
    begin
        case (current_state)
            IDLE:   begin
                        if (DATA_VALID)
                            next_state = START;
                        else
                            next_state = IDLE;
                    end
            
            START: next_state = TRANSMIT_DATA;

            TRANSMIT_DATA:  begin
                                if (Ser_Done && PAR_EN)
                                    next_state = PARITY;
                                else if (Ser_Done && !PAR_EN)
                                    next_state = STOP;
                                else
                                    next_state = TRANSMIT_DATA;
                            end

            PARITY: next_state = STOP;

            STOP:   begin
                        //If DATA_VALID goes high before current frame ends, it immediately starts another frame.
                        if (DATA_VALID)
                            next_state = START;
                        else
                            next_state = IDLE;
                    end

        endcase
    end     


always @ (*)
begin

    Mux_Sel = IDLE;
    Busy = 1'b0;
    Ser_En = 1'b0;

    case (current_state)
        IDLE:   begin
                    if (DATA_VALID)
                        Ser_En = 1'b1;
                    else
                        begin
                            Mux_Sel = IDLE;
                            Busy = 1'b0;
                            Ser_En = 1'b0;
                        end
                end
        
        START:  begin
                    Mux_Sel = START;
                    Busy = 1'b1;
                    Ser_En = 1'b1;
                end

        TRANSMIT_DATA:  begin
                            Mux_Sel = TRANSMIT_DATA;
                            Busy = 1'b1;
                            Ser_En = 1'b1;
                        end

        PARITY: begin
                    Mux_Sel = PARITY;
                    Busy = 1'b1;
                    Ser_En = 1'b0;
                end

        STOP: begin
                    if (DATA_VALID)
                        begin
                            Ser_En = 1'b1;
                            Mux_Sel = STOP;
                            Busy = 1'b1;
                        end
                    else
                        begin
                            Mux_Sel = STOP;
                            Busy = 1'b1;
                            Ser_En = 1'b0;
                        end
            end

    endcase
end   


endmodule