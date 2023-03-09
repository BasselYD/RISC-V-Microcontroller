module InstructionMem (
    input       wire        [31:0]      Address,
    output      wire        [31:0]      Instruction
);


reg        [7:0]      MEM     [0:4_294_967_295];


assign Instruction  =   {MEM[Address + 3], MEM[Address + 2], MEM[Address + 1], MEM[Address]};

    
endmodule
