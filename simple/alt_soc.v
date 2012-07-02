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
`include "alt_soc_defs.v"
`include "alt_soc_conf.v"

//-----------------------------------------------------------------
// Module:
//-----------------------------------------------------------------
module alt_soc 
( 
    // General - Clocking & Reset
    clk_i, 
    rst_i, 
    en_i, 
    ext_intr_i, 
    fault_o,
    break_o,
    
    // UART
    uart_tx_o, 
    uart_rx_i, 
    
    // BootRAM
    int_mem_addr_o, 
    int_mem_data_o, 
    int_mem_data_i, 
    int_mem_wr_o, 
    int_mem_rd_o, 
    int_mem_pause_i, 
    
    // External IO
    ext_io_addr_o, 
    ext_io_data_o, 
    ext_io_data_i, 
    ext_io_wr_o, 
    ext_io_rd_o, 
    ext_io_pause_i, 
        
    // SPI Flash
    flash_cs_o, 
    flash_si_o, 
    flash_so_i, 
    flash_sck_o,       

    // Debug Status
    dbg_pc_o, 
    
    // Debug UART output
    dbg_uart_data_o, 
    dbg_uart_wr_o    
);

//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
parameter  [31:0]   CLK_KHZ             = 12288;
parameter  [31:0]   UART_BAUD           = 115200;
parameter  [31:0]   SPI_FLASH_CLK_KHZ   = (12288/2);
parameter  [31:0]   EXTERNAL_INTERRUPTS = 1;
parameter           CORE_ID             = 0;
parameter           BOOT_VECTOR         = 0;
parameter           ISR_VECTOR          = 0;
    
//-----------------------------------------------------------------
// I/O
//-----------------------------------------------------------------     
input               clk_i /*verilator public*/;
input               rst_i /*verilator public*/;
input               en_i /*verilator public*/;
output              fault_o /*verilator public*/;
output              break_o /*verilator public*/;
input [(EXTERNAL_INTERRUPTS - 1):0]  ext_intr_i /*verilator public*/;
output              uart_tx_o /*verilator public*/;
input               uart_rx_i /*verilator public*/;
output [31:0]       int_mem_addr_o /*verilator public*/;
output [31:0]       int_mem_data_o /*verilator public*/;
input [31:0]        int_mem_data_i /*verilator public*/;
output [3:0]        int_mem_wr_o /*verilator public*/;
output              int_mem_rd_o /*verilator public*/;
input               int_mem_pause_i /*verilator public*/;
output [31:0]       ext_io_addr_o /*verilator public*/;
output [31:0]       ext_io_data_o /*verilator public*/;
input [31:0]        ext_io_data_i /*verilator public*/;
output [3:0]        ext_io_wr_o /*verilator public*/;
output              ext_io_rd_o /*verilator public*/;
input               ext_io_pause_i /*verilator public*/;
output              flash_cs_o /*verilator public*/;
output              flash_si_o /*verilator public*/;
input               flash_so_i /*verilator public*/;
output              flash_sck_o /*verilator public*/;
output [31:0]       dbg_pc_o /*verilator public*/;
output [7:0]        dbg_uart_data_o /*verilator public*/;
output              dbg_uart_wr_o /*verilator public*/;

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
wire                alt_reset;

reg [31:0]          v_irq_status;
reg [2:0]           r_mem_sel;
wire [31:0]         cpu_address;
wire [3:0]          cpu_byte_we;
wire                cpu_oe;
wire [31:0]         cpu_data_w;
reg [31:0]          cpu_data_r;
reg                 cpu_pause;

reg [31:0]          io_address;
reg [31:0]          io_data_w;
reg [31:0]          io_data_r;
reg [3:0]           io_wr;
reg                 io_rd;

// UART
reg [7:0]           uart_tx_data;
wire [7:0]          uart_rx_data;
reg                 uart_wr;
reg                 uart_rd;
wire                uart_tx_busy;
wire                uart_rx_avail;

