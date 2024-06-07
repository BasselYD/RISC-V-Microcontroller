library verilog;
use verilog.vl_types.all;
entity AHB_OutputStage is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        sel_op0         : in     vl_logic;
        addr_op0        : in     vl_logic_vector(31 downto 0);
        auser_op0       : in     vl_logic_vector(31 downto 0);
        trans_op0       : in     vl_logic_vector(1 downto 0);
        write_op0       : in     vl_logic;
        size_op0        : in     vl_logic_vector(2 downto 0);
        burst_op0       : in     vl_logic_vector(2 downto 0);
        prot_op0        : in     vl_logic_vector(3 downto 0);
        master_op0      : in     vl_logic_vector(3 downto 0);
        mastlock_op0    : in     vl_logic;
        wdata_op0       : in     vl_logic_vector(31 downto 0);
        wuser_op0       : in     vl_logic_vector(31 downto 0);
        held_tran_op0   : in     vl_logic;
        HREADYOUTM      : in     vl_logic;
        active_op0      : out    vl_logic;
        HSELM           : out    vl_logic;
        HADDRM          : out    vl_logic_vector(31 downto 0);
        HAUSERM         : out    vl_logic_vector(31 downto 0);
        HTRANSM         : out    vl_logic_vector(1 downto 0);
        HWRITEM         : out    vl_logic;
        HSIZEM          : out    vl_logic_vector(2 downto 0);
        HBURSTM         : out    vl_logic_vector(2 downto 0);
        HPROTM          : out    vl_logic_vector(3 downto 0);
        HMASTERM        : out    vl_logic_vector(3 downto 0);
        HMASTLOCKM      : out    vl_logic;
        HREADYMUXM      : out    vl_logic;
        HWUSERM         : out    vl_logic_vector(31 downto 0);
        HWDATAM         : out    vl_logic_vector(31 downto 0)
    );
end AHB_OutputStage;
