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
// Module:
//-----------------------------------------------------------------
module mem_mux 
( 
    // General
    clk_i, 
    rst_i, 
    
    // Input
    mem_addr_i, 
    mem_data_i, 
    mem_data_o, 
    mem_wr_i, 
    mem_rd_i,     
    mem_pause_o, 
    
    // Outputs
    out0_addr_o, 
    out0_data_o, 
    out0_data_i, 
    out0_wr_o, 
    out0_rd_o, 
    out0_pause_i, 
    
    out1_addr_o, 
    out1_data_o, 
    out1_data_i, 
    out1_wr_o, 
    out1_rd_o, 
    out1_pause_i, 
    
    out2_addr_o, 
    out2_data_o, 
    out2_data_i, 
    out2_wr_o, 
    out2_rd_o, 
    out2_pause_i, 
    
    out3_addr_o, 
    out3_data_o, 
    out3_data_i, 
    out3_wr_o, 
    out3_rd_o, 
    out3_pause_i,
    
    out4_addr_o, 
    out4_data_o, 
    out4_data_i, 
    out4_wr_o, 
    out4_rd_o, 
    out4_pause_i    
);

//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
parameter           BOOT_VECTOR         = 0;
    
//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------     
input               clk_i /*verilator public*/;
input               rst_i /*verilator public*/;
input [31:0]        mem_addr_i /*verilator public*/;
input [31:0]        mem_data_i /*verilator public*/;
output [31:0]       mem_data_o /*verilator public*/;
input [3:0]         mem_wr_i /*verilator public*/;
input               mem_rd_i /*verilator public*/;
output              mem_pause_o /*verilator public*/;
output [31:0]       out0_addr_o /*verilator public*/;
output [31:0]       out0_data_o /*verilator public*/;
input [31:0]        out0_data_i /*verilator public*/;
output [3:0]        out0_wr_o /*verilator public*/;
output              out0_rd_o /*verilator public*/;
input               out0_pause_i /*verilator public*/;
output [31:0]       out1_addr_o /*verilator public*/;
output [31:0]       out1_data_o /*verilator public*/;
input [31:0]        out1_data_i /*verilator public*/;
output [3:0]        out1_wr_o /*verilator public*/;
output              out1_rd_o /*verilator public*/;
input               out1_pause_i /*verilator public*/;
output [31:0]       out2_addr_o /*verilator public*/;
output [31:0]       out2_data_o /*verilator public*/;
input [31:0]        out2_data_i /*verilator public*/;
output [3:0]        out2_wr_o /*verilator public*/;
output              out2_rd_o /*verilator public*/;
input               out2_pause_i /*verilator public*/;
output [31:0]       out3_addr_o /*verilator public*/;
output [31:0]       out3_data_o /*verilator public*/;
input [31:0]        out3_data_i /*verilator public*/;
output [3:0]        out3_wr_o /*verilator public*/;
output              out3_rd_o /*verilator public*/;
input               out3_pause_i /*verilator public*/;
output [31:0]       out4_addr_o /*verilator public*/;
output [31:0]       out4_data_o /*verilator public*/;
input [31:0]        out4_data_i /*verilator public*/;
output [3:0]        out4_wr_o /*verilator public*/;
output              out4_rd_o /*verilator public*/;
input               out4_pause_i /*verilator public*/;

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
reg [2:0]           r_mem_sel;

// Output Signals
reg                 mem_pause_o;
reg [31:0]          mem_data_o;
reg [31:0]          out0_addr_o;
reg [31:0]          out0_data_o;
reg [3:0]           out0_wr_o;
reg                 out0_rd_o;
reg [31:0]          out1_addr_o;
reg [31:0]          out1_data_o;
reg [3:0]           out1_wr_o;
reg                 out1_rd_o;
reg [31:0]          out2_addr_o;
reg [31:0]          out2_data_o;
reg [3:0]           out2_wr_o;
reg                 out2_rd_o;
reg [31:0]          out3_addr_o;
reg [31:0]          out3_data_o;
reg [3:0]           out3_wr_o;
reg                 out3_rd_o;
reg [31:0]          out4_addr_o;
reg [31:0]          out4_data_o;
reg [3:0]           out4_wr_o;
reg                 out4_rd_o;

