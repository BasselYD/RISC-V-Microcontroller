library verilog;
use verilog.vl_types.all;
entity AHB_Arbiter is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        req_port0       : in     vl_logic;
        HREADYM         : in     vl_logic;
        HSELM           : in     vl_logic;
        HTRANSM         : in     vl_logic_vector(1 downto 0);
        HBURSTM         : in     vl_logic_vector(2 downto 0);
        HMASTLOCKM      : in     vl_logic;
        addr_in_port    : out    vl_logic_vector(0 downto 0);
        no_port         : out    vl_logic
    );
end AHB_Arbiter;
