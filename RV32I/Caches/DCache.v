module DCache #(
    parameter   BLOCK_SIZE    =   8,
    parameter   TOTAL_LINES   =   256,
    parameter   ASSOCIATIVITY = 2
) (
    input   wire            clk,
    input   wire            rst,

    //  Processor Interface.
    input   wire    [31:0]      address,
    input   wire                read,
    input   wire                write,
    input   wire    [31:0]      writeData, 
    input   wire    [2:0]       strobe,
    output  reg     [31:0]      readData,
    output  reg                 valid,

    //  Memory Interface.
    input   wire                            memBusy,
    output  reg     [31:0]                  memAddress,
    output  reg                             memRead,
    input   wire    [(BLOCK_SIZE*8) - 1:0]  memReadData,
    output  reg                             memWrite,
    output  wire    [(BLOCK_SIZE*8) - 1:0]  memWriteData
);


localparam NUM_LINES = TOTAL_LINES/ASSOCIATIVITY;
localparam OFFSET_WIDTH = $clog2(BLOCK_SIZE);
localparam INDEX_WIDTH  = $clog2(NUM_LINES);
localparam TAG_WIDTH    = 32 - OFFSET_WIDTH - INDEX_WIDTH;


wire    [7:0]                   cacheDataReg    [ASSOCIATIVITY-1:0] [BLOCK_SIZE-1:0];
wire    [TAG_WIDTH-1:0]         cacheTagReg     [ASSOCIATIVITY-1:0];
wire                            cacheValidReg   [ASSOCIATIVITY-1:0];
wire                            cacheDirtyReg   [ASSOCIATIVITY-1:0];


localparam  IDLE        = 3'b000, 
            UPDATEMEM   = 3'b001, 
            WRWAIT      = 3'b010,      
            READMEM     = 3'b011,
            RDWAIT      = 3'b100,
            UPDATECACHE = 3'b101;

reg [2:0]   currentState, nextState;


wire    [TAG_WIDTH-1:0]     tagIn       =   address[31:(OFFSET_WIDTH + INDEX_WIDTH)];
wire    [INDEX_WIDTH-1:0]   indexIn     =   address[(OFFSET_WIDTH + INDEX_WIDTH)-1:OFFSET_WIDTH];
wire    [OFFSET_WIDTH-1:0]  offsetIn    =   address[OFFSET_WIDTH-1:0];


reg    miss;
reg    [ASSOCIATIVITY-1:0] temp_miss;
reg    [ASSOCIATIVITY-1:0] fill;

reg [$clog2(ASSOCIATIVITY):0] hit_id;   //  Extra bit
reg [ASSOCIATIVITY-1:0] hits;
reg [$clog2(ASSOCIATIVITY)-1:0] LRU_id;

reg confirmWrite;
reg writeBlock [BLOCK_SIZE-1:0];
reg writeAssoc [ASSOCIATIVITY-1:0];
reg    [7:0]   writeDataPacked    [BLOCK_SIZE-1:0];

integer i,j,k,l,m,n,o,p;

wire   [7:0]   memReadDataPacked    [BLOCK_SIZE-1:0];
reg    [7:0]   memWriteDataPacked    [BLOCK_SIZE-1:0];

wire    [ASSOCIATIVITY-1:0] cacheLRUReg;
reg     [ASSOCIATIVITY-1:0] MRU_Bits;
reg     [ASSOCIATIVITY-1:0] MRU_Bits_reg;
wire cacheLRUReg_2;
wire LRU_temp;

genvar x,y;
generate
    for (x = 0; x < BLOCK_SIZE; x = x + 1) begin : x1
        assign memReadDataPacked[x] = memReadData[((BLOCK_SIZE-x)*8)-1 : ((BLOCK_SIZE-x-1)*8)];

        assign memWriteData[((BLOCK_SIZE-x)*8)-1 : ((BLOCK_SIZE-x-1)*8)] = memWriteDataPacked[x];
    end
endgenerate

