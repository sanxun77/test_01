assume cs:code,ds:data,ss:stack
;用栈存储cx的值完成双层循环，实现将4行3列的字符串改为大写
data segment
	db 'ibm.............'	;16个字节
	db 'dec.............'
	db 'dos.............'
	db 'vax.............'
data ends

stack segment
	dw 0,0,0,0,0,0,0,0	;定义一个容量为16字节的栈段
stack ends

code segment
start:mov ax,data
	mov ds,ax
	mov bx,0	;每行为0~15单元，则首行索引为0，次行索引为16，以此类推
	
	mov ax,stack
	mov ss,ax
	mov sp,16	;空间为0~15，则栈顶指针初始即空栈时指向15+1
	
	mov cx,4	;四行
	s0:push cx	;将外层循环的cx值压栈
		mov si,0	;从第0列开始
		mov cx,3	;三列
		s1:mov al,[bx+si]	;将目标字母送入寄存器
			and al,11011111b	;改为大写
			mov [bx+si],al	;将修改后的字母放回段中
			inc si	;寻访下一列
			loop s
		add bx,16	;寻访下一行
		pop cx	;从栈顶弹出cx的值，恢复cx
		loop s0
	
	mov ax,4c00h
	int 21h
code ends
end start
	
		