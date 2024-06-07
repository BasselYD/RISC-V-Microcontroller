library verilog;
use verilog.vl_types.all;
entity UART_Tx_ParCalc is
    port(
        P_DATA          : in     vl_logic_vector(7 downto 0);
        DATA_VALID      : in     vl_logic;
        PAR_TYP         : in     vl_logic;
        CLK             : in     vl_logic;
        Parity_Bit      : out    vl_logic
    );
end UART_Tx_ParCalc;
