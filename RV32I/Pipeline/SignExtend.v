module SignExtend (
    input       wire        [31:7]      ImmFields,
    input       wire        [2:0]       ImmSrcD,
    output      reg         [31:0]      ExtImmD
);


always @ (*)
    begin
        case (ImmSrcD)
            //I-Type Instruction
            3'b000     :   ExtImmD     =       {{20{ImmFields[31]}}, ImmFields[31:20]};

            //S-Type Instruction
            3'b001     :   ExtImmD     =       {{20{ImmFields[31]}}, ImmFields[31:25], ImmFields[11:7]};

            //B-Type Instruction
            3'b010     :   ExtImmD     =       {{19{ImmFields[31]}}, ImmFields[31], ImmFields[7], ImmFields[30:25], ImmFields[11:8], 1'b0};

            //J-Type Instruction
            3'b011     :   ExtImmD     =       {{11{ImmFields[31]}}, ImmFields[31], ImmFields[19:12], ImmFields[20], ImmFields[30:21], 1'b0}; 

            //U-Type Instruction
            3'b100     :   ExtImmD     =       {ImmFields[31:12], 12'b0};

            //Shift Instruction
            3'b101     :   ExtImmD     =       {ImmFields[24:20]};

            
            default :   ExtImmD     =       {{20{ImmFields[31]}}, ImmFields[31:20]};

        endcase
    end

    
endmodule
