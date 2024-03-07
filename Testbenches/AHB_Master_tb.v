`timescale 1ns/1ps

module AHB_Master_tb;


// Testbench inputs
reg              HCLK;
reg              HRESETn;
reg              transfer;
reg              write;
reg    [31:0]    addr;
reg    [31:0]    wdata;
reg    [31:0]    HRDATA;
reg              HREADY;

// Testbench outputs
wire     [31:0]  rdata;
wire     [31:0]  HADDR;
wire             HWRITE;
wire     [31:0]  HWDATA;


initial begin
    HCLK = 0;
    HRESETn = 0;
    #4
    HRESETn = 1;
    #1
    HREADY = 1;

    transfer = 1;
    addr = 32'hA;
    write = 1; 

    #10

    wdata = 32'h27AB;
    addr = 32'hB;
    write = 0;

    #10

    //HREADY = 0;
    HRDATA = 32'hBBBBBBBB;
    addr = 32'hC;
    write = 1;

    #10

    wdata = 32'hAAAAAAAA;
    
    //HREADY = 1;

    

    #50;

    $stop;
end


// Clock generation
always #5 HCLK = ~HCLK;

// Instantiate the AHB Master module
AHB_Master DUT (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .transfer(transfer),
    .write(write),
    .addr(addr),
    .wdata(wdata),
    .HRDATA(HRDATA),
    .HREADY(HREADY),
    .rdata(rdata),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HWDATA(HWDATA)
);


endmodule