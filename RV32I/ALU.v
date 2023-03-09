module ALU (
    input       wire        [31:0]      A,
    input       wire        [31:0]      B,
    input       wire        [2:0]       ALUControlE,
    input       wire        [1:0]       SLTControlE,
    output      reg         [31:0]      ALUResultE,
    output      wire        [3:0]       Flags      //Z C V N
);


reg         [31:0]      Result;
wire                    Zero, Negative;
reg                     Carry, Overflow;


localparam      ADD      =   3'b000,
                SUB      =   3'b001,
                AND      =   3'b010,
                OR       =   3'b011,
                XOR      =   3'b100,
                SLL      =   3'b101,
                SRA      =   3'b110,
                SRL      =   3'b111;


always @ (*)
    begin
        case (ALUControlE)
            ADD         :       begin
                                    {Carry, Result}     =       A + B;
                                    Overflow                =       (A[31] ^ Result[31]) & ~(A[31] ^ B[31]);
                                end

            SUB         :       begin
                                    {Carry, Result}     =       A - B;
                                    Overflow                =       (A[31] ^ Result[31]) & (A[31] ^ B[31]);
                                end


            AND         :       begin
                                    Result  =   A & B;
                                    Carry       =   0;
                                    Overflow    =   0;
                                end

            OR          :       begin
                                    Result  =   A | B;
                                    Carry       =   0;
                                    Overflow    =   0;
                                end

            XOR         :       begin
                                    Result  =   A ^ B;
                                    Carry       =   0;
                                    Overflow    =   0;
                                end

            SLL         :       begin
                                    {Carry, Result}     =   A << B;
                                    Overflow                =   0;
                                end

            SRA         :       begin
                                    {Result, Carry}     =   A >>> B;
                                    Overflow                =   0;
                                end

            SRL         :       begin
                                    {Result, Carry}     =   A >> B;
                                    Overflow                =   0;
                                end

            default     :       begin
                                    {Carry, Result}     =   A + B;
                                    Overflow                =   0;
                                end

        endcase
    end

always @ (*)
    begin
        case (SLTControlE)
            00      :   ALUResultE  =   Result;                          //Normal Operation

            01      :   ALUResultE  =   {31'b0, Negative ^ Overflow};    //SLT

            10      :   ALUResultE  =   {31'b0, ~Carry};                 //SLTU

            11      :   ALUResultE  =   Result;                          //Normal Operation

            default :   ALUResultE  =   Result;                          //Normal Operation
        endcase
    end

assign  Zero        =       ~|Result;
assign  Negative    =       Result[31]; 

assign  Flags       =       {Zero, Carry, Overflow, Negative};

endmodule
