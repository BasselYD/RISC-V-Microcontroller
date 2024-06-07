library verilog;
use verilog.vl_types.all;
entity Timer_APB is
    generic(
        nTIMERS         : integer := 3
    );
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PSEL            : in     vl_logic;
        PADDR           : in     vl_logic_vector(7 downto 0);
        PENABLE         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        PREADY          : out    vl_logic;
        PSLVERR         : out    vl_logic;
        TIMERINT        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of nTIMERS : constant is 1;
end Timer_APB;
