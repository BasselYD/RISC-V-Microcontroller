library verilog;
use verilog.vl_types.all;
entity EX_MEM_Reg is
    port(
        RegWriteE       : in     vl_logic;
        ResultSrcE      : in     vl_logic_vector(2 downto 0);
        MemWriteE       : in     vl_logic;
        MemReadE        : in     vl_logic;
        StrobeE         : in     vl_logic_vector(2 downto 0);
        isPeripheralE   : in     vl_logic;
        Rs1E            : in     vl_logic_vector(4 downto 0);
        Rs2E            : in     vl_logic_vector(4 downto 0);
        ALUResultE      : in     vl_logic_vector(31 downto 0);
        WriteDataE      : in     vl_logic_vector(31 downto 0);
        RdE             : in     vl_logic_vector(4 downto 0);
        ExtImmE         : in     vl_logic_vector(31 downto 0);
        PcTargetE       : in     vl_logic_vector(31 downto 0);
        PCPlus4E        : in     vl_logic_vector(31 downto 0);
        csrDataE        : in     vl_logic_vector(31 downto 0);
        InstrE          : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        FLUSH           : in     vl_logic;
        EN              : in     vl_logic;
        RegWriteM       : out    vl_logic;
        ResultSrcM      : out    vl_logic_vector(2 downto 0);
        MemWriteM       : out    vl_logic;
        MemReadM        : out    vl_logic;
        StrobeM         : out    vl_logic_vector(2 downto 0);
        isPeripheralM   : out    vl_logic;
        Rs1M            : out    vl_logic_vector(4 downto 0);
        Rs2M            : out    vl_logic_vector(4 downto 0);
        InstrM          : out    vl_logic_vector(31 downto 0);
        ALUResultM      : out    vl_logic_vector(31 downto 0);
        WriteDataM      : out    vl_logic_vector(31 downto 0);
        RdM             : out    vl_logic_vector(4 downto 0);
        ExtImmM         : out    vl_logic_vector(31 downto 0);
        PcTargetM       : out    vl_logic_vector(31 downto 0);
        PCPlus4M        : out    vl_logic_vector(31 downto 0);
        csrDataM        : out    vl_logic_vector(31 downto 0)
    );
end EX_MEM_Reg;
