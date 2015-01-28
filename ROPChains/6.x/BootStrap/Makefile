all:	MSetForBoss.dat boot.bin

MSetForBoss.dat	:	BootStrap.elf
	$(OBJCOPY) -O binary $< $@

BootStrap.elf:	BootStrap.S
	$(CC)	-nostartfiles -nostdlib -Ttext=0x00290000 -x assembler-with-cpp $< -o $@

boot.bin: boot.elf
	$(OBJCOPY) -O binary $< $@

boot.elf: boot.s
	$(CC)	-nostartfiles -nostdlib -Ttext=0 -x assembler-with-cpp $< -o $@

clean:
	@rm -f *.elf *.bin *.dat
