module System_Top (
    input       wire        HCLK,
    input       wire        HRESETn,
    input       wire        PCLK,
    input       wire        PRESETn,
    input   wire            NMI,
    input   wire    [15:0]  externalInterrupts,
    input   wire            UART_RX,
    output  wire            UART_TX,
    output  wire            UART_Busy,
    inout   wire    [7:0]   PORTA,
    inout   wire    [7:0]   PORTB,
    inout   wire    [7:0]   PORTC,
    inout   wire    [7:0]   PORTD
);


//  Processor Interface.
wire  [31:0]  addr;
wire          write;
wire  [31:0]  wdata;
wire   [1:0]  transfer;
wire  [31:0]  rdata;
wire          ready;

//  AHB Interface.
/*wire   [31:0]  HRDATA;
reg    [1:0]   HRESP;
reg            HREADY;

wire  [31:0]  HADDR;
wire          HWRITE;
wire  [31:0]  HWDATA;
wire  [2:0]   HSIZE;
wire  [1:0]   HTRANS;
wire  [2:0]   HBURST;
wire  [3:0]   HPROT;*/


//
// Input port SI0 (inputs from processor)
wire  [31:0] HADDRS0;        // Address bus
wire  [1:0] HTRANSS0;        // Transfer type
wire        HWRITES0;        // Transfer direction
wire  [2:0] HSIZES0;         // Transfer size
wire  [2:0] HBURSTS0;        // Burst type
wire  [3:0] HPROTS0;         // Protection control
wire [31:0] HWDATAS0;        // Write data
wire        HMASTLOCKS0;     // Locked Sequence
wire [31:0] HAUSERS0;        // Address USER signals
wire [31:0] HWUSERS0;        // Write-data USER signals


// Input port SI0 (outputs to processor)
wire [31:0] HRDATAS0;        // Read data bus
wire        HREADYS0;        // HREADY feedback
wire        HRESPS0;         // Transfer response
wire [31:0] HRUSERS0;        // Read-data USER signals
wire        SCANOUTHCLK;



// Output port MI0 (outputs to ISRAM)
wire        HSELM0;          // Slave Select
wire [31:0] HADDRM0;         // Address bus
wire [1:0]  HTRANSM0;        // Transfer type
wire        HWRITEM0;        // Transfer direction
wire [2:0]  HSIZEM0;         // Transfer size
wire [2:0]  HBURSTM0;        // Burst type
wire [3:0]  HPROTM0;         // Protection control
wire [31:0] HWDATAM0;        // Write data
wire [31:0] HRDATAM0;        // Read data
wire        HMASTLOCKM0;     // Locked Sequence
wire        HREADYMUXM0;     // Transfer done
wire        HREADYOUTM0;     // Transfer done
wire [31:0] HAUSERM0;        // Address USER signals
wire [31:0] HWUSERM0;        // Write-data USER signals


// Output port MI1 (outputs to DSRAM)
wire        HSELM1;          // Slave Select
wire [31:0] HADDRM1;         // Address bus
wire [1:0]  HTRANSM1;        // Transfer type
wire        HWRITEM1;        // Transfer direction
wire [2:0]  HSIZEM1;         // Transfer size
wire [2:0]  HBURSTM1;        // Burst type
wire [3:0]  HPROTM1;         // Protection control
wire [31:0] HWDATAM1;        // Write data
wire [31:0] HRDATAM1;        // Read data
wire        HMASTLOCKM1;     // Locked Sequence
wire        HREADYMUXM1;     // Transfer done
wire        HREADYOUTM1;     // Transfer done
wire [31:0] HAUSERM1;        // Address USER signals
wire [31:0] HWUSERM1;        // Write-data USER signals


// Output port MI2 (outputs to ...)
wire        HSELM2;          // Slave Select
wire [31:0] HADDRM2;         // Address bus
wire [1:0]  HTRANSM2;        // Transfer type
wire        HWRITEM2;        // Transfer direction
wire [2:0]  HSIZEM2;         // Transfer size
wire [2:0]  HBURSTM2;        // Burst type
wire [3:0]  HPROTM2;         // Protection control
wire [31:0] HWDATAM2;        // Write data
wire [31:0] HRDATAM2;        // Read data
wire        HMASTLOCKM2;     // Locked Sequence
wire        HREADYMUXM2;     // Transfer done
wire        HREADYOUTM2;     // Transfer done
wire [31:0] HAUSERM2;        // Address USER signals
wire [31:0] HWUSERM2;        // Write-data USER signals


