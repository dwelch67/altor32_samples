


COPS = -Wall -O2 -nostdlib -nostartfiles -ffreestanding 
AOPS = --warn  

all : blinker02.bin

rstart.o : rstart.s
	or32-elf-as $(AOPS) rstart.s -o rstart.o

blinker02.o : blinker02.c
	or32-elf-gcc $(COPS) -c blinker02.c -o blinker02.o

blinker02.elf : memmap rstart.o blinker02.o
	or32-elf-ld -T memmap rstart.o blinker02.o -o blinker02.elf
	or32-elf-objdump -D blinker02.elf > blinker02.list

blinker02.bin : blinker02.elf
	or32-elf-objcopy blinker02.elf -O binary blinker02.bin

clean :
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
	rm -f *.list



