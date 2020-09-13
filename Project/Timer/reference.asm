P8255A 		EQU   	0600H 		;8255A口
P8255B 		EQU   	0602H 		;8255B口
P8255C 		EQU   	0604H 		;8255C口
P8255M	 	EQU   	0606H		;8255控制端口
TIMER0    	EQU  	06C0H		;8254 1
TIMER1    	EQU  	06C2H		;8254 2
TIMER2	   	EQU  	06C4H		;8254 3
TIMERM 		EQU  	06C6H		;8254 控制端口
DATA 		SEGMENT 
DISCODE	DB		3FH,06H,5BH,4FH,66H,6DH,7DH,07H	;0--7的显示代码
		DB		7FH,6FH,77H,7CH,39H,5EH,79H,71H		;8--F的显示代码
INDEX	DB		00H,00H,00H,00H,00H,00H,0CCH,0CCH
DYNBUFF	DB      00H,00H,00H,00H,00H,00H,00H,00H 	;动态显示缓冲
LOCATN		DB      00H,00H,00H,00H,00H,00H,00H,00H 	;动态显示位置控制
HOUR		DB		12			;小时
MINUTE		DB		34			;分钟
SECOND		DB		50			;秒
			
COUNT		DB		100
DATA 		ENDS

SSTACK		SEGMENT	PARA  STACK  'STACK'
DW	32	DUP(?)
SSTACK		ENDS

CODE	SEGMENT 
ASSUME 	CS:CODE, DS:DATA,SS: SSTACK			
START:	MOV	AX,DATA	
		MOV	DS,AX	;初始化数据段
;--------------------------------------------------------------- 8255初始化
INITA:	NOP
;------------------------------------------------------------------
INITB:	PUSH	DS
		MOV	AX,0000H		;0~255中断向量表	
		MOV	DS,AX		
		MOV	AX,OFFSET	 MIR7
		MOV	SI,003CH		;0FH*4 = 003CH  偏移地址
		MOV	[SI],AX
		MOV	AX,CS
		MOV	SI,003EH		; 003CH+2 = 003EH 段地址
		MOV	[SI],AX
		MOV	AX,OFFSET	 MIR6
		MOV	SI,0038H		;0EH*4 = 0038H 偏移地址
		MOV	[SI],AX
		MOV	AX,CS
		MOV	SI,003AH		;0038H+2 = 003AH 段地址
		MOV	[SI],AX
		MOV AX, OFFSET	 SIR1 
		MOV SI, 00C4H 
		MOV [SI], AX 
		MOV	AX, CS 
		MOV SI, 00C6H 
		MOV	[SI], AX 
			CLI	
			POP			DS		
;--------------------------------------------------------------- 主
			MOV		AL,11H
			OUT		20H,AL			;ICW1
			MOV		AL,08H
			OUT		21H,AL			;ICW2
			MOV		AL,04H
			OUT		21H,AL			;ICW3
MOV		AL,01H
			OUT		21H,AL			;ICW4
;-------------------------------------------------------------初始化从片8259 
MOV 		AL, 11H 
OUT 		0A0H, AL 		;ICW1 
MOV 		AL, 30H 
OUT	 	0A1H, AL 		;ICW2 
MOV 		AL, 02H 
OUT 		0A1H, AL		 ;ICW3 
MOV 		AL, 01H 
OUT 		0A1H, AL 		;ICW4
 ;--------------------------------------------------------------- 
	MOV	 	AL, 0FDH 		;OCW1 = 1111 1101B
	OUT 		0A1H,AL 		
			MOV		AL,2BH			;OCW1 = 00101011B
			OUT		21H,AL	
			STI
	AA1:	NOP
			JMP			AA1
;--------------------------------------------------------------- 定时器芯片
INITC:	MOV		DX, TIMERM
			MOV		AL,36H
			OUT		DX,AL
			MOV		DX, TIMER0			;计数器0
			MOV		AL,0E8H
			OUT		DX,AL
			MOV		AL,03H
			OUT		DX,AL
			MOV		DX, TIMERM
			MOV		AL,76H
			OUT		DX,AL
			MOV		DX, TIMER1			;计数器1
			MOV		AL,0E8H
			OUT		DX,AL
			MOV		AL,03H
			OUT		DX,AL
;--------------------------------------------------------------- 
	BEGIN:	NOP
	AA2:	JMP			AA2
;--------------------------------------------------------------- 
	MIR7	PROC		NEAR
			PUSH		AX
			PUSH		DX
			MOV		AX,0137H
			INT			10H
			MOV		AX,0120H
			INT			10H

			MOV		AL,20H
			OUT		20H,AL
			POP			DX
			POP			AX			
			IRET
	MIR7	ENDP
;--------------------------------------------------------------- 
MIR6	PROC		NEAR
			PUSH		AX
			PUSH		DX

			MOV		AL,20H
			OUT		20H,AL
			POP			DX
			POP			AX			
			IRET
	MIR6	ENDP	
SIR1	PROC		NEAR
			PUSH		AX
			PUSH		DX

			MOV 		AL, 20H 
			OUT 		0A0H, AL 
			OUT 		20H, AL
			POP			DX
			POP			AX			
			IRET
	SIR1	ENDP	
	CODE	ENDS
			END	START	