generate
    for (x = 0; x < ASSOCIATIVITY; x = x + 1) begin : ASSOC_ROW
        for (y = 0; y < BLOCK_SIZE; y = y + 1) begin : BLOCKS_COLUMN
            Sync_RAM #(
                .ADDR_WIDTH(INDEX_WIDTH),
                .DATA_WIDTH(8)
            ) cacheData (
                .clk(clk),
                .addr(indexIn),
                .data_in(fill[x] ? memReadDataPacked[y] : writeDataPacked[y]),
                .write_enable(fill[x] | (writeAssoc[x] && writeBlock[y])),
                .data_out(cacheDataReg[x][y])
            );
        end 
        
        Sync_RAM #(
            .ADDR_WIDTH(INDEX_WIDTH),
            .DATA_WIDTH(TAG_WIDTH)
        ) cacheTag (
            .clk(clk),
            .addr(indexIn),
            .data_in(tagIn),
            .write_enable(fill[x]),
            .data_out(cacheTagReg[x])
        );


        Sync_RAM #(
            .ADDR_WIDTH(INDEX_WIDTH),
            .DATA_WIDTH(1)
        ) cacheValid (
            .clk(clk),
            .addr(indexIn),
            .data_in(1'b1),
            .write_enable(fill[x]),
            .data_out(cacheValidReg[x])
        );

        Sync_RAM #(
            .ADDR_WIDTH(INDEX_WIDTH),
            .DATA_WIDTH(1)
        ) cacheDirty (
            .clk(clk),
            .addr(indexIn),
            .data_in((fill[x]) ? 1'b0 : 1'b1),
            .write_enable(fill[x] || (confirmWrite && hits[x])),
            .data_out(cacheDirtyReg[x])
        );


        if (ASSOCIATIVITY == 2) begin
            if (x == 0) begin
                Sync_RAM #(
                    .ADDR_WIDTH(INDEX_WIDTH),
                    .DATA_WIDTH(1)
                ) cacheLRU (
                    .clk(clk),
                    .addr(indexIn),
                    .data_in(~hit_id[0]),
                    .write_enable((hit_id != ASSOCIATIVITY)),
                    .data_out(LRU_temp)
                );
                assign cacheLRUReg_2 = (!cacheValidReg[1]) ? (!cacheValidReg[0]) ? 1'b0 : 1'b1 : LRU_temp;
            end    
        end
        else if (ASSOCIATIVITY > 2) begin
            Sync_RAM #(
                .ADDR_WIDTH(INDEX_WIDTH),
                .DATA_WIDTH(1)
            ) cacheLRU (
                .clk(clk),
                .addr(indexIn),
                .data_in(MRU_Bits_reg[x]),
                .write_enable((hit_id != ASSOCIATIVITY)),
                .data_out(cacheLRUReg[x])
            );
        end
        
    end
endgenerate


//  Hit/Miss Detection.
always @ (*) begin
    o = 0;
    for (o = 0; o < ASSOCIATIVITY; o = o + 1) begin : x6
        if (read || write) begin
            if (cacheValidReg[o] && (tagIn == cacheTagReg[o])) begin
                temp_miss[o] = 0;
                hits[o] = 1;
            end
            else begin
                temp_miss[o] = 1;
                hits[o] = 0;
            end
        end
        else begin
            temp_miss[o] = 0;
            hits[o] = 0;
        end
    end
    miss = &temp_miss;

    hit_id = ASSOCIATIVITY;
    for (o = ASSOCIATIVITY - 1; o >= 0; o = o - 1) begin
      if (hits[o] == 1'b1) begin
        hit_id = o;
      end
    end
end


//  Handling LRU (generic case).
generate
    if (ASSOCIATIVITY == 1) begin
        always @(*) begin
            LRU_id = 0;
        end
    end
    else if (ASSOCIATIVITY == 2) begin
        always @(*) begin
            LRU_id = cacheLRUReg_2;
        end
    end
    else if (ASSOCIATIVITY > 2) begin
        always @(*) begin
            MRU_Bits = cacheLRUReg;
            LRU_id = 0;
            if (hit_id != ASSOCIATIVITY) begin
                MRU_Bits[hit_id] = 1;
                    if (&MRU_Bits) begin
                        for (o = 0; o < ASSOCIATIVITY; o = o + 1) begin
                            if (o != hit_id) begin
                                MRU_Bits[o] = 0;
                            end
                        end
                    end
                    else begin
                        for (o = 0; o < ASSOCIATIVITY; o = o + 1) begin
                            if (o != hit_id) begin
                                MRU_Bits[o] = cacheLRUReg[o];
                            end
                        end
                    end
                end     
            else begin
                LRU_id = 0;
                for (o = 0; o < ASSOCIATIVITY; o = o + 1) begin
                    if (MRU_Bits[o] == 1'b0) begin
                        LRU_id = o;
                    end
                end
            end
        end
        always @(posedge clk) begin
            MRU_Bits_reg <= MRU_Bits;
        end
    end
endgenerate



always @ (*) begin
    l = 0;
    m = 0;
    for (l = 0; l < BLOCK_SIZE; l = l + 1) begin : z
        writeBlock[l] = 0;
        writeDataPacked[l] = 0;
    end
    for (m = 0; m < ASSOCIATIVITY; m = m + 1) begin :y1
        writeAssoc[m] = 0;
    end
    if (confirmWrite) begin
        for (m = 0; m < ASSOCIATIVITY; m = m + 1) begin :y2
            writeAssoc[m] = (m == hit_id);
        end
        case (strobe) 
        //sb
        3'b000          :       begin
                                    writeBlock[offsetIn] = 1;
                                    writeDataPacked[offsetIn] = writeData[7:0];
                                end 

        //sh
        3'b001          :       begin
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})] = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})+1] = 1;

                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})]   = writeData[15:8];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})+1] = writeData[7:0];
                                end 

        //sw
        3'b010          :       begin
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})]   = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+1] = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+2] = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+3] = 1;

                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})]   = writeData[31:24];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+1] = writeData[23:16];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+2] = writeData[15:8];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+3] = writeData[7:0];
                                end 

        default         :       begin
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})]   = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+1] = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+2] = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+3] = 1;

                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})]   = writeData[31:24];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+1] = writeData[23:16];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+2] = writeData[15:8];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+3] = writeData[7:0];
                                end 
        endcase
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
                        if (miss) begin
                            if (!cacheValidReg[LRU_id] || !cacheDirtyReg[LRU_id])
                                nextState = READMEM;
                            else
                                nextState = UPDATEMEM;
                        end
                        else begin
                            nextState = IDLE;
                        end
                    end


        UPDATEMEM   :   nextState = WRWAIT;

        WRWAIT  :   begin
                        if (memBusy)    nextState = WRWAIT;
                        else            nextState = READMEM;
                    end

        READMEM     :   nextState = RDWAIT;

        
        RDWAIT  :   begin
                        if (memBusy)    nextState = RDWAIT;
                        else            nextState = UPDATECACHE;
                    end

        UPDATECACHE :   nextState = IDLE;

        default     :   nextState = IDLE;
    endcase
