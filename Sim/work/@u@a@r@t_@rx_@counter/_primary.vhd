library verilog;
use verilog.vl_types.all;
entity UART_Rx_Counter is
    port(
        Count_En        : in     vl_logic;
        Prescale        : in     vl_logic_vector(7 downto 0);
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        Edge_Cnt        : out    vl_logic_vector(7 downto 0);
        Bit_Cnt         : out    vl_logic_vector(3 downto 0)
    );
end UART_Rx_Counter;
