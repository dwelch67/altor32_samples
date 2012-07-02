//-----------------------------------------------------------------
//                           AltOR32 
//              Alternative Lightweight OpenRisc 
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
#include <stdio.h>
#include <unistd.h>
#include <math.h>
#include <time.h>

#include "top.h"

#include "Vtop.h"
#include "Vtop_top.h"
#include "Vtop_sram4__S13.h"
#include "Vtop_sram__S13.h"
#include "verilated.h"

#if VM_TRACE
#include <verilated_vcd_c.h>
#endif

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------
// Memory start offset (set to 0x2000 to match FPGA version where 
// bootloader exists in first 8K)
#define MEMORY_START        0x0000
#define MEMORY_SIZE			(512 * 1024)
#define REGISTERS           32

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
static Vtop *top;
static unsigned int _stop_pc = 0xFFFFFFFF;

#if VM_TRACE
static unsigned int		main_time = 0;
static VerilatedVcdC*	tfp;
#endif

//-----------------------------------------------------------------
// top_init
//-----------------------------------------------------------------
int top_init(void)
{
    top = new Vtop();

#if VM_TRACE                  
    // If verilator was invoked with --trace
    Verilated::traceEverOn(true);
    VL_PRINTF("Enabling GTKWave Trace Output...\n");
    tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("wave_dump.vcd");
#endif

    // Initial
    top->clk_i = 0;
    top->rst_i = 1;
    top->en_i = 1;
    top->intr_i = 0;
    top->dbg_reg_addr_i = 0;
    top->eval();

    // Reset
    top->clk_i = 1;
    top->rst_i = 1;
    top->eval();

    top->clk_i = 0;
    top->rst_i = 0;
    top->eval();

    return 0;
}
//-----------------------------------------------------------------
// top_load
//-----------------------------------------------------------------
int top_load(unsigned int addr, unsigned char val)
{
    if (addr >= (MEMORY_SIZE - MEMORY_START))
        return -1;

    addr += MEMORY_START;

    switch (addr & 0x3)
    {
    case 0:
        top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__3__KET____DOT__u1_bram->ram[addr >> 2] = val;
        break;
    case 1:
        top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__2__KET____DOT__u1_bram->ram[addr >> 2] = val;
        break;
    case 2:
        top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__1__KET____DOT__u1_bram->ram[addr >> 2] = val;
        break;
    case 3:
        top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__0__KET____DOT__u1_bram->ram[addr >> 2] = val;
        break;
    }

    return 0;
}
//-----------------------------------------------------------------
// top_mem_read
//-----------------------------------------------------------------
unsigned char top_mem_read(unsigned int addr)
{
    unsigned char val = 0;

    if (addr >= (MEMORY_SIZE - MEMORY_START))
        return 0;

    addr += MEMORY_START;

    switch (addr & 0x3)
    {
    case 0:
        val = top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__3__KET____DOT__u1_bram->ram[addr >> 2];
        break;
    case 1:
        val = top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__2__KET____DOT__u1_bram->ram[addr >> 2];
        break;
    case 2:
        val = top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__1__KET____DOT__u1_bram->ram[addr >> 2];
        break;
    case 3:
        val = top->v->u1_bram->sram_gen__DOT__sram_loop__BRA__0__KET____DOT__u1_bram->ram[addr >> 2];
        break;
    }

    return val;
}
//-----------------------------------------------------------------
// top_setbreakpoint
//-----------------------------------------------------------------
int top_setbreakpoint(int bp, unsigned int pc)
{
    if (bp != 0)
        return -1;
    else
    {
        _stop_pc = pc;
        return 0;
    }
}
//-----------------------------------------------------------------
// top_run
//-----------------------------------------------------------------
int top_run(int cycles)
{
    int current_cycle = 0;
    unsigned int last_pc = top->dbg_pc_o;

    // Run until fault or number of cycles completed
    while (!Verilated::gotFinish() && !top->fault_o && (current_cycle < cycles || cycles == -1)) 
    {
        // CLK->L
        top->clk_i = 0;
        top->eval();

#if VM_TRACE
        if (tfp) tfp->dump (main_time++);
#endif

        // CLK->H
        top->clk_i = 1;
        top->eval();			

#if VM_TRACE
        if (tfp) tfp->dump (main_time++);
#endif

        if (top->uart_wr_o)
            printf("%c", top->uart_data_o);

        if (last_pc != top->dbg_pc_o)
        {			
            last_pc = top->dbg_pc_o;
            current_cycle++;
        }

        if (_stop_pc == top->dbg_pc_o || top->break_o)
            break;
    }

    // Fault
    if (top->fault_o)
        return TOP_RES_FAULT;
    // Number of cycles reached
    else if (current_cycle >= cycles)
        return TOP_RES_MAX_CYCLES;
    // Breakpoint hit
    else if (_stop_pc == top->dbg_pc_o || top->break_o)
        return TOP_RES_BREAKPOINT;
    // No error
    else
        return TOP_RES_OK;
}
//-----------------------------------------------------------------
// top_reset
//-----------------------------------------------------------------
void top_reset(void)
{
    // Reset = H
    top->rst_i = 1;
    
    // Clock
    top->clk_i = 1;
    top->eval();
    top->clk_i = 0;
    top->eval();

    // Reset = L
    top->rst_i = 0;
    top->eval();
}
//-----------------------------------------------------------------
// top_getreg
//-----------------------------------------------------------------
unsigned int top_getreg(int reg)
{
    top->en_i = 0;

    top->dbg_reg_addr_i = reg;

    // Clock
    top->clk_i = 1;
    top->eval();
    top->clk_i = 0;
    top->eval();

    top->en_i = 1;

    return top->dbg_reg_out_o;
}
//-----------------------------------------------------------------
// top_reset
//-----------------------------------------------------------------
unsigned int top_getpc(void)
{
    return top->dbg_pc_o;
}
//-----------------------------------------------------------------
// top_done
//-----------------------------------------------------------------
void top_done(void)
{
    top->final();
#if VM_TRACE
    if (tfp)
    {
        tfp->close();
        tfp = NULL;
    }
#endif
}