// Systick Timer
reg                 systick_intr;
reg [31:0]          systick_count;
reg [31:0]          systick_clk_count;

// Hi-res system clock tick counter
reg [31:0]          hr_timer_cnt;
reg [31:0]          hr_timer_match;

// IRQ Status
wire                intr_in;
reg [31:0]          irq_status;
reg [31:0]          irq_mask;

// Watchdog
`ifdef SOC_CONF_ENABLE_WATCHDOG  
    reg             watchdog_enable;
    reg [15:0]      watchdog_threshold;
    reg             watchdog_expired;
    reg             watchdog_load;
    reg [15:0]      watchdog_counter;
    reg             watchdog_alt_reset;
`endif

// SPI Flash
`ifdef SOC_CONF_ENABLE_SPI_FLASH
    reg             spi_flash_start;
    wire            spi_flash_busy;
    reg [7:0]       spi_flash_data_wr;
    wire [7:0]      spi_flash_data_rd;
`endif

// Output Signals
wire                uart_tx_o;
reg [31:0]          int_mem_addr_o;
reg [31:0]          int_mem_data_o;
reg [3:0]           int_mem_wr_o;
reg                 int_mem_rd_o;
reg [31:0]          ext_io_addr_o;
reg [31:0]          ext_io_data_o;
reg [3:0]           ext_io_wr_o;
reg                 ext_io_rd_o;
reg                 flash_cs_o;
wire                flash_si_o;
wire                flash_sck_o;

//-----------------------------------------------------------------
// Instantiation
//-----------------------------------------------------------------  

// MPX CPU   
altor32  
u1_cpu
(
    .clk_i(clk_i), 
    .rst_i(alt_reset), 
    .en_i(en_i), 
    .intr_i(intr_in), 
    .fault_o(fault_o), 
    .break_o(break_o), 
    .mem_addr_o(cpu_address), 
    .mem_data_out_o(cpu_data_w), 
    .mem_data_in_i(cpu_data_r), 
    .mem_wr_o(cpu_byte_we), 
    .mem_rd_o(cpu_oe), 
    .mem_pause_i(cpu_pause), 
    .dbg_pc_o(dbg_pc_o)
);

// UART
uart  
#(
    .UART_DIVISOR(((CLK_KHZ * 1000) / UART_BAUD))
) 
u3_uart
(
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    .data_i(uart_tx_data), 
    .data_o(uart_rx_data), 
    .wr_i(uart_wr), 
    .rd_i(uart_rd), 
    .tx_busy_o(uart_tx_busy), 
    .rx_ready_o(uart_rx_avail), 
    .rxd_i(uart_rx_i), 
    .txd_o(uart_tx_o)
);

`ifdef SOC_CONF_ENABLE_SPI_FLASH
    // SPI Flash Master
    spi_master  
    #(
        .CLK_DIV(CLK_KHZ / SPI_FLASH_CLK_KHZ),
        .TRANSFER_WIDTH(8)
    ) 
    u4_spi_flash
    (
        // Clocking / Reset
        .clk_i(clk_i), 
        .rst_i(rst_i), 
        // Control & Status
        .start_i(spi_flash_start), 
        .done_o(/*open */), 
        .busy_o(spi_flash_busy), 
        // Data
        .data_i(spi_flash_data_wr), 
        .data_o(spi_flash_data_rd), 
        // SPI interface
        .spi_clk_o(flash_sck_o), 
        .spi_ss_o(/*open */), 
        .spi_mosi_o(flash_si_o), 
        .spi_miso_i(flash_so_i)
    );
`else
    // SPI Flash Disabled
    assign flash_cs_o   = 1'b1;
    assign flash_si_o   = 1'b0;
    assign flash_sck_o  = 1'b0;
