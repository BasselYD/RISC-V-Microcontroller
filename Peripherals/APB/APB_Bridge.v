/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//    Asynchronous AHB3-Lite to APB Bridge                         //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2017-2019 ROA Logic BV                //
//             www.roalogic.com                                    //
//                                                                 //
//     Unless specifically agreed in writing, this software is     //
//   licensed under the RoaLogic Non-Commercial License            //
//   version-1.0 (the "License"), a copy of which is included      //
//   with this file or may be found on the RoaLogic website        //
//   http://www.roalogic.com. You may not use the file except      //
//   in compliance with the License.                               //
//                                                                 //
//     THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY           //
//   EXPRESS OF IMPLIED WARRANTIES OF ANY KIND.                    //
//   See the License for permissions and limitations under the     //
//   License.                                                      //
//                                                                 //
/////////////////////////////////////////////////////////////////////

// +FHDR -  Semiconductor Reuse Standard File Header Section  -------
// FILE NAME      : ahb3lite_apb_bridge.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     2017-03-29  rherveille  initial release
// 1.1     2019-08-01  rherveille  Fixed PSTRB ahb_hwrite size
// ------------------------------------------------------------------
// KEYWORDS : AMBA AHB AHB3-Lite APB Bridge
// ------------------------------------------------------------------
// PURPOSE  : Asynchronous AHB3Lite to APB4 Bridge
// ------------------------------------------------------------------
// PARAMETERS
//  PARAM NAME        RANGE    DESCRIPTION              DEFAULT UNITS
//  HADDR_SIZE        1+       AHB Address bus size     32      bits
//  HDATA_SIZE        1+       AHB Data bus size        32      bits
//  PADDR_SIZE        1+       APB Address bus size     10      bits
//  PDATA_SIZE        1+       APB Data bus size        8       bits
//  SYNC_DEPTH        1+       CDC sync stages          3       stages
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : external asynchronous active low; HRESETn
//   Clock Domains       : HCLK, rising edge
//   Critical Timing     : 
//   Test Features       : na
//   Asynchronous I/F    : no
//   Scan Methodology    : na
//   Instantiations      : none
//   Synthesizable (y/n) : Yes
//   Other               :                                         
// -FHDR-------------------------------------------------------------

module APB_Bridge
#(
  parameter HADDR_SIZE = 16,
  parameter HDATA_SIZE = 32,
  parameter PADDR_SIZE = 16,
  parameter PDATA_SIZE = 32,
  parameter SYNC_DEPTH =  3
)
(
  //AHB Slave Interface
  input                         HRESETn,
                                HCLK,
  input                         HSEL,
  input      [HADDR_SIZE  -1:0] HADDR,
  input      [HDATA_SIZE  -1:0] HWDATA,
  output reg [HDATA_SIZE  -1:0] HRDATA,
  input                         HWRITE,
  input      [             2:0] HSIZE,
  input      [             2:0] HBURST,
  input      [             3:0] HPROT,
  input      [             1:0] HTRANS,
  input                         HMASTLOCK,
  output reg                    HREADYOUT,
  input                         HREADY,
  output reg                    HRESP,

  //APB Master Interface
  input                         PRESETn,
                                PCLK,
  output reg                    PSEL,
  output reg                    PENABLE,
  output reg [             2:0] PPROT,
  output reg                    PWRITE,
  output reg [PDATA_SIZE/8-1:0] PSTRB,
  output reg [PADDR_SIZE  -1:0] PADDR,
  output reg [PDATA_SIZE  -1:0] PWDATA,
  input      [PDATA_SIZE  -1:0] PRDATA,
  input                         PREADY,
  input                         PSLVERR
);
//////////////////////////////////////////////////////////////////
//
// Constants
//

localparam [1:0]    ST_AHB_IDLE=2'b00,
                    ST_AHB_TRANSFER=2'b01,
                    ST_AHB_ERROR=2'b10;

localparam [1:0]    ST_APB_IDLE=2'b00,
                    ST_APB_SETUP=2'b01,
                    ST_APB_TRANSFER=2'b10;


//PPROT
localparam [2:0] PPROT_NORMAL      = 3'b000,
                 PPROT_PRIVILEGED  = 3'b001,
                 PPROT_SECURE      = 3'b000,
                 PPROT_NONSECURE   = 3'b010,
                 PPROT_DATA        = 3'b000,
                 PPROT_INSTRUCTION = 3'b100;

//SYNC_DEPTH
localparam SYNC_DEPTH_MIN = 3;
localparam SYNC_DEPTH_CHK = SYNC_DEPTH > SYNC_DEPTH_MIN ? SYNC_DEPTH : SYNC_DEPTH_MIN;

localparam       HTRANS_SIZE   = 2;
localparam       HSIZE_SIZE    = 3;
localparam       HBURST_SIZE   = 3;
localparam       HPROT_SIZE    = 4;

