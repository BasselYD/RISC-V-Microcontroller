library verilog;
use verilog.vl_types.all;
entity Memory_Arbiter is
    generic(
        BLOCK_SIZE      : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        inst_memAddress : in     vl_logic_vector(31 downto 0);
        inst_memRead    : in     vl_logic;
        inst_memReadData: out    vl_logic_vector;
        inst_memBusy    : out    vl_logic;
        data_memAddress : in     vl_logic_vector(31 downto 0);
        data_memRead    : in     vl_logic;
        data_memReadData: out    vl_logic_vector;
        data_memWrite   : in     vl_logic;
        data_memWriteData: in     vl_logic_vector;
        data_memBusy    : out    vl_logic;
        instrM          : in     vl_logic_vector(31 downto 0);
        peripheral_memAddress: in     vl_logic_vector(31 downto 0);
        peripheral_memRead: in     vl_logic;
        peripheral_memReadData: out    vl_logic_vector(31 downto 0);
        peripheral_memWrite: in     vl_logic;
        peripheral_memWriteData: in     vl_logic_vector(31 downto 0);
        peripheral_strobe: in     vl_logic_vector(2 downto 0);
        peripheral_memBusy: out    vl_logic;
        peripheral_flush: out    vl_logic;
        rdata           : in     vl_logic_vector(31 downto 0);
        ready           : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        addr            : out    vl_logic_vector(31 downto 0);
        write           : out    vl_logic;
        wdata           : out    vl_logic_vector(31 downto 0);
        transfer        : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BLOCK_SIZE : constant is 1;
end Memory_Arbiter;