end


reg [31:0]  tempReadData;
reg [7:0]   tempByte;
reg [15:0]  tempHalfWord;

//  Output Logic.
always @ (*) begin

    if (hit_id != ASSOCIATIVITY) begin
        tempByte = cacheDataReg[hit_id][offsetIn];

        tempHalfWord = {cacheDataReg[hit_id][(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})],
                        cacheDataReg[hit_id][(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})+1]};

        tempReadData = {cacheDataReg[hit_id][(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})], 
                        cacheDataReg[hit_id][(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+1],
                        cacheDataReg[hit_id][(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+2],
                        cacheDataReg[hit_id][(offsetIn & {{(OFFSET_WIDTH-2){1'b1}},(2'b00)})+3]};
    end
    else begin
        tempReadData = 0;
        tempByte = 0;
        tempHalfWord = 0;
    end

    case (strobe) 
        //lb
        3'b000  :   begin
                        readData  =   {{24{tempByte[7]}}, tempByte};
                    end 

        //lh
        3'b001  :   begin
                        readData  =   {{16{tempHalfWord[15]}}, tempHalfWord};
                    end 

        //lw
        3'b010  :   begin
                        readData  =   tempReadData;
                    end 

        //lbu
        3'b100  :   begin
                        readData  =   {24'b0, tempByte};
                    end 

        //lhu
        3'b101  :   begin
                        readData  =   {16'b0, tempHalfWord};
                    end 

        default :   begin
                        readData  =   tempReadData;
                    end 
    endcase
    

    fill = 0;
    case (currentState)
        IDLE    :   begin
                        memRead      = 0;
                        memAddress   = 0;
                        memWrite     = 0;
                        for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x7
                            memWriteDataPacked[j] = 0;
                        end
                        fill = 0;
                        confirmWrite = 0;
                        if (miss) begin
                            valid = 0;
                        end
                        else begin
                            valid = 1;
                            if (write) begin
                                confirmWrite = 1;
                            end
                            else begin
                                confirmWrite = 0;
                            end
                        end
                    end


        UPDATEMEM   :   begin
                            memRead      = 0;
                            memAddress   = {cacheTagReg[LRU_id], indexIn, {OFFSET_WIDTH{1'b0}}};
                            memWrite     = 1;
                            for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x9
                                memWriteDataPacked[j] = cacheDataReg[LRU_id][j];
                            end
                            fill = 0;
                            valid = 0;
                            confirmWrite = 0;
                        end


        WRWAIT  :   begin
                        memRead      = 0;
                        memAddress   = {cacheTagReg[LRU_id], indexIn, {OFFSET_WIDTH{1'b0}}};
                        memWrite     = 1;
                        for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x10
                            memWriteDataPacked[j] = cacheDataReg[LRU_id][j];
                        end
                        fill = 0;
                        valid = 0;
                        confirmWrite = 0;
                    end


        READMEM :   begin
                        memRead     = 1;
                        memAddress  = address;
                        memWrite     = 0;
                        for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x11
                            memWriteDataPacked[j] = 0;
                        end
                        fill = 0;
                        valid = 0;
                        confirmWrite = 0;
                    end


        RDWAIT  :   begin
                        memAddress  = address;
                        memWrite     = 0;
                        for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x12
                            memWriteDataPacked[j] = 0;
                        end
                        valid = 0;
                        fill = 0;
                        confirmWrite = 0;
                        if (memBusy) begin
                            memRead      = 1;
                            fill[LRU_id] = 0;
                        end
                        else begin
                            memRead      = 0;
                            fill[LRU_id] = 1;
                        end
                    end

        UPDATECACHE :   begin
                            memRead     = 0;
                            memAddress  = 0;
                            memWrite     = 0;
                            for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x13
                                memWriteDataPacked[j] = 0;
                            end
                            valid = 0;
                            fill[LRU_id] = 1;
                            confirmWrite = 0;
                        end

        default     :   begin
                            memRead      = 0;
                            memAddress   = 0;
                            memWrite     = 0;
                            for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x14
                                memWriteDataPacked[j] = 0;
                            end
                            fill = 0;
                            valid = 0;
                            confirmWrite = 0;
                        end
    endcase
end

endmodule