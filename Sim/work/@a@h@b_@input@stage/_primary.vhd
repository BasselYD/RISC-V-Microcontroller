library verilog;
use verilog.vl_types.all;
entity AHB_InputStage is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HSELS           : in     vl_logic;
        HADDRS          : in     vl_logic_vector(31 downto 0);
        HAUSERS         : in     vl_logic_vector(31 downto 0);
        HTRANSS         : in     vl_logic_vector(1 downto 0);
        HWRITES         : in     vl_logic;
        HSIZES          : in     vl_logic_vector(2 downto 0);
        HBURSTS         : in     vl_logic_vector(2 downto 0);
        HPROTS          : in     vl_logic_vector(3 downto 0);
        HMASTERS        : in     vl_logic_vector(3 downto 0);
        HMASTLOCKS      : in     vl_logic;
        HREADYS         : in     vl_logic;
        active_ip       : in     vl_logic;
        readyout_ip     : in     vl_logic;
        resp_ip         : in     vl_logic_vector(1 downto 0);
        HREADYOUTS      : out    vl_logic;
        HRESPS          : out    vl_logic_vector(1 downto 0);
        sel_ip          : out    vl_logic;
        addr_ip         : out    vl_logic_vector(31 downto 0);
        auser_ip        : out    vl_logic_vector(31 downto 0);
        trans_ip        : out    vl_logic_vector(1 downto 0);
        write_ip        : out    vl_logic;
        size_ip         : out    vl_logic_vector(2 downto 0);
        burst_ip        : out    vl_logic_vector(2 downto 0);
        prot_ip         : out    vl_logic_vector(3 downto 0);
        master_ip       : out    vl_logic_vector(3 downto 0);
        mastlock_ip     : out    vl_logic;
        held_tran_ip    : out    vl_logic
    );
end AHB_InputStage;
