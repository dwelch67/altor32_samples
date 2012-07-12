

extern unsigned int SFEQ ( unsigned int, unsigned int );
extern unsigned int SFGES ( unsigned int, unsigned int );
extern unsigned int SFGEU ( unsigned int, unsigned int );
extern unsigned int SFGTS ( unsigned int, unsigned int );
extern unsigned int SFGTU ( unsigned int, unsigned int );
extern unsigned int SFLES ( unsigned int, unsigned int );

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
unsigned int SFEQ_test ( unsigned int a, unsigned int b )
{
    unsigned int ret;

    ret=SFEQ(a,b);
    hexstrings(a); hexstrings(b); hexstring(ret);
    return(ret);
}
//-------------------------------------------------------------------------
unsigned int SFGES_test ( unsigned int a, unsigned int b )
{
    unsigned int ret;

    ret=SFGES(a,b);
    hexstrings(a); hexstrings(b); hexstring(ret);
    return(ret);
}
//-------------------------------------------------------------------------
unsigned int SFGEU_test ( unsigned int a, unsigned int b )
{
    unsigned int ret;

    ret=SFGEU(a,b);
    hexstrings(a); hexstrings(b); hexstring(ret);
    return(ret);
}
//-------------------------------------------------------------------------
unsigned int SFGTS_test ( unsigned int a, unsigned int b )
{
    unsigned int ret;

    ret=SFGTS(a,b);
    hexstrings(a); hexstrings(b); hexstring(ret);
    return(ret);
}
//-------------------------------------------------------------------------
unsigned int SFGTU_test ( unsigned int a, unsigned int b )
{
    unsigned int ret;

    ret=SFGTU(a,b);
    hexstrings(a); hexstrings(b); hexstring(ret);
    return(ret);
}
//-------------------------------------------------------------------------
unsigned int SFLES_test ( unsigned int a, unsigned int b )
{
    unsigned int ret;

    ret=SFLES(a,b);
    hexstrings(a); hexstrings(b); hexstring(ret);
    return(ret);
}
//-------------------------------------------------------------------------
unsigned int notmain ( void )
{
    unsigned int ra;

    hexstring(0x12345678);

    //hexstring(0x1111);

    SFEQ_test(0x00000000,0x00000000);
    SFEQ_test(0xFFFFFFFF,0xFFFFFFFF);
    SFEQ_test(0x80000000,0x80000000);
    SFEQ_test(0x00000001,0x00000001);
    SFEQ_test(0x00000000,0x00000001);
    SFEQ_test(0xFFFFFFFF,0x00000000);
    SFEQ_test(0x80000000,0xFFFFFFFF);
    SFEQ_test(0x00000001,0x80000000);

    hexstring(0x2222);

    SFGES_test(0x00000002,0x00000000);
    SFGES_test(0x00000002,0x00000001);
    SFGES_test(0x00000002,0x00000002);
    SFGES_test(0x00000002,0x00000003);
    SFGES_test(0x00000002,0x00000004);
    SFGES_test(0x00000000,0x80000000);
    SFGES_test(0x80000000,0x00000000);
    SFGES_test(0xFFFFFFFD,0xFFFFFFFF);
    SFGES_test(0xFFFFFFFD,0xFFFFFFFE);
    SFGES_test(0xFFFFFFFD,0xFFFFFFFD);
    SFGES_test(0xFFFFFFFD,0xFFFFFFFC);
    SFGES_test(0xFFFFFFFD,0xFFFFFFFB);

    hexstring(0x3333);

    SFGEU_test(0x00000002,0x00000000);
    SFGEU_test(0x00000002,0x00000001);
    SFGEU_test(0x00000002,0x00000002);
    SFGEU_test(0x00000002,0x00000003);
    SFGEU_test(0x00000002,0x00000004);
    SFGEU_test(0x00000000,0x80000000);
    SFGEU_test(0x80000000,0x00000000);
    SFGEU_test(0xFFFFFFFD,0xFFFFFFFF);
    SFGEU_test(0xFFFFFFFD,0xFFFFFFFE);
    SFGEU_test(0xFFFFFFFD,0xFFFFFFFD);
    SFGEU_test(0xFFFFFFFD,0xFFFFFFFC);
    SFGEU_test(0xFFFFFFFD,0xFFFFFFFB);

    hexstring(0x4444);

    SFGTS_test(0x00000002,0x00000000);
    SFGTS_test(0x00000002,0x00000001);
    SFGTS_test(0x00000002,0x00000002);
    SFGTS_test(0x00000002,0x00000003);
    SFGTS_test(0x00000002,0x00000004);
    SFGTS_test(0x00000000,0x80000000);
    SFGTS_test(0x80000000,0x00000000);
    SFGTS_test(0xFFFFFFFD,0xFFFFFFFF);
    SFGTS_test(0xFFFFFFFD,0xFFFFFFFE);
    SFGTS_test(0xFFFFFFFD,0xFFFFFFFD);
    SFGTS_test(0xFFFFFFFD,0xFFFFFFFC);
    SFGTS_test(0xFFFFFFFD,0xFFFFFFFB);

    hexstring(0x5555);

    SFGTU_test(0x00000002,0x00000000);
    SFGTU_test(0x00000002,0x00000001);
    SFGTU_test(0x00000002,0x00000002);
    SFGTU_test(0x00000002,0x00000003);
    SFGTU_test(0x00000002,0x00000004);
    SFGTU_test(0x00000000,0x80000000);
    SFGTU_test(0x80000000,0x00000000);
    SFGTU_test(0xFFFFFFFD,0xFFFFFFFF);
    SFGTU_test(0xFFFFFFFD,0xFFFFFFFE);
    SFGTU_test(0xFFFFFFFD,0xFFFFFFFD);
    SFGTU_test(0xFFFFFFFD,0xFFFFFFFC);
    SFGTU_test(0xFFFFFFFD,0xFFFFFFFB);

    hexstring(0x6666);

    SFLES_test(0x00000002,0x00000000);
    SFLES_test(0x00000002,0x00000001);
    SFLES_test(0x00000002,0x00000002);
    SFLES_test(0x00000002,0x00000003);
    SFLES_test(0x00000002,0x00000004);
    SFLES_test(0x00000000,0x80000000);
    SFLES_test(0x80000000,0x00000000);
    SFLES_test(0xFFFFFFFD,0xFFFFFFFF);
    SFLES_test(0xFFFFFFFD,0xFFFFFFFE);
    SFLES_test(0xFFFFFFFD,0xFFFFFFFD);
    SFLES_test(0xFFFFFFFD,0xFFFFFFFC);
    SFLES_test(0xFFFFFFFD,0xFFFFFFFB);

    hexstring(0x12345678);

    return(0);
}
