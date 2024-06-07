//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2010-2013 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-15 17:00:07 +0100 (Mon, 15 Apr 2013) $
//
//      Revision            : $Revision: 244029 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-00rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : APB slave multiplex
//-----------------------------------------------------------------------------
module cmsdk_apb_slave_mux
 (
// --------------------------------------------------------------------------
// Port Definitions
// --------------------------------------------------------------------------

  input  wire         PSEL0,
  input  wire         PREADY0,
  input  wire [31:0]  PRDATA0,
  input  wire         PSLVERR0,

  input  wire         PSEL1,
  input  wire         PREADY1,
  input  wire [31:0]  PRDATA1,
  input  wire         PSLVERR1,

  input  wire         PSEL2,
  input  wire         PREADY2,
  input  wire [31:0]  PRDATA2,
  input  wire         PSLVERR2,
  
  input  wire         PSEL3,
  input  wire         PREADY3,
  input  wire [31:0]  PRDATA3,
  input  wire         PSLVERR3,

  input  wire         PSEL4,
  input  wire         PREADY4,
  input  wire [31:0]  PRDATA4,
  input  wire         PSLVERR4,

  output wire         PREADY,
  output wire [31:0]  PRDATA,
  output wire         PSLVERR);

  // --------------------------------------------------------------------------
  // Start of main code
  // --------------------------------------------------------------------------

 

  assign PREADY  = (~PSEL0 & ~PSEL1  & ~PSEL2  & ~PSEL3 & ~PSEL4  ) |
                   ((PREADY0  && PSEL0) ) |
                   ((PREADY1  && PSEL1) ) |
                   ((PREADY2  && PSEL2) ) |
                   ((PREADY3  && PSEL3) ) |
                   ((PREADY4  && PSEL4) ) ;
                

  assign PSLVERR = ( PSEL0  & PSLVERR0  ) |
                   ( PSEL1  & PSLVERR1  ) |
                   ( PSEL2  & PSLVERR2  ) |
                   ( PSEL3  & PSLVERR3  ) |
                   ( PSEL4  & PSLVERR4  );
                

  assign PRDATA  = ( {32{PSEL0 }} & PRDATA0  ) |
                   ( {32{PSEL1 }} & PRDATA1  ) |
                   ( {32{PSEL2 }} & PRDATA2  ) |
                   ( {32{PSEL3 }} & PRDATA3  ) |
                   ( {32{PSEL4 }} & PRDATA4  );
                  

endmodule
