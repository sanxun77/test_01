assume cs:code,ds:data,es:table

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992',
	db '1993','1994','1995'
	;以上表示21年的21个字符串//4*21=84=54h
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	;以上表示21年公司总收入的21个dword型数据//84+4*21=168=0A8h
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,45257,17800
	;以上表示21年公司雇佣人数的21个word型数据
data ends

table segment
	db 21 dup('year summ ne ?? ')
table ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov ax,table
	mov es,ax
	mov bx,0
	mov si,0
	mov di,0
	mov cx,21
	s:
		mov al,[bx]
		mov es:[di],al
		mov al,[bx+1]
		mov es:[di+1],al
		mov al,[bx+2]
		mov es:[di+2],al
		mov al,[bx+3]
		mov es:[di+3],al
		;以上8句的作用是存放年份
		mov ax,54h[bx]	;第一个'年收入'的段基址为54h
		mov dx,56h[bx]	;双字型数据存在ax和dx中
		mov es:5h[di],ax
		mov es:7h[di],dx
		;以上4句的作用是存放公司总收入
		mov ax,0A8h[si]	;第一个'人数'的段基址为0A8H
		mov es:0Ah[di],ax
		;以上2句存放公司的人数
		mov ax,54h[bx]
		mov dx,56h[bx]
		div word ptr ds:0A8h[si]
		mov es:0dh[di],ax
		;以上3句存放人均收入
		add bx,4
		add si,2
		add di,16
		;以上3句为下一次循环时存放数据做准备
		;3个寄存器递增的速度决定了所要存取的数据的偏移地址
	loop s
	mov ax,4c00h
	int 21h
code ends
end start
		