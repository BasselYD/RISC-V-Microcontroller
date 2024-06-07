library verilog;
use verilog.vl_types.all;
entity SignExtend is
    port(
        ImmFields       : in     vl_logic_vector(31 downto 7);
        ImmSrcD         : in     vl_logic_vector(2 downto 0);
        ExtImmD         : out    vl_logic_vector(31 downto 0)
    );
end SignExtend;
