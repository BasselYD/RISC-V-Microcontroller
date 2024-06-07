module UART_APB (

    //APB Signals
    input       wire                     PCLK,    
    input       wire                     PRESETn, 
    input       wire                     PSEL,
    input       wire                     PENABLE,
    input       wire                     PWRITE,
    input       wire        [31:0]       PADDR,
    input       wire        [31:0]       PWDATA,
    input       wire        [3:0]        PSTRB,
    output      reg         [31:0]       PRDATA,
    output      reg                      PREADY,
    output      reg                      PSLVERR,
  
    //Rx Signals
    input       wire                     RX_IN_TOP,
     
    //Tx Signals
    output      wire                     TX_OUT_TOP,
    output      wire                     Busy_TOP
);

//      UART Registers :
//[0] Transmit and Receive with UART

//[1] Baud Rate Divisor Register
reg         [31:0]          BRD_R;

//[2] Prescale Register
reg         [7:0]           Prescale_R;

//[3] Control Register : PEN, PTYP, TxEn, RxEn
reg         [7:0]           UARTCTRL_R;

wire                        PAR_EN_TOP  =   UARTCTRL_R[3];
wire                        PAR_TYP_TOP =   UARTCTRL_R[2];   

//[4] Flags Register   : RxFull, RxEmpty, TxFull, TxEmpty, Busy
wire         [7:0]           UARTFLAGS_R;

assign                      UARTFLAGS_R[7] = 0;
assign                      UARTFLAGS_R[6] = Rx.Par_Err_TOP;
assign                      UARTFLAGS_R[5] = Rx.Stp_Err_TOP;
wire                        Rx_Full  = UARTFLAGS_R[4];
wire                        Rx_Empty = UARTFLAGS_R[3];
wire                        Tx_Empty = UARTFLAGS_R[2];
wire                        Tx_Full  = UARTFLAGS_R[1];
assign                      Busy_TOP = UARTFLAGS_R[0];


localparam      TXRX          =       0,
                BRD           =       4,
                Prescale      =       8,
                UARTCTRL      =       12,
                UARTFLAGS     =       16;


//Internal Signals
wire         [31:0]           Rx_Divisor        =    (Prescale_R == 0) ? BRD_R : (BRD_R / Prescale_R); //Rx is (Prescale) times faster than Baud Rate.
wire                          CLK_Rx, CLK_Tx;


reg                           WR_UART;                      //Signal to Write to UART
reg          [7:0]            WR_DATA_Tx;                   //Write Data
wire         [7:0]            RD_DATA_Tx;                   //Data read by Tx to Transmit
reg                           DATA_VALID_Tx;                //Signal to Start Transmitting
wire                          RD_EN_Tx = DATA_VALID_Tx;     //Signal for Tx to read from its FIFO


reg                           RD_UART;                      //Signal to Read from UART
wire         [7:0]            RD_DATA_Rx;                   //Read Data
wire         [7:0]            WR_DATA_Rx;                   //Data Rx Received
wire                          WR_EN_Rx;                     //Signal for Rx to write to its FIFO (If data is valid)



always @ (posedge CLK_Tx)
    begin
        DATA_VALID_Tx <= DATA_VALID_Tx ? 0 : (~Tx_Empty) && (~Busy_TOP);    //Start Transmitting if FIFO has data and not already transmitting.
    end

