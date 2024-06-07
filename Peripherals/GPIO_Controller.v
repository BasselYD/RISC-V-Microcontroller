module GPIO_Controller #(parameter PINS = 8) (
    input       wire                     PCLK,    
    input       wire                     PRESETn, 
    input       wire                     PSEL,
    input       wire                     PENABLE,
    input       wire                     PWRITE,
    input       wire        [31:0]       PADDR,
    input       wire        [31:0]       PWDATA,
    input       wire        [3:0]        PSTRB,
    output      reg         [31:0]       PRDATA,
    output      wire                     PREADY,
    output      reg                      PSLVERR,

    inout       wire         [PINS-1 : 0]    PORTA,
    inout       wire         [PINS-1 : 0]    PORTB,
    inout       wire         [PINS-1 : 0]    PORTC,
    inout       wire         [PINS-1 : 0]    PORTD
);

reg         [PINS-1 : 0]    PORTA_MODE_R;            //Address 0
reg         [PINS-1 : 0]    PORTA_DIRECTION_R;       //Address 1
reg         [PINS-1 : 0]    PORTA_OUTPUT_R;          //Address 2
reg         [PINS-1 : 0]    PORTA_INPUT_R;           //Address 3

reg         [PINS-1 : 0]    PORTB_MODE_R;            //Address 4
reg         [PINS-1 : 0]    PORTB_DIRECTION_R;       //Address 5
reg         [PINS-1 : 0]    PORTB_OUTPUT_R;          //Address 6
reg         [PINS-1 : 0]    PORTB_INPUT_R;           //Address 7

reg         [PINS-1 : 0]    PORTC_MODE_R;            //Address 8
reg         [PINS-1 : 0]    PORTC_DIRECTION_R;       //Address 9
reg         [PINS-1 : 0]    PORTC_OUTPUT_R;          //Address 10
reg         [PINS-1 : 0]    PORTC_INPUT_R;           //Address 11

reg         [PINS-1 : 0]    PORTD_MODE_R;            //Address 12
reg         [PINS-1 : 0]    PORTD_DIRECTION_R;       //Address 13
reg         [PINS-1 : 0]    PORTD_OUTPUT_R;          //Address 14
reg         [PINS-1 : 0]    PORTD_INPUT_R;           //Address 15


localparam  Push_Pull   =   0,
            Open_Drain  =   1;

localparam  A_MODE            =   0,
            A_DIRECTION       =   4,
            A_OUTPUT          =   8,
            A_INPUT           =   12,
            B_MODE            =   16,
            B_DIRECTION       =   20,
            B_OUTPUT          =   24,
            B_INPUT           =   28,
            C_MODE            =   32,
            C_DIRECTION       =   36,
            C_OUTPUT          =   40,
            C_INPUT           =   44,
            D_MODE            =   48,
            D_DIRECTION       =   52,
            D_OUTPUT          =   56,
            D_INPUT           =   60;

genvar N;


