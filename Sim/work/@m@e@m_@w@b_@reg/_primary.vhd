library verilog;
use verilog.vl_types.all;
entity MEM_WB_Reg is
    port(
        RegWriteM       : in     vl_logic;
        ResultSrcM      : in     vl_logic_vector(2 downto 0);
        ALUResultM      : in     vl_logic_vector(31 downto 0);
        ReadDataM       : in     vl_logic_vector(31 downto 0);
        RdM             : in     vl_logic_vector(4 downto 0);
        ExtImmM         : in     vl_logic_vector(31 downto 0);
        PcTargetM       : in     vl_logic_vector(31 downto 0);
        PCPlus4M        : in     vl_logic_vector(31 downto 0);
        csrDataM        : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        EN              : in     vl_logic;
        RegWriteW       : out    vl_logic;
        ResultSrcW      : out    vl_logic_vector(2 downto 0);
        ALUResultW      : out    vl_logic_vector(31 downto 0);
        ReadDataW       : out    vl_logic_vector(31 downto 0);
        RdW             : out    vl_logic_vector(4 downto 0);
        ExtImmW         : out    vl_logic_vector(31 downto 0);
        PcTargetW       : out    vl_logic_vector(31 downto 0);
        PCPlus4W        : out    vl_logic_vector(31 downto 0);
        csrDataW        : out    vl_logic_vector(31 downto 0)
    );
end MEM_WB_Reg;
