module ControlUnit (
    input       wire        [31:0]      Instr,

    output      reg                     RegWriteD,
    output      reg         [2:0]       ResultSrcD,
    output      reg                     MemWriteD,
    output      reg                     MemReadD,
    output      reg                     JumpD,
    output      reg                     JumpTypeD,
    output      reg                     BranchD,
    output      reg         [2:0]       BranchTypeD,
    output      reg         [2:0]       ALUControlD,
    output      reg                     ALUSrcD,
    output      reg         [1:0]       SLTControlD,
    output      reg         [2:0]       ImmSrcD,
    output      reg         [2:0]       StrobeD,

    output      reg         [1:0]       csrOp,
    output      reg                     exception,
    output      reg         [3:0]       exceptionType,
    output      reg                     mret  
);


localparam      RTYPE   =   7'b0110011,
                ITYPE   =   7'b0010011,
                LOAD    =   7'b0000011,
                STORE   =   7'b0100011,
                JAL     =   7'b1101111,
                JALR    =   7'b1100111,
                BRANCH  =   7'b1100011,
                LUI     =   7'b0110111,
                AUIPC   =   7'b0010111,
                SYSTEM  =   7'b1110011,
                FENCE   =   7'b0001111;


localparam      ADD      =   3'b000,
                SUB      =   3'b001,
                AND      =   3'b010,
                OR       =   3'b011,
                XOR      =   3'b100,
                SLL      =   3'b101,
                SRA      =   3'b110,
                SRL      =   3'b111;

wire        [6:0]       OP;
wire        [2:0]       funct3;
wire                    funct7_5;

assign OP       = Instr[6:0];
assign funct3   = Instr[14:12];
assign funct7_5 = Instr[30];

