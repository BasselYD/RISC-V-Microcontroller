library verilog;
use verilog.vl_types.all;
entity BranchLogic is
    port(
        JumpE           : in     vl_logic;
        BranchE         : in     vl_logic;
        BranchTypeE     : in     vl_logic_vector(2 downto 0);
        Zero            : in     vl_logic;
        LSB             : in     vl_logic;
        trap            : in     vl_logic;
        mret            : in     vl_logic;
        PCSrcE          : out    vl_logic
    );
end BranchLogic;
