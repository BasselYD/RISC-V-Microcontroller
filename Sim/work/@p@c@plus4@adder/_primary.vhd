library verilog;
use verilog.vl_types.all;
entity PCPlus4Adder is
    port(
        PCF             : in     vl_logic_vector(31 downto 0);
        PCPlus4F        : out    vl_logic_vector(31 downto 0)
    );
end PCPlus4Adder;
