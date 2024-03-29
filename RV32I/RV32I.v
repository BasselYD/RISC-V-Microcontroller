module RV32I (
    input       wire        clk,
    input       wire        rst,

    //  AHB ADAPTER INTERFACE
    input   wire    [31:0]      rdata,
    input   wire                ready,
    input   wire    [1:0]       HTRANS,

    output  wire    [31:0]      addr,
    output  wire                write,
    output  wire    [31:0]      wdata,
    output  wire    [2:0]       transfer
);

//----------Internal Signals----------//

//Fetch Stage
wire    [31:0]  PCF_p; 
wire            StallF;
wire    [31:0]  PCF;
wire    [31:0]  PCPlus4F;

wire    [31:0]  InstrF;

//Decode Stage
wire            RegWriteD;
wire    [2:0]   ResultSrcD;
wire            MemWriteD;
wire            MemReadD;
wire            JumpD;
wire            JumpTypeD;
wire            BranchD;
wire    [2:0]   BranchTypeD;
wire    [2:0]   ALUControlD;
wire            ALUSrcD;
wire    [1:0]   SLTControlD;
wire    [2:0]   ImmSrcD;
wire    [2:0]   StrobeD;

wire    [31:0]  InstrD;
wire    [31:0]  PCD;
wire    [31:0]  PCPlus4D;
wire    [31:0]  RD1D;
wire    [31:0]  RD2D;
wire    [4:0]   Rs1D;
wire    [4:0]   Rs2D;
wire    [4:0]   RdD;
wire    [31:0]  ExtImmD;

wire            FlushD; 
wire            StallD;

//Execute Stage
wire            RegWriteE;
wire    [2:0]   ResultSrcE;
wire            MemWriteE;
wire            MemReadE;
wire            JumpE;
wire            JumpTypeE;
wire            BranchE;
wire    [2:0]   BranchTypeE;
wire    [2:0]   ALUControlE;
wire            ALUSrcE;
wire    [1:0]   SLTControlE;
wire    [2:0]   StrobeE;

wire    [31:0]  PCE;
wire    [31:0]  PCPlus4E;
wire    [31:0]  RD1E;
wire    [31:0]  RD2E;
wire    [4:0]   Rs1E;
wire    [4:0]   Rs2E;
wire    [4:0]   RdE;
wire    [31:0]  ExtImmE;
wire    [31:0]  PcTargetAdd;
wire    [31:0]  PcTargetE;

wire            FlushE; 
wire    [2:0]   ForwardAE;
wire    [2:0]   ForwardBE;
wire            ForwardRs1;
wire            ForwardRs2;
wire    [31:0]  RD1Src;
wire    [31:0]  RD2Src;

wire    [31:0]  SrcAE;
wire    [31:0]  WriteDataE;
wire    [31:0]  SrcBE;
wire    [31:0]  ALUResultE;
wire    [3:0]   Flags;

wire            PCSrcE;


//Memory Stage
wire            RegWriteM;
wire    [2:0]   ResultSrcM;
wire            MemWriteM;
wire            MemReadM;
wire    [2:0]   StrobeM;
wire    [4:0]   Rs1M;
wire    [4:0]   Rs2M;

wire    [31:0]  ALUResultM;
wire    [31:0]  WriteDataM;
wire    [4:0]   RdM;
wire    [31:0]  ExtImmM;
wire    [31:0]  PcTargetM;
wire    [31:0]  PCPlus4M;
wire    [31:0]  ReadDataM;


//WriteBack Stage
wire    [31:0]  ResultW;
wire    [4:0]   RdW;
wire            RegWriteW;
wire    [2:0]   ResultSrcW;
wire    [31:0]  ALUResultW;
wire    [31:0]  ReadDataW;
wire    [31:0]  ExtImmW;
wire    [31:0]  PcTargetW;
wire    [31:0]  PCPlus4W;

localparam BLOCK_SIZE = 32;
localparam NUM_LINES = 256;


wire ICacheValid;
wire DCacheValid;
wire HazardStallF;
wire HazardStallD;

wire    [(BLOCK_SIZE*8) - 1:0]          inst_memReadData;
wire                                    inst_memBusy;
wire     [31:0]                         inst_memAddress;
wire                                    inst_memRead;

wire    [31:0]                      data_memAddress;
wire                                data_memRead;
wire                                data_memWrite;
wire    [31:0]                      data_memWriteData;
wire    [2:0]                       data_strobe;
wire    [(BLOCK_SIZE*8) - 1:0]      data_memReadData;
wire                                data_memBusy;


//Program Counter
PC  PC  (
    .PCF_p(PCF_p),
    .EN(~StallF),
    .clk(clk),
    .rst(rst),
    .PCF(PCF)
);

