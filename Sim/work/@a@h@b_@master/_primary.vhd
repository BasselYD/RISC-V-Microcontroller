library verilog;
use verilog.vl_types.all;
entity AHB_Master is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        addr            : in     vl_logic_vector(31 downto 0);
        write           : in     vl_logic;
        wdata           : in     vl_logic_vector(31 downto 0);
        transfer        : in     vl_logic_vector(1 downto 0);
        rdata           : out    vl_logic_vector(31 downto 0);
        ready           : out    vl_logic;
        HRDATA          : in     vl_logic_vector(31 downto 0);
        HRESP           : in     vl_logic;
        HREADY          : in     vl_logic;
        HADDR           : out    vl_logic_vector(31 downto 0);
        HWRITE          : out    vl_logic;
        HWDATA          : out    vl_logic_vector(31 downto 0);
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HPROT           : out    vl_logic_vector(3 downto 0)
    );
end AHB_Master;
