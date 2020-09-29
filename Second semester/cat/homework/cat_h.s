.globl _start
.data
msg:	.ascii "Ошибка!\n"
lmsg = . - msg
maxfilelen = 2000000

.bss
.lcomm	filelen, 4
.lcomm	filebuffer, maxfilelen
.lcomm	resultbuffer, maxfilelen

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
	cmp 	r0, #0			
	bgt 	1f			@ jump		f - forward
	bl 	typeerror
	b 	exit
1:
	ldr 	r1, =filelen
	str 	r0, [r1]		@ берет р1 как адрес и туда кладём р0

@	bl 	upper_case

	ldr 	r0, =filebuffer		@ ссылка на буфер, из которого читаем
	ldr 	r1, =filelen		@ 
	ldr 	r1, [r1]		@ кладём длинну файла
	ldr 	r4, =resultbuffer	@ ссылка на буфер, куда пишем отформатировнный текст

	eor 	r7, r7 			@ слово не началось

	eor 	r2, r2			@ смещение в первом буфере
	eor 	r3, r3			@ рассматриваемый символ
	eor 	r5, r5 			@ смещение во втором буфере

	bl 	format_on
2:
	ldrb 	r3, [r0, r2]		@ в р3 кладём значение по адресу р0+р2		считали мы байт
	cmp 	r7, #0			@ проверяем не началось ли слово
	beq	5f
	cmp 	r3, #0x20		@ сравнили с пробелом
	beq 	4f
	cmp 	r3, #0x09 		@ сравнили с табом
	beq 	4f
	cmp 	r3, #0x0a		@ сравнили с /n
	bne 	3f
	eor 	r7, r7			@ слово не началось
	bl 	format_on		@ включаем форматирование
	b 	6f
3:
@ это не /n. применяем капс
	cmp 	r6, #0
	beq 	6f
	bl 	upper
	b 	6f
4:
@ это пробел или табуляция. выключаем форматирование
	bl 	format_off
	b 	6f
5:
@ слово не начиналось. началось ли сейчас?
	cmp 	r3, #0x20 		@ сравниваем
	beq 	6f 
	cmp 	r3, #0x09
	beq 	6f
	cmp 	r3, #0x0a
	beq 	6f

	mov 	r7, #1
	bl 	upper
6:
	strb 	r3, [r4, r5]
	add 	r2, #1
	add 	r5, #1

	subs 	r1, #1			@ s - чтобы sub поставил флаги
	bne 	2b

write:
	mov 	r7, #4
	mov 	r0, #1
	ldr 	r1, =resultbuffer
@	ldr 	r2, =filelen
@	ldr 	r2, [r2]
	ldr 	r2, r5

	svc 	#0
	b 	exit

format_on:
	push 	{lr}
	mov 	r6, #1 			@ форматирование вкл
	bl 	bold
	bl 	green
@	bx 	lr
	pop 	{r15}

format_off:
	eor 	r6, r6 			@ форматирование выкл
	eor 	r9, r9

	mov 	r9, #0x1b
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x5b
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x30
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x6d
	str 	r9, [r4, r5]
	add 	r5, #1

	bx 	lr

bold:
	eor 	r9, r9

	mov 	r9, #0x1b
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x5b
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x31
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x6d
	str 	r9, [r4, r5]
	add 	r5, #1
	bx 	lr
green:
	eor 	r9, r9

	mov 	r9, #0x1b
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x5b
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x33
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x32
	str 	r9, [r4, r5]
	add 	r5, #1

	mov 	r9, #0x6d
	str 	r9, [r4, r5]
	add 	r5, #1
	bx 	lr
upper:
	cmp 	r3, #0x61
	bmi	1f 			@ Если меньше то нам делать ничего не надо
	cmp	r3, #0x7b
	submi	r3, #0x20		@ Вычли при условии
1:
	bx 	lr

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