// Output port MI3 (outputs to ...)
wire        HSELM3;          // Slave Select
wire [31:0] HADDRM3;         // Address bus
wire [1:0]  HTRANSM3;        // Transfer type
wire        HWRITEM3;        // Transfer direction
wire [2:0]  HSIZEM3;         // Transfer size
wire [2:0]  HBURSTM3;        // Burst type
wire [3:0]  HPROTM3;         // Protection control
wire [31:0] HWDATAM3;        // Write data
wire [31:0] HRDATAM3;        // Read data
wire        HMASTLOCKM3;     // Locked Sequence
wire        HREADYMUXM3;     // Transfer done
wire        HREADYOUTM3;     // Transfer done
wire [31:0] HAUSERM3;        // Address USER signals
wire [31:0] HWUSERM3;        // Write-data USER signals

wire timerInterrupt;


RV32I Processor (
    .clk(HCLK),
    .rst(HRESETn),

    .rdata(rdata),
    .ready(ready),
    .HTRANS(HTRANSS0),

    .addr(addr),
    .write(write),
    .wdata(wdata),
    .transfer(transfer),

    .NMI(NMI),
    .timerInterrupt(timerInterrupt),
    .externalInterrupts(externalInterrupts)
);

AHB_Master AHB_Interface (
    //  Clock and Reset.
    .HCLK(HCLK),
    .HRESETn(HRESETn),

    //  Processor Interface.
    .addr(addr),
    .write(write),
    .wdata(wdata),
    .transfer(transfer),
    .rdata(rdata),
    .ready(ready),

    //  AHB Interface.
    .HRDATA(HRDATAS0),
    .HRESP(HRESPS0),
    .HREADY(HREADYS0),

    .HADDR(HADDRS0),
    .HWRITE(HWRITES0),
    .HWDATA(HWDATAS0),
    .HSIZE(HSIZES0),
    .HTRANS(HTRANSS0),
    .HBURST(HBURSTS0),
    .HPROT(HPROTS0)
);


