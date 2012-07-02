//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//                          AltOR32 OpenRisc Simulator
//                                    V0.1
//                              Ultra-Embedded.com
//                            Copyright 2011 - 2012
//
//                         Email: admin@ultra-embedded.com
//
//                                License: GPL
//  Please contact the above address if you would like a version of this 
//  software with a more permissive license for use in closed source commercial 
//  applications.
//-----------------------------------------------------------------------------
//
// This file is part of AltOR32 OpenRisc Simulator.
//
// AltOR32 OpenRisc Simulator is free software; you can redistribute it and/or 
// modify it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// AltOR32 OpenRisc Simulator is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with AltOR32 OpenRisc Simulator; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#include "or32.h"

#ifdef WIN32
#include "getopt_win32.h"
#else
#include <unistd.h>
#endif

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------
#define DEFAULT_MEM_BASE            0x00000000
#define DEFAULT_MEM_SIZE            (10 << 20)
#define DEFAULT_LOAD_ADDR           0x00000000
#define DEFAULT_FILENAME            NULL

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// main
//-----------------------------------------------------------------
int main(int argc, char *argv[])
{
    int c;
    unsigned int loadAddr = DEFAULT_LOAD_ADDR;
    unsigned int memBase = DEFAULT_MEM_BASE;
    unsigned int memSize = DEFAULT_MEM_SIZE;
    unsigned int startAddr = VECTOR_RESET;
    int max_cycles = -1;
    char *filename = DEFAULT_FILENAME;
    int help = 0;
    int trace = 0;
    unsigned int trace_mask = 1;
    int exitcode = 0;
    OR32 *sim = NULL;

    while ((c = getopt (argc, argv, "tv:l:b:s:f:c:x:")) != -1)
    {
        switch(c)
        {
            case 't':
                 trace = 1;
                 break;
            case 'v':
                 trace_mask = strtoul(optarg, NULL, 0);
                 break;
            case 'l':
                 loadAddr = strtoul(optarg, NULL, 0);
                 break;
            case 'b':
                 memBase = strtoul(optarg, NULL, 0);
                 break;
            case 's':
                 memSize = strtoul(optarg, NULL, 0);
                 break;
            case 'x':
                 startAddr = strtoul(optarg, NULL, 0);
                 break;
            case 'f':
                 filename = optarg;
                 break;
            case 'c':
                 max_cycles = (int)strtoul(optarg, NULL, 0);
                 break;
            case '?':
            default:
                help = 1;   
                break;
        }
    }

    if (help || filename == NULL)
    {
        fprintf (stderr,"Usage:\n");
        fprintf (stderr,"-f filename.bin = Executable to load (binary)\n");
        fprintf (stderr,"-t              = Enable program trace\n");
        fprintf (stderr,"-v 0xX          = Trace Mask\n");
        fprintf (stderr,"-b 0xnnnn       = Memory base address\n");
        fprintf (stderr,"-s 0xnnnn       = Memory size\n");
        fprintf (stderr,"-l 0xnnnn       = Executable load address\n");     
        fprintf (stderr,"-x 0xnnnn       = Executable boot address\n");     
        fprintf (stderr,"-c nnnn         = Max instructions to execute\n");
 
        exit(-1);
    }

    sim = new OR32(memBase, memSize);
    sim->Reset(startAddr);

    if (trace)
        sim->EnableTrace(trace_mask);

    FILE *f = fopen(filename, "rb");
    if (f)
    {
        long size;
        char *buf;

        // Get size
        fseek(f, 0, SEEK_END);
        size = ftell(f);
        rewind(f);

        buf = (char*)malloc(size+1);
        if (buf)
        {
            int wait_for_input = 0;

            // Read file data in
            int len = fread(buf, 1, size, f);
            buf[len] = 0;

            if (sim->Load(loadAddr, (unsigned char *)buf, len))
            {
                int cycles = 0;

                while (!sim->GetBreak() && !sim->GetFault())
                {
                    sim->Step();
                    cycles++;

                    if (max_cycles != -1 && max_cycles == cycles)
                        break;                  
                }
            }
            else
                fprintf (stderr,"Error: Could not load image to memory\n");

            free(buf);
            fclose(f);
        }
        // Show execution stats
        sim->DumpStats();
        
        if (sim->GetBreak())
        {
            printf("Exit code = %d\n", 0);
        }
    }
    else
        fprintf (stderr,"Error: Could not open %s\n", filename);

    delete sim;

    return exitcode;
}