//HTRANS
localparam [1:0] HTRANS_IDLE   = 2'b00,
                HTRANS_BUSY   = 2'b01,
                HTRANS_NONSEQ = 2'b10,
                HTRANS_SEQ    = 2'b11;

//HSIZE
localparam [2:0] HSIZE_B8    = 3'b000,
                HSIZE_B16   = 3'b001,
                HSIZE_B32   = 3'b010,
                HSIZE_B64   = 3'b011,
                HSIZE_B128  = 3'b100, //4-word line
                HSIZE_B256  = 3'b101, //8-word line
                HSIZE_B512  = 3'b110,
                HSIZE_B1024 = 3'b111,
                HSIZE_BYTE  = HSIZE_B8,
                HSIZE_HWORD = HSIZE_B16,
                HSIZE_WORD  = HSIZE_B32,
                HSIZE_DWORD = HSIZE_B64;

//HBURST
localparam [2:0] HBURST_SINGLE = 3'b000,
                HBURST_INCR   = 3'b001,
                HBURST_WRAP4  = 3'b010,
                HBURST_INCR4  = 3'b011,
                HBURST_WRAP8  = 3'b100,
                HBURST_INCR8  = 3'b101,
                HBURST_WRAP16 = 3'b110,
                HBURST_INCR16 = 3'b111;

//HPROT
localparam [3:0] HPROT_OPCODE         = 4'b0000,
                HPROT_DATA           = 4'b0001,
                HPROT_USER           = 4'b0000,
                HPROT_PRIVILEGED     = 4'b0010,
                HPROT_NON_BUFFERABLE = 4'b0000,
                HPROT_BUFFERABLE     = 4'b0100,
                HPROT_NON_CACHEABLE  = 4'b0000,
                HPROT_CACHEABLE      = 4'b1000;

//HRESP
localparam       HRESP_OKAY  = 1'b0,
                HRESP_ERROR = 1'b1;



////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//
// Variables
//
reg                       ahb_treq;       //transfer request from AHB Statemachine
reg                       treq_toggle;    //toggle-signal-version
reg  [SYNC_DEPTH_CHK-1:0] treq_sync;      //synchronized transfer request
wire                      apb_treq_strb;  //transfer request strobe to APB Statemachine

reg                       apb_tack;       //transfer acknowledge from APB Statemachine
reg                       tack_toggle;    //toggle-signal-version
reg  [SYNC_DEPTH_CHK-1:0] tack_sync;      //synchronized transfer acknowledge
wire                      ahb_tack_strb;  //transfer acknowledge strobe to AHB Statemachine


//store AHB data locally (pipelined bus)
reg  [HADDR_SIZE    -1:0] ahb_haddr;
reg  [HDATA_SIZE    -1:0] ahb_hwdata;
reg                       ahb_hwrite;
reg  [               2:0] ahb_hsize;
reg  [               3:0] ahb_hprot;

reg                       latch_ahb_hwdata;


//store APB data locally
reg  [HDATA_SIZE    -1:0] apb_prdata;
reg                       apb_pslverr;


//State machines
reg  [1:0]                ahb_fsm;
reg  [1:0]                apb_fsm;


//number of transfer cycles (AMBA-beats) on APB interface
reg  [               6:0] apb_beat_cnt;

//running offset in HWDATA
reg  [               9:0] apb_beat_data_offset;


//////////////////////////////////////////////////////////////////
//
// Tasks
//
task ahb_no_transfer;
begin
    ahb_fsm   <= ST_AHB_IDLE;

    HREADYOUT <= 1'b1;
    HRESP     <= HRESP_OKAY;
end
endtask //ahb_no_transfer


task ahb_prep_transfer;
begin
    ahb_fsm    <= ST_AHB_TRANSFER;

    HREADYOUT  <= 1'b0; //hold off master
    HRESP      <= HRESP_OKAY;
    ahb_treq   <= 1'b1; //request data transfer
end
endtask //ahb_prep_transfer


//////////////////////////////////////////////////////////////////
//
// Functions
//
function [6:0] apb_beats
(
    input [2:0] hsize
);
begin

    case (hsize)
        HSIZE_B1024: apb_beats = 1023/PDATA_SIZE; 
        HSIZE_B512 : apb_beats =  511/PDATA_SIZE;
        HSIZE_B256 : apb_beats =  255/PDATA_SIZE;
        HSIZE_B128 : apb_beats =  127/PDATA_SIZE;
        HSIZE_DWORD: apb_beats =   63/PDATA_SIZE;
        HSIZE_WORD : apb_beats =   31/PDATA_SIZE;
        HSIZE_HWORD: apb_beats =   15/PDATA_SIZE;
        default    : apb_beats =    7/PDATA_SIZE;
    endcase
end
endfunction //apb_beats


