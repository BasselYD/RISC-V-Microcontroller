library verilog;
use verilog.vl_types.all;
entity AHB_BusMatrix_default_slave is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HSEL            : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HREADY          : in     vl_logic;
        HREADYOUT       : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0)
    );
end AHB_BusMatrix_default_slave;
