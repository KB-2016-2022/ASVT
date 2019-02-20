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
RootEntryCnt	dw 64		; 2 сектора на root dir
TotalSectors	dw 360	
MediaByte	db 0FCh		; 1 голова 9 секторов 40 цилиндров
FATsize		dw 2		; 2 сектора на каждый FAT
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
; итого 1 сектор MBR, 4 сектора FATы и 2 сектора rootDir
; т.о. занято 7 секторов
; еще 2 с нулевой дороги займем на свой root dir
;  и остается 39 дорожек на файлы (включая свой загрузчик)
;
_start:
;hig;olyj;uj;ugtuifihhlcgo;ud
	nop
	nop
org	766
dw	0aa55h
end begin
