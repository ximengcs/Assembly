SSTACK 	SEGMENT STACK
DW 32 DUP(?) 
SSTACK 	ENDS 
CODE 	SEGMENT 
ASSUME CS:CODE 
START: 	NOP
;-----------------------------------------------
PUSH 	DS 
MOV 		AX, 0000H
MOV 		DS, AX 
MOV 		AX, OFFSET MIR7 ;取中断入口地址
MOV 		SI, 003CH ;中断矢量地址
MOV 		[SI], AX ;填IRQ7的偏移矢量
MOV 		AX, CS ;段地址
MOV 		SI, 003EH 
MOV 		[SI], AX ;填IRQ7的段地址矢量

MOV 		AX, 0000H
MOV 		DS, AX 
MOV 		AX, OFFSET MIR6 ;取中断入口地址
MOV 		SI, 0038H ;中断矢量地址
MOV 		[SI], AX ;填IRQ7的偏移矢量
MOV 		AX, CS ;段地址
MOV 		SI, 003AH 
MOV 		[SI], AX 

MOV 		AX, 0000H
MOV 		DS, AX 
MOV 		AX, OFFSET SIR1 ;取中断入口地址
MOV 		SI, 00C4H ;中断矢量地址
MOV 		[SI], AX ;填IRQ7的偏移矢量
MOV 		AX, CS ;段地址
MOV 		SI, 00C6H 
MOV 		[SI], AX 
CLI 
POP 		DS 
;----------------------------------------------
;初始化主片8259 
MOV 		AL, 11H 
OUT 		20H, AL ;ICW1 
MOV 		AL, 08H 
OUT 		21H, AL ;ICW2 
MOV		    AL, 04H 
OUT 		21H, AL ;ICW3 
MOV 		AL, 01H 
OUT 		21H, AL ;ICW4
;从片初始化-------------------------------------
MOV     	AL, 11H 
OUT     0A0H, AL ;ICW1 
MOV    	AL, 30H 
OUT		0A1H, AL ;ICW2 
MOV 	AL, 02H 
OUT 	0A1H, AL ;ICW3 
MOV 	AL, 01H 
OUT 	0A1H, AL ;ICW4 

  ;-----------------------------------------------------------------
MOV 	AL,0FDH ;OCW1 
OUT 	0A1H, AL 
MOV 	AL,2BH ;OCW1 
OUT 	21H, AL
STI 
AA1: 	NOP 
JMP 		AA1 
;-----------------------------------------------------------------
MIR7	PROC
		PUSH	AX
	    STI 
;CALL 	DELAY 
MOV 	AX, 0137H 
INT 		10H ;显示字符7 
MOV	AX, 0120H
INT 		10H 
MOV 	AL, 20H 
OUT		20H, AL ;中断结束命令
POP		AX
IRET 
MIR7	ENDP
MIR6	PROC
		PUSH	AX
	    STI 
;CALL 	DELAY 
MOV 	AX, 0136H 
INT 		10H ;显示字符7 
MOV	AX, 0120H
INT 		10H 
MOV 	AL, 20H 
OUT		20H, AL ;中断结束命令
POP		AX
IRET 
MIR6	ENDP
SIR1	PROC
		PUSH	AX
	    STI 
;CALL 	DELAY 
MOV 	AX, 0131H 
INT 		10H ;显示字符
MOV	    AX, 0120H
INT 		10H 
MOV 	AL, 20H 
OUT		0A0H, AL 
OUT		20H, AL ;中断结束命令
POP		AX
IRET 
SIR1	ENDP
DELAY	PROC
		PUSH	CX 
MOV 	CX, 0F00H 
AA0: 	PUSH 	AX 
POP 		AX 
LOOP 	AA0 
POP 		CX 
RET 
DELAY	ENDP
CODE 	ENDS 
END 	START
