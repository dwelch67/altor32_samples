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
`include "uart_defs.v"

//-----------------------------------------------------------------
// Module:
//-----------------------------------------------------------------
module uart_periph
( 
    // General - Clocking & Reset
    clk_i, 
    rst_i, 
    intr_o,
    
    // UART
    tx_o, 
    rx_i, 
    
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
parameter  [31:0]   UART_DIVISOR        = 1;
    
//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------     
input               clk_i /*verilator public*/;
input               rst_i /*verilator public*/;
output              intr_o /*verilator public*/;

output              tx_o /*verilator public*/;
input               rx_i /*verilator public*/;

input [7:0]         addr_i /*verilator public*/;
output [31:0]       data_o /*verilator public*/;
input [31:0]        data_i /*verilator public*/;
input [3:0]         wr_i /*verilator public*/;
input               rd_i /*verilator public*/;

//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
reg [31:0]          data_o;

// UART
reg [7:0]           uart_tx_data;
wire [7:0]          uart_rx_data;
reg                 uart_wr;
reg                 uart_rd;
wire                uart_tx_busy;
wire                uart_rx_avail;

//-----------------------------------------------------------------
// Instantiation
//-----------------------------------------------------------------  

// UART
uart  
#(
    .UART_DIVISOR(UART_DIVISOR)
) 
u1_uart
(
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    .data_i(uart_tx_data), 
    .data_o(uart_rx_data), 
    .wr_i(uart_wr), 
    .rd_i(uart_rd), 
    .tx_busy_o(uart_tx_busy), 
    .rx_ready_o(uart_rx_avail), 
    .rxd_i(rx_i), 
    .txd_o(tx_o)
);

//-----------------------------------------------------------------
// Peripheral Register Write
//-----------------------------------------------------------------   
always @ (posedge rst_i or posedge clk_i )
begin 
   if (rst_i == 1'b1) 
   begin 
       uart_tx_data     <= 8'h00;
       uart_wr          <= 1'b0;
   end
   else 
   begin 
   
       uart_wr            <= 1'b0;
       
       // Write Cycle
       if (wr_i != 4'b0000)
       begin
           case (addr_i)
           
           `UART_UDR : 
           begin 
               uart_tx_data <= data_i[7:0];
               uart_wr <= 1'b1;
           end
                  
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
       uart_rd      <= 1'b0;
   end
   else 
   begin 
       uart_rd <= 1'b0;
       
       // Read cycle?
       if (rd_i == 1'b1)
       begin
           case (addr_i[7:0])
                
           `UART_USR : 
                data_o <= {27'h0000000, 1'b0, uart_tx_busy, 1'b0, 1'b0, uart_rx_avail};
                
           `UART_UDR : 
           begin 
               data_o <= {24'h000000,uart_rx_data};
               uart_rd <= 1'b1;
           end
             
           default : 
                data_o <= 32'h00000000;
           endcase
        end
   end
end
      
//-----------------------------------------------------------------
// Combinatorial Logic
//-----------------------------------------------------------------     
assign intr_o      = uart_rx_avail;

endmodule