//APB Interfacing
always @ (posedge PCLK or negedge PRESETn)
    begin
        if (~PRESETn) begin
            PSLVERR <= 0;
            PRDATA <= 0;
        end
        else begin
            if (PSEL)
            begin
                case (PADDR[7:0])
                    TXRX    :   begin
                                    if (PENABLE && PWRITE)
                                        begin
                                            if (!Tx_Full)
                                                begin
                                                    WR_UART <= 1;
                                                    WR_DATA_Tx <= PWDATA;
                                                    //case (PSTRB)
                                                    //    4'b0001    :   WR_DATA_Tx <= PWDATA[7:0];
                                                    //    4'b0010    :   WR_DATA_Tx <= PWDATA[15:8];
                                                    //    4'b0100    :   WR_DATA_Tx <= PWDATA[23:16];
                                                    //    4'b1000    :   WR_DATA_Tx <= PWDATA[31:24];
                                                    //endcase
                                                    PSLVERR <= 0;
                                                    RD_UART <= 0;
                                                end
                                            else
                                                begin
                                                    PSLVERR <= 1;
                                                    WR_UART <= 0;
                                                    RD_UART <= 0;
                                                end
                                        end
                                    else if (PENABLE && !PWRITE)
                                        begin
                                            if (!Rx_Empty)
                                                begin
                                                    RD_UART <= 1;
                                                    PRDATA <= RD_DATA_Rx;
                                                    PSLVERR <= 0;
                                                    WR_UART <= 0;
                                                end
                                            else
                                                begin
                                                    PSLVERR <= 1;
                                                    WR_UART <= 0;
                                                    RD_UART <= 0;
                                                end
                                        end
                                    else
                                        begin
                                            WR_UART <= 0;
                                            RD_UART <= 0;
                                            PSLVERR <= 0;
                                        end
                                end

                    BRD   :     begin
                                    if (PENABLE && PWRITE)
                                        begin
                                            BRD_R <= PWDATA;
                                        end
                                    else if (PENABLE && !PWRITE)
                                        begin
                                            PRDATA <= BRD_R;
                                        end
                                    PSLVERR <= 0;
                                    WR_UART <= 0;
                                    RD_UART <= 0;
                                end
                    
                    Prescale   :    begin
                                        if (PENABLE && PWRITE)
                                            begin
                                                Prescale_R <= PWDATA;
                                                //case (PSTRB)
                                                //    4'b0001    :   Prescale_R <= PWDATA[7:0];
                                                //    4'b0010    :   Prescale_R <= PWDATA[15:8];
                                                //    4'b0100    :   Prescale_R <= PWDATA[23:16];
                                                //    4'b1000    :   Prescale_R <= PWDATA[31:24];
                                                //endcase
                                            end
                                        else if (PENABLE && !PWRITE)
                                            begin
                                                PRDATA <= Prescale_R;
                                            end
                                        PSLVERR <= 0;
                                        WR_UART <= 0;
                                        RD_UART <= 0;
                                    end

                    UARTCTRL   :    begin
                                        if (PENABLE && PWRITE)
                                            begin
                                                UARTCTRL_R <= PWDATA;
                                                //case (PSTRB)
                                                //    4'b0001    :   UARTCTRL_R <= PWDATA[7:0];
                                                //    4'b0010    :   UARTCTRL_R <= PWDATA[15:8];
                                                //    4'b0100    :   UARTCTRL_R <= PWDATA[23:16];
                                                //    4'b1000    :   UARTCTRL_R <= PWDATA[31:24];
                                                //endcase
                                            end
                                        else if (PENABLE && !PWRITE)
                                            begin
                                                PRDATA <= UARTCTRL_R;
                                            end
                                        PSLVERR <= 0;
                                        WR_UART <= 0;
                                        RD_UART <= 0;
                                    end

                    UARTFLAGS   :   begin
                                        if (PENABLE && !PWRITE)
                                            begin
                                                PRDATA <= UARTFLAGS_R;
                                                PSLVERR <= 0;
                                            end
                                        else if (PENABLE && PWRITE)
                                            begin
                                                PSLVERR <= 1;
                                            end
                                        WR_UART <= 0;
                                        RD_UART <= 0;
                                    end
                endcase
            end
            else begin
                WR_UART <= 0;
                RD_UART <= 0;
                PSLVERR <= 0;
            end
        end
        
    end

//PREADY
always @ (*)
    begin
        if (PADDR[15:0] == TXRX)
            begin
                if (PWRITE)
                    PREADY = 1; //if Tx_Full, an error is signalled.
                else
                    PREADY = Rx_Empty;
            end
        else
            begin
                PREADY = 1;
            end
    end


//Instantiations

UART_Rx_TOP  Rx (
    .RX_IN_TOP(RX_IN_TOP),
    .Prescale_TOP(Prescale_R),
    .PAR_EN_TOP(PAR_EN_TOP),
    .PAR_TYP_TOP(PAR_TYP_TOP),
    .CLK_TOP(CLK_Rx),  
    .RST_TOP(PRESETn),
    .P_DATA_TOP(WR_DATA_Rx),
    .Data_Valid_TOP(WR_EN_Rx)
);

Async_FIFO  Rx_FIFO (
    .wr_en(WR_EN_Rx),
    .wr_data(WR_DATA_Rx),
    .rd_en(RD_UART),
    .wr_clk(CLK_Rx),
    .rd_clk(PCLK),
    .rst(PRESETn),
    .rd_data(RD_DATA_Rx),
    .full_flag(UARTFLAGS_R[4]),
    .empty_flag(UARTFLAGS_R[3])
);


UART_Tx_TOP  Tx (
    .P_DATA_TOP(RD_DATA_Tx),
    .DATA_VALID_TOP(DATA_VALID_Tx),
    .PAR_EN_TOP(PAR_EN_TOP),
    .PAR_TYP_TOP(PAR_TYP_TOP),
    .CLK_TOP(CLK_Tx),
    .RST_TOP(PRESETn),
    .TX_OUT_TOP(TX_OUT_TOP),
    .Busy_TOP(UARTFLAGS_R[0])
);


Async_FIFO  Tx_FIFO (
    .wr_en(WR_UART),
    .wr_data(WR_DATA_Tx),
    .rd_en(RD_EN_Tx),
    .wr_clk(PCLK),
    .rd_clk(CLK_Tx),
    .rst(PRESETn),
    .rd_data(RD_DATA_Tx),
    .full_flag(UARTFLAGS_R[1]),
    .empty_flag(UARTFLAGS_R[2])
);


ClkDiv  Baud_Rate_Generator (
    .i_ref_clk(PCLK),
    .i_rst_n(PRESETn),
    .i_clk_en(1'b1),
    .i_div_ratio(BRD_R),
    .o_div_clk(CLK_Tx)
);

ClkDiv  Rx_Clock_Generator (
    .i_ref_clk(PCLK),
    .i_rst_n(PRESETn),
    .i_clk_en(1'b1),
    .i_div_ratio(Rx_Divisor),
    .o_div_clk(CLK_Rx)
);


endmodule

