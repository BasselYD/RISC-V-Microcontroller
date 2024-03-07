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


//reg     [TAG_WIDTH-1:0]         cacheTag    [ASSOCIATIVITY-1:0]  [NUM_LINES-1:0];
//reg                             cacheValid  [ASSOCIATIVITY-1:0]  [NUM_LINES-1:0];
//reg                             cacheDirty  [ASSOCIATIVITY-1:0]  [NUM_LINES-1:0];
//reg     [3:0]       cacheLRU    [NUM_LINES-1:0] [ASSOCIATIVITY-1:0];


wire    [7:0]                   cacheDataReg    [ASSOCIATIVITY-1:0] [BLOCK_SIZE-1:0];
wire    [TAG_WIDTH-1:0]         cacheTagReg     [ASSOCIATIVITY-1:0];
wire                            cacheValidReg   [ASSOCIATIVITY-1:0];
wire                            cacheDirtyReg   [ASSOCIATIVITY-1:0];
wire    [3:0]                   cacheLRUReg     [ASSOCIATIVITY-1:0];


localparam  IDLE        = 3'b000,
            FINDLRU     = 3'b001, 
            UPDATEMEM   = 3'b010, 
            WRWAIT      = 3'b011,      
            READMEM     = 3'b100,
            RDWAIT      = 3'b101,
            UPDATECACHE = 3'b110;

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
wire LRU_found;
reg order;
reg [$clog2(ASSOCIATIVITY):0] counter;
reg confirmWrite;
reg writeBlock [BLOCK_SIZE-1:0];
reg writeAssoc [ASSOCIATIVITY-1:0];
reg    [7:0]   writeDataPacked    [BLOCK_SIZE-1:0];

integer i,j,k,l,m,n,o,p;

wire   [7:0]   memReadDataPacked    [BLOCK_SIZE-1:0];
reg    [7:0]   memWriteDataPacked    [BLOCK_SIZE-1:0];

