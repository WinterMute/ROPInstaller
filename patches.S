@---------------------------------------------------------------------------------
@	Patch file format
@
@	0	4	Header - 'PPOR'
@	4	4	offset to index
@
@	index entry
@	0	4	Firmware revision this patch set applies to
@	8	4	Offset in file to patch set
@
@	patch set
@	0	4	Header	- 'PTCH'
@	4	4	Number of patches
@
@	for each patch
@	0	4	size of patch
@	4	4	offset in user settings to patch
@	8	...	patch data
@---------------------------------------------------------------------------------

	.arm
	.text

	.global	_start
@---------------------------------------------------------------------------------
_start:
	.word	0x524f5050
	.word	index

@---------------------------------------------------------------------------------
patch_4_x_description:
@---------------------------------------------------------------------------------
	.asciz	"4.x eur/jpn/usa/kor"

#define	P4_LOAD_ADDRESS		0x00279400
#define	P4_S2_LOAD_ADDRESS	0x002b0000
#define	P4_DATA_ADDRESS		0x00279000
#define P4_READ_SIZE		0x9000

@---------------------------------------------------------------------------------
patch_4_x_1:
@---------------------------------------------------------------------------------
	.word	p4_1_end - p4_1_start
	.word	0

@---------------------------------------------------------------------------------
p4_1_start:
@---------------------------------------------------------------------------------
	.word 0x0010f2b9		@ pop {r0,r2,pc}
	.word 0x00272bae		@ (r0) (char * "YS:")
	.word 0xdeadbeef		@ (r2)
	.word 0x0018f19c		@ FS_MOUNTSDMC(), ends with  ldmfd   sp!, {r3-r5,pc}
	.word 0xdeadbeef		@ (r3)
	.word 0xdeadbeef		@ (r4)
	.word 0xdeadbeef		@ (r5)
	.word 0x0010f2b9		@ pop {r0,r2,pc}
	.word P4_DATA_ADDRESS		@ (r0) _this
	.word 0x00000001		@ (r2) openflags
	.word 0x001549e1		@ pop {r1,pc}
	.word 0x00276f64		@ (utf16* "YS:/MsetForBoss.dat")
	.word 0x001b82ac		@ IFile_Open(): r0=_this r1=UTF16 path r2=openflags, ends with ldmfd sp!, {r4-r8,pc}
	.word 0xdeadbeef		@ (r4)
	.word 0xdeadbeef		@ (r5)
	.word 0xdeadbeef		@ (r6)
	.word 0xdeadbeef		@ (r7)
	.word 0xdeadbeef		@ (r8)
	.word 0x0010f2b9		@ pop {r0,r2,pc}
	.word P4_DATA_ADDRESS		@ (r0) _this
	.word P4_S2_LOAD_ADDRESS	@ (r2) buffer
	.word 0x001549e1		@ pop {r1,pc}
	.word P4_DATA_ADDRESS + 32	@ (r1) &readbytes
	.word 0x0010538c		@ pop {r3,pc}
	.word P4_READ_SIZE		@ (r3) size
	.word 0x001b3958		@ IFile_Read(): r0=_this r1=&readbytes r2=readbuf r3=size, ends with ldmfd sp!,{r4-r9,pc}
					@ This reads the first READ_SIZE bytes from the file to S2_LOAD_ADDRESS.
	.word 0xdeadbeef		@ (r4)
	.word 0xdeadbeef		@ (r5)
	.word 0xbadc0ded		@ (r6) - gets overwritten with counter and CRC1
	.word 0xdeadbeef		@ (r7)
	.word 0xdeadbeef		@ (r8)
	.word 0xdeadbeef		@ (r9)
	.word 0x0010538c		@ pop {r3,pc}

	.word (P4_S2_LOAD_ADDRESS-(P4_LOAD_ADDRESS+p4_1_end-p4_1_start))

	.word 0x00143d60		@ add sp,sp,r3 | ldr pc,[sp],#4
@---------------------------------------------------------------------------------
p4_1_end:
@---------------------------------------------------------------------------------

@---------------------------------------------------------------------------------
patch_4_x_2:
@---------------------------------------------------------------------------------
	.word	p4_2_end - p4_2_start
	.word	0x1b4

@---------------------------------------------------------------------------------
p4_2_start:
@---------------------------------------------------------------------------------
	.word 0x0010f2b9			@ pop {r0,r2,pc}
	.word 0x0001fe00			@ (r0) offset in firmware
	.word 0x00000100			@ (r2) size
	.word 0x001549e1			@ pop {r1,pc}
	.word P4_LOAD_ADDRESS			@ (r1) dst
	.word 0x001334fc			@ cfg:nor::ReadData(offset,dst,size), ends with ldmfd   sp!,{r4,pc}
	.word 0xdeadbeef			@ (r4)
	.word 0x0010538c			@ pop {r3,pc}
	.word P4_LOAD_ADDRESS - 0x0fffff64	@ (r3)
	.word 0x00143d60			@ add sp,sp,r3 | ldr pc,[sp],#4
@---------------------------------------------------------------------------------
p4_2_end:
@---------------------------------------------------------------------------------

@---------------------------------------------------------------------------------
patch_6_x_description:
@---------------------------------------------------------------------------------
	.asciz	"6.x eur/jpn/usa/kor"

