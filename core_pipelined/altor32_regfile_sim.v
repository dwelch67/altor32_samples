//-----------------------------------------------------------------
//                           AltOR32 
//              Alternative Lightweight OpenRisc 
//                            V0.1
//                     Ultra-Embedded.com
//                   Copyright 2011 - 2012
//
//               Email: admin@ultra-embedded.com
//
//                       License: LGPL
//
// If you would like a version with a different license for use 
// in commercial projects please contact the above email address 
// for more details.
//-----------------------------------------------------------------
//
// Copyright (C) 2011 - 2012 Ultra-Embedded.com
//
// This source file may be used and distributed without         
// restriction provided that this copyright statement is not    
// removed from the file and that any derivative work contains  
// the original copyright notice and the associated disclaimer. 
//
// This source file is free software; you can redistribute it   
// and/or modify it under the terms of the GNU Lesser General   
// Public License as published by the Free Software Foundation; 
// either version 2.1 of the License, or (at your option) any   
// later version.                                               
//
// This source is distributed in the hope that it will be       
// useful, but WITHOUT ANY WARRANTY; without even the implied   
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      
// PURPOSE.  See the GNU Lesser General Public License for more 
// details.                                                     
//
// You should have received a copy of the GNU Lesser General    
// Public License along with this source; if not, write to the 
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, 
// Boston, MA  02111-1307  USA              
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "altor32_defs.v"

//-----------------------------------------------------------------
// Module
//-----------------------------------------------------------------
module altor32_regfile_sim 
( 
    clk_i, 
    rst_i, 
    en_i, 
    wr_i, 
    rs_i, 
    rt_i, 
    rd_i, 
    reg_rs_o, 
    reg_rt_o, 
    reg_rd_i 
);

//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------
input           clk_i               /*verilator public*/;
input           rst_i               /*verilator public*/;
input           en_i                /*verilator public*/;
input           wr_i                /*verilator public*/;
input [4:0]     rs_i                /*verilator public*/;
input [4:0]     rt_i                /*verilator public*/;
input [4:0]     rd_i                /*verilator public*/;
output [31:0]   reg_rs_o            /*verilator public*/;
output [31:0]   reg_rt_o            /*verilator public*/;
input [31:0]    reg_rd_i            /*verilator public*/;

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------

// Register file
reg [31:0] reg_r1_sp;
reg [31:0] reg_r2_fp;
reg [31:0] reg_r3;
reg [31:0] reg_r4;
reg [31:0] reg_r5;
reg [31:0] reg_r6;
reg [31:0] reg_r7;
reg [31:0] reg_r8;
reg [31:0] reg_r9_lr;
reg [31:0] reg_r10;
reg [31:0] reg_r11;
reg [31:0] reg_r12;
reg [31:0] reg_r13;
reg [31:0] reg_r14;
reg [31:0] reg_r15;
reg [31:0] reg_r16;
reg [31:0] reg_r17;
reg [31:0] reg_r18;
reg [31:0] reg_r19;
reg [31:0] reg_r20;
reg [31:0] reg_r21;
reg [31:0] reg_r22;
reg [31:0] reg_r23;
reg [31:0] reg_r24;
reg [31:0] reg_r25;
reg [31:0] reg_r26;
reg [31:0] reg_r27;
reg [31:0] reg_r28;
reg [31:0] reg_r29;
reg [31:0] reg_r30;
reg [31:0] reg_r31;

reg [31:0] reg_rs_o;
reg [31:0] reg_rt_o;    
    
//-----------------------------------------------------------------
// Register File (for simulation)
//-----------------------------------------------------------------    

