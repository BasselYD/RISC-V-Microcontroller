module DataMem (
    input       wire        [31:0]      Address,
    input       wire        [31:0]      WriteDataM,
    input       wire                    MemWriteM,
    input       wire        [2:0]       StrobeM,
    input       wire                    CLK,
    
    output      reg         [31:0]      ReadDataM
);


reg        [7:0]      MEM     [0:4_294_967_295];


always @ (posedge CLK)
    begin
        if (MemWriteM)
            begin
                case (StrobeM)
                    //sb
                    000         :       begin
                                            MEM[Address]    <=      WriteDataM[7:0];
                                        end 

                    //sh
                    001         :       begin
                                            {MEM[Address], MEM[Address + 1]}    <=      WriteDataM[15:0];
                                        end 

                    //sw
                    010         :       begin
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
            000         :       begin
                                    ReadDataM  =   {{24{MEM[Address][7]}}, MEM[Address]};
                                end 

            //lh
            001         :       begin
                                    ReadDataM  =   {{16{MEM[Address][7]}}, MEM[Address], MEM[Address + 1]};
                                end 

            //lw
            010         :       begin
                                    ReadDataM  =   {MEM[Address], MEM[Address + 1], MEM[Address + 2], MEM[Address + 3]};
                                end 

            //lbu
            100         :       begin
                                    ReadDataM  =   {24'b0, MEM[Address]};
                                end 

            //lhu
            101         :       begin
                                    ReadDataM  =   {16'b0, MEM[Address], MEM[Address + 1]};
                                end 

            default     :       begin
                                    ReadDataM  =   {MEM[Address], MEM[Address + 1], MEM[Address + 2], MEM[Address + 3]};
                                end 
        
        endcase
    end

    
endmodule

