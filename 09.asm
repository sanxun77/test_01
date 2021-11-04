;在屏幕的8行3列用绿色显示data段中的字符串
assume cs:code
data segment
	db 'Welcome to masm!'
data ends

code segment
start:mov dh,8
	mov dl,3	;dl装列号(范围1-80)，每超过80等于行号+1
	mov cl,2	;cl中存放颜色属性(0cah为红底高亮闪烁绿色属性)
	mov ax,data
	mov ds,ax
	mov si,0
	call show_str
	
	mov ax,4c00h
	int 21h
show_str:	;显示字符串的子程序
	push cx
	push si
	
	mov al,0A0h	;每行有80*2=160个字节=0A0h个字节内容
	
	dec dh		;行号在显存中下标从0开始，所以减1
	mul dh		;相当于从(n-1)*0A0h个Byte单元开始
	
	mov bx,ax	;定位好的位置偏移地址存放在bx里(行)
	
	mov al,2	;每个字符占两个字节
	mul dl		;定位列，结果ax存放的是定位好的列的位置
	sub ax,2	;列号在显存中下标从0开始，因为偶字节存放字符所以减2
	
	add bx,ax	;此时bx中存放的是行与列号的偏移地址
	
	mov ax,0B800h	;显存开始的地址
	mov es,ax		;es中存放的是显存的第0页(共0-7页)的起始段地址
	
	mov di,0	;di指向显存的偏移地址
	
	mov al,cl	;cl是存放颜色的参数，这时候al存放颜色,因为cl下边要用来临时存放要处理的字符
	
	mov ch,0	;下边cx存放的是每次准备处理的字符
	
s:	mov cl,ds:[si]	;ds:[si]指向“Welcome to masm!”,0

	jcxz ok			;当cl=0时,cx=0,则发生跳转到ok处结束处理
	
	mov es:[bx+di],cl	;偶地址存放字符
	mov es:[bx+di+1],al	;奇地址存放字符的颜色属性
	
	inc si
	
	add di,2	;指向了下个字符
	jmp short s	;无条件跳转
	ok:	pop si
		pop cx
		ret
code ends
end start
	