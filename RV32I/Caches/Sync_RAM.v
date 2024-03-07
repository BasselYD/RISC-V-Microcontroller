module Sync_RAM #(
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 8   
)(
    input wire                  clk,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] data_in,
    input wire                  write_enable,
    output reg [DATA_WIDTH-1:0] data_out
);

localparam RAM_DEPTH = 2**ADDR_WIDTH; 

// Internal memory array
reg [DATA_WIDTH-1:0] memory [0:RAM_DEPTH-1];

integer k;
initial begin
    for (k = 0; k < RAM_DEPTH; k = k + 1) begin : z2
        memory[k] = 0;
    end
end

// Read operation
always @(negedge clk) begin
    data_out <= memory[addr];
end

// Write operation
always @(negedge clk) begin
    if (write_enable)
        memory[addr] <= data_in;
end

endmodule