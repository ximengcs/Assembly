ASSUME DS:DATA,CS:CODE
DATA SEGMENT
STRING DB 'TEST$'
RESULT DB 0H
DATA ENDS
CODE SEGMENT
START:	MOV AX,DATA
		MOV DS,AX
		
		MOV CX,4H			;循环次数CX
		LEA DI,RESULT		;取存放结果的偏移地址
		LEA SI,STRING
AGAIN:	MOV AL,[SI]			;
		OR AL,80H			;
		JPE SUMA			;
		MOV [SI],AL
		INT SI
		LOOP AGAIN
		JMP DONE
SUMA:	INC [DI]
		MOV [SI],AL
		INC SI
		LOOP AGAIN
DONE:	MOV AH,4CH
		INT 21H
CODE ENDS
END START
		
		