Memory_Arbiter #(
    .BLOCK_SIZE(BLOCK_SIZE)
) mem_arb (
    .clk(clk),
    .rst(rst),

    //  I-CACHE INTERFACE
    .inst_memAddress(inst_memAddress),
    .inst_memRead(inst_memRead),
    .inst_memReadData(inst_memReadData),
    .inst_memBusy(inst_memBusy),

    //  D-CACHE INTERFACE
    .data_memAddress(data_memAddress),
    .data_memRead(data_memRead),
    .data_memWrite(data_memWrite),
    .data_memWriteData(data_memWriteData),
    .data_strobe(data_strobe),
    .data_memReadData(data_memReadData),
    .data_memBusy(data_memBusy),


    //  AHB ADAPTER INTERFACE
    .rdata(rdata),
    .ready(ready),
    .HTRANS(HTRANS),

    .addr(addr),
    .write(write),
    .wdata(wdata),
    .transfer(transfer)
);



ICache #(
    .BLOCK_SIZE(BLOCK_SIZE), 
    .NUM_LINES(NUM_LINES)
) u_icache (
    .clk(clk),
    .rst(rst),

    //  Processor Interface.
    .address(PCF),
    .instruction(InstrF),
    .valid(ICacheValid),

    //  Memory Interface.
    .memReadData(inst_memReadData),
    .memBusy(inst_memBusy),
    .memAddress(inst_memAddress),
    .memRead(inst_memRead)
);


assign StallF = HazardStallF | ~ICacheValid | ~DCacheValid; 
assign StallD = HazardStallD | ~ICacheValid | ~DCacheValid; 


PCPlus4Adder PCAdder (
    .PCF(PCF),
    .PCPlus4F(PCPlus4F)
);

