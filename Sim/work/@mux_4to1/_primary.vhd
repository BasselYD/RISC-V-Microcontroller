library verilog;
use verilog.vl_types.all;
entity Mux_4to1 is
    port(
        I0              : in     vl_logic_vector(31 downto 0);
        I1              : in     vl_logic_vector(31 downto 0);
        I2              : in     vl_logic_vector(31 downto 0);
        I3              : in     vl_logic_vector(31 downto 0);
        SEL             : in     vl_logic_vector(1 downto 0);
        Y               : out    vl_logic_vector(31 downto 0)
    );
end Mux_4to1;
