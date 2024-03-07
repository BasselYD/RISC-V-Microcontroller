module Register_File #(parameter WIDTH = 32, parameter DEPTH_BITS = 5) (
    input       wire                                      clk,
    input       wire                                      rst,

    input       wire       [WIDTH - 1 : 0]                WrData,
    input       wire       [DEPTH_BITS - 1 : 0]           WrAddress,
    input       wire                                      WrEn,

    input       wire       [DEPTH_BITS - 1 : 0]           RdAddress1,
    input       wire       [DEPTH_BITS - 1 : 0]           RdAddress2,

    output      reg        [WIDTH - 1 : 0]                RdData1,
    output      reg        [WIDTH - 1 : 0]                RdData2
);

localparam DEPTH = (1 << DEPTH_BITS);

reg     [WIDTH - 1 : 0]      RF      [DEPTH - 1 : 0];


always @ (posedge clk or negedge rst)
begin
    if (!rst)
        begin
            RdData1 <= 0;
            RdData2 <= 0;
        end

    else 
        begin
            RdData1 <= (RdAddress1 == 0) ? 32'b0 : RF[RdAddress1];
            RdData2 <= (RdAddress2 == 0) ? 32'b0 : RF[RdAddress2];
        end

end

always @ (negedge clk)
begin
    if (WrEn)
        begin
            if (WrAddress != 0)
                RF[WrAddress] <= WrData;
        end
end



endmodule