library verilog;
use verilog.vl_types.all;
entity APB_Subsystem is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HPROT           : in     vl_logic_vector(3 downto 0);
        HADDR           : in     vl_logic_vector(15 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HSEL            : in     vl_logic;
        HWRITE          : in     vl_logic;
        HREADY          : in     vl_logic;
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        HRDATA          : out    vl_logic_vector(31 downto 0);
        HREADYOUT       : out    vl_logic;
        HRESP           : out    vl_logic;
        UART_RX         : in     vl_logic;
        UART_TX         : out    vl_logic;
        UART_Busy       : out    vl_logic;
        PORTA           : inout  vl_logic_vector(7 downto 0);
        PORTB           : inout  vl_logic_vector(7 downto 0);
        PORTC           : inout  vl_logic_vector(7 downto 0);
        PORTD           : inout  vl_logic_vector(7 downto 0);
        timer_interrupt : out    vl_logic
    );
end APB_Subsystem;
