


COPS = -Wall -O2 -nostdlib -nostartfiles -ffreestanding 
AOPS = --warn  

all : blinker01.bin

rstart.o : rstart.s
	or32-elf-as $(AOPS) rstart.s -o rstart.o

blinker01.o : blinker01.c
	or32-elf-gcc $(COPS) -c blinker01.c -o blinker01.o

blinker01.elf : memmap rstart.o blinker01.o
	or32-elf-ld -T memmap rstart.o blinker01.o -o blinker01.elf
	or32-elf-objdump -D blinker01.elf > blinker01.list

blinker01.bin : blinker01.elf
	or32-elf-objcopy blinker01.elf -O binary blinker01.bin

clean :
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
	rm -f *.list



