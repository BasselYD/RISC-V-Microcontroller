library verilog;
use verilog.vl_types.all;
entity UART_Rx_ParChk is
    port(
        Par_Chk_En      : in     vl_logic;
        Sampled_Bit     : in     vl_logic;
        P_DATA          : in     vl_logic_vector(7 downto 0);
        PAR_TYP         : in     vl_logic;
        Prescale        : in     vl_logic_vector(7 downto 0);
        Edge_Cnt        : in     vl_logic_vector(7 downto 0);
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        Par_Err         : out    vl_logic
    );
end UART_Rx_ParChk;