// Synchronous register write back
always @ (posedge clk_i or posedge rst_i) 
begin 
   if (rst_i) 
   begin 
        reg_r1_sp <= 32'h00000000;
        reg_r2_fp <= 32'h00000000;
        reg_r3 <= 32'h00000000;
        reg_r4 <= 32'h00000000;
        reg_r5 <= 32'h00000000;
        reg_r6 <= 32'h00000000;
        reg_r7 <= 32'h00000000;
        reg_r8 <= 32'h00000000;
        reg_r9_lr <= 32'h00000000;
        reg_r10 <= 32'h00000000;
        reg_r11 <= 32'h00000000;
        reg_r12 <= 32'h00000000;
        reg_r13 <= 32'h00000000;
        reg_r14 <= 32'h00000000;
        reg_r15 <= 32'h00000000;
        reg_r16 <= 32'h00000000;
        reg_r17 <= 32'h00000000;
        reg_r18 <= 32'h00000000;
        reg_r19 <= 32'h00000000;
        reg_r20 <= 32'h00000000;
        reg_r21 <= 32'h00000000;
        reg_r22 <= 32'h00000000;
        reg_r23 <= 32'h00000000;
        reg_r24 <= 32'h00000000;
        reg_r25 <= 32'h00000000;
        reg_r26 <= 32'h00000000;
        reg_r27 <= 32'h00000000;
        reg_r28 <= 32'h00000000;
        reg_r29 <= 32'h00000000;
        reg_r30 <= 32'h00000000;
        reg_r31 <= 32'h00000000;
   end
   else if (en_i == 1'b1)
   begin 
       if (wr_i == 1'b1) 
           case (rd_i[4:0])
               5'b00001 : 
                       reg_r1_sp <= reg_rd_i;
               5'b00010 : 
                       reg_r2_fp <= reg_rd_i;
               5'b00011 : 
                       reg_r3 <= reg_rd_i;
               5'b00100 : 
                       reg_r4 <= reg_rd_i;
               5'b00101 : 
                       reg_r5 <= reg_rd_i;
               5'b00110 : 
                       reg_r6 <= reg_rd_i;
               5'b00111 : 
                       reg_r7 <= reg_rd_i;
               5'b01000 : 
                       reg_r8 <= reg_rd_i;
               5'b01001 : 
                       reg_r9_lr <= reg_rd_i;
               5'b01010 : 
                       reg_r10 <= reg_rd_i;
               5'b01011 : 
                       reg_r11 <= reg_rd_i;
               5'b01100 : 
                       reg_r12 <= reg_rd_i;
               5'b01101 : 
                       reg_r13 <= reg_rd_i;
               5'b01110 : 
                       reg_r14 <= reg_rd_i;
               5'b01111 : 
                       reg_r15 <= reg_rd_i;
               5'b10000 : 
                       reg_r16 <= reg_rd_i;
               5'b10001 : 
                       reg_r17 <= reg_rd_i;
               5'b10010 : 
                       reg_r18 <= reg_rd_i;
               5'b10011 : 
                       reg_r19 <= reg_rd_i;
               5'b10100 : 
                       reg_r20 <= reg_rd_i;
               5'b10101 : 
                       reg_r21 <= reg_rd_i;
               5'b10110 : 
                       reg_r22 <= reg_rd_i;
               5'b10111 : 
                       reg_r23 <= reg_rd_i;
               5'b11000 : 
                       reg_r24 <= reg_rd_i;
               5'b11001 : 
                       reg_r25 <= reg_rd_i;
               5'b11010 : 
                       reg_r26 <= reg_rd_i;
               5'b11011 : 
                       reg_r27 <= reg_rd_i;
               5'b11100 : 
                       reg_r28 <= reg_rd_i;
               5'b11101 : 
                       reg_r29 <= reg_rd_i;
               5'b11110 : 
                       reg_r30 <= reg_rd_i;
               5'b11111 : 
                       reg_r31 <= reg_rd_i;
               default : 
                   ;
           endcase
   end 
end

// Asynchronous Register read (Rs & Rd)       
always @ (rs_i or rt_i or reg_r1_sp or reg_r2_fp or reg_r3 or reg_r4 or reg_r5 or reg_r6 or reg_r7 or reg_r8 or reg_r9_lr or reg_r10 or reg_r11 or reg_r12 or reg_r13 or reg_r14 or reg_r15 or reg_r16 or reg_r17 or reg_r18 or reg_r19 or reg_r20 or reg_r21 or reg_r22 or reg_r23 or reg_r24 or reg_r25 or reg_r26 or reg_r27 or reg_r28 or reg_r29 or reg_r30 or reg_r31 )
begin 
   case (rs_i)
       5'b00000 : 
               reg_rs_o = 32'h00000000;
       5'b00001 : 
               reg_rs_o = reg_r1_sp;
       5'b00010 : 
               reg_rs_o = reg_r2_fp;
       5'b00011 : 
               reg_rs_o = reg_r3;
       5'b00100 : 
               reg_rs_o = reg_r4;
       5'b00101 : 
               reg_rs_o = reg_r5;
       5'b00110 : 
               reg_rs_o = reg_r6;
       5'b00111 : 
               reg_rs_o = reg_r7;
       5'b01000 : 
               reg_rs_o = reg_r8;
       5'b01001 : 
               reg_rs_o = reg_r9_lr;
       5'b01010 : 
               reg_rs_o = reg_r10;
       5'b01011 : 
               reg_rs_o = reg_r11;
       5'b01100 : 
               reg_rs_o = reg_r12;
       5'b01101 : 
               reg_rs_o = reg_r13;
       5'b01110 : 
               reg_rs_o = reg_r14;
       5'b01111 : 
               reg_rs_o = reg_r15;
       5'b10000 : 
               reg_rs_o = reg_r16;
       5'b10001 : 
               reg_rs_o = reg_r17;
       5'b10010 : 
               reg_rs_o = reg_r18;
       5'b10011 : 
               reg_rs_o = reg_r19;
       5'b10100 : 
               reg_rs_o = reg_r20;
       5'b10101 : 
               reg_rs_o = reg_r21;
       5'b10110 : 
               reg_rs_o = reg_r22;
       5'b10111 : 
               reg_rs_o = reg_r23;
       5'b11000 : 
               reg_rs_o = reg_r24;
       5'b11001 : 
               reg_rs_o = reg_r25;
       5'b11010 : 
               reg_rs_o = reg_r26;
       5'b11011 : 
               reg_rs_o = reg_r27;
       5'b11100 : 
               reg_rs_o = reg_r28;
       5'b11101 : 
               reg_rs_o = reg_r29;
       5'b11110 : 
               reg_rs_o = reg_r30;
       5'b11111 : 
               reg_rs_o = reg_r31;
       default : 
               reg_rs_o = 32'h00000000;
   endcase
   
   case (rt_i)
       5'b00000 : 
               reg_rt_o = 32'h00000000;
       5'b00001 : 
               reg_rt_o = reg_r1_sp;
       5'b00010 : 
               reg_rt_o = reg_r2_fp;
       5'b00011 : 
               reg_rt_o = reg_r3;
       5'b00100 : 
               reg_rt_o = reg_r4;
       5'b00101 : 
               reg_rt_o = reg_r5;
       5'b00110 : 
               reg_rt_o = reg_r6;
       5'b00111 : 
               reg_rt_o = reg_r7;
       5'b01000 : 
               reg_rt_o = reg_r8;
       5'b01001 : 
               reg_rt_o = reg_r9_lr;
       5'b01010 : 
               reg_rt_o = reg_r10;
       5'b01011 : 
               reg_rt_o = reg_r11;
       5'b01100 : 
               reg_rt_o = reg_r12;
       5'b01101 : 
               reg_rt_o = reg_r13;
       5'b01110 : 
               reg_rt_o = reg_r14;
       5'b01111 : 
               reg_rt_o = reg_r15;
       5'b10000 : 
               reg_rt_o = reg_r16;
       5'b10001 : 
               reg_rt_o = reg_r17;
       5'b10010 : 
               reg_rt_o = reg_r18;
       5'b10011 : 
               reg_rt_o = reg_r19;
       5'b10100 : 
               reg_rt_o = reg_r20;
       5'b10101 : 
               reg_rt_o = reg_r21;
       5'b10110 : 
               reg_rt_o = reg_r22;
       5'b10111 : 
               reg_rt_o = reg_r23;
       5'b11000 : 
               reg_rt_o = reg_r24;
       5'b11001 : 
               reg_rt_o = reg_r25;
       5'b11010 : 
               reg_rt_o = reg_r26;
       5'b11011 : 
               reg_rt_o = reg_r27;
       5'b11100 : 
               reg_rt_o = reg_r28;
       5'b11101 : 
               reg_rt_o = reg_r29;
       5'b11110 : 
               reg_rt_o = reg_r30;
       5'b11111 : 
               reg_rt_o = reg_r31;
       default : 
               reg_rt_o = 32'h00000000;
   endcase
end 

endmodule
