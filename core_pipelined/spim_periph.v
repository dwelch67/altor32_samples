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
`include "spim_defs.v"

//-----------------------------------------------------------------
// Module:
//-----------------------------------------------------------------
module spim_periph
( 
    // General - Clocking & Reset
    clk_i, 
    rst_i, 
    intr_o,
    
    // SPI Bus 
    spi_clk_o, 
    spi_ss_o, 
    spi_mosi_o, 
    spi_miso_i,
        
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
parameter  [31:0]   CLK_DIV = 32;
    
//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------     
input               clk_i /*verilator public*/;
input               rst_i /*verilator public*/;
output              intr_o /*verilator public*/;

output              spi_clk_o /*verilator public*/;
output              spi_ss_o /*verilator public*/;
output              spi_mosi_o /*verilator public*/;
input               spi_miso_i /*verilator public*/;

input [7:0]         addr_i /*verilator public*/;
output [31:0]       data_o /*verilator public*/;
input [31:0]        data_i /*verilator public*/;
input [3:0]         wr_i /*verilator public*/;
input               rd_i /*verilator public*/;


//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
reg [31:0]          data_o;
reg                 spi_ss_o;
reg                 spi_start;
wire                spi_busy;
reg [7:0]           spi_data_wr;
wire [7:0]          spi_data_rd;

//-----------------------------------------------------------------
// Instantiation
//-----------------------------------------------------------------  

// SPI Master
spi_master  
#(
    .CLK_DIV(CLK_DIV),
    .TRANSFER_WIDTH(8)
) 
u1_spi_master
(
    // Clocking / Reset
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    // Control & Status
    .start_i(spi_start), 
    .done_o(intr_o), 
    .busy_o(spi_busy), 
    // Data
    .data_i(spi_data_wr), 
    .data_o(spi_data_rd), 
    // SPI interface
    .spi_clk_o(spi_clk_o), 
    .spi_ss_o(/*open */), 
    .spi_mosi_o(spi_mosi_o), 
    .spi_miso_i(spi_miso_i)
);

//-----------------------------------------------------------------
// Peripheral Register Write
//-----------------------------------------------------------------   
always @ (posedge rst_i or posedge clk_i )
begin 
   if (rst_i == 1'b1) 
   begin 
       spi_ss_o     <= 1'b1;
       spi_start    <= 1'b0;
       spi_data_wr  <= 8'h00;
   end
   else 
   begin 
   
       spi_start    <= 1'b0;
       
       // Write Cycle
       if (wr_i != 4'b0000)
       begin
           case (addr_i)
           
           `SPI_MASTER_CTRL : 
           begin 
               spi_ss_o <= data_i[0];
           end
           
           `SPI_MASTER_DATA : 
           begin 
               spi_data_wr <= data_i[7:0];
               spi_start   <= 1'b1;
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
   end
   else 
   begin 
       
       // Read cycle?
       if (rd_i == 1'b1)
       begin
           case (addr_i[7:0])
                
           `SPI_MASTER_STAT : 
                data_o <= {31'h00000000, spi_busy};
                
           `SPI_MASTER_DATA : 
                data_o <= {24'h000000, spi_data_rd};
             
           default : 
                data_o <= 32'h00000000;
           endcase
        end
   end
end

endmodule
