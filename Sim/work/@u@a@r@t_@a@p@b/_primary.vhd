library verilog;
use verilog.vl_types.all;
entity UART_APB is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(31 downto 0);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PSTRB           : in     vl_logic_vector(3 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        PREADY          : out    vl_logic;
        PSLVERR         : out    vl_logic;
        RX_IN_TOP       : in     vl_logic;
        TX_OUT_TOP      : out    vl_logic;
        Busy_TOP        : out    vl_logic
    );
end UART_APB;
