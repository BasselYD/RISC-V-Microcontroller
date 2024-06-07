library verilog;
use verilog.vl_types.all;
entity UART_Tx_Serializer is
    port(
        P_DATA          : in     vl_logic_vector(7 downto 0);
        Ser_En          : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        Ser_Done        : out    vl_logic;
        S_DATA          : out    vl_logic
    );
end UART_Tx_Serializer;
