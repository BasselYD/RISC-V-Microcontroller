module DataMem (
    input       wire        [31:0]      Address,
    input       wire        [31:0]      WriteDataM,
    input       wire                    MemWriteM,
    input       wire        [2:0]       StrobeM,
    input       wire                    CLK,
    
    output      reg         [31:0]      ReadDataM
);


reg        [7:0]      MEM     [0:512]; //2_147_483_648 Half the Address Space.


always @ (posedge CLK)
    begin
        if (MemWriteM)
            begin
                case (StrobeM)
                    //sb
                    3'b000         :       begin
                                            MEM[Address]    <=      WriteDataM[7:0];
                                        end 

                    //sh
                    3'b001         :       begin
                                            {MEM[Address], MEM[Address + 1]}    <=      WriteDataM[15:0];
                                        end 

                    //sw
                    3'b010         :       begin
                                            {MEM[Address], MEM[Address + 1], MEM[Address + 2], MEM[Address + 3]}     <=      WriteDataM;
                                        end 

                    default     :       begin
                                            {MEM[Address], MEM[Address + 1], MEM[Address + 2], MEM[Address + 3]}    <=      WriteDataM;
                                        end 
                
                endcase
            end
    end

always @ (*)
    begin
        case (StrobeM)
            //lb
            3'b000         :       begin
                                    ReadDataM  =   {{24{MEM[Address][7]}}, MEM[Address]};
                                end 

            //lh
            3'b001         :       begin
                                    ReadDataM  =   {{16{MEM[Address][7]}}, MEM[Address], MEM[Address + 1]};
                                end 

            //lw
            3'b010         :       begin
                                    ReadDataM  =   {MEM[Address], MEM[Address + 1], MEM[Address + 2], MEM[Address + 3]};
                                end 

            //lbu
            3'b100         :       begin
                                    ReadDataM  =   {24'b0, MEM[Address]};
                                end 

            //lhu
            3'b101         :       begin
                                    ReadDataM  =   {16'b0, MEM[Address], MEM[Address + 1]};
                                end 

            default     :       begin
                                    ReadDataM  =   {MEM[Address], MEM[Address + 1], MEM[Address + 2], MEM[Address + 3]};
                                end 
        
        endcase
    end

    
endmodule

