library verilog;
use verilog.vl_types.all;
entity HazardUnit is
    port(
        Rs1D            : in     vl_logic_vector(4 downto 0);
        Rs2D            : in     vl_logic_vector(4 downto 0);
        Rs1E            : in     vl_logic_vector(4 downto 0);
        Rs2E            : in     vl_logic_vector(4 downto 0);
        Rs1M            : in     vl_logic_vector(4 downto 0);
        Rs2M            : in     vl_logic_vector(4 downto 0);
        RdE             : in     vl_logic_vector(4 downto 0);
        PCSrcE          : in     vl_logic;
        ResultSrcE      : in     vl_logic_vector(2 downto 0);
        ResultSrcM      : in     vl_logic_vector(2 downto 0);
        ResultSrcW      : in     vl_logic_vector(2 downto 0);
        RdM             : in     vl_logic_vector(4 downto 0);
        RegWriteM       : in     vl_logic;
        RdW             : in     vl_logic_vector(4 downto 0);
        RegWriteW       : in     vl_logic;
        rst             : in     vl_logic;
        StallF          : out    vl_logic;
        StallD          : out    vl_logic;
        FlushD          : out    vl_logic;
        FlushE          : out    vl_logic;
        ForwardAE       : out    vl_logic_vector(2 downto 0);
        ForwardACSR     : out    vl_logic;
        ForwardBE       : out    vl_logic_vector(2 downto 0);
        ForwardBCSR     : out    vl_logic;
        ForwardRs1      : out    vl_logic;
        ForwardRs2      : out    vl_logic;
        LSForward       : out    vl_logic
    );
end HazardUnit;
