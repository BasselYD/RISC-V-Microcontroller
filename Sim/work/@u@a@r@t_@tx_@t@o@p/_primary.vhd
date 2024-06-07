library verilog;
use verilog.vl_types.all;
entity UART_Tx_TOP is
    port(
        P_DATA_TOP      : in     vl_logic_vector(7 downto 0);
        DATA_VALID_TOP  : in     vl_logic;
        PAR_EN_TOP      : in     vl_logic;
        PAR_TYP_TOP     : in     vl_logic;
        CLK_TOP         : in     vl_logic;
        RST_TOP         : in     vl_logic;
        TX_OUT_TOP      : out    vl_logic;
        Busy_TOP        : out    vl_logic
    );
end UART_Tx_TOP;