`endif

//-----------------------------------------------------------------
// I/O Handlers
//-----------------------------------------------------------------   
always @ (posedge rst_i or posedge clk_i )
begin 
   if (rst_i == 1'b1) 
   begin 
       // UART
       uart_tx_data     <= 8'h00;
       uart_wr          <= 1'b0;
       
       // Interrupt Status
       irq_status       <= 32'h00000000;
       irq_mask         <= 32'h00000000;
       hr_timer_cnt     <= 32'h00000000;
       hr_timer_match   <= 32'h00000000;
       
       // SPI Flash (Configuration PROM)
    `ifdef SOC_CONF_ENABLE_SPI_FLASH       
       flash_cs_o       <= 1'b1;
       spi_flash_start  <= 1'b0;
       spi_flash_data_wr<= 8'h00;
    `endif
       
       // Watchdog
    `ifdef SOC_CONF_ENABLE_WATCHDOG       
       watchdog_enable      <= 1'b0;
       watchdog_load        <= 1'b0;
       watchdog_threshold   <= 16'h0000;
    `endif       
   end
   else 
   begin 
   
       uart_wr            <= 1'b0;
    `ifdef SOC_CONF_ENABLE_SPI_FLASH
       spi_flash_start    <= 1'b0;
    `endif
    `ifdef SOC_CONF_ENABLE_WATCHDOG  
       watchdog_load      <= 1'b0;
    `endif       
       
       // Get current IRQ status
       v_irq_status = irq_status;
       
       // Clock tick counter
       hr_timer_cnt <= (hr_timer_cnt + 1);
       
       // Systick IRQ?
       if (systick_intr == 1'b1)
           v_irq_status[`IRQ_SYSTICK] = 1'b1;
           
       // UART IRQ?
       if (uart_rx_avail == 1'b1) 
           v_irq_status[`IRQ_UART_RX_AVAIL] = 1'b1;
           
       // Hi-res Timer IRQ [IRQ6]
       if ((hr_timer_match != 32'h00000000) && (hr_timer_match == hr_timer_cnt))
           v_irq_status[`IRQ_PIT] = 1'b1;
           
       // External interrupts
       begin : ext_ints_loop
           integer i;
           for (i=0; i< EXTERNAL_INTERRUPTS; i=i+1) 
           begin 
               if (ext_intr_i[i] == 1'b1) 
                   v_irq_status[(`IRQ_EXT_FIRST + i)] = 1'b1;
           end
       end
       
       // Update IRQ status
       irq_status <= v_irq_status;
       
       // IO Write Cycle
       if (io_wr != 4'b0000)
           case (io_address[7:0])
           
           `UART_UDR : 
           begin 
               uart_tx_data <= io_data_w[7:0];
               uart_wr <= 1'b1;
           end
           
           `IRQ_MASK_SET : 
                irq_mask <= (irq_mask | io_data_w);
                
           `IRQ_MASK_CLR : 
                irq_mask <= (irq_mask & ~ (io_data_w));
                
           `IRQ_STATUS : // (IRQ Acknowledge)
                irq_status <= (v_irq_status & ~ (io_data_w));
                
    `ifdef SOC_CONF_ENABLE_WATCHDOG
           `WATCHDOG_CTRL :
           begin
                // Enable watchdog if non-zero
                if (io_data_w[15:0] != 16'h0000)
                    watchdog_enable    <= 1'b1;
                else
                    watchdog_enable    <= 1'b0;

                // Store threshold for timeout (16-bit x 1ms)
                watchdog_threshold    <= io_data_w[15:0];
                watchdog_load         <= 1'b1;
           end
    `endif
           
           `SYS_CLK_COUNT : 
                hr_timer_match <= io_data_w;
                
    `ifdef SOC_CONF_ENABLE_SPI_FLASH                
           `SPI_PROM_CTRL : 
           begin 
               flash_cs_o <= io_data_w[0];
           end
           
           `SPI_PROM_DATA : 
           begin 
               spi_flash_data_wr <= io_data_w[7:0];
               spi_flash_start   <= 1'b1;
           end
    `endif           
           default : 
               ;
           endcase
   end
end
   
// IO memory space READ handler
always @ (posedge rst_i or posedge clk_i )
begin 
   if (rst_i == 1'b1) 
   begin 
       io_data_r    <= 32'h00000000;
       uart_rd      <= 1'b0;
   end
   else 
   begin 
       uart_rd <= 1'b0;
       
       // Read cycle?
       if (io_rd == 1'b1)
           case (io_address[7:0])
           
           `CORE_ID : 
                io_data_r <= CORE_ID;
                
           `UART_USR : 
                io_data_r <= {27'h0000000, 1'b0, uart_tx_busy, 1'b0, 1'b0, uart_rx_avail};
                
           `UART_UDR : 
           begin 
               io_data_r <= {24'h000000,uart_rx_data};
               uart_rd <= 1'b1;
           end
           
           `TIMER_VAL : // (32-bit 1ms counter)
                io_data_r <= systick_count;
                
           `IRQ_MASK_SET : 
                io_data_r <= irq_mask;
                
           `IRQ_MASK_CLR : 
                io_data_r <= irq_mask;
                
           `IRQ_STATUS : 
                io_data_r <= (irq_status & irq_mask);
                
    `ifdef SOC_CONF_ENABLE_WATCHDOG                
           `WATCHDOG_CTRL :
                io_data_r <= {15'h000000, watchdog_expired, watchdog_counter};
    `endif
                
           `SYS_CLK_COUNT : 
                io_data_r <= hr_timer_cnt;
                
    `ifdef SOC_CONF_ENABLE_SPI_FLASH                   
           `SPI_PROM_STAT : 
                io_data_r <= {31'h00000000, spi_flash_busy};
                
           `SPI_PROM_DATA : 
                io_data_r <= {24'h000000, spi_flash_data_rd};
    `endif
                    
           default : 
                io_data_r <= 32'h00000000;
           endcase
   end
end
   
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

// Watchdog
`ifdef SOC_CONF_ENABLE_WATCHDOG
    always @ (posedge rst_i or posedge clk_i )
    begin 
       if (rst_i == 1'b1) 
       begin     
           watchdog_counter     <= 16'h0000;
           watchdog_expired     <= 1'b0;
           watchdog_alt_reset   <= 1'b0;
       end
       else 
       begin 

           // On 1ms tick - decrement watchdog if enabled
           if (systick_intr == 1'b1) 
               if (watchdog_enable == 1'b1)
               begin
                    // Count down or expire if 0
                    if (watchdog_counter != 16'h0000)
                        watchdog_counter    <= (watchdog_counter - 1);
                    else
                    begin
                        // Clear reset if already high
                        watchdog_alt_reset    <= 1'b0;
                        
                        // If not already expired, start reset sequence
                        if (watchdog_expired != 1'b1)
                        begin
                            watchdog_expired    <= 1'b1;
                            watchdog_alt_reset  <= 1'b1;
                            
                            // Hold reset high for a couple of ms
                            watchdog_counter    <= 16'h002;
                        end
                    end
               end

           // If watchdog reset signalled, reset counter with new threshold value           
           if (watchdog_load == 1'b1)
           begin
                watchdog_counter <= watchdog_threshold;
                watchdog_expired <= 1'b0;
           end
       end
    end
`endif

//-----------------------------------------------------------------
// Memory Map
//-----------------------------------------------------------------   
always @ (cpu_address or cpu_byte_we or cpu_oe or cpu_data_w )
begin 
   case (cpu_address[30:28])
   
   // Block RAM
   `MEM_REGION_INTERNAL : 
   begin 
       int_mem_addr_o       = cpu_address;
       int_mem_wr_o         = cpu_byte_we;
       int_mem_rd_o         = cpu_oe;
       int_mem_data_o       = cpu_data_w;
       
       io_address           = 32'h00000000;
       io_wr                = 4'b0000;
       io_rd                = 1'b0;
       io_data_w            = 32'h00000000;
       
       ext_io_addr_o        = 32'h00000000;
       ext_io_wr_o          = 4'b0000;
       ext_io_rd_o          = 1'b0;
       ext_io_data_o        = 32'h00000000;
   end
   
   // Core I/O peripherals
   `MEM_REGION_CORE_IO : 
   begin 
       io_address           = cpu_address;
       io_wr                = cpu_byte_we;
       io_rd                = cpu_oe;
       io_data_w            = cpu_data_w;
       
       int_mem_addr_o       = 32'h00000000;
       int_mem_wr_o         = 4'b0000;
       int_mem_rd_o         = 1'b0;
       int_mem_data_o       = 32'h00000000;
       
       ext_io_addr_o        = 32'h00000000;
       ext_io_wr_o          = 4'b0000;
       ext_io_rd_o          = 1'b0;
       ext_io_data_o        = 32'h00000000;
   end
   
   // Extended I/O peripherals   
   `MEM_REGION_EXT_IO : 
   begin 
       ext_io_addr_o        = cpu_address;
       ext_io_wr_o          = cpu_byte_we;
       ext_io_rd_o          = cpu_oe;
       ext_io_data_o        = cpu_data_w;
       
       int_mem_addr_o       = 32'h00000000;
       int_mem_wr_o         = 4'b0000;
       int_mem_rd_o         = 1'b0;
       int_mem_data_o       = 32'h00000000;
       
       io_address           = 32'h00000000;
       io_wr                = 4'b0000;
       io_rd                = 1'b0;
       io_data_w            = 32'h00000000;
   end
      
   default : 
   begin 
       io_address           = 32'h00000000;
       io_wr                = 4'b0000;
       io_rd                = 1'b0;
       io_data_w            = 32'h00000000;
       
       int_mem_addr_o       = 32'h00000000;
       int_mem_wr_o         = 4'b0000;
       int_mem_rd_o         = 1'b0;
       int_mem_data_o       = 32'h00000000;
       
       ext_io_addr_o        = 32'h00000000;
       ext_io_wr_o          = 4'b0000;
       ext_io_rd_o          = 1'b0;
       ext_io_data_o        = 32'h00000000;
   end
   endcase
end
   
//-----------------------------------------------------------------
// Read Port
//-----------------------------------------------------------------   
always @ (r_mem_sel or int_mem_data_i or io_data_r or ext_io_data_i or int_mem_pause_i or ext_io_pause_i)
begin 
   case (r_mem_sel)
   
   // Block RAM
   `MEM_REGION_INTERNAL : 
   begin 
       cpu_data_r   = int_mem_data_i;
       cpu_pause    = int_mem_pause_i;
   end
     
   // Core I/O peripherals
   `MEM_REGION_CORE_IO : 
   begin 
       cpu_data_r   = io_data_r;
       cpu_pause    = 1'b0;
   end
   
   // Extended I/O peripherals
   `MEM_REGION_EXT_IO : 
   begin 
       cpu_data_r   = ext_io_data_i;
       cpu_pause    = ext_io_pause_i;
   end
   
   default : 
   begin 
       cpu_data_r   = 32'h00000000;
       cpu_pause    = 1'b0;
   end
   endcase
end
   
//-----------------------------------------------------------------
// Registered device select
//----------------------------------------------------------------- 
reg [31:0] v_mem_sel;
  
always @ (posedge clk_i or posedge alt_reset )
begin
   if (alt_reset == 1'b1)
   begin 
       v_mem_sel = BOOT_VECTOR;
       r_mem_sel <= v_mem_sel[30:28];
   end
   else 
       r_mem_sel <= cpu_address[30:28];
end
   
//-----------------------------------------------------------------
// Combinatorial Logic
//-----------------------------------------------------------------     
assign intr_in      = ((irq_mask & irq_status) != 32'h00000000) ? 1'b1 : 1'b0;
`ifdef SOC_CONF_ENABLE_WATCHDOG 
assign alt_reset    = (rst_i | watchdog_alt_reset);
`else
assign alt_reset    = rst_i;
`endif

//-----------------------------------------------------------------
// External Interface
//-----------------------------------------------------------------  
// Debug UART
assign dbg_uart_data_o  = uart_tx_data;
assign dbg_uart_wr_o    = uart_wr;

endmodule
