library verilog;
use verilog.vl_types.all;
entity DCache is
    generic(
        BLOCK_SIZE      : integer := 8;
        TOTAL_LINES     : integer := 256;
        ASSOCIATIVITY   : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        address         : in     vl_logic_vector(31 downto 0);
        read            : in     vl_logic;
        write           : in     vl_logic;
        writeData       : in     vl_logic_vector(31 downto 0);
        strobe          : in     vl_logic_vector(2 downto 0);
        readData        : out    vl_logic_vector(31 downto 0);
        valid           : out    vl_logic;
        memBusy         : in     vl_logic;
        memAddress      : out    vl_logic_vector(31 downto 0);
        memRead         : out    vl_logic;
        memReadData     : in     vl_logic_vector;
        memWrite        : out    vl_logic;
        memWriteData    : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BLOCK_SIZE : constant is 1;
    attribute mti_svvh_generic_type of TOTAL_LINES : constant is 1;
    attribute mti_svvh_generic_type of ASSOCIATIVITY : constant is 1;
end DCache;
