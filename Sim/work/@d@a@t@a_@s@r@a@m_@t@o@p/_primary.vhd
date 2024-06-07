library verilog;
use verilog.vl_types.all;
entity DATA_SRAM_TOP is
    generic(
        AW              : integer := 16
    );
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HSEL            : in     vl_logic;
        HREADY          : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HWRITE          : in     vl_logic;
        HADDR           : in     vl_logic_vector;
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HREADYOUT       : out    vl_logic;
        HRESP           : out    vl_logic;
        HRDATA          : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AW : constant is 1;
end DATA_SRAM_TOP;