function [6:0] address_mask;
    input integer data_size;
begin

    //Which bits in HADDR should be taken into account?
    case (data_size)
            1024: address_mask = 7'b111_1111; 
            512:  address_mask = 7'b011_1111;
            256:  address_mask = 7'b001_1111;
            128:  address_mask = 7'b000_1111;
            64:   address_mask = 7'b000_0111;
            32:   address_mask = 7'b000_0011;
            16:   address_mask = 7'b000_0001;
        default:  address_mask = 7'b000_0000;
    endcase
end
endfunction //address_mask


function [9:0] data_offset (input [HADDR_SIZE-1:0] haddr);
    reg [6:0] haddr_masked;
begin

    //Generate masked address
    haddr_masked = haddr & address_mask(HDATA_SIZE);

    //calculate bit-offset
    data_offset = 8 * haddr_masked;
end
endfunction //data_offset


function [PDATA_SIZE/8-1:0] pstrb;
    input [           2:0] hsize;
    input [PADDR_SIZE-1:0] paddr;

    reg [127:0] full_pstrb;
    reg [  6:0] paddr_masked;
begin

    //get number of active lanes for a 1024bit databus (max width) for this HSIZE
    case (hsize)
        HSIZE_B1024: full_pstrb = {128{1'b1}}; 
        HSIZE_B512 : full_pstrb = { 64{1'b1}};
        HSIZE_B256 : full_pstrb = { 32{1'b1}};
        HSIZE_B128 : full_pstrb = { 16{1'b1}};
        HSIZE_DWORD: full_pstrb = {  8{1'b1}};
        HSIZE_WORD : full_pstrb = {  4{1'b1}};
        HSIZE_HWORD: full_pstrb = {  2{1'b1}};
        default    : full_pstrb = {  1{1'b1}};
    endcase

    //generate masked address
    paddr_masked = paddr & address_mask(PDATA_SIZE);

    //create PSTRB
    pstrb = full_pstrb[PDATA_SIZE/8-1:0] << paddr_masked;
end
endfunction //pstrb


//////////////////////////////////////////////////////////////////
//
// Module Body
//

/*
* AHB Statemachine
*/
always @(posedge HCLK,negedge HRESETn) begin
    if (!HRESETn)
    begin
        ahb_fsm    <= ST_AHB_IDLE;

        HREADYOUT  <= 1'b1;
        HRESP      <= HRESP_OKAY;
        HRDATA     <=  'h0;

        ahb_treq   <= 1'b0;
        ahb_haddr  <=  'h0;
        ahb_hwrite <= 1'b0;
        ahb_hprot  <=  'h0;
        ahb_hsize  <=  'h0;
    end
    else
    begin
        ahb_treq <= 1'b0; //1 cycle strobe signal

        case (ahb_fsm)
            ST_AHB_IDLE:
            begin
                //store basic parameters
                ahb_haddr  <= HADDR;
                ahb_hwrite <= HWRITE;
                ahb_hprot  <= HPROT;
                ahb_hsize  <= HSIZE;

                if (HSEL && HREADY)
                begin
                    /*
                    * This (slave) is selected ... what kind of transfer is this?
                    */
                    case (HTRANS)
                        HTRANS_IDLE  : ahb_no_transfer;
                        HTRANS_BUSY  : ahb_no_transfer;
                        HTRANS_NONSEQ: ahb_prep_transfer;
                        HTRANS_SEQ   : ahb_prep_transfer;
                    endcase //HTRANS
                end
                else ahb_no_transfer;
            end

            ST_AHB_TRANSFER:
            if (ahb_tack_strb)
            begin
                /*
                * APB acknowledged transfer. Current transfer done
                * Check AHB bus to determine if another transfer is pending
                */

                //assign read data
                HRDATA <= apb_prdata; 

                //indicate transfer done. Normally HREADYOUT = '1', HRESP=OKAY
                //HRESP=ERROR requires 2 cycles
                if (apb_pslverr)
                begin
                    HREADYOUT <= 1'b0;
                    HRESP     <= HRESP_ERROR;
                    ahb_fsm   <= ST_AHB_ERROR;
                end
                else
                begin
                    HREADYOUT <= 1'b1;
                    HRESP     <= HRESP_OKAY;
                    ahb_fsm   <= ST_AHB_IDLE;
                end
            end
            else
            begin
                HREADYOUT <= 1'b0; //transfer still in progress
            end

            ST_AHB_ERROR:
            begin
                //2nd cycle of error response
                ahb_fsm   <= ST_AHB_IDLE;
                HREADYOUT <= 1'b1;
            end
        endcase //ahb_fsm
    end
end


always @(posedge HCLK)
    latch_ahb_hwdata <= HSEL & HREADY & HWRITE & ((HTRANS == HTRANS_NONSEQ) || (HTRANS == HTRANS_SEQ));

always @(posedge HCLK)
    if (latch_ahb_hwdata) ahb_hwdata <= HWDATA;



/*
* Clock domain crossing ...
*/
//AHB -> APB
always @(posedge HCLK,negedge HRESETn)
    if      (!HRESETn ) treq_toggle <= 1'b0;
    else if ( ahb_treq) treq_toggle <= ~treq_toggle;


always @(posedge PCLK,negedge PRESETn)
    if (!PRESETn) treq_sync <= 'h0;
    else          treq_sync <= {treq_sync[SYNC_DEPTH-2:0], treq_toggle};//~~


assign apb_treq_strb = treq_sync[SYNC_DEPTH-1] ^ treq_sync[SYNC_DEPTH-2];


//APB -> AHB
always @(posedge PCLK,negedge PRESETn)
    if      (!PRESETn ) tack_toggle <= 1'b0;
    else if ( apb_tack) tack_toggle <= ~tack_toggle;


always @(posedge HCLK,negedge HRESETn)
    if (!HRESETn) tack_sync <= 'h0;
    else          tack_sync <= {tack_sync[SYNC_DEPTH-2:0], tack_toggle};


assign ahb_tack_strb = tack_sync[SYNC_DEPTH-1] ^ tack_sync[SYNC_DEPTH-2];


/*
* APB Statemachine
*/
always @(posedge PCLK,negedge PRESETn) begin
    if (!PRESETn)
    begin
        apb_fsm              <= ST_APB_IDLE;
        apb_tack             <= 1'b0;
        apb_prdata           <=  'h0;
        apb_beat_cnt         <=  'h0;
        apb_beat_data_offset <=  'h0;
        apb_pslverr          <= 1'b0;

        PSEL                 <= 1'b0;
        PPROT                <= 1'b0;
        PADDR                <=  'h0;
        PWRITE               <= 1'b0;
        PENABLE              <= 1'b0;
        PWDATA               <=  'h0;
        PSTRB                <=  'h0;
    end
    else
    begin
        apb_tack <= 1'b0;

        case (apb_fsm)
            ST_APB_IDLE:
                if (apb_treq_strb)
                begin
                    apb_fsm              <= ST_APB_SETUP;

                    PSEL                 <= 1'b1;
                    PENABLE              <= 1'b0;
                    PPROT                <= ((ahb_hprot & HPROT_DATA      ) ? PPROT_DATA       : PPROT_INSTRUCTION) |
                                            ((ahb_hprot & HPROT_PRIVILEGED) ? PPROT_PRIVILEGED : PPROT_NORMAL     ); 
                    PADDR                <= ahb_haddr[PADDR_SIZE-1:0];
                    PWRITE               <= ahb_hwrite;
                    PWDATA               <= ahb_hwdata >> data_offset(ahb_haddr);
                    PSTRB                <= {PDATA_SIZE/8{ahb_hwrite}} & pstrb(ahb_hsize,ahb_haddr[PADDR_SIZE-1:0]);

                    apb_prdata           <= 'h0;                                   //clear prdata
                    apb_beat_cnt         <= apb_beats(ahb_hsize);
                    apb_beat_data_offset <= data_offset(ahb_haddr) + PDATA_SIZE;   //for the NEXT transfer
                end

            ST_APB_SETUP:
                begin
                    //retain all signals and assert PENABLE
                    apb_fsm <= ST_APB_TRANSFER;
                    PENABLE <= 1'b1;
                end

            ST_APB_TRANSFER:
                if (PREADY)
                begin
                    apb_beat_cnt         <= apb_beat_cnt -1;
                    apb_beat_data_offset <= apb_beat_data_offset + PDATA_SIZE;

                    apb_prdata           <= (apb_prdata << PDATA_SIZE) | (PRDATA << data_offset(ahb_haddr));//TODO: check/sim
                    apb_pslverr          <= PSLVERR;

                    PENABLE              <= 1'b0;

                    if (PSLVERR || ~|apb_beat_cnt)
                    begin
                        /*
                        * Transfer complete
                        * Go back to IDLE
                        * Signal AHB fsm, transfer complete
                        */
                        apb_fsm  <= ST_APB_IDLE;
                        apb_tack <= 1'b1;
                        PSEL     <= 1'b0;
                    end
                    else
                    begin
                        /*
                        * More beats in current transfer
                        * Setup next address and data
                        */
                        apb_fsm       <= ST_APB_SETUP;

                        PADDR  <= PADDR + (1 << PDATA_SIZE/8);
                        PWDATA <= ahb_hwdata >> apb_beat_data_offset;
                        PSTRB  <= {PDATA_SIZE/8{ahb_hwrite}} & pstrb(ahb_hsize,PADDR + (1 << ahb_hsize));
                    end
                end
        endcase
    end
end

endmodule