;段内跳转易错
assume cs:codesg
codesg segment
	mov ax,4c00h
	int 21h
start:mov ax,0
s:	nop  ;jmp short s1（不是转移到s1处，而是往上跳10个字节执行mov ax,4c00h）
	nop
	mov di,offset s
	mov si,offset s2
	mov ax,cs:[si]
	mov cs:[di],ax  ;使第一个nop变为s2处的内容即jmp short s1
s0:	jmp short s
s1:	mov ax,0
	int 21h   ;只有当ax=4c00h时,int 21h才会正常结束程序，否则报错
	mov ax,0
s2:	jmp short s1	;往上跳10字节
	nop
codesg ends
end start