module Register_File #(parameter WIDTH = 32, parameter DEPTH_BITS = 5) (
    input       wire       [WIDTH - 1 : 0]                WrData,
    input       wire       [DEPTH_BITS - 1 : 0]           WrAddress,
    input       wire                                      WrEn,

    input       wire       [DEPTH_BITS - 1 : 0]           RdAddress1,
    input       wire       [DEPTH_BITS - 1 : 0]           RdAddress2,

    input       wire                                      CLK,
    input       wire                                      RST,

    output      wire       [WIDTH - 1 : 0]                RdData1,
    output      wire       [WIDTH - 1 : 0]                RdData2
);

localparam DEPTH = (1 << DEPTH_BITS);

reg     [WIDTH - 1 : 0]      RF      [DEPTH - 1 : 0];

integer I;

always @ (posedge CLK or negedge RST)
begin
    if (!RST)
        begin
            for (I = 0; I < DEPTH; I = I + 1)
                begin
                    RF[I] = 'b0;
                end
        end

    else if (WrEn)
        begin
            RF[WrAddress] <= WrData;
        end
end


assign RdData1 = RF[RdAddress1];
assign RdData2 = RF[RdAddress2];


endmodule