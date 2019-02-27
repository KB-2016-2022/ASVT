.model tiny
.code
org 100h
begin:
	jmp short _start
	nop
operator	db 'MBR.180K'
; BPB
BytesPerSec	dw 200h
SectPerClust	db 1
RsvdSectors	dw 1
NumFATs		db 2
RootEntryCnt	dw 64		; 2 А╔╙Б╝Ю═ ╜═ root dir
TotalSectors	dw 360	
MediaByte	db 0FCh		; 1 ё╝╚╝╒═ 9 А╔╙Б╝Ю╝╒ 40 Ф╗╚╗╜╓Ю╝╒
FATsize		dw 2		; 2 А╔╙Б╝Ю═ ╜═ ╙═╕╓К╘ FAT
SecPerTrk	dw 9
NumHeads	dw 1
HidSec		dw 0, 0
TotSec32	dd 0
DrvNum		db 0
Reserved	db 0
Signatura	db ')'		; 29h
; 
Vol_ID		db 'XDRV'
DiskLabel	db 'TestMBRdisk'
FATtype		db 'FAT12   '
;
; ╗Б╝ё╝ 1 А╔╙Б╝Ю MBR, 4 А╔╙Б╝Ю═ FATК ╗ 2 А╔╙Б╝Ю═ rootDir
; Б.╝. ╖═╜ОБ╝ 7 А╔╙Б╝Ю╝╒
; ╔И╔ 2 А ╜Ц╚╔╒╝╘ ╓╝Ю╝ё╗ ╖═╘╛╔╛ ╜═ А╒╝╘ root dir
;  ╗ ╝АБ═╔БАО 39 ╓╝Ю╝╕╔╙ ╜═ Д═╘╚К (╒╙╚НГ═О А╒╝╘ ╖═ёЮЦ╖Г╗╙)
;
_start:
	cld
	mov	ax, 0b800h
	mov	es, ax
	mov	di, 326
_1:
	xor	ah, ah
	int	16h
	cmp	ah, 0eh
	jz	_2
	cmp	ah, 1
	jz	_3
	cmp	ah, 48h
	jz	_up
	cmp	ah, 4bh
	jz	_left
	cmp	ah, 4dh
	jz	_right
	cmp	ah, 50h
	jz	_down
	mov	ah, 0ah
	stosw
	jmp	_1
_2:
	sub	di, 2
	mov	ax, 0020h
	stosw
	sub	di, 2
	jmp	_1
_3:
	int	19h
_up:
	sub	di, 160
	jmp	_1
_down:
	add	di, 160
	jmp	_1
_left:
	sub	di, 2
	jmp	_1
_right:
	add	di, 2
	jmp	_1
	nop
	nop
org	766
dw	0aa55h
end begin
