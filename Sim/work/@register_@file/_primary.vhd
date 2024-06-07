library verilog;
use verilog.vl_types.all;
entity Register_File is
    generic(
        WIDTH           : integer := 32;
        DEPTH_BITS      : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        WrData          : in     vl_logic_vector;
        WrAddress       : in     vl_logic_vector;
        WrEn            : in     vl_logic;
        RdAddress1      : in     vl_logic_vector;
        RdAddress2      : in     vl_logic_vector;
        RdData1         : out    vl_logic_vector;
        RdData2         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH_BITS : constant is 1;
end Register_File;
