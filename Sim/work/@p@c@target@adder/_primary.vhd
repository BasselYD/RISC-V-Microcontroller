library verilog;
use verilog.vl_types.all;
entity PCTargetAdder is
    port(
        PCE             : in     vl_logic_vector(31 downto 0);
        ExtImmE         : in     vl_logic_vector(31 downto 0);
        PcTargetE       : out    vl_logic_vector(31 downto 0)
    );
end PCTargetAdder;
