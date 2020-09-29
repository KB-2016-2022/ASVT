.globl _start
.data
x:	.long 1, 2, 3, 4, 5, 6
.text
_start:
	ldr 	r0, =x
	ldmia 	r0!, {r1-r10}
	ldr 	r1, =4090
	add 	r0, r0, r1
	stmia 	r0!, {r2-r11}

	mov 	r7, #1
	svc 	#0