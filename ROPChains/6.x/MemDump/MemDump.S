	.arm
	.text

#define DUMPSTART 	0x00100000
#define DUMPSIZE	0x00300000

	.global	_start
@---------------------------------------------------------------------------------
_start:
	.word 0x0011be4d 		@ pop {r1, r2, r3, pc}
		.word FileName 		@ r1 (wchar* "YS:/memdump_6_x.bin")
		.word 0x00000006 	@ r2 (openflags)
		.word 0xdeadbeef 	@ r3 (garbage)
	.word 0x001a9349 		@ pop {r0, pc}
		.word FILE	    	@ r0 (_this)
	.word 0x001C08B8 		@ IFile_Open(_this, path, openflags)
		.word 0xdeadbeef 	@ r4 (garbage)
		.word 0xdeadbeef 	@ r5 (garbage)
		.word 0xdeadbeef 	@ r6 (garbage)
		.word 0xdeadbeef 	@ r7 (garbage)
		.word 0xdeadbeef 	@ r8 (garbage)
	.word 0x0011be4d		@ pop {r1, r2, r3, pc}
		.word byteswritten	@ r1 (&byteswritten)
		.word DUMPSTART		@ r2 (src)
		.word DUMPSIZE		@ r3 (size)
	.word 0x001a9349		@ pop {r0, pc}
		.word FILE		@ r0 (_this)
	.word 0x001BC384		@ IFile_Write(_this, &byteswritten, src, size)
		.word 0xdeadbeef	@ r4 (garbage)
		.word 0xdeadbeef	@ r5 (garbage)
		.word 0xdeadbeef	@ r6 (garbage)
		.word 0xdeadbeef	@ r7 (garbage)
		.word 0xdeadbeef	@ r8 (garbage)
		.word 0xdeadbeef	@ r9 (garbage)

FileName:
	.string16 "YS:/memdump_6_x.bin"

	.balign 32
FILE:	.fill	32, 1, 0
byteswritten:
	.word	0
