library verilog;
use verilog.vl_types.all;
entity Timer is
    generic(
        nTIMERS         : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        cs              : in     vl_logic;
        addr            : in     vl_logic_vector(7 downto 0);
        rw              : in     vl_logic;
        wdata           : in     vl_logic_vector(31 downto 0);
        rdata           : out    vl_logic_vector(31 downto 0);
        error           : out    vl_logic;
        ready           : out    vl_logic;
        interrupt       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of nTIMERS : constant is 1;
end Timer;
