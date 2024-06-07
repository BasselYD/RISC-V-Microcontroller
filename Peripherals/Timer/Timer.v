module Timer #(parameter nTIMERS = 3) (
    input   wire            clk,
    input   wire            rst,
    input   wire            cs,
    input   wire    [7:0]   addr,
    input   wire            rw,
    input   wire    [31:0]  wdata,
    output  reg     [31:0]  rdata,
    output  wire            error,
    output  wire            ready,
    output  wire            interrupt
);

wire div_clk;

reg [31:0]  TIME, PRESCALER, IENABLE, IPENDING;
reg [31:0]  TIMECMP [nTIMERS-1:0];

reg [31:0]  TIME_c, PRESCALER_c, IENABLE_c, IPENDING_c;
reg [31:0]  TIMECMP_c [nTIMERS-1:0];

reg [31:0]  timecmp_rdata;
reg [31:0]  clear_pending;  

integer i;

ClkDiv #(.DIV_WIDTH(32)) u_prescaler (
    .i_ref_clk(clk),
    .i_rst_n(rst),
    .i_clk_en(1'b1),
    .i_div_ratio(PRESCALER),
    .o_div_clk(div_clk)
);

always @ (posedge div_clk or negedge rst) begin
    if (!rst)
        TIME <= 0;
    else
        TIME <= TIME + 1'b1; 
end

always @ (posedge clk or negedge rst) begin
    if (!rst) begin
        PRESCALER <= 0;
        IENABLE   <= 0;
        IPENDING  <= 0;

        for (i = 0; i < nTIMERS; i = i + 1) begin
            TIMECMP[i] <= 0;
        end
    end
    else begin
        PRESCALER <= PRESCALER_c;
        IENABLE   <= IENABLE_c;
        IPENDING  <= IPENDING_c;

        for (i = 0; i < nTIMERS; i = i + 1) begin
            TIMECMP[i] <= TIMECMP_c[i];
        end
    end
end

always @ (*) begin
    rdata = 0;
    PRESCALER_c = PRESCALER;
    IENABLE_c   = IENABLE;
    IPENDING_c  = IPENDING;
    TIMECMP_c[0] = TIMECMP[0];
    clear_pending = 0;

    for (i = 0; i < nTIMERS; i = i + 1) begin
        IPENDING_c[i] = IENABLE[i] && (TIME >= TIMECMP[i]) && ~clear_pending[i]; 
    end

    if (cs) begin
        case (addr)
            //  TIME
            8'h00   :   begin
                            rdata = TIME;
                        end

            //  PRESCALER
            8'h04   :   begin
                            rdata = PRESCALER;
                            if (rw)
                                PRESCALER_c = wdata;
                            else
                                PRESCALER_c = PRESCALER;
                        end

            //  IENABLE
            8'h08   :   begin
                            rdata = IENABLE;
                            if (rw)
                                IENABLE_c = wdata;
                            else
                                IENABLE_c = IENABLE;
                        end

            //  IPENDING
            8'h0c   :   begin
                            rdata = IPENDING;
                        end

            //  TIMECMP[0]
            8'h10   :   begin
                            rdata = TIMECMP[0];
                            if (rw) begin
                                TIMECMP_c[0] = wdata;
                                clear_pending[0] = 1;
                            end
                            else begin
                                TIMECMP_c[0] = TIMECMP[0];
                                clear_pending[0] = 0;
                            end
                        end

            default :   begin
                            rdata = timecmp_rdata;
                        end
        endcase
    end
    else begin
        
    end
end

genvar x;
generate
    for (x = 1; x < nTIMERS; x = x + 1) begin
        always @ (*) begin
            if (cs) begin
                if (addr == (8'h10 + (x<<2))) begin
                    timecmp_rdata = TIMECMP[x];
                    if (rw) begin
                        TIMECMP_c[x] = wdata;
                        clear_pending[x] = 1;
                    end
                    else begin
                        TIMECMP_c[x] = TIMECMP[x];
                        clear_pending[x] = 0;
                    end
                end
                else begin
                    timecmp_rdata = 0;
                    TIMECMP_c[x] = TIMECMP[x];
                    clear_pending[x] = 0;
                end
            end
            else begin
                timecmp_rdata = 0;
                TIMECMP_c[x] = TIMECMP[x];
                clear_pending[x] = 0;
            end 
        end
    end
endgenerate

assign interrupt = |IPENDING;
assign ready = 1;
assign error = cs && (addr >= 8'h84);


endmodule