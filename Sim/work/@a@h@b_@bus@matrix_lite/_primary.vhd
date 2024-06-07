library verilog;
use verilog.vl_types.all;
entity AHB_BusMatrix_lite is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        REMAP           : in     vl_logic_vector(3 downto 0);
        HADDRS0         : in     vl_logic_vector(31 downto 0);
        HTRANSS0        : in     vl_logic_vector(1 downto 0);
        HWRITES0        : in     vl_logic;
        HSIZES0         : in     vl_logic_vector(2 downto 0);
        HBURSTS0        : in     vl_logic_vector(2 downto 0);
        HPROTS0         : in     vl_logic_vector(3 downto 0);
        HWDATAS0        : in     vl_logic_vector(31 downto 0);
        HMASTLOCKS0     : in     vl_logic;
        HAUSERS0        : in     vl_logic_vector(31 downto 0);
        HWUSERS0        : in     vl_logic_vector(31 downto 0);
        HRDATAM0        : in     vl_logic_vector(31 downto 0);
        HREADYOUTM0     : in     vl_logic;
        HRESPM0         : in     vl_logic;
        HRUSERM0        : in     vl_logic_vector(31 downto 0);
        HRDATAM1        : in     vl_logic_vector(31 downto 0);
        HREADYOUTM1     : in     vl_logic;
        HRESPM1         : in     vl_logic;
        HRUSERM1        : in     vl_logic_vector(31 downto 0);
        HRDATAM2        : in     vl_logic_vector(31 downto 0);
        HREADYOUTM2     : in     vl_logic;
        HRESPM2         : in     vl_logic;
        HRUSERM2        : in     vl_logic_vector(31 downto 0);
        HRDATAM3        : in     vl_logic_vector(31 downto 0);
        HREADYOUTM3     : in     vl_logic;
        HRESPM3         : in     vl_logic;
        HRUSERM3        : in     vl_logic_vector(31 downto 0);
        SCANENABLE      : in     vl_logic;
        SCANINHCLK      : in     vl_logic;
        HSELM0          : out    vl_logic;
        HADDRM0         : out    vl_logic_vector(31 downto 0);
        HTRANSM0        : out    vl_logic_vector(1 downto 0);
        HWRITEM0        : out    vl_logic;
        HSIZEM0         : out    vl_logic_vector(2 downto 0);
        HBURSTM0        : out    vl_logic_vector(2 downto 0);
        HPROTM0         : out    vl_logic_vector(3 downto 0);
        HWDATAM0        : out    vl_logic_vector(31 downto 0);
        HMASTLOCKM0     : out    vl_logic;
        HREADYMUXM0     : out    vl_logic;
        HAUSERM0        : out    vl_logic_vector(31 downto 0);
        HWUSERM0        : out    vl_logic_vector(31 downto 0);
        HSELM1          : out    vl_logic;
        HADDRM1         : out    vl_logic_vector(31 downto 0);
        HTRANSM1        : out    vl_logic_vector(1 downto 0);
        HWRITEM1        : out    vl_logic;
        HSIZEM1         : out    vl_logic_vector(2 downto 0);
        HBURSTM1        : out    vl_logic_vector(2 downto 0);
        HPROTM1         : out    vl_logic_vector(3 downto 0);
        HWDATAM1        : out    vl_logic_vector(31 downto 0);
        HMASTLOCKM1     : out    vl_logic;
        HREADYMUXM1     : out    vl_logic;
        HAUSERM1        : out    vl_logic_vector(31 downto 0);
        HWUSERM1        : out    vl_logic_vector(31 downto 0);
        HSELM2          : out    vl_logic;
        HADDRM2         : out    vl_logic_vector(31 downto 0);
        HTRANSM2        : out    vl_logic_vector(1 downto 0);
        HWRITEM2        : out    vl_logic;
        HSIZEM2         : out    vl_logic_vector(2 downto 0);
        HBURSTM2        : out    vl_logic_vector(2 downto 0);
        HPROTM2         : out    vl_logic_vector(3 downto 0);
        HWDATAM2        : out    vl_logic_vector(31 downto 0);
        HMASTLOCKM2     : out    vl_logic;
        HREADYMUXM2     : out    vl_logic;
        HAUSERM2        : out    vl_logic_vector(31 downto 0);
        HWUSERM2        : out    vl_logic_vector(31 downto 0);
        HSELM3          : out    vl_logic;
        HADDRM3         : out    vl_logic_vector(31 downto 0);
        HTRANSM3        : out    vl_logic_vector(1 downto 0);
        HWRITEM3        : out    vl_logic;
        HSIZEM3         : out    vl_logic_vector(2 downto 0);
        HBURSTM3        : out    vl_logic_vector(2 downto 0);
        HPROTM3         : out    vl_logic_vector(3 downto 0);
        HWDATAM3        : out    vl_logic_vector(31 downto 0);
        HMASTLOCKM3     : out    vl_logic;
        HREADYMUXM3     : out    vl_logic;
        HAUSERM3        : out    vl_logic_vector(31 downto 0);
        HWUSERM3        : out    vl_logic_vector(31 downto 0);
        HRDATAS0        : out    vl_logic_vector(31 downto 0);
        HREADYS0        : out    vl_logic;
        HRESPS0         : out    vl_logic;
        HRUSERS0        : out    vl_logic_vector(31 downto 0);
        SCANOUTHCLK     : out    vl_logic
    );
end AHB_BusMatrix_lite;