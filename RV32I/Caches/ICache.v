module ICache #(
    parameter   BLOCK_SIZE  =   32,
    parameter   NUM_LINES   =   256
) (
    input   wire            clk,
    input   wire            rst,

    //  Processor Interface.
    input   wire    [31:0]      address,
    output  reg     [31:0]      instruction,
    output  reg                 valid,

    //  Memory Interface.
    input   wire    [(BLOCK_SIZE*8) - 1:0]  memReadData,
    input   wire                            memBusy,
    output  reg     [31:0]                  memAddress,
    output  reg                             memRead
);

//  256 bits in a block. 8 words. 
localparam OFFSET_WIDTH = $clog2(BLOCK_SIZE);
localparam INDEX_WIDTH  = $clog2(NUM_LINES);
localparam TAG_WIDTH    = 32 - OFFSET_WIDTH - INDEX_WIDTH;


reg     [(BLOCK_SIZE*8) -1:0]  cacheData   [NUM_LINES-1:0];
reg     [TAG_WIDTH-1:0]     cacheTag    [NUM_LINES-1:0];
reg     cacheValid [NUM_LINES-1:0];


reg     [0:(BLOCK_SIZE*8) -1]  cacheDataReg;
reg     [TAG_WIDTH-1:0]     cacheTagReg;
reg                         cacheValidReg;

integer i;
initial begin
    for (i = 0; i < NUM_LINES; i = i + 1) begin
        cacheData[i] <= 0;
        cacheTag[i] <= 0;
        cacheValid[i] <= 0;
    end
end


localparam  IDLE    = 2'b00,
            READMEM = 2'b01,
            WAIT  = 2'b10,
            UPDATE = 2'b11;

reg [1:0]   currentState, nextState;


wire    [TAG_WIDTH-1:0]     tagIn       =   address[31:(OFFSET_WIDTH + INDEX_WIDTH)];
wire    [INDEX_WIDTH-1:0]   indexIn     =   address[(OFFSET_WIDTH + INDEX_WIDTH)-1:OFFSET_WIDTH];
wire    [OFFSET_WIDTH-1:0]  offsetIn    =   address[OFFSET_WIDTH-1:0];


reg    miss;
reg    fill;

//  Handling Cache itself.
always @ (negedge clk) begin
    cacheDataReg <= cacheData[indexIn];
    cacheTagReg <= cacheTag[indexIn];
    cacheValidReg <= cacheValid[indexIn];
end

always @ (negedge clk) begin
    if (fill) begin
        cacheValid[indexIn] <= 1;
        cacheTag[indexIn]   <= tagIn;
        cacheData[indexIn] <= memReadData;
    end
end


//  Hit/Miss Detection.
always @ (*) begin
    if (cacheValidReg && (tagIn == cacheTagReg)) begin
        miss = 0;
    end
    else begin
        miss = 1;
    end
end


//  State Transition.
always @ (posedge clk or negedge rst) begin
    if (!rst) begin
        currentState <= IDLE;
    end
    else begin
        currentState <= nextState;
    end
end

//  State Transition Logic.
always @ (*) begin
    case (currentState)
        IDLE    :   begin
                        if (miss)   nextState = READMEM;
                        else        nextState = IDLE;
                    end

        READMEM :   nextState = WAIT;

        WAIT    :   begin
                        if (memBusy)    nextState = WAIT;
                        else            nextState = UPDATE;
                    end

        UPDATE  :   nextState = IDLE;
    endcase
end
//7 6 5 4 3 2 1 0
//  Output Logic.
always @ (*) begin
    instruction = (cacheDataReg << (offsetIn*8)) >> ((BLOCK_SIZE*7));
    case (currentState)
        IDLE    :   begin
                        memRead     = 0;
                        memAddress  = 0;
                        fill = 0;
                        if (miss) begin
                            valid = 0;
                        end
                        else begin
                            valid = 1;
                        end
                    end

        READMEM :   begin
                        memRead     = 1;
                        memAddress  = address;
                        valid = 0;
                        fill = 0;
                    end


        WAIT    :   begin
                        memAddress  = address;
                        valid = 0;
                        if (memBusy) begin
                            memRead     = 1;
                            fill = 0;
                        end
                        else begin
                            memRead     = 0;
                            fill = 1;
                        end
                    end

        UPDATE  :   begin
                        memRead     = 0;
                        memAddress  = 0;
                        valid = 0;
                        fill = 1;
                    end
    endcase
end


endmodule