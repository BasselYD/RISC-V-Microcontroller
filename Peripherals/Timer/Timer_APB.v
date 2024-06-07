module Timer_APB #(parameter nTIMERS = 3) (
    input  wire        PCLK,    	// PCLK for timer operation
    input  wire        PRESETn, 	// Reset
  
    input  wire        PSEL,    	// Device select
    input  wire [7:0]  PADDR,   	// Address
    input  wire        PENABLE, 	// Transfer control
    input  wire        PWRITE,  	// Write control
    input  wire [31:0] PWDATA,  	// Write data
  
    output wire [31:0] PRDATA,  	// Read data
    output wire        PREADY,  	// Device ready
    output wire        PSLVERR, 	// Device error response

    output wire        TIMERINT
);

wire write_enable = PSEL & (~PENABLE) & PWRITE; // Assert for 1st cycle of write transfer.

Timer #(.nTIMERS(nTIMERS)) u_Timer_Core (
    .clk(PCLK),
    .rst(PRESETn),
    .cs(PSEL),
    .addr(PADDR),
    .rw(write_enable),
    .wdata(PWDATA),
    .rdata(PRDATA),
    .error(PSLVERR),
    .ready(PREADY),
    .interrupt(TIMERINT)
);

endmodule