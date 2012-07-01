
.space 0x100
l.movhi r6,0
l.movhi r7,0
l.sw 0(r6),r6
l.addi r7,r7,1
l.addi r7,r7,1
l.sb 0(r6),r7
l.lws r3,0(r6)
l.lwz r4,0(r6)
l.trap 0
l.nop
l.nop
