;在屏幕中间打印三行字符串,第一行绿字，第二行绿底红字，第三行白底蓝字
;显存：B8000H~BFFFFH共32KB的空间，为80*25(80列25行)彩色字符模式的显示缓冲区
;向这个地址空间写入数据，写入的内容将立即出现在显示器上
;一个字符在显示缓冲区中占两个字节，分别存放字符的ASCII码和颜色属性
;80*25模式下，一屏的内容在显示缓冲区中占4000个字节
;显示缓冲区分为8页，每页4KB(约4000B)
;一般情况下显示第0页内容，即B8000H~B8F9FH中的4000个字节
;偏移000~09F对应显示器上的第一行(80个字符占160个字节)，0A0~13F对应第二行
;闪烁的效果必须在全屏dos方式下才能看到
assume cs:code,ds:data,ss:stack
data segment
	db 'welcome to masm!'	;定义要显示的字符串(共16字节)
	db 02h,24h,71h			;定义三种颜色属性
data ends

stack segment
	dw 8 dup(0)
stack ends

code segment
start:mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,10h
	xor bx,bx	;相减,bx清零，用来索引颜色
	mov ax,0b872h	;***算出屏幕第12行中间的显存段起始位置放入ax中***
	mov cx,3	;s3循环控制行数，外循环3次，因为要显示3个字符串
s3:	push cx		;3个进栈操作为外循环s3保存相关寄存器的值
	push ax		;防止它们的值在内循环中被破坏
	push bx
	mov es,ax	;es为屏幕第12行中间的显存的段起始位置
	mov si,0	;si用来索引代码列的字符
	mov di,0	;di用来定位目标列
	
	mov cx,10h
	;s1循环控制存放的字符，内循环10h(16字节)次，因为1个字符串中含10h个字节
	s1:	mov al,ds:[si]
		mov es:[di],al
		inc si
		add di,2
		loop s1		;次循环实现偶地址中存放字符
		
	mov di,1	;di的值设为1，从而为在显存奇地址中存放字符的颜色属性做准备
	pop bx
	mov al,ds:10h[bx]	;***取颜色属性***
	inc bx
	mov cx,10h	;第二个内循环也为10h次
	s2:	mov es:[di],al
		add di,2
		loop s2	;此循环实现奇地址中存放字符的颜色属性
		
	;以下4句为下一趟外循环做准备
	pop ax
	add ax,0ah	;***将显存的段起始地址设为当前行的下一行***
	;在段地址中加0ah,相当于在偏移地址中加了0a0h(=160d)
	pop cx
	loop s3
	mov ax,4cooh
	int 21h
code ends
end start 
	
	