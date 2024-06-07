library verilog;
use verilog.vl_types.all;
entity UART_Rx_Sampler is
    port(
        RX_IN           : in     vl_logic;
        Sample_En       : in     vl_logic;
        Prescale        : in     vl_logic_vector(7 downto 0);
        Edge_Cnt        : in     vl_logic_vector(7 downto 0);
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        Sampled_Bit     : out    vl_logic
    );
end UART_Rx_Sampler;
