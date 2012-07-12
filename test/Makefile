


COPS = -Wall -O2 -nostdlib -nostartfiles -ffreestanding 
AOPS = --warn  

all : test.bin

rstart.o : rstart.s
	or32-elf-as $(AOPS) rstart.s -o rstart.o

test.o : test.c
	or32-elf-gcc $(COPS) -c test.c -o test.o

test.elf : memmap rstart.o test.o
	or32-elf-ld -T memmap rstart.o test.o -o test.elf
	or32-elf-objdump -D test.elf > test.list

test.bin : test.elf
	or32-elf-objcopy test.elf -O binary test.bin

clean :
	rm -f *.o
	rm -f *.elf
	rm -f *.bin
	rm -f *.list



