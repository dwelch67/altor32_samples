

test.bin : test.s
	or32-elf-as test.s -o test.o
	or32-elf-ld -T memmap test.o -o test.elf
	or32-elf-objcopy test.elf -O binary test.bin

clean :
	rm -f *.o
	rm -f *.elf
	rm -f *.bin