//-----------------------------------------------------------------
// Memory Map
//-----------------------------------------------------------------   
always @ (mem_addr_i or mem_wr_i or mem_rd_i or mem_data_i )
begin 
   case (mem_addr_i[30:28])
   
   3'b000 : 
   begin 
       out0_addr_o      = mem_addr_i;
       out0_wr_o        = mem_wr_i;
       out0_rd_o        = mem_rd_i;
       out0_data_o      = mem_data_i;
       
       out1_addr_o      = 32'h00000000;
       out1_wr_o        = 4'b0000;
       out1_rd_o        = 1'b0;
       out1_data_o      = 32'h00000000;       
       
       out2_addr_o      = 32'h00000000;
       out2_wr_o        = 4'b0000;
       out2_rd_o        = 1'b0;
       out2_data_o      = 32'h00000000;
       
       out3_addr_o      = 32'h00000000;
       out3_wr_o        = 4'b0000;
       out3_rd_o        = 1'b0;
       out3_data_o      = 32'h00000000;
       
       out4_addr_o      = 32'h00000000;
       out4_wr_o        = 4'b0000;
       out4_rd_o        = 1'b0;
       out4_data_o      = 32'h00000000;       
   end
   
   3'b001 : 
   begin 
       out0_addr_o      = 32'h00000000;
       out0_wr_o        = 4'b0000;
       out0_rd_o        = 1'b0;
       out0_data_o      = 32'h00000000;
       
       out1_addr_o      = mem_addr_i;
       out1_wr_o        = mem_wr_i;
       out1_rd_o        = mem_rd_i;
       out1_data_o      = mem_data_i;       
       
       out2_addr_o      = 32'h00000000;
       out2_wr_o        = 4'b0000;
       out2_rd_o        = 1'b0;
       out2_data_o      = 32'h00000000;
       
       out3_addr_o      = 32'h00000000;
       out3_wr_o        = 4'b0000;
       out3_rd_o        = 1'b0;
       out3_data_o      = 32'h00000000;
       
       out4_addr_o      = 32'h00000000;
       out4_wr_o        = 4'b0000;
       out4_rd_o        = 1'b0;
       out4_data_o      = 32'h00000000;         
   end
       
   3'b010 : 
   begin 
       out0_addr_o      = 32'h00000000;
       out0_wr_o        = 4'b0000;
       out0_rd_o        = 1'b0;
       out0_data_o      = 32'h00000000;
       
       out1_addr_o      = 32'h00000000;
       out1_wr_o        = 4'b0000;
       out1_rd_o        = 1'b0;
       out1_data_o      = 32'h00000000;       
       
       out2_addr_o      = mem_addr_i;
       out2_wr_o        = mem_wr_i;
       out2_rd_o        = mem_rd_i;
       out2_data_o      = mem_data_i;
       
       out3_addr_o      = 32'h00000000;
       out3_wr_o        = 4'b0000;
       out3_rd_o        = 1'b0;
       out3_data_o      = 32'h00000000;
       
       out4_addr_o      = 32'h00000000;
       out4_wr_o        = 4'b0000;
       out4_rd_o        = 1'b0;
       out4_data_o      = 32'h00000000;         
   end
   
   3'b011 : 
   begin 
       out0_addr_o      = 32'h00000000;
       out0_wr_o        = 4'b0000;
       out0_rd_o        = 1'b0;
       out0_data_o      = 32'h00000000;
       
       out1_addr_o      = 32'h00000000;
       out1_wr_o        = 4'b0000;
       out1_rd_o        = 1'b0;
       out1_data_o      = 32'h00000000;       
       
       out2_addr_o      = 32'h00000000;
       out2_wr_o        = 4'b0000;
       out2_rd_o        = 1'b0;
       out2_data_o      = 32'h00000000;
       
       out3_addr_o      = mem_addr_i;
       out3_wr_o        = mem_wr_i;
       out3_rd_o        = mem_rd_i;
       out3_data_o      = mem_data_i;
       
       out4_addr_o      = 32'h00000000;
       out4_wr_o        = 4'b0000;
       out4_rd_o        = 1'b0;
       out4_data_o      = 32'h00000000;         
   end
   
   3'b100 : 
   begin 
       out0_addr_o      = 32'h00000000;
       out0_wr_o        = 4'b0000;
       out0_rd_o        = 1'b0;
       out0_data_o      = 32'h00000000;
       
       out1_addr_o      = 32'h00000000;
       out1_wr_o        = 4'b0000;
       out1_rd_o        = 1'b0;
       out1_data_o      = 32'h00000000;       
       
       out2_addr_o      = 32'h00000000;
       out2_wr_o        = 4'b0000;
       out2_rd_o        = 1'b0;
       out2_data_o      = 32'h00000000;
       
       out3_addr_o      = 32'h00000000;
       out3_wr_o        = 4'b0000;
       out3_rd_o        = 1'b0;
       out3_data_o      = 32'h00000000;
       
       out4_addr_o      = mem_addr_i;
       out4_wr_o        = mem_wr_i;
       out4_rd_o        = mem_rd_i;
       out4_data_o      = mem_data_i;       
   end   
   
   default : 
   begin 
       out0_addr_o      = 32'h00000000;
       out0_wr_o        = 4'b0000;
       out0_rd_o        = 1'b0;
       out0_data_o      = 32'h00000000;
       
       out1_addr_o      = 32'h00000000;
       out1_wr_o        = 4'b0000;
       out1_rd_o        = 1'b0;
       out1_data_o      = 32'h00000000;       
       
       out2_addr_o      = 32'h00000000;
       out2_wr_o        = 4'b0000;
       out2_rd_o        = 1'b0;
       out2_data_o      = 32'h00000000;
       
       out3_addr_o      = 32'h00000000;
       out3_wr_o        = 4'b0000;
       out3_rd_o        = 1'b0;
       out3_data_o      = 32'h00000000;
       
       out4_addr_o      = 32'h00000000;
       out4_wr_o        = 4'b0000;
       out4_rd_o        = 1'b0;
       out4_data_o      = 32'h00000000;         
   end
   endcase
