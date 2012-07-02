
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

As well as something that embeds in an fpga well, this also appears to be
a good processor for educational purposes.  For learning assembly, for
learning about instruction set simulators, for examining what the source
code for a processor looks like, for learning how and seeing your code
execute inside a processor.  I should spend some time on one or some of
these things.

It is very important to understand something at this level, I spend time
in forums and from the questions asked there are some obvious myths or
beliefs that should have been taught in school.  First, as a programmer
yourself you should understand that given a programming task with some
sort of specification of requirements, take a room full of N programmers
you will get somewhere between 2 and N number of different solutions
to the same problem (assuming the specification is not so detailed that
it essentially contains the entire source for the program).  Hardware
is implemented using programming languages and hardware programmers
are no different than software programmers, you will get somewhere between
2 and N number of different solutions giving the same task to a group
of individuals.  Altor32 was not developed by the same group of people
that developed the or32.  Questions like "instruction X in or32 does this
why doesnt it do that in altor32".  Well first altor32 is not the or32
anyway, and second even if it were to meet the same spec it is not
implemented by the same team so one may take a different number of
clocks to execute the same code, etc.  The second myth should now be
obvious, but perhaps not, two compilers or the same compiler built two
different ways, does not produce the same output, the same machine code
from the same source code.  Borland C and Microsoft C do not produce
the same binary given the same C program.  Likewise there is no reason
to ever assume that clang and gcc would produce the same machine code
from the same source code.  Nor would you assume that one gcc version
to the next would produce the same machine code from the same source
code.  Nor would you assume that the same gcc source code built for
the same target processor with different configure/compile options would
create the same machine code.  The latter might be more likely to
than any of the other combinations, but still you should never make that
assumption.  Which means that just because your C code worked one day
with one compiler does not mean your C code is working and is debugged.
This is the "it works on my machine" problem.  Works on my machine doesnt
mean works on every machine.

Geez, so what was that paragraph all about?  The altor32 is not the or32,
it is derived from a subset of the same spec.  That is where the two are
common and diverge.  If necessary the or32 gnu tools may need to be
modified further to build code that works on altor32 properly.  So the
or32 and altor32 compilers might vary some day.  For now the or32 tools
are being used.  Also, the altor32 project will ultimately have
a simple version of the processor (linear execution) and a pipelined
version (pipeline execution).  Even if developed by the same person
these are also two separate processors, the fast and simple and will
have differences to each other from an execution speed perspective,
ideally they will have the same instruction set and interpret the
instructions in the same way.
