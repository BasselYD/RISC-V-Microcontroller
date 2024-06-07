library verilog;
use verilog.vl_types.all;
entity IF_ID_Reg is
    port(
        InstrF          : in     vl_logic_vector(31 downto 0);
        PCF             : in     vl_logic_vector(31 downto 0);
        PCPlus4F        : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        FLUSH           : in     vl_logic;
        EN              : in     vl_logic;
        InstrD          : out    vl_logic_vector(31 downto 0);
        PCD             : out    vl_logic_vector(31 downto 0);
        PCPlus4D        : out    vl_logic_vector(31 downto 0)
    );
end IF_ID_Reg;
