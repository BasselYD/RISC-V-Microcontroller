library verilog;
use verilog.vl_types.all;
entity APB_Bridge is
    generic(
        HADDR_SIZE      : integer := 16;
        HDATA_SIZE      : integer := 32;
        PADDR_SIZE      : integer := 16;
        PDATA_SIZE      : integer := 32;
        SYNC_DEPTH      : integer := 3
    );
    port(
        HRESETn         : in     vl_logic;
        HCLK            : in     vl_logic;
        HSEL            : in     vl_logic;
        HADDR           : in     vl_logic_vector;
        HWDATA          : in     vl_logic_vector;
        HRDATA          : out    vl_logic_vector;
        HWRITE          : in     vl_logic;
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HPROT           : in     vl_logic_vector(3 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HMASTLOCK       : in     vl_logic;
        HREADYOUT       : out    vl_logic;
        HREADY          : in     vl_logic;
        HRESP           : out    vl_logic;
        PRESETn         : in     vl_logic;
        PCLK            : in     vl_logic;
        PSEL            : out    vl_logic;
        PENABLE         : out    vl_logic;
        PPROT           : out    vl_logic_vector(2 downto 0);
        PWRITE          : out    vl_logic;
        PSTRB           : out    vl_logic_vector;
        PADDR           : out    vl_logic_vector;
        PWDATA          : out    vl_logic_vector;
        PRDATA          : in     vl_logic_vector;
        PREADY          : in     vl_logic;
        PSLVERR         : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of HADDR_SIZE : constant is 1;
    attribute mti_svvh_generic_type of HDATA_SIZE : constant is 1;
    attribute mti_svvh_generic_type of PADDR_SIZE : constant is 1;
    attribute mti_svvh_generic_type of PDATA_SIZE : constant is 1;
    attribute mti_svvh_generic_type of SYNC_DEPTH : constant is 1;
end APB_Bridge;
