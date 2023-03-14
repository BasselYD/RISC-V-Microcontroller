module BranchLogic (
    input       wire                    JumpE,
    input       wire                    BranchE,
    input       wire        [2:0]       BranchTypeE,
    input       wire                    Zero,
    input       wire                    LSB,
    output      wire                    PCSrcE
);

reg     Condition;

always @ (*)
    begin   
        case (BranchTypeE)
            //beq
            3'b000         :       Condition   =   Zero;

            //bne
            3'b001         :       Condition   =   ~Zero;

            //blt
            3'b100         :       Condition   =   LSB;

            //bge
            3'b101         :       Condition   =   ~LSB;

            //bltu
            3'b110         :       Condition   =   LSB;

            //bgeu
            3'b111         :       Condition   =   ~LSB;
            
            default     :       Condition   =   Zero;
        endcase
    end

assign  PCSrcE  =   (Condition & BranchE) | JumpE;


endmodule
