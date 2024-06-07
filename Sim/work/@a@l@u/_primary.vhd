library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        ALUControlE     : in     vl_logic_vector(2 downto 0);
        SLTControlE     : in     vl_logic_vector(1 downto 0);
        ALUResultE      : out    vl_logic_vector(31 downto 0);
        Flags           : out    vl_logic_vector(3 downto 0)
    );
end ALU;
