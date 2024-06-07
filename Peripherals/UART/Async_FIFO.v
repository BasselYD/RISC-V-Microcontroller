module Async_FIFO #(parameter DEPTH_BITS = 4) (
    input       wire                        wr_en,
    input       wire        [7:0]           wr_data,
    input       wire                        rd_en,
    input       wire                        wr_clk,
    input       wire                        rd_clk,
    input       wire                        rst,
    output      reg         [7:0]           rd_data,
    output      reg                         full_flag,
    output      reg                         empty_flag
);

localparam DEPTH = (2 << DEPTH_BITS-1);

reg     [7:0]                    FIFO           [DEPTH-1 : 0];
reg     [DEPTH_BITS : 0]       wr_ptr, rd_ptr;
integer                          I;

always @ (negedge rst)
    begin
        if (!rst)
            begin
                for (I = 0; I < DEPTH; I = I + 1)
                    begin
                        FIFO[I] <= 0;
                    end
                
                wr_ptr <= 0;
                rd_ptr <= 0;
                //rd_data <= 0;
                //full_flag <= 0;
                //empty_flag <= 1;
            end
    end

always @ (posedge wr_clk)
    begin
        if (wr_en && !full_flag)
            begin
                FIFO[wr_ptr[DEPTH_BITS-1:0]] <= wr_data;
                wr_ptr <= wr_ptr + 1;
            end
    end


always @ (posedge rd_clk)
    begin
        if (rd_en && !empty_flag)
            begin
                rd_ptr <= rd_ptr + 1;
            end
    end


always @ (*)
    begin
        rd_data = FIFO[rd_ptr[DEPTH_BITS-1:0]];
        empty_flag = (rd_ptr == wr_ptr);
        full_flag  = (rd_ptr[DEPTH_BITS-1 : 0] == (wr_ptr[DEPTH_BITS-1 : 0])) && (rd_ptr[DEPTH_BITS] != wr_ptr[DEPTH_BITS]);
    end


endmodule