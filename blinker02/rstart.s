


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

    l.j hang
    l.nop





