;将以0结尾的多行字符串改为大写,jcxz的使用
assume cs:code

data segment
	db 'word',0
	db 'unix',0
	db 'wind',0
	db 'good',0
data ends

code segment
start:mov ax,data
	mov ds,ax
	mov si,0
	mov cx,4
s:	
	call capital
	add si,5
	loop s
	mov ax,4c00h
	int 21h
capital:mov cl,[si]
	mov ch,0
	jcxz ok
	and byte ptr [si],11011111b
	inc si
	jmp short capital
ok:	ret
code ends
end start

;cx引发错误