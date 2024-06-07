library verilog;
use verilog.vl_types.all;
entity Zicsr is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        index           : in     vl_logic_vector(11 downto 0);
        data            : in     vl_logic_vector(31 downto 0);
        opcode          : in     vl_logic_vector(1 downto 0);
        mret            : in     vl_logic;
        exception       : in     vl_logic;
        exceptionType   : in     vl_logic_vector(3 downto 0);
        exceptionPC     : in     vl_logic_vector(31 downto 0);
        NMI             : in     vl_logic;
        timerInterrupt  : in     vl_logic;
        externalInterrupts: in     vl_logic_vector(15 downto 0);
        stalled         : in     vl_logic;
        interrupt_reg   : out    vl_logic;
        csrData         : out    vl_logic_vector(31 downto 0);
        nextPC          : out    vl_logic_vector(31 downto 0)
    );
end Zicsr;
