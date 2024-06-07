library verilog;
use verilog.vl_types.all;
entity ICache is
    generic(
        BLOCK_SIZE      : integer := 32;
        NUM_LINES       : integer := 256
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        address         : in     vl_logic_vector(31 downto 0);
        instruction     : out    vl_logic_vector(31 downto 0);
        valid           : out    vl_logic;
        memReadData     : in     vl_logic_vector;
        memBusy         : in     vl_logic;
        memAddress      : out    vl_logic_vector(31 downto 0);
        memRead         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BLOCK_SIZE : constant is 1;
    attribute mti_svvh_generic_type of NUM_LINES : constant is 1;
end ICache;
