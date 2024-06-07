module ClkDiv #(parameter DIV_WIDTH = 4) (
    input       wire                                i_ref_clk,
    input       wire                                i_rst_n,
    input       wire                                i_clk_en,
    input       wire        [DIV_WIDTH-1:0]         i_div_ratio,
    output      wire                                o_div_clk
);

reg     [31:0]      counter;
reg                 Toggled;
wire                ClkEn;
reg                 div_clk;

always @ (posedge i_ref_clk or negedge i_rst_n)
    begin
        if (!i_rst_n)
            begin
                counter <= 0;
                div_clk <= 0;
                Toggled <= 0;
            end
        else
            begin
                if (ClkEn)
                begin
                    counter <= counter + 1;

                    if (!i_div_ratio[0] && counter == (i_div_ratio >> 1))
                        begin 
                            div_clk <= ~div_clk;
                            counter <= 1;
                        end
                        
                    else if (i_div_ratio[0])
                        begin
                            if (counter == (i_div_ratio >> 1) && !Toggled)
                                begin
                                    div_clk <= ~div_clk;
                                    Toggled <= ~Toggled;
                                    counter <= 1;
                                end

                            else if (counter == ((i_div_ratio >> 1) + 1) && Toggled)
                                begin
                                    div_clk <= ~div_clk;
                                    Toggled <= ~Toggled;
                                    counter <= 1;
                                end
                        end
                end
            end

    end

assign ClkEn = i_clk_en && |i_div_ratio && (i_div_ratio != 1);

assign o_div_clk = ClkEn ? div_clk : i_ref_clk;

endmodule
