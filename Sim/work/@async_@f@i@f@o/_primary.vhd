library verilog;
use verilog.vl_types.all;
entity Async_FIFO is
    generic(
        DEPTH_BITS      : integer := 4
    );
    port(
        wr_en           : in     vl_logic;
        wr_data         : in     vl_logic_vector(7 downto 0);
        rd_en           : in     vl_logic;
        wr_clk          : in     vl_logic;
        rd_clk          : in     vl_logic;
        rst             : in     vl_logic;
        rd_data         : out    vl_logic_vector(7 downto 0);
        full_flag       : out    vl_logic;
        empty_flag      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DEPTH_BITS : constant is 1;
end Async_FIFO;
