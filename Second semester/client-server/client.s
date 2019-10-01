.globl _start
.data
msg: 	.ascii "Hello from Orange Pi!\n"
lmsg = . -msg
.text
_start:
	mov 	r7, #281	@ socket
	mov 	r0, #2		@ ipv4
	mov	r1, #1 		@ socket type (TCP)
	mov 	r2, #0		@ так надо. потому что TCP
	svc	#0
@ todo: проверяем на ошибку при создании сокета
	mov 	r6, r0
	add 	r7, #2 		@ connect() получится 283 так, потому что понты
	ldr 	r1, =struct_addr
	mov 	r2, #16
	svc 	#0
@ todo: обработка щшибок
	add 	r7, #6 		@ send() получится 289 так, потому что понты
	mov 	r0, r6		@ файловый дескриптор сокета
	ldr 	r1, =msg
	mov 	r2, #lmsg
	eor 	r3, r3
	svc 	#0

	mov 	r7, #6		@ close()
	mov 	r0, r6
	svc 	#0

	mov 	r7, #1 		@ exit
	eor 	r0, r0
	svc 	#0

struct_addr:
	.ascii 	"\x02\x00"	@ AF_INET
	.ascii 	"\x1f\x90"	@ port 8080
	.byte 	127, 0, 0, 1	@ ip address 127.0.0.1
