


.space 0x100
.globl _start
_start:
    l.movhi r1,0x1
    l.movhi r1,0x1
    l.jal notmain
    l.nop
hang:
    l.trap 0
    l.j hang
    l.nop

.globl PUT32
PUT32:
    l.jr r9
    l.sw 0(r3),r4

.globl GET32
GET32:
    l.jr r9
    l.lwz r11,0(r3)


/* 11100100000AAAAABBBBB----------- l.sfeq ra,rb */
.globl SFEQ
SFEQ:
    l.sfeq r3,r4
    l.bf SFEQ_SET
    l.nop
    l.jr r9
    l.ori r11,r0,0
SFEQ_SET:
    l.jr r9
    l.ori r11,r0,1




/* 11100101011AAAAABBBBB----------- l.sfges ra,rb */
.globl SFGES
SFGES:
    l.sfges r3,r4
    l.bf SFGES_SET
    l.nop
    l.jr r9
    l.ori r11,r0,0
SFGES_SET:
    l.jr r9
    l.ori r11,r0,1
/* 11100100011AAAAABBBBB----------- l.sfgeu ra,rb */
.globl SFGEU
SFGEU:
    l.sfgeu r3,r4
    l.bf SFGEU_SET
    l.nop
    l.jr r9
    l.ori r11,r0,0
SFGEU_SET:
    l.jr r9
    l.ori r11,r0,1

/* 11100101010AAAAABBBBB----------- l.sfgts ra,rb */
.globl SFGTS
SFGTS:
    l.sfgts r3,r4
    l.bf SFGTS_SET
    l.nop
    l.jr r9
    l.ori r11,r0,0
SFGTS_SET:
    l.jr r9
    l.ori r11,r0,1
/* 11100100010AAAAABBBBB----------- l.sfgtu ra,rb */
.globl SFGTU
SFGTU:
    l.sfgtu r3,r4
    l.bf SFGTU_SET
    l.nop
    l.jr r9
    l.ori r11,r0,0
SFGTU_SET:
    l.jr r9
    l.ori r11,r0,1
/* 11100101101AAAAABBBBB----------- l.sfles ra,rb */
.globl SFLES
SFLES:
    l.sfles r3,r4
    l.bf SFLES_SET
    l.nop
    l.jr r9
    l.ori r11,r0,0
SFLES_SET:
    l.jr r9
    l.ori r11,r0,1
/* 11100100101AAAAABBBBB----------- l.sfleu ra,rb */
/* 11100101100AAAAABBBBB----------- l.sflts ra,rb */
/* 11100100100AAAAABBBBB----------- l.sfltu ra,rb */
/* 11100100001AAAAABBBBB----------- l.sfne ra,rb  */



    l.j hang
    l.nop
