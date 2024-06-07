library verilog;
use verilog.vl_types.all;
entity Mux_2to1 is
    port(
        I0              : in     vl_logic_vector(31 downto 0);
        I1              : in     vl_logic_vector(31 downto 0);
        SEL             : in     vl_logic;
        Y               : out    vl_logic_vector(31 downto 0)
    );
end Mux_2to1;
