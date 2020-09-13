A	EQU   	0640H 		;8255A口
B	EQU   	0642H 		;8255B口
C	EQU   	0644H 		;8255C口
CTR	EQU   	0646H		;8255控制端口

STACK SEGMENT
DB 32 DUP(0)
STACK ENDS

CODE SEGMENT
ASSUME CS:CODE,SS:STACK
START:
		;初始化8255
		MOV DX,CTR
		MOV AL,81H
		OUT DX,AL
		
SEARCH:	MOV CX,04H	;外循环4次
		MOV AH,00H
		MOV BH,10000000B	;行(高四位)
OUTER:	
		MOV AH,BH	;存放行
		NOT BH
		;C口高位输出
		MOV DX,C
		MOV AL,BH;
		OUT DX,AL
		
		PUSH CX
		
		MOV CX,04H 	;内循环4次
		MOV BL,00001000B	;列(低四位)
		IN AL,DX ;读C口
INNER:	
		TEST AL,BL
		JNZ FINISH	;没有按键按下
		OR AH,BL	;存放列
		CALL SWITCH
FINISH:	SHR BL,1
		LOOP INNER
		
		POP CX
		NOT BH
		SHR BH,1
		LOOP OUTER

		JMP SEARCH

PROC SWITCH
		PUSH BX
		PUSH CX
		PUSH DX
		
		; AH:保存开关状态
		CMP AH,10001000B	;按键1
		JNZ NEXT1
		;如果是该按键------------------------------------
		mov dx,A
		mov al,01h
		out dx,al
		JMP DONEALL
NEXT1:	CMP AH,10000100B	;按键2
		JNZ	NEXT2
		;
		mov dx,A
		mov al,02h
		out dx,al
		JMP DONEALL
NEXT2:	CMP AH,10000010B	;按键3
		JNZ	NEXT3
		;
		mov dx,A
		mov al,04h
		out dx,al
		JMP DONEALL
NEXT3:	CMP AH,10000001B	;按键4
		JNZ	NEXT4
		;
		mov dx,A
		mov al,08h
		out dx,al
		JMP DONEALL
NEXT4:	CMP AH,01001000B	;按键5
		JNZ	NEXT5
		;
		mov dx,A
		mov al,10h
		out dx,al
		JMP DONEALL
NEXT5:	CMP AH,01000100B	;按键6
		JNZ	NEXT6
		;
		mov dx,A
		mov al,20h
		out dx,al
		JMP DONEALL
NEXT6:	CMP AH,01000010B	;按键7
		JNZ	NEXT7
		;
		mov dx,A
		mov al,40h
		out dx,al
		JMP DONEALL
NEXT7:	CMP AH,01000001B	;按键8
		JNZ	NEXT8
		;
		mov dx,A
		mov al,80h
		out dx,al
		JMP DONEALL
NEXT8:	CMP AH,00101000B	;按键9
		JNZ	NEXT9
		;
		mov dx,B
		mov al,01h
		out dx,al
		JMP DONEALL
NEXT9:	CMP AH,00100100B	;按键10
		JNZ	NEXT10
		;
		mov dx,B
		mov al,02h
		out dx,al
		JMP DONEALL
NEXT10:	CMP AH,00100010B	;按键11
		JNZ	NEXT11
		;
		mov dx,B
		mov al,04h
		out dx,al
		JMP DONEALL
NEXT11:	CMP AH,00100001B	;按键12
		JNZ	NEXT12
		;
		mov dx,B
		mov al,08h
		out dx,al
		JMP DONEALL
NEXT12:	CMP AH,00011000B	;按键13
		JNZ	NEXT13
		;
		mov dx,B
		mov al,10h
		out dx,al
		JMP DONEALL
NEXT13:	CMP AH,00010100B	;按键14
		JNZ	NEXT14
		;
		mov dx,B
		mov al,20h
		out dx,al
		JMP DONEALL
NEXT14:	CMP AH,00010010B	;按键15
		JNZ	NEXT15
		;
		mov dx,B
		mov al,40h
		out dx,al
		JMP DONEALL
NEXT15:	CMP AH,00010001B	;按键16
		JNZ	DONEALL
		;
		mov dx,B
		mov al,80h
		out dx,al
DONEALL:POP DX
		POP CX
		POP BX
		
		RET
ENDP SWITCH

END START
CODE ENDS