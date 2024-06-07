library verilog;
use verilog.vl_types.all;
entity UART_Rx_FSM is
    port(
        RX_IN           : in     vl_logic;
        PAR_EN          : in     vl_logic;
        Prescale        : in     vl_logic_vector(7 downto 0);
        Edge_Cnt        : in     vl_logic_vector(7 downto 0);
        Bit_Cnt         : in     vl_logic_vector(3 downto 0);
        Par_Err         : in     vl_logic;
        Strt_Glitch     : in     vl_logic;
        Stp_Err         : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        Count_En        : out    vl_logic;
        Data_Samp_En    : out    vl_logic;
        Par_Chk_En      : out    vl_logic;
        Strt_Chk_En     : out    vl_logic;
        Stp_Chk_En      : out    vl_logic;
        Deser_En        : out    vl_logic;
        Data_Valid      : out    vl_logic
    );
end UART_Rx_FSM;
