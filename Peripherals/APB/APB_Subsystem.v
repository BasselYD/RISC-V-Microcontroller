module APB_Subsystem (
    //AHB inputs
    input HCLK,
    input HRESETn,
    input [1:0] HTRANS,
    input [2:0] HSIZE,
    input [3:0] HPROT,
    input [15:0] HADDR,
    input [31:0] HWDATA,
    input HSEL,
    input HWRITE,
    input HREADY,

    //APB inputs  
    input PCLK,
    input PRESETn,

    //AHB outputs
    output [31:0] HRDATA,
    output HREADYOUT,
    output HRESP,

    input       UART_RX,
     
    //Tx Signals
    output      UART_TX,
    output      UART_Busy,

    inout   [7:0]    PORTA,
    inout   [7:0]    PORTB,
    inout   [7:0]    PORTC,
    inout   [7:0]    PORTD,
    
    //APB outputs
    output timer_interrupt
);

wire        PSEL;
wire        PENABLE;
wire        PWRITE;
wire [15:0] PADDR;
wire [31:0] PWDATA;
wire [3:0]  PSTRB;

wire        TIMER_PSEL;
wire [31:0] TIMER_PRDATA;
wire        TIMER_SLVERR;
wire        TIMER_READY;

wire        UART_PSEL;
wire [31:0] UART_PRDATA;
wire        UART_SLVERR;
wire        UART_READY;

wire        GPIO_PSEL;
wire [31:0] GPIO_PRDATA;
wire        GPIO_SLVERR;
wire        GPIO_READY;

wire        PSLVERR;
wire        PREADY;
wire [31:0] PRDATA;

APB_Bridge #(.HADDR_SIZE (16),
             .HDATA_SIZE (32),
             .PADDR_SIZE (16),
             .PDATA_SIZE (32),
             .SYNC_DEPTH (3))
APB_Bridge_inst (
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    .HSEL(HSEL),
    .HADDR(HADDR),
    .HWDATA(HWDATA),
    .HRDATA(HRDATA),
    .HWRITE(HWRITE),
    .HSIZE(HSIZE),
    .HBURST(3'b0),  
    .HPROT(HPROT),
    .HTRANS(HTRANS),
    .HMASTLOCK(1'b0), 
    .HREADYOUT(HREADYOUT),
    .HREADY(HREADY),
    .HRESP(HRESP),
    .PRESETn(PRESETn),
    .PCLK(PCLK),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PPROT(), 
    .PWRITE(PWRITE),
    .PSTRB(), 
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PREADY(PREADY),  
    .PSLVERR(PSLVERR)
);

//  0x1000 UART
//  0x2000 GPIO
APB_decoder APB_decoder_inst (
    .PADDR(PADDR[15:12]),
    .PSEL(PSEL),
    .TIMER_PSEL(TIMER_PSEL),
    .UART_PSEL(UART_PSEL),
    .GPIO_PSEL(GPIO_PSEL)
);

Timer_APB #(.nTIMERS(3)) u_Timer (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(TIMER_PSEL),
    .PADDR(PADDR[7:0]),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PRDATA(TIMER_PRDATA),
    .PREADY(TIMER_READY),
    .PSLVERR(TIMER_SLVERR),
    .TIMERINT(timer_interrupt)
);

UART_APB u_UART (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(UART_PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR[7:0]),
    .PWDATA(PWDATA),
    .PSTRB(PSTRB),
    .PRDATA(UART_PRDATA),
    .PREADY(UART_READY),
    .PSLVERR(UART_SLVERR),
    .RX_IN_TOP(UART_RX),
    .TX_OUT_TOP(UART_TX),
    .Busy_TOP(UART_Busy)
);

GPIO_Controller #(.PINS(8)) u_GPIO (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(GPIO_PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR[7:0]),
    .PWDATA(PWDATA),
    .PSTRB(PSTRB),
    .PRDATA(GPIO_PRDATA),
    .PREADY(GPIO_READY),
    .PSLVERR(GPIO_SLVERR),
    .PORTA(PORTA),
    .PORTB(PORTB),
    .PORTC(PORTC),
    .PORTD(PORTD)
);

cmsdk_apb_slave_mux u_slave_mux(
    .PSEL0(TIMER_PSEL),
    .PREADY0(TIMER_READY), 
    .PRDATA0(TIMER_PRDATA),
    .PSLVERR0(TIMER_SLVERR),
    .PSEL1(UART_PSEL),
    .PREADY1(UART_READY), 
    .PRDATA1(UART_PRDATA),
    .PSLVERR1(UART_SLVERR),
    .PSEL2(GPIO_PSEL),
    .PREADY2(GPIO_READY),
    .PRDATA2(GPIO_PRDATA),
    .PSLVERR2(GPIO_SLVERR),
    .PSEL3(1'b0),
    .PREADY3(1'b1),
    .PRDATA3(0),
    .PSLVERR3(1'b0),
    .PSEL4(1'b0),
    .PREADY4(1'b1), 
    .PRDATA4(0),
    .PSLVERR4(1'b0),
    .PREADY(PREADY),
    .PRDATA(PRDATA),
    .PSLVERR(PSLVERR)
);

endmodule