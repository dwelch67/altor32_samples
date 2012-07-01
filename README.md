
Well, ultra-embedded.com has another core at opencores.org.

http://opencores.org/project,altor32

Alternative OpenRisc32 is a cut-down, lightweight implementation of the
OpenRisc 1000 (ORBIS32) instruction set.

So what does cut down mean?  See the arch directory which is a discovery
into what is in this processor.

The altor32 directory contains the rtl pieces from the altor32 project
at opencores.  Uses verilator to build, probably want gtkwave to see
the output.

The or32-sim directory also from the altor32 project is a software
instruction set simulator, you just need a C/C++ compiler.