AHB_BusMatrix_lite BusMatrix (

    // Common AHB signals
    .HCLK(HCLK),
    .HRESETn(HRESETn),

    // System Address Remap control
    .REMAP(3'b0),

    // Input port SI0 (inputs from master 0, RISC-V)
    .HADDRS0(HADDRS0),
    .HTRANSS0(HTRANSS0),
    .HWRITES0(HWRITES0),
    .HSIZES0(HSIZES0),
    .HBURSTS0(HBURSTS0),
    .HPROTS0(HPROTS0),
    .HWDATAS0(HWDATAS0),
    .HMASTLOCKS0(0),
    .HAUSERS0(0),
    .HWUSERS0(0),

    // Output port MI0 (inputs from slave 0, I-SRAM)
    .HRDATAM0(HRDATAM0),
    .HREADYOUTM0(HREADYOUTM0),
    .HRESPM0(HRESPM0),
    .HRUSERM0(HRUSERM0),

    // Output port MI1 (inputs from slave 1, D-SRAM)
    .HRDATAM1(HRDATAM1),
    .HREADYOUTM1(HREADYOUTM1),
    .HRESPM1(HRESPM1),
    .HRUSERM1(HRUSERM1),

    // Output port MI2 (inputs from slave 2)
    .HRDATAM2(HRDATAM2),
    .HREADYOUTM2(HREADYOUTM2),
    .HRESPM2(HRESPM2),
    .HRUSERM2(HRUSERM2),

    // Output port MI3 (inputs from slave 3)
    .HRDATAM3(HRDATAM3),
    .HREADYOUTM3(HREADYOUTM3),
    .HRESPM3(HRESPM3),
    .HRUSERM3(HRUSERM3),

    // Scan test dummy signals; not connected until scan insertion
    .SCANENABLE(SCANENABLE),   // Scan Test Mode Enable
    .SCANINHCLK(SCANINHCLK),   // Scan Chain Input


    // Output port MI0 (outputs to slave 0, I-SRAM)
    .HSELM0(HSELM0),
    .HADDRM0(HADDRM0),
    .HTRANSM0(HTRANSM0),
    .HWRITEM0(HWRITEM0),
    .HSIZEM0(HSIZEM0),
    .HBURSTM0(HBURSTM0),
    .HPROTM0(HPROTM0),
    .HWDATAM0(HWDATAM0),
    .HMASTLOCKM0(HMASTLOCKM0),
    .HREADYMUXM0(HREADYMUXM0),
    .HAUSERM0(HAUSERM0),
    .HWUSERM0(HWUSERM0),

    // Output port MI1 (outputs to slave 1, D-SRAM)
    .HSELM1(HSELM1),
    .HADDRM1(HADDRM1),
    .HTRANSM1(HTRANSM1),
    .HWRITEM1(HWRITEM1),
    .HSIZEM1(HSIZEM1),
    .HBURSTM1(HBURSTM1),
    .HPROTM1(HPROTM1),
    .HWDATAM1(HWDATAM1),
    .HMASTLOCKM1(HMASTLOCKM1),
    .HREADYMUXM1(HREADYMUXM1),
    .HAUSERM1(HAUSERM1),
    .HWUSERM1(HWUSERM1),

    // Output port MI2 (outputs to slave 2)
    .HSELM2(HSELM2),
    .HADDRM2(HADDRM2),
    .HTRANSM2(HTRANSM2),
    .HWRITEM2(HWRITEM2),
    .HSIZEM2(HSIZEM2),
    .HBURSTM2(HBURSTM2),
    .HPROTM2(HPROTM2),
    .HWDATAM2(HWDATAM2),
    .HMASTLOCKM2(HMASTLOCKM2),
    .HREADYMUXM2(HREADYMUXM2),
    .HAUSERM2(HAUSERM2),
    .HWUSERM2(HWUSERM2),

    // Output port MI3 (outputs to slave 3)
    .HSELM3(HSELM3),
    .HADDRM3(HADDRM3),
    .HTRANSM3(HTRANSM3),
    .HWRITEM3(HWRITEM3),
    .HSIZEM3(HSIZEM3),
    .HBURSTM3(HBURSTM3),
    .HPROTM3(HPROTM3),
    .HWDATAM3(HWDATAM3),
    .HMASTLOCKM3(HMASTLOCKM3),
    .HREADYMUXM3(HREADYMUXM3),
    .HAUSERM3(HAUSERM3),
    .HWUSERM3(HWUSERM3),

    // Input port SI0 (outputs to master 0)
    .HRDATAS0(HRDATAS0),
    .HREADYS0(HREADYS0),
    .HRESPS0(HRESPS0),
    .HRUSERS0(HRUSERS0),

    // Scan test dummy signals; not connected until scan insertion
    .SCANOUTHCLK(SCANOUTHCLK)   // Scan Chain Output

);

    
Instruction_SRAM_TOP Instruction_SRAM_TOP_instance(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSELM0),
    .HREADY(HREADYMUXM0),
    .HTRANS(HTRANSM0),
    .HSIZE(HSIZEM0),
    .HWRITE(HWRITEM0),
    .HADDR(HADDRM0),
    .HWDATA(HWDATAM0),
    .HREADYOUT(HREADYOUTM0),
    .HRESP(HRESPM0),
    .HRDATA(HRDATAM0)
);


DATA_SRAM_TOP DATA_SRAM_TOP_instance(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSELM1),
    .HREADY(HREADYMUXM1),
    .HTRANS(HTRANSM1),
    .HSIZE(HSIZEM1),
    .HWRITE(HWRITEM1),
    .HADDR(HADDRM1),
    .HWDATA(HWDATAM1),
    .HREADYOUT(HREADYOUTM1),
    .HRESP(HRESPM1),
    .HRDATA(HRDATAM1)
);

APB_Subsystem u_apb_subsystem (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HTRANS(HTRANSM2),
    .HSIZE(HSIZEM2),
    .HPROT(HPROTM2),
    .HADDR(HADDRM2[15:0]),
    .HWDATA(HWDATAM2),
    .HSEL(HSELM2),
    .HWRITE(HWRITEM2),
    .HREADY(HREADYMUXM2), 
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .HRDATA(HRDATAM2),
    .HREADYOUT(HREADYOUTM2),
    .HRESP(HRESPM2),
    .UART_RX(UART_RX),
    .UART_TX(UART_TX),
    .UART_Busy(UART_Busy),
    .PORTA(PORTA),
    .PORTB(PORTB),
    .PORTC(PORTC),
    .PORTD(PORTD),
    .timer_interrupt(timerInterrupt)
);

endmodule