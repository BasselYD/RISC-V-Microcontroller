module InstructionMem (
    input       wire        [31:0]      Address,
    output      wire        [31:0]      Instruction
);


reg        [7:0]      MEM     [0:512]; //2_147_483_648 Half the Address Space.


assign Instruction  =   {MEM[Address], MEM[Address + 1], MEM[Address + 2], MEM[Address + 3]};

    
endmodule
