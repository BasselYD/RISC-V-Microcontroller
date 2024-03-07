`timescale 1ns/1ns

module ICache_tb;

localparam BLOCK_SIZE = 32;
localparam NUM_LINES = 10;

// Testbench inputs
reg clk;
reg rst;
reg [31:0] address;
reg [(BLOCK_SIZE*8) - 1:0] memReadData;
reg memBusy;

// Testbench outputs
wire [31:0]   instruction;
wire          valid;
wire [31:0]   memAddress;
wire          memRead;


integer i;

initial begin
    clk = 0;
    rst = 0;
    #5
    rst = 1;

    // Cache miss scenario
    address = 32'b1111000011110000111100001_0010_000;
    #20;
    memBusy = 1;
    #30
    memReadData = 256'h12345678_9ABCDEF1_23456789_ABCDEF12_3456789A_BCDEF123_456789AB_CDEF1234;
    memBusy = 0;
    #21
    memReadData = 0;
    #9

    for (i = 0; i < 8; i = i + 1) begin
        address = {29'b1111000011110000111100001_0010,i[2:0]};
        #10;    
    end


    address = 32'b1111000011110000111100001_0011_000;
    #20;
    memBusy = 1;
    #30
    memReadData = 256'h11111111_22222222_33333333_44444444_55555555_66666666_77777777_88888888;
    memBusy = 0;
    #20
    memReadData = 0;
    #10

    for (i = 0; i < 8; i = i + 1) begin
        address = {29'b1111000011110000111100001_0011,i[2:0]};
        #10;    
    end


    address = 32'b1111000011110000000000001_0010_000;
    #20;
    memBusy = 1;
    #30
    memReadData = {32{8'hAB}};
    memBusy = 0;
    #20
    memReadData = 0;
    #10

    for (i = 0; i < 8; i = i + 1) begin
        address = {29'b1111000011110000000000001_0010,i[2:0]};
        #10;    
    end

    #20;

    $stop;
end


// Clock generation
always #5 clk = ~clk;

// Instantiate the I-Cache module
ICache #(
    .BLOCK_SIZE(BLOCK_SIZE),
    .NUM_LINES(NUM_LINES)
) DUT (
    .clk(clk),
    .rst(rst),
    .address(address),
    .instruction(instruction),
    .valid(valid),
    .memReadData(memReadData),
    .memBusy(memBusy),
    .memAddress(memAddress),
    .memRead(memRead)
);


endmodule