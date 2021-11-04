;call和ret指令的配合使用
assume cs:code
code segment
start:mov ax,1
	mov cx,3
	call s	;将下一行的ip的值压入栈，然后跳转到s处执行
	mov bx,ax
	mov ax,4c00h
	int 21h
s:	add ax,ax ;1+1=2,cx=2,2+2=4,cx=1,4+4=8,cx=0,即2的3次方
	loop s
	ret	;将栈中的值出栈给ip,则跳至call s的下一行执行
code ends
end start