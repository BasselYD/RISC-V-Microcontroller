library verilog;
use verilog.vl_types.all;
entity UART_Rx_TOP is
    port(
        RX_IN_TOP       : in     vl_logic;
        Prescale_TOP    : in     vl_logic_vector(7 downto 0);
        PAR_EN_TOP      : in     vl_logic;
        PAR_TYP_TOP     : in     vl_logic;
        CLK_TOP         : in     vl_logic;
        RST_TOP         : in     vl_logic;
        P_DATA_TOP      : out    vl_logic_vector(7 downto 0);
        Data_Valid_TOP  : out    vl_logic
    );
end UART_Rx_TOP;
