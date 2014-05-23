MSetForBoss.dat	:	MemDump.elf
	$(OBJCOPY) -O binary $^ $@

MemDump.elf:	MemDump.S
	$(CC)	-nostartfiles -nostdlib -Ttext=0x00290000 MemDump.S -o $@

clean:
	@rm -f *.elf *.dat 
