#ifndef __OR32_H__
#define __OR32_H__

#include "or32_isa.h"

//--------------------------------------------------------------------
// Defines:
//--------------------------------------------------------------------
#define LOG_OR1K        (1 << 0)
#define LOG_INST        (1 << 1)
#define LOG_REGISTERS   (1 << 2)
#define LOG_MEM         (1 << 3)

//--------------------------------------------------------------------
// Class
//--------------------------------------------------------------------
class OR32
{
public:
                        OR32(unsigned int baseAddr, unsigned int len);
    virtual             ~OR32();

    bool                Load(unsigned int startAddr, unsigned char *data, int len);
    bool                WriteMem(TAddress addr, unsigned char *data, int len);
    bool                ReadMem(TAddress addr, unsigned char *data, int len);

    void                Reset(TRegister start_addr = VECTOR_RESET);
    bool                Clock(void);
    bool                Step(void);

    int                 GetFault(void) { return Fault; }
    int                 GetBreak(void) { return Break; }
    TRegister           GetRegister(int r) { return (r < REGISTERS) ? r_gpr[r] : 0; }

    void                EnableTrace(unsigned mask)  { Trace = mask; }

    void                DumpStats(void);

protected:  
    void                Decode(void);
    void                Execute(void);
    void                WriteBack(void);

protected:  
    // Peripheral access
    virtual void        PeripheralReset(void) { }
    virtual void        PeripheralClock(void) { }
    virtual TRegister   PeripheralAccess(TAddress addr, TRegister data_in, TRegister wr, TRegister rd) { return 0; }
    virtual bool	    PeripheralInterrupt(void) { return false; }

protected:  
    // Execution monitoring
    virtual void        MonInstructionExecute(TAddress addr, TRegister instr) { }
    virtual void        MonDataLoad(TAddress addr, TRegister mask, TAddress value) { }
    virtual void        MonDataStore(TAddress addr, TRegister mask, TAddress value) { }
    virtual void        MonFault(TAddress addr, TRegister instr) { }
    virtual void        MonExit(void) { }
    virtual void        MonNop(TRegister imm);
    
private:

    // CPU Registers
    TRegister           r_gpr[REGISTERS];
    TRegister           r_pc;
    TRegister           r_pc_next;
    TRegister           r_pc_last;
    TRegister           r_sr;
    TRegister           r_epc;
    TRegister           r_esr;

    // Register file access
    TRegister           r_ra;
    TRegister           r_rd;
    TRegister           r_rd_wb;
    TRegister           r_rb;
    TRegister           r_reg_ra;
    TRegister           r_reg_rb;
    TRegister           r_reg_result;
    TRegister           r_reg_rd_out;
    int                 r_writeback;
    TInstruction        r_opcode;

    // Memory
    TMemory             *Mem;
    TAddress            MemBase;
    unsigned int        MemSize;

    // Memory access
    TAddress            mem_addr;
    TRegister           mem_data_out;
    TRegister           mem_data_in;
    TRegister           mem_offset;
    TRegister           mem_wr;
    TRegister           mem_rd;

    // Status
    int                 Fault;
    int                 Break;
    TRegister           BreakValue;
    unsigned            Trace;
    int                 Cycle;

    // Stats
    int                 StatsMem;
    int                 StatsInstructions;
    int                 StatsNop;
    int                 StatsBranches;
    int                 StatsExceptions;
};

#endif
