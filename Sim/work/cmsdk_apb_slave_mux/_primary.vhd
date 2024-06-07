library verilog;
use verilog.vl_types.all;
entity cmsdk_apb_slave_mux is
    port(
        PSEL0           : in     vl_logic;
        PREADY0         : in     vl_logic;
        PRDATA0         : in     vl_logic_vector(31 downto 0);
        PSLVERR0        : in     vl_logic;
        PSEL1           : in     vl_logic;
        PREADY1         : in     vl_logic;
        PRDATA1         : in     vl_logic_vector(31 downto 0);
        PSLVERR1        : in     vl_logic;
        PSEL2           : in     vl_logic;
        PREADY2         : in     vl_logic;
        PRDATA2         : in     vl_logic_vector(31 downto 0);
        PSLVERR2        : in     vl_logic;
        PSEL3           : in     vl_logic;
        PREADY3         : in     vl_logic;
        PRDATA3         : in     vl_logic_vector(31 downto 0);
        PSLVERR3        : in     vl_logic;
        PSEL4           : in     vl_logic;
        PREADY4         : in     vl_logic;
        PRDATA4         : in     vl_logic_vector(31 downto 0);
        PSLVERR4        : in     vl_logic;
        PREADY          : out    vl_logic;
        PRDATA          : out    vl_logic_vector(31 downto 0);
        PSLVERR         : out    vl_logic
    );
end cmsdk_apb_slave_mux;
