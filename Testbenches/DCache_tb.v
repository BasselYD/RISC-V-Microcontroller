`timescale 1ns / 1ps

module DCache_tb;

    // Parameters for D-Cache module
    parameter BLOCK_SIZE = 8;
    parameter TOTAL_LINES = 256;
    parameter ASSOCIATIVITY = 4;

    // Signals
    reg clk;
    reg rst;

    reg  [31:0] address;
    reg         read;
    reg         write;
    reg  [31:0] writeData;
    reg  [2:0]  strobe;
    wire [31:0] readData;
    wire        valid;

    reg                         memBusy;
    wire [31:0]                 memAddress;
    wire                        memRead;
    reg  [(BLOCK_SIZE*8) - 1:0] memReadData;
    wire                        memWrite;
    wire [(BLOCK_SIZE*8) - 1:0] memWriteData;

    // Instantiate D-Cache module
    DCache #(
        .BLOCK_SIZE(BLOCK_SIZE),
        .TOTAL_LINES(TOTAL_LINES),
        .ASSOCIATIVITY(ASSOCIATIVITY)
    ) dut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .read(read),
        .write(write),
        .writeData(writeData),
        .strobe(strobe),
        .readData(readData),
        .valid(valid),
        .memBusy(memBusy),
        .memAddress(memAddress),
        .memRead(memRead),
        .memReadData(memReadData),
        .memWrite(memWrite),
        .memWriteData(memWriteData)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer i;
    // Reset generation
    initial begin
        clk = 0;
        rst = 0;
        #10;
        rst = 1;

        memBusy = 0;
        memReadData = 0;

        //  Test case 1: Read from cache (miss, set 0, word).
        #20; 
        address = 32'h00000004; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b010; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hAB_CD_12_34_56_78_90_90;

        @valid
        #10
        read = 0;

        //  Test case 2: Read from cache (miss, same index, set 1, u-byte).
        #20; 
        address = 32'h00001005; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b100; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hAA_AA_AA_AA_AA_BB_CC_AA;

        @valid
        #10
        read = 0;

        //  Test case 3: Write to cache (miss, same index, set 2, byte).
        #20; 
        address = 32'h00031005; 
        read = 0; 
        write = 1; 
        writeData = 8'h49;
        strobe = 3'b000; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hBB_BB_BB_BB_BB_BB_CC_BB;

        @valid
        #20
        write = 0;

        //  Test case 4: Write to cache (miss, same index, set 3, byte).
        #20; 
        address = 32'h00051002; 
        read = 0; 
        write = 1; 
        writeData = 16'h6767;
        strobe = 3'b001; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hBB_BB_BB_BB_BB_BB_CC_BB;

        @valid
        #20
        write = 0;

         //  Test case 5: Read from cache (miss, set 0, word).
        #20; 
        address = 32'h033000004; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b010; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hAB_99_99_99_99_99_99_99;

        @valid
        #10
        read = 0;

        //  Test case 6: Read from cache (miss, same index, set 1, u-byte).
        #20; 
        address = 32'h70001005; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b100; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'h45_54_DD_DD_DD_CC_CC_CC;

        @valid
        #10
        read = 0;

        //  Test case 7: Read from cache (miss, same index, set 1, u-byte).
        #20; 
        address = 32'h90001001; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b100; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'h00_19_33_66_00_88_99_00;

        @valid
        #10
        read = 0;

        //  Test case 8: Read from cache (miss, same index, set 1, u-byte).
        #20; 
        address = 32'h99001001; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b010; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hFF_FF_FF_FF_EE_EE_EE_EE;

        @valid
        #10
        read = 0;

        //  Test case 9: Read from cache (miss, same index, set 1, u-byte).
        #20; 
        address = 32'h10101001; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b010; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hFF_FF_FF_FF_EE_EE_EE_EE;

        @valid
        #10
        read = 0;

        //  Test case 10: Read from cache (miss, same index, set 1, u-byte).
        #20; 
        address = 32'h10201001; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b010; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'h19_09_19_09_EE_CC_EE_CC;

        @valid
        #10
        read = 0;

        /*
        //  Test case 1: Read from cache (miss, set 0, word).
        #20; 
        address = 32'h00000004; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b010; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hAB_CD_12_34_56_78_90_90;

        @valid
        #10
        read = 0;

        //  Test case 2: Read from cache (miss, same index, set 1, u-byte).
        #20; 
        address = 32'h00001005; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b100; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hAA_AA_AA_AA_AA_BB_CC_AA;

        @valid
        #10
        read = 0;

        //  Test case 3: Write to cache (hit, set 1, word).
        #20; 
        address = 32'h00001005; 
        read = 0; 
        write = 1; 
        writeData = 32'hFAFAFFFF;
        strobe = 3'b010; 
        #10
        write = 0;



        //  Test case 4: Read from cache (hit, set 0, byte).
        //               Read from cache (hit, set 0, halfword).
        #20; 
        address = 32'h00000001; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b000; 
        #10
        read = 0;
        //
        #20; 
        address = 32'h00000006; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b001; 
        #10
        read = 0;

        //  Test case 5: Read from cache (miss, set 1, u-halfword).
        #20; 
        address = 32'h00C01005; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b101; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hCC_BB_DD_AA_CC_BB_DD_AA;

        @valid
        #10
        read = 0;


        //  Test case 6: Write to cache (hit, set 0, halfword).
        #20; 
        address = 32'h00000003; 
        read = 0; 
        write = 1; 
        writeData = 32'h1111;
        strobe = 3'b001; 
        #10
        write = 0;

        //  Test case 7: Write to cache (hit, set 0, byte).
        #20; 
        address = 32'h00000005; 
        read = 0; 
        write = 1; 
        writeData = 32'hCC;
        strobe = 3'b000; 
        #10
        write = 0;

        //  Test case 8: Read from cache (hit, set 0, byte).
        #20; 
        address = 32'h00000005; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b000; 
        #10
        read = 0;

        //  Test case 9: Read from cache (miss, set 0, word).
        //  Reading from set 1 so set 0 becomes LRU, to test writeback.
        for (i = 0; i < 4; i=i+1) begin
            #20; 
            address = 32'h00C01005; 
            read = 1; 
            write = 0; 
            writeData = 0;
            strobe = 3'b101; 
            #10
            read = 0;
        end

        #20; 
        address = 32'hAB000004; 
        read = 1; 
        write = 0; 
        writeData = 0;
        strobe = 3'b010; 

        //  Memory response.
        @memRead
        memBusy = 1;
        #20
        memBusy = 0;
        memReadData = 256'hBB_AA_BB_AA_19_09_27_04;

        @valid
        #10
        read = 0;*/
        
        #500
        $stop; // End simulation
    end

endmodule