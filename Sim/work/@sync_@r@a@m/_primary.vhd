library verilog;
use verilog.vl_types.all;
entity Sync_RAM is
    generic(
        ADDR_WIDTH      : integer := 10;
        DATA_WIDTH      : integer := 8
    );
    port(
        clk             : in     vl_logic;
        addr            : in     vl_logic_vector;
        data_in         : in     vl_logic_vector;
        write_enable    : in     vl_logic;
        data_out        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
end Sync_RAM;
