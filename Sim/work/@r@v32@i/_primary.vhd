library verilog;
use verilog.vl_types.all;
entity RV32I is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rdata           : in     vl_logic_vector(31 downto 0);
        ready           : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        addr            : out    vl_logic_vector(31 downto 0);
        write           : out    vl_logic;
        wdata           : out    vl_logic_vector(31 downto 0);
        transfer        : out    vl_logic_vector(1 downto 0);
        NMI             : in     vl_logic;
        timerInterrupt  : in     vl_logic;
        externalInterrupts: in     vl_logic_vector(15 downto 0)
    );
end RV32I;