genvar x,y;
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
            .DATA_WIDTH(4)
        ) cacheLRU (
            .clk(clk),
            .addr(indexIn),
            .data_in((cacheValidReg[x] == 1'b0) ? 4'b0 : (cacheLRUReg[x] + 1'b1)),
            .write_enable((cacheValidReg[x] == 1'b0) || (hits[x])),
            .data_out(cacheLRUReg[x])
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
        
    end
endgenerate

generate
    for (x = 0; x < BLOCK_SIZE; x = x + 1) begin : x1
        assign memReadDataPacked[x] = memReadData[((BLOCK_SIZE-x)*8)-1 : ((BLOCK_SIZE-x-1)*8)];

        assign memWriteData[((BLOCK_SIZE-x)*8)-1 : ((BLOCK_SIZE-x-1)*8)] = memWriteDataPacked[x];
    end
endgenerate


//  Handling Cache itself.
always @ (negedge clk or negedge rst) begin
    if (!rst) begin
        counter <= 1;
        LRU_id <= 0;
    end

    else begin
        for (i = 0; i < ASSOCIATIVITY; i = i + 1) begin : x2
            //cacheTagReg[i]   <= cacheTag[i][indexIn];
            //cacheValidReg[i] <= cacheValid[i][indexIn];
            //cacheDirtyReg[i] <= cacheDirty[i][indexIn];
            //cacheLRUReg[i]   <= cacheLRU[indexIn][i];
        end  

        if (order) begin
            if (counter == ASSOCIATIVITY) begin
                counter <= 1;   
                LRU_id <= 0;    
            end
            else begin
                if (cacheLRUReg[counter] < cacheLRUReg[LRU_id]) begin
                    LRU_id <= counter;
                end
                counter <= counter + 1'b1;
            end
        end
    end
end

assign LRU_found = (counter == ASSOCIATIVITY);


/*always @ (negedge clk or negedge rst) begin
    j = 0;
    if (!rst) begin
        for (k = 0; k < ASSOCIATIVITY; k = k + 1) begin : z2
            for (j = 0; j < NUM_LINES; j = j + 1) begin: z3
                cacheValid[k][j] <= 0;
                //cacheTag[k][j] <= 0;
                cacheDirty[k][j] <= 0;
                //cacheLRU[j][k] <= 0;
            end
        end
    end
    else begin
        for (k = 0; k < ASSOCIATIVITY; k = k + 1) begin : x4
            if (fill[k]) begin
                cacheValid[k][indexIn]  <= 1;
                //cacheTag[k][indexIn]    <= tagIn;
                cacheDirty[k][indexIn]  <= 0;
            end
            if (cacheValidReg[k] != 1) begin
                //cacheLRU[indexIn][k] <= 0;
            end
        end  
    
        if (hit_id != ASSOCIATIVITY) begin
            //cacheLRU[indexIn][hit_id] <= cacheLRU[indexIn][hit_id] + 1'b1; 
        end
    
    
        if (confirmWrite) begin
            cacheDirty[hit_id][indexIn] <= 1'b1;
        end
    end
end*/

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
                                    //cacheData[hit_id][indexIn][offsetIn] <= writeData[7:0];
                                end 

        //sh
        3'b001          :       begin
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})] = 1;
                                    writeBlock[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})+1] = 1;

                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})]   = writeData[15:8];
                                    writeDataPacked[(offsetIn & {{(OFFSET_WIDTH-1){1'b1}},(1'b0)})+1] = writeData[7:0];
                                    //{cacheData[hit_id][indexIn][(offsetIn & (1'b0))],
                                    // cacheData[hit_id][indexIn][(offsetIn & (1'b0))+1]} <= writeData[15:0];
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
                                    //{cacheData[hit_id][indexIn][(offsetIn & (2'b00))], 
                                    // cacheData[hit_id][indexIn][(offsetIn & (2'b00))+1],
                                    // cacheData[hit_id][indexIn][(offsetIn & (2'b00))+2],
                                    // cacheData[hit_id][indexIn][(offsetIn & (2'b00))+3]} <= writeData;
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
                                    //{cacheData[hit_id][indexIn][(offsetIn & (2'b00))], 
                                    // cacheData[hit_id][indexIn][(offsetIn & (2'b00))+1],
                                    // cacheData[hit_id][indexIn][(offsetIn & (2'b00))+2],
                                    // cacheData[hit_id][indexIn][(offsetIn & (2'b00))+3]} <= writeData;
                                end 
        endcase
    end
end


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
    //hit_id = (hits == 0) ? ASSOCIATIVITY : hits;    //
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
                            nextState = FINDLRU;
                        end
                        else begin
                            nextState = IDLE;
                        end
                    end

        FINDLRU :   begin
                        if (LRU_found) begin
                            if (!cacheValidReg[LRU_id] || !cacheDirtyReg[LRU_id])
                                nextState = READMEM;
                            else
                                nextState = UPDATEMEM;
                        end
                        else begin
                            nextState = FINDLRU;
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

        //tempReadData = (cacheDataReg[hit_id] << (offsetIn[OFFSET_WIDTH-1:2]*8)) >> ((BLOCK_SIZE*7));
        //tempByte = ((tempReadData & (8'hFF << ((3-offsetIn[1:0])*8))) >> ((3-offsetIn[1:0])*8));
        //tempHalfWord = ((tempReadData & (16'hFFFF << ((1-(offsetIn[1]))*16))) >> ((1-(offsetIn[1]))*16));
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
                            order = 1;
                        end
                        else begin
                            order = 0;
                            /*if (hit_id != ASSOCIATIVITY) begin
                                valid = 1;
                            end
                            else begin
                                valid = 0;
                            end*/
                            valid = 1;
                            if (write) begin
                                confirmWrite = 1;
                            end
                            else begin
                                confirmWrite = 0;
                            end
                        end
                    end

        FINDLRU :   begin
                        memRead      = 0;
                        memAddress   = 0;
                        memWrite     = 0;
                        for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x8
                            memWriteDataPacked[j] = 0;
                        end
                        fill = 0;
                        valid = 0;
                        order = 1;
                        confirmWrite = 0;
                    end


        UPDATEMEM   :   begin
                            memRead      = 0;
                            memAddress   = address;
                            memWrite     = 1;
                            for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x9
                                memWriteDataPacked[j] = cacheDataReg[LRU_id][j];
                            end
                            fill = 0;
                            valid = 0;
                            order = 0;
                            confirmWrite = 0;
                        end


        WRWAIT  :   begin
                        memRead      = 0;
                        memAddress   = address;
                        memWrite     = 1;
                        for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x10
                            memWriteDataPacked[j] = cacheDataReg[LRU_id][j];
                        end
                        fill = 0;
                        valid = 0;
                        order = 0;
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
                        order = 0;
                        confirmWrite = 0;
                    end


        RDWAIT  :   begin
                        memAddress  = address;
                        memWrite     = 0;
                        for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : x12
                            memWriteDataPacked[j] = 0;
                        end
                        valid = 0;
                        order = 0;
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
                            order = 0;
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
                            order = 0;
                            confirmWrite = 0;
                        end
    endcase
end

endmodule