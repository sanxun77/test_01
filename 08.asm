;计算data段中第一组数据的3次方，结果保存在后面一组dword单元中
assume cs:code
data segment
dw 1,2,3,4,5,6,7,8
dd 0,0,0,0,0,0,0,0
data ends

code segment
start:mov ax,data
	mov ds,ax
	mov di,16
	mov si,0
	mov cx,8
	
s:	mov bx,[si]
	call m
	mov [di],ax
	mov [di].2,dx
	add si,2
	add di,4
	loop s
	mov ax,4c00h
	int 21h
m:	mov ax,bx
	mul bx
	mul bx
	ret
code ends
end start 