library verilog;
use verilog.vl_types.all;
entity GPIO_Controller is
    generic(
        PINS            : integer := 8
    );
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
        PORTA           : inout  vl_logic_vector;
        PORTB           : inout  vl_logic_vector;
        PORTC           : inout  vl_logic_vector;
        PORTD           : inout  vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PINS : constant is 1;
end GPIO_Controller;
