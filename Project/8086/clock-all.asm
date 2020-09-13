A	EQU   	0640H 		;8255A口
B	EQU   	0642H 		;8255B口
C	EQU   	0644H 		;8255C口
CTR	EQU   	0646H		;8255控制端口
TIMER0	EQU  	06C0H		;8254 1
TIMER1	EQU  	06C2H		;8254 2
TIMER2	EQU  	06C4H		;8254 3
TIMERM	EQU  	06C6H		;8254 控制端口
DATA	SEGMENT



PRE	DB 0FFH DUP(0FH)
DISCODE	DB		3FH,06H,5BH,4FH,66H,6DH,7DH,07H	;0--7的显示代码
		DB		7FH,6FH,77H,7CH,39H,5EH,79H,71H		;8--F的显示代码
INDEX	DB		00H,01H,02H,03H,04H,05H
BUFF	DB      3FH,3FH,3FH,3FH,3FH,3FH 	;动态显示缓冲
LOCATN	DB      0DFH,0EFH,0F7H,0FBH,0FDH,0FEH 	;动态显示位置控制
HOUR	DB		24			;小时
MINUTE	DB		60			;分钟
SECOND	DB		60			;秒
		
COUNT	DB		00
DATA 	ENDS

SSTACK		SEGMENT	PARA  STACK  'STACK'
DW	32	DUP(?)
SSTACK		ENDS

CODE	SEGMENT
ASSUME 	CS:CODE, DS:DATA,SS: SSTACK			
START:	
		MOV	AX,DATA	
		MOV	DS,AX	;初始化数据段
;--------------------------------------------------------------- 
INITA:	NOP
;----------------------------------------------------------------8259初始化
;-----------------------初始化中断向量表(MIR7,MIR6,STR1)---------
INITB:	PUSH	DS
		MOV	AX,0000H		;0~255中断向量表	
		MOV	DS,AX		
			
		MOV	AX,OFFSET	 MIR7
		MOV	SI,003CH		;0FH*4 = 003CH  偏移地址
		MOV	[SI],AX
		MOV	AX,CS
		MOV	SI,003EH				;003CH+2 = 003EH 段地址
		MOV	[SI],AX
INI:
		CLI	
		POP	DS		
;-------------------------------------------------------------初始化主片8259
		MOV	AL,13H
		OUT	20H,AL			;ICW1	00010011: 000:x 1:特征 0:边沿触发 0:x 1:单片 1:写ICW4
		MOV	AL,08H
		OUT	22H,AL			;ICW2	00001:中断向量码前5位
		MOV	AL,04H
		OUT	22H,AL			;ICW3	0000 0100: MIR2上连接从片
		MOV	AL,01H
		OUT	22H,AL			;ICW4	0000 0001: 000:特征 0:一般嵌套 00:非缓冲 0非自动EOI 1:8086特征

;-------------------------------------------------------------初始化从片8259 
		MOV AL, 11H 
		OUT 0A0H, AL 		;ICW1 	00010001: 000:x 1:特征 0:边沿触发 0:x 0:级联 1:写ICW4
		MOV AL, 30H 
		OUT	0A1H, AL 		;ICW2 	00110:中断向量码前5位
		MOV AL, 02H 
		OUT 0A1H, AL		;ICW3 	00000010: STR1上连接主片
		MOV AL, 01H 
		OUT 0A1H, AL 		;ICW4	10100001: 000:特征 0:一般嵌套 00:非缓冲 0:非自动EOI 1：8086特征

		MOV	AL,0FDH 	;从片OCW1 = 1111 1101B
		OUT	0A1H,AL 		
		MOV	AL,2BH		;主片OCW1 = 0010 1011B
		OUT	22H,AL	
		
		STI

;--------------------------------------------------------------- 初始化8254
INITC:	MOV	DX,TIMERM			;-------控制端口
		MOV	AL,36H				;00110110: 00:计数器0 11:先读写低8位，再读写高8位
		OUT	DX,AL
		MOV	DX,TIMER0			;-------计数器0
		MOV	AL,03H				;
		OUT	DX,AL
		MOV	AL,0E8H
		OUT	DX,AL
		
		MOV	DX,TIMERM			;-------控制端口
		MOV	AL,76H				;01110110: 01:计数器1
		OUT	DX,AL
		MOV	DX,TIMER1			;-------计数器1
		MOV	AL,03H
		OUT	DX,AL
		MOV	AL,0E8H
		OUT	DX,AL
		
		LEA DI,BUFF			;时间缓冲
		LEA SI,LOCATN		;显示掩码
;----------------------------------------------------------------------------8255初始化
MOV 	DX,CTR			
		MOV AL,80H		;ABC方式0，输出
		OUT DX,AL

