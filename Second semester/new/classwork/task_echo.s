.globl _start
.text
_start:
	eor 	r0, r0
	bl 	getche
	cmp 	r0, #27
	bne 	_start
	mov 	r7, #1
	svc 	#0
