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
// Module
//-----------------------------------------------------------------
module spi_master 
(
    // Clocking & Reset 
    clk_i, 
    rst_i, 
    // Control & Status
    start_i, 
    done_o, 
    busy_o, 
    // Data
    data_i, 
    data_o,
    // SPI Bus 
    spi_clk_o, 
    spi_ss_o, 
    spi_mosi_o, 
    spi_miso_i 
);

//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
parameter  [31:0]               CLK_DIV = 32;
parameter  [31:0]               TRANSFER_WIDTH = 8;
    
//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------      
input                           clk_i /*verilator public*/;
input                           rst_i /*verilator public*/;
input                           start_i /*verilator public*/;
output                          done_o /*verilator public*/;
output                          busy_o /*verilator public*/;
input [(TRANSFER_WIDTH - 1):0]  data_i /*verilator public*/;
output [(TRANSFER_WIDTH - 1):0] data_o /*verilator public*/;
output                          spi_clk_o /*verilator public*/;
output                          spi_ss_o /*verilator public*/;
output                          spi_mosi_o /*verilator public*/;
input                           spi_miso_i /*verilator public*/;

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
reg                             running;
integer                         cycle_count;
reg [(TRANSFER_WIDTH - 1):0]    shift_reg;
reg                             spi_clk_gen;
reg                             last_clk_gen;
integer                         clk_div_count;
reg                             done_o;
reg                             spi_ss_o;
reg                             spi_clk_o;

//-----------------------------------------------------------------
// Implementation
//-----------------------------------------------------------------   

// SPI Clock Generator 
always @ (posedge clk_i or posedge rst_i ) 
begin 
   // Async Reset  
   if (rst_i == 1'b1)
   begin 
       clk_div_count    <= 0;
       spi_clk_gen      <= 1'b0;
   end
   else
   begin
       // SPI transfer active?
       if (running == 1'b1)
       begin 
           // Clock divider cycle_count matched?
           if (clk_div_count == (CLK_DIV - 1)) 
           begin 
               // Toggle clock (input to SPI transfer process)
               spi_clk_gen   <= ~(spi_clk_gen);
               
               // Reset counter
               clk_div_count <= 0;
           end
           // Increment SPI clock divider counter
           else
                clk_div_count <= (clk_div_count + 1);
       end 
       else // (!running)
           spi_clk_gen <= 1'b0;
    end
end

// SPI transfer process
always @ (posedge clk_i or posedge rst_i )
begin 
   // Async Reset  
   if (rst_i == 1'b1)
   begin 
       cycle_count  <= 0;
       shift_reg    <= {(TRANSFER_WIDTH - 0){1'b0}};
       last_clk_gen <= 1'b0;
       spi_clk_o    <= 1'b0;
       running      <= 1'b0;
       done_o       <= 1'b0;
       spi_ss_o     <= 1'b0;
   end
   else 
   begin 
   
       // Update previous SCLK value
       last_clk_gen <= spi_clk_gen;
       
       done_o <= 1'b0;
       
       //-------------------------------
       // SPI = IDLE
       //-------------------------------
       if (running == 1'b0)
       begin 
           // Wait until start_i = 1 to start_i transfer
           if (start_i == 1'b1)
           begin 
               cycle_count  <= 0;
               shift_reg    <= data_i;
               running      <= 1'b1;
               spi_ss_o     <= 1'b1;
           end
       end
       else
       //-------------------------------
       // SPI = RUNNING
       //-------------------------------
       begin
           // SCLK 1->0 - Falling Edge
           if ((last_clk_gen == 1'b1) && (spi_clk_gen == 1'b0))
           begin 
               // SCLK_OUT = L
               spi_clk_o <= 1'b0;
               
               // Increment cycle counter
               cycle_count <= (cycle_count + 1);
               
               // Shift left & add MISO to LSB
               shift_reg <= {shift_reg[(TRANSFER_WIDTH - 2):0],spi_miso_i};
               
               // End of SPI transfer reached
               if (cycle_count == (TRANSFER_WIDTH - 1))
               begin 
                   // Go back to IDLE running
                   running  <= 1'b0;
                   
                   // Set transfer complete flags
                   done_o   <= 1'b1;
                   spi_ss_o <= 1'b0;
               end
           end
           // SCLK 0->1 - Rising Edge
           else if ((last_clk_gen == 1'b0) & (spi_clk_gen == 1'b1)) 
           begin
               // SCLK_OUT = H
               spi_clk_o <= 1'b1;
           end
       end
   end
end
   
//-----------------------------------------------------------------
// Combinatorial Logic
//-----------------------------------------------------------------  
assign spi_mosi_o    = shift_reg[(TRANSFER_WIDTH - 1)];
assign data_o        = shift_reg;
assign busy_o        = ((running == 1'b1) || (start_i == 1'b1)) ? 1'b1 : 1'b0;

endmodule
