###############################################################################
## Simulator Makefile
###############################################################################

# Target
TARGET		= altor32-sim

# Options
CFLAGS	    = 
LDFLAGS     = 

# Source Files
OBJ = main.o altor32.o altor32_inst_dump.o

###############################################################################
# Rules
###############################################################################
all: $(TARGET)
	
clean:
	-rm *.o $(TARGET)

%.o : %.c
	gcc -c $(CFLAGS) $< -o $@

%.o : %.cpp
	g++ -c $(CFLAGS) $< -o $@

$(TARGET): $(OBJ) Makefile
	g++ $(LDFLAGS) $(LIBS) $(OBJ) -o $@

