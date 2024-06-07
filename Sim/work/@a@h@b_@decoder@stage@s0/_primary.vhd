library verilog;
use verilog.vl_types.all;
entity AHB_DecoderStageS0 is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HREADYS         : in     vl_logic;
        sel_dec         : in     vl_logic;
        decode_addr_dec : in     vl_logic_vector(31 downto 10);
        trans_dec       : in     vl_logic_vector(1 downto 0);
        active_dec0     : in     vl_logic;
        readyout_dec0   : in     vl_logic;
        resp_dec0       : in     vl_logic_vector(1 downto 0);
        rdata_dec0      : in     vl_logic_vector(31 downto 0);
        ruser_dec0      : in     vl_logic_vector(31 downto 0);
        active_dec1     : in     vl_logic;
        readyout_dec1   : in     vl_logic;
        resp_dec1       : in     vl_logic_vector(1 downto 0);
        rdata_dec1      : in     vl_logic_vector(31 downto 0);
        ruser_dec1      : in     vl_logic_vector(31 downto 0);
        active_dec2     : in     vl_logic;
        readyout_dec2   : in     vl_logic;
        resp_dec2       : in     vl_logic_vector(1 downto 0);
        rdata_dec2      : in     vl_logic_vector(31 downto 0);
        ruser_dec2      : in     vl_logic_vector(31 downto 0);
        active_dec3     : in     vl_logic;
        readyout_dec3   : in     vl_logic;
        resp_dec3       : in     vl_logic_vector(1 downto 0);
        rdata_dec3      : in     vl_logic_vector(31 downto 0);
        ruser_dec3      : in     vl_logic_vector(31 downto 0);
        sel_dec0        : out    vl_logic;
        sel_dec1        : out    vl_logic;
        sel_dec2        : out    vl_logic;
        sel_dec3        : out    vl_logic;
        active_dec      : out    vl_logic;
        HREADYOUTS      : out    vl_logic;
        HRESPS          : out    vl_logic_vector(1 downto 0);
        HRUSERS         : out    vl_logic_vector(31 downto 0);
        HRDATAS         : out    vl_logic_vector(31 downto 0)
    );
end AHB_DecoderStageS0;
