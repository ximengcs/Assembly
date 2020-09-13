A8254 		EQU   06C0H 
B8254 		EQU   06C2H 
C8254 		EQU   06C4H 
CON8254 	EQU   06C6H

DATA	SEGMENT
STRING	DB 'This ia a counting test.$'
DATA	ENDS

SSTACK 	SEGMENT 	STACK 
			DW 32 DUP(?) 
SSTACK 	ENDS 
CODE 		SEGMENT 
			ASSUME  CS:CODE, SS:SSTACK 
START: 	NOP
 ;--------------------------------------------------------8254 
			MOV 	DX, CON8254 
			MOV 	AL, 14H ;计数器0，方式0 
			OUT 	DX, AL 
			MOV 	DX, A8254 
			MOV		AL, 05H
			OUT 	DX, AL
			STI
			
			LEA		DX,STRING
			MOV 	AH,09H
			INT 	21H
			
AA1: 		JMP		AA1 
CODE		ENDS 
			END 	START
