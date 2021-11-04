;计算1000000/10(F4240H/0AH)
;进行不会溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
;参数：ax=dword数据的低16位，dx=dword数据的高16位，cx=除数
;返回：ax=dword结果的低16位，dx=dword结果的高16位，cx=余数
;X:被除数[0,FFFFFFFF]，N:除数[0,FFFF]，H:X高16位，L:X低16位
;X/N=int(H/N)*65536+[rem(H/N)*65536+L]/N