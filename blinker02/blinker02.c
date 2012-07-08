

#define UART_USR 0x20000004
#define UART_UDR 0x20000008

#define TIMER_SYSTICK_VAL 0x20000100
#define TIMER_HIRES       0x20000104

#define IRQ_MASK_SET      0x20000200
#define IRQ_MASK_STATUS   0x20000204
#define IRQ_MASK_CLR      0x20000208
#define IRQ_STATUS        0x2000020C
#define IRQ_STATUS_RAW    0x20000210

//    .intr2_i(timer_intr_hires),


extern void PUT32 ( unsigned int, unsigned int );
extern unsigned int GET32 ( unsigned int );

unsigned int fun ( unsigned int x )
{
    return(x+5);
}

//-------------------------------------------------------------------
void uart_putc ( unsigned char x )
{
    while(GET32(UART_USR)&0x8) continue;
    PUT32(UART_UDR,x);
}
//-------------------------------------------------------------------
void uart_init(void)
{
}
//-------------------------------------------------------------------------
void hexstrings ( unsigned int d )
{
    unsigned int rb;
    unsigned int rc;

    rb=32;
    while(1)
    {
        rb-=4;
        rc=(d>>rb)&0xF;
        if(rc>9) rc+=0x37; else rc+=0x30;
        uart_putc(rc);
        if(rb==0) break;
    }
    uart_putc(0x20);
}
//-------------------------------------------------------------------------
void hexstring ( unsigned int d )
{
    hexstrings(d);
    uart_putc(0x0D);
    uart_putc(0x0A);
}
//-------------------------------------------------------------------------
unsigned int notmain ( void )
{
    unsigned int ra;

    hexstring(0x12345678);

    PUT32(TIMER_HIRES,0x1000);
    PUT32(IRQ_MASK_SET,1<<2);
    for(ra=0;ra<10;)
    {
        while(1)
        {
            if(GET32(IRQ_STATUS_RAW)&1<<2) break;
        }
        PUT32(IRQ_STATUS,1<<2);
        hexstring(ra++);
    }
    hexstring(0x12345678);

    return(0);
}