end
   
//-----------------------------------------------------------------
// Read Port
//-----------------------------------------------------------------   
always @ ( r_mem_sel or 
            out0_data_i or out0_pause_i or 
            out1_data_i or out1_pause_i or 
            out2_data_i or out2_pause_i or 
            out3_data_i or out3_pause_i or 
            out4_data_i or out4_pause_i )
begin 
   case (r_mem_sel)
   
   3'b000 : 
   begin 
       mem_data_o   = out0_data_i;
       mem_pause_o  = out0_pause_i;
   end
   
   3'b001 : 
   begin 
       mem_data_o   = out1_data_i;
       mem_pause_o  = out1_pause_i;
   end
   
   3'b010 : 
   begin 
       mem_data_o   = out2_data_i;
       mem_pause_o  = out2_pause_i;
   end
   
   3'b011 : 
   begin 
       mem_data_o   = out3_data_i;
       mem_pause_o  = out3_pause_i;
   end
   
   3'b100 : 
   begin 
       mem_data_o   = out4_data_i;
       mem_pause_o  = out4_pause_i;
   end   
   
   default : 
   begin 
       mem_data_o   = 32'h00000000;
       mem_pause_o  = 1'b0;
   end
   endcase
end
   
//-----------------------------------------------------------------
// Registered device select
//----------------------------------------------------------------- 
reg [31:0] v_mem_sel;
  
always @ (posedge clk_i or posedge rst_i )
begin
   if (rst_i == 1'b1)
   begin 
       v_mem_sel = BOOT_VECTOR;
       r_mem_sel <= v_mem_sel[30:28];
   end
   else 
       r_mem_sel <= mem_addr_i[30:28];
end
   
endmodule
