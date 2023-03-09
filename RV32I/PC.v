module PC (
    input       wire        [31:0]      PCF_p,
    input       wire                    EN,
    input       wire                    CLK,
    input       wire                    RST,
    output      reg         [31:0]      PCF
);


always @ (posedge CLK or negedge RST) 
    begin
        if (!RST)
            PCF <= 0;
        else
            begin
                if (EN)
                    PCF <= PCF_p;
            end
    end


endmodule