always @ (posedge PCLK or negedge PRESETn)
    begin
        if (!PRESETn)
            begin
                PORTA_MODE_R <= 0;
                PORTA_DIRECTION_R <= 0;
                PORTA_OUTPUT_R <= 0;
                PORTA_INPUT_R <= 0;

                PORTB_MODE_R <= 0;
                PORTB_DIRECTION_R <= 0;
                PORTB_OUTPUT_R <= 0;
                PORTB_INPUT_R <= 0;

                PORTC_MODE_R <= 0;
                PORTC_DIRECTION_R <= 0;
                PORTC_OUTPUT_R <= 0;
                PORTC_INPUT_R <= 0;

                PORTD_MODE_R <= 0;
                PORTD_DIRECTION_R <= 0;
                PORTD_OUTPUT_R <= 0;
                PORTD_INPUT_R <= 0;

                PSLVERR <= 0;
                PRDATA <= 0;
            end

        else
            if (PSEL)
                begin
                    case (PADDR[7:0])
                        A_MODE          :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        PORTA_MODE_R <= PWDATA;
                                                        //case (PSTRB)
                                                        //    4'b0001    :   PORTA_MODE_R <= PWDATA[7:0];
                                                        //    4'b0010    :   PORTA_MODE_R <= PWDATA[15:8];
                                                        //    4'b0100    :   PORTA_MODE_R <= PWDATA[23:16];
                                                        //    4'b1000    :   PORTA_MODE_R <= PWDATA[31:24];
                                                        //endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTA_MODE_R;
                                                    end
                                                PSLVERR <= 0;
                                            end
                        
                        A_DIRECTION     :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        PORTA_DIRECTION_R <= PWDATA;
                                                        //case (PSTRB)
                                                        //    4'b0001    :   PORTA_DIRECTION_R <= PWDATA[7:0];
                                                        //    4'b0010    :   PORTA_DIRECTION_R <= PWDATA[15:8];
                                                        //    4'b0100    :   PORTA_DIRECTION_R <= PWDATA[23:16];
                                                        //    4'b1000    :   PORTA_DIRECTION_R <= PWDATA[31:24];
                                                        //endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTA_DIRECTION_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        A_OUTPUT        :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        PORTA_OUTPUT_R <= PWDATA;
                                                        //case (PSTRB)
                                                        //    4'b0001    :   PORTA_OUTPUT_R <= PWDATA[7:0];
                                                        //    4'b0010    :   PORTA_OUTPUT_R <= PWDATA[15:8];
                                                        //    4'b0100    :   PORTA_OUTPUT_R <= PWDATA[23:16];
                                                        //    4'b1000    :   PORTA_OUTPUT_R <= PWDATA[31:24];
                                                        //endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTA_OUTPUT_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        A_INPUT         :   begin
                                                if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTA_INPUT_R;
                                                        PSLVERR <= 0;
                                                    end
                                                else if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        PSLVERR <= 1;
                                                    end
                                            end


                        B_MODE          :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTB_MODE_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTB_MODE_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTB_MODE_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTB_MODE_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTB_MODE_R;
                                                    end
                                                PSLVERR <= 0;
                                            end
                        
                        B_DIRECTION     :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTB_DIRECTION_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTB_DIRECTION_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTB_DIRECTION_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTB_DIRECTION_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTB_DIRECTION_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        B_OUTPUT        :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTB_OUTPUT_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTB_OUTPUT_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTB_OUTPUT_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTB_OUTPUT_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTB_OUTPUT_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        B_INPUT         :   begin
                                                if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTB_INPUT_R;
                                                        PSLVERR <= 0;
                                                    end
                                                else if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        PSLVERR <= 1;
                                                    end
                                            end


                        C_MODE          :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTC_MODE_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTC_MODE_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTC_MODE_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTC_MODE_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTC_MODE_R;
                                                    end
                                                PSLVERR <= 0;
                                            end
                        
                        C_DIRECTION     :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTC_DIRECTION_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTC_DIRECTION_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTC_DIRECTION_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTC_DIRECTION_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTC_DIRECTION_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        C_OUTPUT        :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTC_OUTPUT_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTC_OUTPUT_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTC_OUTPUT_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTC_OUTPUT_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTC_OUTPUT_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        C_INPUT         :   begin
                                                if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTC_INPUT_R;
                                                        PSLVERR <= 0;
                                                    end
                                                else if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        PSLVERR <= 1;
                                                    end
                                            end


                        D_MODE          :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTD_MODE_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTD_MODE_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTD_MODE_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTD_MODE_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTD_MODE_R;
                                                    end
                                                PSLVERR <= 0;
                                            end
                        
                        D_DIRECTION     :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTD_DIRECTION_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTD_DIRECTION_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTD_DIRECTION_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTD_DIRECTION_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTD_DIRECTION_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        D_OUTPUT        :   begin
                                                if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        case (PSTRB)
                                                            4'b0001    :   PORTD_OUTPUT_R <= PWDATA[7:0];
                                                            4'b0010    :   PORTD_OUTPUT_R <= PWDATA[15:8];
                                                            4'b0100    :   PORTD_OUTPUT_R <= PWDATA[23:16];
                                                            4'b1000    :   PORTD_OUTPUT_R <= PWDATA[31:24];
                                                        endcase
                                                    end
                                                else if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTD_OUTPUT_R;
                                                    end
                                                PSLVERR <= 0;
                                            end

                        D_INPUT         :   begin
                                                if (PENABLE && PREADY && !PWRITE)
                                                    begin
                                                        PRDATA <= PORTD_INPUT_R;
                                                        PSLVERR <= 0;
                                                    end
                                                else if (PENABLE && PREADY && PWRITE)
                                                    begin
                                                        PSLVERR <= 1;
                                                    end
                                            end
                            
                    endcase
                end
    end

// /PORTA_INPUT_R[N] = PORTA[N];
generate
    for (N = 0; N < PINS; N = N + 1)
        begin
            assign PORTA[N] = ~PORTA_MODE_R[N] ? (PORTA_DIRECTION_R[N] ? PORTA_OUTPUT_R[N] : 1'bz) : ((PORTA_DIRECTION_R[N] & ~PORTA_OUTPUT_R[N]) ? 0 : 1'bz);
            assign PORTB[N] = ~PORTB_MODE_R[N] ? (PORTB_DIRECTION_R[N] ? PORTB_OUTPUT_R[N] : 1'bz) : ((PORTB_DIRECTION_R[N] & ~PORTB_OUTPUT_R[N]) ? 0 : 1'bz);
            assign PORTC[N] = ~PORTC_MODE_R[N] ? (PORTC_DIRECTION_R[N] ? PORTC_OUTPUT_R[N] : 1'bz) : ((PORTC_DIRECTION_R[N] & ~PORTC_OUTPUT_R[N]) ? 0 : 1'bz);
            assign PORTD[N] = ~PORTD_MODE_R[N] ? (PORTD_DIRECTION_R[N] ? PORTD_OUTPUT_R[N] : 1'bz) : ((PORTD_DIRECTION_R[N] & ~PORTD_OUTPUT_R[N]) ? 0 : 1'bz); 
        end
endgenerate

always @ (posedge PCLK or negedge PRESETn) begin
    if (~PRESETn) begin
        PORTA_INPUT_R <= 0;
        PORTB_INPUT_R <= 0;
        PORTC_INPUT_R <= 0;
        PORTD_INPUT_R <= 0;
    end
    else begin
        PORTA_INPUT_R <= PORTA;
        PORTB_INPUT_R <= PORTB;
        PORTC_INPUT_R <= PORTC;
        PORTD_INPUT_R <= PORTD;
    end
end


assign PREADY = 1;



endmodule