@---------------------------------------------------------------------------------
#define	P6_DATAADR	0x00287000
#define	P6_SECPAYADR	0x00297000
#define	P6_TRDPAYADR	0x00290000
@---------------------------------------------------------------------------------

@---------------------------------------------------------------------------------
patch_6_x_1:
@---------------------------------------------------------------------------------
	.word	p6_1_end - p6_1_start
	.word	0

@---------------------------------------------------------------------------------
p6_1_start:
@---------------------------------------------------------------------------------
	.word 0x001a9349 		@ pop	{r0, pc}
	.word 0x00280252 		@ r0 (char* "YS:")
	.word 0x0019B498 		@ FS_MOUNTSDMC()
	.word 0xDEADDEAD 		@ r3 (garbage)
	.word 0xDEADDEAD 		@ r4 (garbage)
	.word 0xDEADDEAD 		@ r5 (garbage)
	.word 0x0011be4d 		@ pop {r1, r2, r3, pc}
	.word 0x002846D8 		@ r1 (wchar* "YS:/MsetForBoss.dat")
	.word 0x00000001 		@ r2 (openflags)
	.word 0xDEADDEAD 		@ r3 (garbage)
	.word 0x001a9349 		@ pop	{r0, pc}
	.word P6_DATAADR    		@ r0 (_this)
	.word 0x001C08B8 		@ IFile_Open(_this, path, openflags)
	.word 0xDEADDEAD 		@ r4 (garbage)
	.word 0xDEADDEAD 		@ r5 (garbage)
	.word 0xDEADDEAD 		@ r6 (garbage)
	.word 0xDEADDEAD 		@ r7 (garbage)
	.word 0xDEADDEAD 		@ r8 (garbage)
	.word 0x0011be4d 		@ pop {r1, r2, r3, pc}
	.word P6_DATAADR+32 		@ r1 (&readbytes)
	.word P6_TRDPAYADR  		@ r2 (dst)
	.word 0x00007000 		@ r3 (size)
	.word 0x001a9349 		@ pop	{r0, pc}
	.word P6_DATAADR    		@ r0 (_this)
	.word 0x001BC18C 		@ IFile_Read(_this, &readbytes, dst, size)
	.word 0xDEADDEAD 		@ r4 (garbage)
	.word 0xDEADDEAD 		@ r5 (garbage)
	.word 0xDEADDEAD 		@ r6 (garbage)
	.word 0xBADC0DED 		@ r7 (garbage) - is replaced by counter and CRC1
	.word 0xDEADDEAD 		@ r8 (garbage)
	.word 0xDEADDEAD 		@ r9 (garbage)
	.word 0x00144BA4 		@ pop {r3} | add sp, sp, r3 | pop {pc}
	.word (P6_TRDPAYADR-(P6_SECPAYADR+p6_1_end-p6_1_start)) @ r3
@---------------------------------------------------------------------------------
p6_1_end:
@---------------------------------------------------------------------------------

@---------------------------------------------------------------------------------
patch_6_x_2:
@---------------------------------------------------------------------------------
	.word	p6_2_end - p6_2_start
	.word	0x1b4

@---------------------------------------------------------------------------------
p6_2_start:
@---------------------------------------------------------------------------------
	.word 0x0011be4d 		@ pop {r1, r2, r3, pc}
	.word P6_SECPAYADR  		@ r1 (dst address)
	.word 0x00000100 		@ r2 (size)
	.word 0xDEADDEAD 		@ r3 (garbage)
	.word 0x001a9349 		@ pop	{r0, pc}
	.word 0x0001FE00 		@ r0 (offset)
	.word 0x00133838 		@ cfg:nor::ReadData(offset,dst,size), ends in ldmfd sp!, {r4,pc}
	.word 0xDEADDEAD 		@ r4 (garbage)
	.word 0x00144BA4 		@ pop {r3} | add sp, sp, r3 | pop {pc}
	.word (P6_SECPAYADR-0x0FFFFF64)	@ r3


@---------------------------------------------------------------------------------
p6_2_end:
@---------------------------------------------------------------------------------

@---------------------------------------------------------------------------------
patch_count1:
@---------------------------------------------------------------------------------
	.word	2
	.word	0x70

	.word	0x51

@---------------------------------------------------------------------------------
patch_count2:
@---------------------------------------------------------------------------------

	.word	2
	.word	0x170

	.hword	0x52

@---------------------------------------------------------------------------------
patch_message_length:
@---------------------------------------------------------------------------------

	.word	2
	.word	0x150

	.hword	0x6e

@---------------------------------------------------------------------------------
patch_4_x:
@---------------------------------------------------------------------------------
	.word	0x50544348
	.word	5
	.word	patch_4_x_1
	.word	patch_4_x_2
	.word	patch_count1
	.word	patch_count2
	.word	patch_message_length


@---------------------------------------------------------------------------------
patch_6_x:
@---------------------------------------------------------------------------------
	.word	0x50544348
	.word	5
	.word	patch_6_x_1
	.word	patch_6_x_2
	.word	patch_count1
	.word	patch_count2
	.word	patch_message_length

@---------------------------------------------------------------------------------
index:
@---------------------------------------------------------------------------------
	.word	patch_4_x_description
	.word	patch_4_x

	.word	patch_6_x_description
	.word	patch_6_x