;----------------------------------------------------------------------------
SHOW:	
	
		MOV DX,B;-------------------------------------时
		MOV AL,0FFH		;全部关闭
		OUT DX,AL
		
		MOV DX,A
		MOV AL,[DI]	
		OUT DX,AL
		
		MOV DX,B
		MOV AL,[SI]
		OUT DX,AL
		
		MOV DX,B
		MOV AL,0FFH		;全部关闭
		OUT DX,AL;---------------
		
		MOV DX,A
		MOV AL,[DI+1]	
		OR AL,80H
		OUT DX,AL
		
		MOV DX,B
		MOV AL,[SI+1]
		OUT DX,AL
		
		MOV DX,B
		MOV AL,0FFH		;全部关闭
		OUT DX,AL;-------------------------------------时
		
		MOV DX,B;-------------------------------------分
		MOV AL,0FFH		;全部关闭
		OUT DX,AL
		
		MOV DX,A
		MOV AL,[DI+2]	
		OUT DX,AL
		
		MOV DX,B
		MOV AL,[SI+2]
		OUT DX,AL
		
		MOV DX,B
		MOV AL,0FFH		;全部关闭
		OUT DX,AL;---------------
		
		MOV DX,A
		MOV AL,[DI+3]
		OR AL,80H		
		OUT DX,AL
		
		MOV DX,B
		MOV AL,[SI+3]
		OUT DX,AL
		
		MOV DX,B
		MOV AL,0FFH		;全部关闭
		OUT DX,AL;-------------------------------------分
		
		MOV DX,B;-------------------------------------秒
		MOV AL,0FFH		;全部关闭
		OUT DX,AL
		
		MOV DX,A
		MOV AL,[DI+4]	
		OUT DX,AL
		
		MOV DX,B
		MOV AL,[SI+4]
		OUT DX,AL
		
		MOV DX,B
		MOV AL,0FFH		;全部关闭
		OUT DX,AL;---------------
		
		MOV DX,A
		MOV AL,[DI+5]	
		OUT DX,AL
		
		MOV DX,B
		MOV AL,[SI+5]
		OUT DX,AL
		
		MOV DX,B
		MOV AL,0FFH		;全部关闭
		OUT DX,AL;-------------------------------------秒
		
		JMP SHOW
		
;--------------------------------------------------------------- 


MIR7	PROC NEAR

		PUSH SI
		PUSH DI

		MOV AX,0H
		
		;-------------------------------------------
		;-------------------------------------------BL:时(个)
		;-------------------------------------------BH:时(十)
		;-------------------------------------------CL:分(个)
		;-------------------------------------------CH:分(十)
		;-------------------------------------------DL:秒(个)
		;-------------------------------------------DH:秒(十)
		;秒+1
		MOV SI,OFFSET INDEX
		MOV DI,OFFSET DISCODE
		MOV BX,OFFSET BUFF
		
		LEA DX,DISCODE
		MOV	AL,[SI+5]			;-----------秒(个)
		INC AL			;++
		CMP AL,0AH
		JZ TMCG			;如果到10
		MOV [SI+5],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+5],AL
		JMP DONE
TMCG:	
		MOV AL,0H	;重新计数
		MOV [SI+5],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+5],AL
		
		LEA DI,DISCODE
		MOV AL,[SI+4]			;-----------秒(十)
		INC AL			;++
		CMP AL,06H
		JZ	TMCS
		MOV [SI+4],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+4],AL
		JMP DONE
TMCS:
		MOV AL,0H
		MOV [SI+4],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+4],AL
		
		
		LEA DI,DISCODE
		MOV AL,[SI+3]			;-----------分(个)
		INC AL
		CMP AL,0AH
		JZ TFCG
		MOV [SI+3],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+3],AL
		JMP DONE
TFCG:	
		MOV AL,0H
		MOV [SI+3],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+3],AL
		
		LEA DI,DISCODE
		MOV AL,[SI+2]			;------------分(十)
		INC AL
		CMP AL,06H
		JZ TFCS
		MOV [SI+2],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+2],AL
		JMP DONE
TFCS:	
		MOV AL,0H
		MOV [SI+2],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+2],AL
		
		LEA DI,DISCODE
		MOV AL,[SI+1]			;-------------时(个)
		INC AL
		CMP AL,0AH
		JZ TSCG
		MOV [SI+1],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+1],AL
		JMP DONE
TSCG:	
		MOV AL,0H
		MOV [SI+1],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX+1],AL
		
		LEA DI,DISCODE
		MOV AL,[SI]				;-------------时(十)
		INC AL
		CMP AL,02H
		JZ TSCS
		MOV [SI],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX],AL
		JMP DONE
TSCS:	
		MOV AL,0H
		MOV [SI],AL
		ADD DI,AX
		MOV AL,[DI]		;取数码管码
		MOV [BX],AL	
	
		;-------------------------------------------
DONE:					;00100000 :OCW2 手动结束EOI
						;主片

		;MOV	AL,20H
		;OUT	20H,AL	

		POP DI
		POP SI
		RET
MIR7	ENDP	
;---------------------------------------------------------------MIR7

;---------------------------------------------------------------MIR6

;---------------------------------------------------------------SIR1

CODE	ENDS
END	START