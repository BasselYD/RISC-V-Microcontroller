module APB_decoder (
    input               PSEL,
    input       [3:0]   PADDR,  
    output reg          TIMER_PSEL,
    output reg          UART_PSEL,
    output reg          GPIO_PSEL
);


always @ (*) begin

    TIMER_PSEL = 1'b0;
    UART_PSEL = 1'b0;
    GPIO_PSEL = 1'b0;

    if(PSEL) begin
        case(PADDR)
            4'b0000 :   TIMER_PSEL = 1'b1;

            4'b0001 :   UART_PSEL = 1'b1;

            4'b0010 :   GPIO_PSEL = 1'b1;

            default :   begin
                            TIMER_PSEL = 1'b0;
                            UART_PSEL = 1'b0;
                            GPIO_PSEL = 1'b0;
                        end
        endcase
    end
    else begin
        TIMER_PSEL = 1'b0;
        UART_PSEL = 1'b0;
        GPIO_PSEL = 1'b0;
    end

end

endmodule