always @ (*)
    begin
        csrOp = 0;
        exception = 0;
        exceptionType = 4'd0;
        mret = 0; 
        if (OP == RTYPE || OP == ITYPE)
            begin
                if (OP == RTYPE)
                    begin
                        RegWriteD = 1;
                        ResultSrcD = 3'b000;
                        MemWriteD = 0;
                        MemReadD = 0;
                        JumpD = 0;
                        JumpTypeD = 0;
                        BranchD = 0;
                        BranchTypeD = 3'b000;
                        ALUSrcD = 0;
                        ImmSrcD = 3'b000;
                        StrobeD = 3'b000;
                    end

                else //I-Type
                    begin
                        RegWriteD = 1;
                        ResultSrcD = 3'b000;
                        MemWriteD = 0;
                        MemReadD = 0;
                        JumpD = 0;
                        JumpTypeD = 0;
                        BranchD = 0;
                        BranchTypeD = 3'b000;
                        ALUSrcD = 1;
                        ImmSrcD = 3'b000;
                        StrobeD = 3'b000;
                    end

                case (funct3)
                    3'b000     :        begin
                                            SLTControlD         =   2'b00;
                                            if (OP == RTYPE && funct7_5)
                                                ALUControlD     =   SUB;
                                            else
                                                ALUControlD     =   ADD;    
                                        end

                    3'b001     :        begin
                                            ALUControlD     =       SLL;
                                            SLTControlD     =       2'b00;
                                            ImmSrcD         =       3'b101;
                                        end

                    3'b010     :        begin
                                            ALUControlD     =       SUB;
                                            SLTControlD     =       2'b01;
                                        end


                    3'b011     :        begin
                                            ALUControlD     =       SUB;
                                            SLTControlD     =       2'b10;
                                        end

                    3'b100     :        begin
                                            ALUControlD     =       XOR;
                                            SLTControlD     =       2'b00;
                                        end

                    3'b101     :        begin
                                            ImmSrcD         =       3'b101;
                                            SLTControlD     =       2'b00;
                                            if (funct7_5)
                                                ALUControlD     =   SRA;
                                            else
                                                ALUControlD     =   SRL; 
                                        end

                    3'b110     :        begin
                                            ALUControlD     =       OR;
                                            SLTControlD     =       2'b00;
                                        end

                    3'b111     :        begin
                                            ALUControlD     =       AND;
                                            SLTControlD     =       2'b00;
                                        end
                endcase
            end

        else if (OP == LOAD)
            begin
                RegWriteD = 1;
                ResultSrcD = 3'b001;
                MemWriteD = 0;
                MemReadD = 1;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 1;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = funct3;
            end

        else if (OP == STORE)
            begin
                RegWriteD = 0;
                ResultSrcD = 3'b000;
                MemWriteD = 1;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 1;
                ImmSrcD = 3'b001;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = funct3;
            end

        else if (OP == JAL)
            begin
                RegWriteD = 1;
                ResultSrcD = 3'b010;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 1;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 1;
                ImmSrcD = 3'b011;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end
        
        else if (OP == JALR)
            begin
                RegWriteD = 1;
                ResultSrcD = 3'b010;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 1;
                JumpTypeD = 1;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 1;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end

        else if (OP == BRANCH)
            begin
                RegWriteD = 0;
                ResultSrcD = 3'b000;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 1;
                ALUSrcD = 0;
                ImmSrcD = 3'b010;
                ALUControlD = SUB;
                StrobeD = 0;
                BranchTypeD = funct3;

                case (funct3)
                    //beq
                    3'b000         :        begin
                                                SLTControlD = 2'b00;
                                            end

                    //bne
                    3'b001         :        begin
                                                SLTControlD = 2'b00;
                                            end

                    //blt
                    3'b100         :        begin
                                                SLTControlD = 2'b01;
                                            end

                    //bge
                    3'b101         :        begin
                                                SLTControlD = 2'b01;
                                            end

                    //bltu
                    3'b110         :        begin
                                                SLTControlD = 2'b10;
                                            end

                    //bgeu
                    3'b111         :        begin
                                                SLTControlD = 2'b10;
                                            end

                    default     :       begin
                                            SLTControlD = 2'b00;
                                        end
                endcase
            end

        else if (OP == LUI)
            begin
                RegWriteD = 1;
                ResultSrcD = 3'b011;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b100;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end

        else if (OP == AUIPC)
            begin
                RegWriteD = 1;
                ResultSrcD = 3'b100;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b100;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end

        else if (OP == SYSTEM) begin
            //  ECALL
            if (Instr[31:7] == 25'b0000000000000000000000000) begin
                exception = 1;
                exceptionType = 4'd11;    //  ECALL Instruction.

                RegWriteD = 0;
                ResultSrcD = 3'b000;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end
            //  EBREAK
            else if (Instr[31:7] == 25'b0000000000010000000000000) begin
                exception = 1;
                exceptionType = 4'd3;    //  EBREAK Instruction.

                RegWriteD = 0;
                ResultSrcD = 3'b000;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end
            //  MRET
            else if (Instr[31:7] == 25'b0011000000100000000000000) begin
                exception = 0;
                exceptionType = 4'd0;  
                mret = 1; 

                RegWriteD = 0;
                ResultSrcD = 3'b000;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end
            //  WFI
            else if (Instr[31:7] == 25'b0001000001010000000000000) begin
                exception = 0;
                exceptionType = 4'd0;

                RegWriteD = 0;
                ResultSrcD = 3'b000;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end
            else begin
                case (funct3) 
                    //  cssrw
                    3'b001         :        begin
                                                csrOp = 1;
                                                exception = 0;
                                                exceptionType = 4'd0;  
                                                RegWriteD = 1; 
                                                ResultSrcD = 3'b101;
                                            end
                    
                    //  cssrs
                    3'b010         :        begin
                                                csrOp = 2;
                                                exception = 0;
                                                exceptionType = 4'd0;
                                                RegWriteD = 1;
                                                ResultSrcD = 3'b101;
                                            end

                    //  cssrc
                    3'b011         :        begin
                                                csrOp = 3;
                                                exception = 0;
                                                exceptionType = 4'd0;
                                                RegWriteD = 1;
                                                ResultSrcD = 3'b101;
                                            end

                    //  cssrwi
                    3'b101         :        begin
                                                csrOp = 1;
                                                exception = 0;
                                                exceptionType = 4'd0;
                                                RegWriteD = 1;
                                                ResultSrcD = 3'b101;
                                            end

                    //  cssrsi
                    3'b110         :        begin
                                                csrOp = 2;
                                                exception = 0;
                                                exceptionType = 4'd0;
                                                RegWriteD = 1;
                                                ResultSrcD = 3'b101;
                                            end

                    //  cssrci
                    3'b111         :        begin
                                                csrOp = 3;
                                                exception = 0;
                                                exceptionType = 4'd0;
                                                RegWriteD = 1;
                                                ResultSrcD = 3'b101;
                                            end

                    default     :       begin
                                            csrOp = 0;
                                            exception = 1;
                                            exceptionType = 4'd2;    //  Illegal Instruction.
                                            RegWriteD = 0;
                                            ResultSrcD = 3'b000;
                                        end
                endcase

                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 0;
            end
        end

        else if (OP == FENCE) begin
            exception = 0;
            exceptionType = 4'd0;
            mret = 0;
            RegWriteD = 0;
            ResultSrcD = 3'b000;
            MemWriteD = 0;
            MemReadD = 0;
            JumpD = 0;
            JumpTypeD = 0;
            BranchD = 0;
            BranchTypeD = 3'b000;
            ALUSrcD = 0;
            ImmSrcD = 3'b000;
            ALUControlD = ADD;
            SLTControlD = 2'b00;
            StrobeD = 0;
        end

        else
            begin
                exception = 1;
                exceptionType = 4'd2;    //  Illegal Instruction.

                RegWriteD = 0;
                ResultSrcD = 3'b000;
                MemWriteD = 0;
                MemReadD = 0;
                JumpD = 0;
                JumpTypeD = 0;
                BranchD = 0;
                BranchTypeD = 3'b000;
                ALUSrcD = 0;
                ImmSrcD = 3'b000;
                ALUControlD = ADD;
                SLTControlD = 2'b00;
                StrobeD = 3'b000;
            end
    end


endmodule
