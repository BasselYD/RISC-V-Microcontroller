library verilog;
use verilog.vl_types.all;
entity System_Top is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        NMI             : in     vl_logic;
        externalInterrupts: in     vl_logic_vector(15 downto 0);
        UART_RX         : in     vl_logic;
        UART_TX         : out    vl_logic;
        UART_Busy       : out    vl_logic;
        PORTA           : inout  vl_logic_vector(7 downto 0);
        PORTB           : inout  vl_logic_vector(7 downto 0);
        PORTC           : inout  vl_logic_vector(7 downto 0);
        PORTD           : inout  vl_logic_vector(7 downto 0)
    );
end System_Top;
