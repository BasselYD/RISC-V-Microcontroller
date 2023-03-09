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
            000         :       Condition   =   Zero;

            //bne
            001         :       Condition   =   ~Zero;

            //blt
            100         :       Condition   =   LSB;

            //bge
            101         :       Condition   =   ~LSB;

            //bltu
            110         :       Condition   =   LSB;

            //bgeu
            111         :       Condition   =   ~LSB;
            
            default     :       Condition   =   Zero;
        endcase
    end

assign  PCSrcE  =   (Condition & BranchE) | JumpE;


endmodule
