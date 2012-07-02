//-----------------------------------------------------------------
//                           AltOR32 
//              Alternative Lightweight OpenRisc 
//                     Ultra-Embedded.com
//                   Copyright 2011 - 2012
//
//               Email: admin@ultra-embedded.com
//
//                       License: LGPL
//
// If you would like a version with a different license for use 
// in commercial projects please contact the above email address 
// for more details.
//-----------------------------------------------------------------
//
// Copyright (C) 2011 - 2012 Ultra-Embedded.com
//
// This source file may be used and distributed without         
// restriction provided that this copyright statement is not    
// removed from the file and that any derivative work contains  
// the original copyright notice and the associated disclaimer. 
//
// This source file is free software; you can redistribute it   
// and/or modify it under the terms of the GNU Lesser General   
// Public License as published by the Free Software Foundation; 
// either version 2.1 of the License, or (at your option) any   
// later version.                                               
//
// This source is distributed in the hope that it will be       
// useful, but WITHOUT ANY WARRANTY; without even the implied   
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      
// PURPOSE.  See the GNU Lesser General Public License for more 
// details.                                                     
//
// You should have received a copy of the GNU Lesser General    
// Public License along with this source; if not, write to the 
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, 
// Boston, MA  02111-1307  USA              
//-----------------------------------------------------------------
#include <stdio.h>
#include <unistd.h>

#include "top.h"
#include "verilated.h"

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// main
//-----------------------------------------------------------------
int main(int argc, char **argv, char **env) 
{
    int c;
    int err;
    unsigned int loadAddr = 0x00000000;
    char *filename = NULL;
    int help = 0;
    int exitcode = 0;
    int cycles = -1;

    Verilated::commandArgs(argc, argv);

    while ((c = getopt (argc, argv, "f:l:c:")) != -1)
    {
        switch(c)
        {
            case 'l':
                 loadAddr = strtoul(optarg, NULL, 0);
                 break;
            case 'f':
                 filename = optarg;
                 break;
            case 'c':
                 cycles = strtoul(optarg, NULL, 0);
                 break;
            case '?':
            default:
                help = 1;	
                break;
        }
    }

    if (help)
    {
        fprintf (stderr,"Usage:\n");
        fprintf (stderr,"-t          = Enable program trace\n");
        fprintf (stderr,"-l 0xnnnn   = Executable load address\n");
        fprintf (stderr,"-f filename = Executable to load\n");
        fprintf (stderr,"-c num      = Max number of cycles\n");
 
        exit(0);
    }

    top_init();

    if (filename)
    {
        FILE *f;

        printf("Opening %s\n", filename);
        f = fopen(filename, "rb");
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
                unsigned int addr;

                // Read file data in
                int len = fread(buf, 1, size, f);
                buf[len] = 0;

                printf("Loading to 0x%x\n", loadAddr);
                for (addr=0;addr<len;addr++)
                    top_load(loadAddr + addr, buf[addr]);

                free(buf);
                fclose(f);
            }
        }
        else
        {
            printf("Could not read file!\n");
            exit(-1);
        }
    }

    // Run
    err = top_run(cycles);

    if (err == TOP_RES_FAULT)
        printf("FAULT PC %x!\n", top_getpc());

    top_done();

    printf("Exit\n");
    exit(0);
}
