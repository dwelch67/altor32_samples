#ifndef __TOP_H__
#define __TOP_H__

//--------------------------------------------------------------------
// Defines
//--------------------------------------------------------------------
#define			TOP_RES_FAULT			-1
#define			TOP_RES_OK				0
#define			TOP_RES_MAX_CYCLES		1
#define			TOP_RES_BREAKPOINT		2

//--------------------------------------------------------------------
// Prototypes
//--------------------------------------------------------------------
int				top_init(void);
int				top_load(unsigned int addr, unsigned char val);
void			top_reset(void);
void			top_done(void);
unsigned int	top_getreg(int reg);
unsigned int	top_getpc(void);
int				top_run(int cycles);
int				top_setbreakpoint(int bp, unsigned int pc);


#endif
