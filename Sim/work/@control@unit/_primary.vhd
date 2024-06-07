library verilog;
use verilog.vl_types.all;
entity ControlUnit is
    port(
        Instr           : in     vl_logic_vector(31 downto 0);
        RegWriteD       : out    vl_logic;
        ResultSrcD      : out    vl_logic_vector(2 downto 0);
        MemWriteD       : out    vl_logic;
        MemReadD        : out    vl_logic;
        JumpD           : out    vl_logic;
        JumpTypeD       : out    vl_logic;
        BranchD         : out    vl_logic;
        BranchTypeD     : out    vl_logic_vector(2 downto 0);
        ALUControlD     : out    vl_logic_vector(2 downto 0);
        ALUSrcD         : out    vl_logic;
        SLTControlD     : out    vl_logic_vector(1 downto 0);
        ImmSrcD         : out    vl_logic_vector(2 downto 0);
        StrobeD         : out    vl_logic_vector(2 downto 0);
        csrOp           : out    vl_logic_vector(1 downto 0);
        exception       : out    vl_logic;
        exceptionType   : out    vl_logic_vector(3 downto 0);
        mret            : out    vl_logic
    );
end ControlUnit;
