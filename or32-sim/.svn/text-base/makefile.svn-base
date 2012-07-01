###############################################################################
## Simulator Makefile
###############################################################################

# Target
TARGET		= or32-sim

# Options
CFLAGS	    = 
LDFLAGS     = 

# Source Files
OBJ = main.o or32.o or32_inst_dump.o

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

$(TARGET): $(OBJ) makefile
	g++ $(LDFLAGS) $(LIBS) $(OBJ) -o $@

