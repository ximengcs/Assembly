A8254 		EQU   06C0H 
B8254 		EQU   06C2H 
C8254 		EQU   06C4H 
CON8254 	EQU   06C6H
SSTACK 	SEGMENT 	STACK 
			DW 32 DUP(?) 
SSTACK 	ENDS 
CODE 		SEGMENT 
			ASSUME  CS:CODE, SS:SSTACK 
START: 	NOP
;----------------------------------------------------------设置中断向量表
			PUSH 	DS 
			MOV 	AX, 0000H 
			MOV 	DS, AX 
			MOV 	AX, OFFSET IRQ7 ;取中断入口地址 
			MOV 	SI, 003CH ;中断矢量地址 
			MOV 	[SI], AX ;填IRQ7的偏移矢量 
			MOV 	AX, CS ;段地址 
			MOV 	SI, 003EH 
			MOV 	[SI], AX ;填IRQ7的段地址矢量 
			CLI 
			POP		 DS
 ;---------------------------------------------------------初始化主片8259 
			MOV 	AL, 11H 
			OUT 	20H, AL ;ICW1 
			MOV 	AL, 08H 
			OUT 	21H, AL ;ICW2 
			MOV 	AL, 04H 
			OUT 	21H, AL ;ICW3 
			MOV 	AL, 01H 
			OUT 	21H, AL ;ICW4 
;---------------------------------------------------------设置OCW1
			MOV 	AL, 6FH ;OCW1 
			OUT 	21H, AL
 ;--------------------------------------------------------8254 
			MOV 	DX, CON8254 
			MOV 	AL, 10H ;计数器0，方式0 
			OUT 	DX, AL 
			MOV 	DX, A8254 
			MOV		AL, 05H 
			OUT 	DX, AL
			STI 
AA1: 		JMP		AA1 
IRQ7		PROC
			PUSH	DX
			PUSH	AX 
;-----------------------------------------------在此添加功能3
			MOV 	AX, 014DH 
			INT 	10H ;显示字符M 
			MOV 	AX, 0120H 
			INT 	10H
 			MOV 	AL, 20H 
			OUT 	20H, AL ;中断结束命令 
			POP	AX
			POP	DX
			IRET 
IRQ7		ENDP
CODE		ENDS 
			END 	START
