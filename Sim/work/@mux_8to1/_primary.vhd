library verilog;
use verilog.vl_types.all;
entity Mux_8to1 is
    port(
        I0              : in     vl_logic_vector(31 downto 0);
        I1              : in     vl_logic_vector(31 downto 0);
        I2              : in     vl_logic_vector(31 downto 0);
        I3              : in     vl_logic_vector(31 downto 0);
        I4              : in     vl_logic_vector(31 downto 0);
        I5              : in     vl_logic_vector(31 downto 0);
        I6              : in     vl_logic_vector(31 downto 0);
        I7              : in     vl_logic_vector(31 downto 0);
        SEL             : in     vl_logic_vector(2 downto 0);
        Y               : out    vl_logic_vector(31 downto 0)
    );
end Mux_8to1;
