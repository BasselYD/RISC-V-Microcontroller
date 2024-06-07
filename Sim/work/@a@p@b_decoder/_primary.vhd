library verilog;
use verilog.vl_types.all;
entity APB_decoder is
    port(
        PSEL            : in     vl_logic;
        PADDR           : in     vl_logic_vector(3 downto 0);
        TIMER_PSEL      : out    vl_logic;
        UART_PSEL       : out    vl_logic;
        GPIO_PSEL       : out    vl_logic
    );
end APB_decoder;
