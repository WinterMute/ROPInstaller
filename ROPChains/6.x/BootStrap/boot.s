#define	GSPHEAP 0x14000000

#define	FBOFFSET (GSPHEAP+0x184E61)

	.global _start
_start:
	ldr	r0, =FBOFFSET
	ldr	r1, =0xFFFFFFFF
	mov	r2, #0
	ldr	r3, =(240*400*3)

loop:
	add	r4, r0, r2
	strb	r1, [r4, #0]
	strb	r1, [r4, #1]
	strb	r1, [r4, #2]
	add	r1, r1, #1
	add	r2, #3
	cmp	r2, r3
	movge	r2, #0
	b	loop


	.pool
