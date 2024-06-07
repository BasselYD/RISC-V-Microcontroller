library verilog;
use verilog.vl_types.all;
entity UART_Rx_Deserializer is
    port(
        Deser_En        : in     vl_logic;
        Sampled_Bit     : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        P_DATA          : out    vl_logic_vector(7 downto 0)
    );
end UART_Rx_Deserializer;
