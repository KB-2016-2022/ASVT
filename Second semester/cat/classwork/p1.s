.globl _start
.data
msg:	.ascii "Ошибка!\n"
maxfilelen = 2000000
lmsg = . - msg

@ .byte	0x1b
@ .ascii "[0m"			@ функцией 4 работать не будет
@ 
@ long 	0x6d305b1b

.bss
.lcomm	filelen, 4
.lcomm	filebuffer, maxfilelen
.text
typeerror:
	push 	{lr}
	mov 	r7, #4
	mov 	r0, #1
	ldr 	r1, =msg
	mov 	r2, #lmsg
	svc 	#0
	pop 	{r15}

exit:
	mov 	r7, #1
	eor 	r0, r0			@ xor
	svc 	#0
_start:
	mov	r7, #3
	mov	r0, #5
	ldr 	r1, =filebuffer
@	mov 	r2, #maxfilelen 	@ ОШИБКА
	ldr 	r2, =maxfilelen
	svc 	#0
	cmp 	r0, #0			@ Сравнивает r0 c -1
	bgt 	1f			@ jump		f - forward
	bl 	typeerror
	b 	exit
1:
	ldr 	r1, =filelen
	str 	r0, [r1]		@ берет р1 как адрес и туда кладём р0

	bl 	upper_case

	mov 	r7, #4
	mov 	r0, #1
	ldr 	r1, =filebuffer
	ldr 	r2, =filelen
	ldr 	r2, [r2]
	svc 	#0
	b 	exit
upper_case:
	ldr 	r0, =filebuffer
	ldr 	r1, =filelen
	ldr 	r1, [r1]
	eor 	r2, r2
	eor 	r3, r3
1:
	ldrb 	r3, [r0, r2]		@ в р3 кладём значение по адресу р0+р2		считали мы байт
	cmp 	r3, #0x61
	bmi	2f 			@ Если меньше то нам делать ничего не надо
	cmp	r3, #0x7b
	submi	r3, #0x20		@ Вычли при условии

2: 
	strb 	r3, [r0, r2]
	add 	r2, #1

	subs 	r1, #1			@ s - чтобы sub поставил флаги
	bne 	1b
	bx 	lr 			@ выйти из подпрограммы
