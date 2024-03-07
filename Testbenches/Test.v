`timescale 1ns/1ps

module Test_tb;


reg              clk;
reg              rst;

reg [31:0]  mem [255:0];

// Task to initialize memory from a hex file
task initialize_memory;
    integer i; // Loop index

    begin
        // Read memory initialization file
        $readmemh("C:/Users/basse/Desktop/idk/Digital IC Design/Projects/RISC-V Microcontroller/instructions.hex", mem);

        // Display a message indicating memory initialization is complete
        $display("Memory initialization complete");
    end
endtask

initial begin
    initialize_memory();

    clk = 0;
    rst = 0;
    #5
    rst = 1;
    #5

    //DUT.HREADY = 1;
    //DUT.HRESP = 0;

    #50
    //DUT.HREADY = 0;
    #10
    //DUT.HREADY = 1;

    #5000;

    $stop;
end

//assign DUT.HRDATA = mem[DUT.HADDR >> 2];

// Clock generation
always #5 clk = ~clk;


System_Top DUT (
    .clk(clk),
    .rst(rst)
);


endmodule