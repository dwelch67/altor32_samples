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
`include "timer_defs.v"

//-----------------------------------------------------------------
// Module:
//-----------------------------------------------------------------
module timer_periph
( 
    // General - Clocking & Reset
    clk_i, 
    rst_i, 
    
    // Interrupts
    intr_systick_o,
    intr_hires_o,
    
    // Peripheral bus
    addr_i, 
    data_o, 
    data_i, 
    wr_i, 
    rd_i
);

//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
parameter  [31:0]   CLK_KHZ             = 12288;
    
//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------     
input               clk_i /*verilator public*/;
input               rst_i /*verilator public*/;

output              intr_systick_o /*verilator public*/;
output              intr_hires_o /*verilator public*/;

input [7:0]         addr_i /*verilator public*/;
output [31:0]       data_o /*verilator public*/;
input [31:0]        data_i /*verilator public*/;
input [3:0]         wr_i /*verilator public*/;
input               rd_i /*verilator public*/;

//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------

reg [31:0]          data_o;

// Systick Timer
reg                 systick_intr;
reg [31:0]          systick_count;
reg [31:0]          systick_clk_count;

// Hi-res system clock tick counter
reg                 hr_timer_intr;
reg [31:0]          hr_timer_cnt;
reg [31:0]          hr_timer_match;

//-----------------------------------------------------------------
// Implementation
//-----------------------------------------------------------------  

// SysTick Timer (1 ms resolution)
always @ (posedge rst_i or posedge clk_i )
begin 
   if (rst_i == 1'b1) 
   begin 
       systick_count        <= 32'h00000000;
       systick_clk_count    <= 32'h00000000;
       systick_intr         <= 1'b0;
   end
   else 
   begin 
       systick_intr         <= 1'b0;
       
       if (systick_clk_count == CLK_KHZ) 
       begin 
           systick_count     <= (systick_count + 1);
           systick_intr      <= 1'b1;
           systick_clk_count <= 32'h00000000;
       end
       else 
           systick_clk_count <= (systick_clk_count + 1);
   end
end

//-----------------------------------------------------------------
// Peripheral Register Write
//-----------------------------------------------------------------   
always @ (posedge rst_i or posedge clk_i )
begin 
   if (rst_i == 1'b1) 
   begin 
       hr_timer_cnt     <= 32'h00000000;
       hr_timer_match   <= 32'h00000000;
       hr_timer_intr    <= 1'b0;
   end
   else 
   begin 
   
       hr_timer_intr <= 1'b0;
   
       // Clock tick counter
       hr_timer_cnt <= (hr_timer_cnt + 1);
       
       // Hi-res Timer IRQ
       if ((hr_timer_match != 32'h00000000) && (hr_timer_match == hr_timer_cnt))
           hr_timer_intr <= 1'b1;
       
       // Write Cycle
       if (wr_i != 4'b0000)
       begin
           case (addr_i)
           
           `TIMER_HIRES : 
                hr_timer_match <= data_i;
                  
           default : 
               ;
           endcase
        end
   end
end

//-----------------------------------------------------------------
// Peripheral Register Read
//----------------------------------------------------------------- 
always @ (posedge rst_i or posedge clk_i )
begin 
   if (rst_i == 1'b1) 
   begin 
       data_o       <= 32'h00000000;
   end
   else 
   begin 
       // Read cycle?
       if (rd_i == 1'b1)
       begin
           case (addr_i[7:0])
                
           // 32-bit systick/1ms counter
           `TIMER_SYSTICK_VAL :
                data_o <= systick_count;
                
           // Hi res timer (clock rate)
           `TIMER_HIRES : 
                data_o <= hr_timer_cnt;
             
           default : 
                data_o <= 32'h00000000;
           endcase
        end
   end
end
      
//-----------------------------------------------------------------
// Combinatorial Logic
//-----------------------------------------------------------------     
assign intr_systick_o      = systick_intr;
assign intr_hires_o        = hr_timer_intr;

endmodule
