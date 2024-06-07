library verilog;
use verilog.vl_types.all;
entity UART_Tx_MUX is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        START           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        TRANSMIT_DATA   : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        PARITY          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        STOP            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        Mux_Sel         : in     vl_logic_vector(2 downto 0);
        S_DATA          : in     vl_logic;
        Parity_Bit      : in     vl_logic;
        TX_OUT          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of START : constant is 1;
    attribute mti_svvh_generic_type of TRANSMIT_DATA : constant is 1;
    attribute mti_svvh_generic_type of PARITY : constant is 1;
    attribute mti_svvh_generic_type of STOP : constant is 1;
end UART_Tx_MUX;