//Fetch-Decode Register
IF_ID_Reg   IFIDReg (
    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .rst(rst),
    .clk(clk),
    .FLUSH(FlushD),
    .EN(~StallD), 
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

//Control Unit
ControlUnit CU (
    .OP(InstrD[6:0]),
    .funct3(InstrD[14:12]),
    .funct7_5(InstrD[30]),

    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .MemReadD(MemReadD),
    .JumpD(JumpD),
    .JumpTypeD(JumpTypeD),
    .BranchD(BranchD),
    .BranchTypeD(BranchTypeD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .SLTControlD(SLTControlD),
    .ImmSrcD(ImmSrcD),
    .StrobeD(StrobeD)
);

//Register File
Register_File #(.WIDTH(32), .DEPTH_BITS(5))  RF (
    .WrData(ResultW),
    .WrAddress(RdW),
    .WrEn(RegWriteW),

    .RdAddress1(InstrD[19:15]),
    .RdAddress2(InstrD[24:20]),

    .clk(clk),
    .rst(rst),

    .RdData1(RD1D),
    .RdData2(RD2D)
);

//Sign Extender
SignExtend  Extend (
    .ImmFields(InstrD[31:7]),
    .ImmSrcD(ImmSrcD),
    .ExtImmD(ExtImmD)
);

//Decode-Execute Register
ID_EX_Reg   IDEXReg (
    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .MemReadD(MemReadD),
    .JumpD(JumpD),
    .JumpTypeD(JumpTypeD),
    .BranchD(BranchD),
    .BranchTypeD(BranchTypeD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .SLTControlD(SLTControlD),
    .StrobeD(StrobeD),

    .RD1D(RD1Src),
    .RD2D(RD2Src),
    
    .PCD(PCD),
    .Rs1D(InstrD[19:15]),
    .Rs2D(InstrD[24:20]),
    .RdD(InstrD[11:7]),
    .ExtImmD(ExtImmD),
    .PCPlus4D(PCPlus4D),

    .rst(rst),
    .clk(clk),
    .EN(~DCacheValid),
    .FLUSH(FlushE),

    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .MemReadE(MemReadE),
    .JumpE(JumpE),
    .JumpTypeE(JumpTypeE),
    .BranchE(BranchE),
    .BranchTypeE(BranchTypeE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .SLTControlE(SLTControlE),
    .StrobeE(StrobeE),

    .RD1E(RD1E),
    .RD2E(RD2E),

    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .ExtImmE(ExtImmE),

    .PCE(PCE),
    .PCPlus4E(PCPlus4E)
);

//PC Target Adder
PCTargetAdder TargetAdder (
    .PCE(PCE),
    .ExtImmE(ExtImmE),
    .PcTargetE(PcTargetAdd)
);

Mux_8to1 ForwardAMux (
    .I0(RD1E),
    .I1(ResultW),
    .I2(ALUResultM),
    .I3(ExtImmM),
    .I4(PcTargetM),
    .I5(ExtImmW),
    .I6(PcTargetW),
    .I7(0),
    .SEL(ForwardAE),
    .Y(SrcAE)
);

Mux_8to1 ForwardBMux (
    .I0(RD2E),
    .I1(ResultW),
    .I2(ALUResultM),
    .I3(ExtImmM),
    .I4(PcTargetM),
    .I5(ExtImmW),
    .I6(PcTargetW),
    .I7(0),
    .SEL(ForwardBE),
    .Y(WriteDataE)
);

Mux_2to1 SrcBMux (
    .I0(WriteDataE),
    .I1(ExtImmE),
    .SEL(ALUSrcE),
    .Y(SrcBE)
);

Mux_2to1 ForwardR1 (
    .I0(RD1D),
    .I1(ResultW),
    .SEL(ForwardRs1),
    .Y(RD1Src)
);


Mux_2to1 ForwardR2 (
    .I0(RD2D),
    .I1(ResultW),
    .SEL(ForwardRs2),
    .Y(RD2Src)
);


ALU ALU (
    .A(SrcAE),
    .B(SrcBE),
    .ALUControlE(ALUControlE),
    .SLTControlE(SLTControlE),
    .ALUResultE(ALUResultE),
    .Flags(Flags)      
);

Mux_2to1 PCTargetMux (
    .I0(PcTargetAdd),
    .I1({ALUResultE[31:1], 1'b0}),
    .SEL(JumpTypeE),
    .Y(PcTargetE)
);

Mux_2to1 PCMux (
    .I0(PCPlus4F),
    .I1(PcTargetE),
    .SEL(PCSrcE),
    .Y(PCF_p)
);

BranchLogic BL (
    .JumpE(JumpE),
    .BranchE(BranchE),
    .BranchTypeE(BranchTypeE),
    .Zero(Flags[3]),
    .LSB(ALUResultE[0]),
    .PCSrcE(PCSrcE)
);

EX_MEM_Reg EXMEMReg (
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .MemReadE(MemReadE),
    .StrobeE(StrobeE),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),

    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .RdE(RdE),
    .ExtImmE(ExtImmE),
    .PcTargetE(PcTargetE),
    .PCPlus4E(PCPlus4E),

    .clk(clk),
    .rst(rst),
    .EN(~DCacheValid),

    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM),
    .MemReadM(MemReadM),
    .StrobeM(StrobeM),
    .Rs1M(Rs1M),
    .Rs2M(Rs2M),

    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .ExtImmM(ExtImmM),
    .PcTargetM(PcTargetM),
    .PCPlus4M(PCPlus4M)
);




wire [31:0] WData;
wire LSForward;

assign WData = (LSForward) ? ReadDataW : WriteDataM;



DCache #(
    .BLOCK_SIZE(BLOCK_SIZE), 
    .TOTAL_LINES(NUM_LINES),
    .ASSOCIATIVITY(2)) 
    u_dcache (
        .clk(clk),
        .rst(rst),

        .address(ALUResultM),
        .read(MemReadM),
        .write(MemWriteM),
        .writeData(WData),
        .strobe(StrobeM),
        .readData(ReadDataM),
        .valid(DCacheValid),

        .memBusy(data_memBusy),
        .memAddress(data_memAddress),
        .memRead(data_memRead),
        .memReadData(data_memReadData),
        .memWrite(data_memWrite),
        .memWriteData(data_memWriteData)
    );


/*DataMem DMEM (
    .Address(ALUResultM),
    .WriteDataM(WData),
    .MemWriteM(MemWriteM),
    .StrobeM(StrobeM),
    .clk(clk),
    .ReadDataM(ReadDataM)
);*/

MEM_WB_Reg MEMWBReg (
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),

    .ALUResultM(ALUResultM),
    .ReadDataM(ReadDataM),
    .RdM(RdM),
    .ExtImmM(ExtImmM),
    .PcTargetM(PcTargetM),
    .PCPlus4M(PCPlus4M),

    .clk(clk),
    .rst(rst),
    .EN(~DCacheValid),

    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),

    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
    .ExtImmW(ExtImmW),
    .PcTargetW(PcTargetW),
    .PCPlus4W(PCPlus4W)
);

Mux_8to1 WriteBackMux (
    .I0(ALUResultW),
    .I1(ReadDataW),
    .I2(PCPlus4W),
    .I3(ExtImmW),
    .I4(PcTargetW),
    .I5(0),
    .I6(0),
    .I7(0),
    .SEL(ResultSrcW),
    .Y(ResultW)
);

HazardUnit HU (
    .Rs1D(InstrD[19:15]),
    .Rs2D(InstrD[24:20]),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .Rs1M(Rs1M),
    .Rs2M(Rs2M),
    .RdE(RdE),
    .PCSrcE(PCSrcE),
    .ResultSrcE(ResultSrcE),
    .ResultSrcM(ResultSrcM),
    .ResultSrcW(ResultSrcW),
    .RdM(RdM),
    .RegWriteM(RegWriteM),
    .RdW(RdW),
    .RegWriteW(RegWriteW),
    .rst(rst),

    .StallF(HazardStallF),
    .StallD(HazardStallD),
    .FlushD(FlushD),
    .FlushE(FlushE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .ForwardRs1(ForwardRs1),
    .ForwardRs2(ForwardRs2),
    .LSForward(LSForward)
);


endmodule