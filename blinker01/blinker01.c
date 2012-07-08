

#define UART_USR 0x20000004
#define UART_UDR 0x20000008

#define TIMER_SYSTICK_VAL 0x20000100
#define TIMER_HIRES       0x20000104


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
    unsigned int tick;
    unsigned int last_tick;
    unsigned int hres;
    unsigned int last_hres;

    hexstring(0x12345678);

    last_tick=GET32(TIMER_SYSTICK_VAL);
    last_hres=0;
    for(ra=0;ra<10;)
    {
        tick=GET32(TIMER_SYSTICK_VAL);
        if(tick!=last_tick)
        {
            last_tick=tick;
            hres=GET32(TIMER_HIRES);
            if(ra)
            {
                hexstrings(ra++);
                hexstrings(hres);
                hexstring(hres-last_hres);
            }
            else
            {
                hexstrings(ra++);
                hexstring(hres);
            }
            last_hres=hres;
        }
    }
    hexstring(0x12345678);

    return(0);
}
