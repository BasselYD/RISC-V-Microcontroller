library verilog;
use verilog.vl_types.all;
entity cmsdk_fpga_isram is
    generic(
        AW              : integer := 16;
        MEMFILE         : string  := "E:/idk/Digital IC Design/Projects/RISC-V Microcontroller/Testbenches/Test Programs/gpio_uart.hex"
    );
    port(
        CLK             : in     vl_logic;
        ADDR            : in     vl_logic_vector;
        WDATA           : in     vl_logic_vector(31 downto 0);
        WREN            : in     vl_logic_vector(3 downto 0);
        CS              : in     vl_logic;
        RDATA           : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of MEMFILE : constant is 1;
end cmsdk_fpga_isram;
