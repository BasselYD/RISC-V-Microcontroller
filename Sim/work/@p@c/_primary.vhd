library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        PCF_p           : in     vl_logic_vector(31 downto 0);
        EN              : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        PCF             : out    vl_logic_vector(31 downto 0)
    );
end PC;
