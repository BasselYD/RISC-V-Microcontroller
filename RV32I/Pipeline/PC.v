module PC (
    input       wire        [31:0]      PCF_p,
    input       wire                    EN,
    input       wire                    clk,
    input       wire                    rst,
    output      reg         [31:0]      PCF
);


always @ (posedge clk or negedge rst) 
    begin
        if (!rst)
            PCF <= 0;
        else
            begin
                if (EN)
                    PCF <= PCF_p;
            end
    end


endmodule
