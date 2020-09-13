A	EQU   	0640H 		;8255A口
B	EQU   	0642H 		;8255B口
C	EQU   	0644H 		;8255C口
CTR	EQU   	0646H		;8255控制端口

TIMER0	EQU  	06C0H		;8254 1
TIMER1	EQU  	06C2H		;8254 2
TIMER2	EQU  	06C4H		;8254 3
TIMERM	EQU  	06C6H		;8254 控制端口

DATA	SEGMENT
PR		DB		10H	DUP(0)
DISCODE	DB		3FH,06H,5BH,4FH,66H,6DH,7DH,07H	;0--7的显示代码
		DB		7FH,6FH,77H,7CH,39H,5EH,79H,71H		;8--F的显示代码
INDEX	DB		02H,03H,05H,09H,05H,00H
BUFF	DB      5BH,4FH,6DH,6FH,6DH,3FH 	;动态显示缓冲
LOCATN	DB      0DFH,0EFH,0F7H,0FBH,0FDH,0FEH 	;动态显示位置控制
HOUR	DB		24			;小时
MINUTE	DB		60			;分钟
SECOND	DB		60			;秒	
COUNT	DB		00

SET_FLAG	DB	0
HOUR_FLAG	DB	0
MINUTE_FLAG	DB	0
SECOND_FLAG	DB	0

DATA 	ENDS

SSTACK		SEGMENT	PARA  STACK  'STACK'
DW	32	DUP(?)
SSTACK		ENDS

CODE	SEGMENT
ASSUME 	CS:CODE, DS:DATA,SS: SSTACK			
START:	
		MOV	AX,DATA	
		MOV	DS,AX	;初始化数据段
	
INITA:	NOP
;----------------------------------------------------------------NMI初始化
;-----------------------初始化中断向量表(MIR7,MIR6,STR1)---------
PUSH 	DS 
MOV 		AX, 0000H
 		MOV 		DS, AX 
MOV 		AX, OFFSET MIR7 ;取中断入口地址 
MOV 		SI, 0008H ;中断矢量地址 
MOV 		[SI], AX ;填IRQ7的偏移矢量 
MOV 		AX, CS ;段地址 
MOV 		SI, 000AH 
MOV 		[SI], AX ;填IRQ7的段地址矢量 
CLI 
POP 		DS 
;----------------------------------------------

		;--------------------------------------------------------------- 初始化8254
INITC:	MOV	DX,TIMERM			;-------控制端口
		MOV	AL,36H				;00110110: 00:计数器0 11:先读写低8位，再读写高8位
		OUT	DX,AL
		MOV	DX,TIMER0			;-------计数器0
		MOV	AL,0E8H				;
		OUT	DX,AL
		MOV	AL,03H
		OUT	DX,AL
		
		MOV	DX,TIMERM			;-------控制端口
		MOV	AL,76H				;01110110: 01:计数器1
		OUT	DX,AL
		MOV	DX,TIMER1			;-------计数器1
		MOV	AL,0E8H
		OUT	DX,AL
		MOV	AL,03H
		OUT	DX,AL

;----------------------------------------------------------------------------8255初始化
MOV 	DX,CTR			
		MOV AL,81H		;ABC方式0，输出
		OUT DX,AL
	
;--------------------------------------------------------------- 



;----------------------------------------------------------------------------
LP:		MOV AX,0000H		;;+++
		MOV DS,AX			;;+++
		MOV CX,10
DISS:	CALL DISPLAY
		LOOP DISS
		CALL SCANCER
		JMP LP
		
;--------------------------------------------------------------- 
;--------------------------------------------------------------显示
DISPLAY	PROC NEAR
	
		LEA DI,BUFF			;时间缓冲
		LEA SI,LOCATN		;显示掩码
	
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

		RET
DISPLAY ENDP

MIR7	PROC
		PUSH SI
		PUSH DI
		PUSH AX
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
		CMP AL,04H
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
		CMP AL,03H
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
DONE:	;00100000 :OCW2 手动结束EOI
		;主片

		;MOV	AL,20H
		;OUT	20H,AL	
		POP AX
		POP DI
		POP SI
		RET
MIR7	ENDP

;---------------------------------------------------------------设置
SET		PROC
		PUSH BX
SLP:	

		;CALL DISPLAY

		CALL SCANCER
		MOV BX,OFFSET SET_FLAG
		MOV BL,[BX]
		TEST BL,1
		JZ	SET_RET
		JMP SLP
SET_RET:	
		POP BX
		RET
SET 	ENDP


DELAY	PROC
		PUSH	CX 
MOV 	CX, 0080H 
AA0: 	PUSH 	AX 
POP 		AX 
LOOP 	AA0 
POP 		CX 
RET 
DELAY	ENDP


;-----------------------------------------------------------扫描程序
SCANCER		PROC
		PUSH BX
		PUSH CX
		PUSH DX
		MOV CX,04H	;外循环4次
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
		CALL SWITCH			;如果有按键按下
FINISH:	SHR BL,1
		LOOP INNER
		
		POP CX
		NOT BH
		SHR BH,1
		LOOP OUTER
		POP DX
		POP CX
		POP BX
		RET
SCANCER		ENDP

PROC SWITCH

		PUSH BX
		PUSH CX
		PUSH DX
		
		; AH:保存开关状态
		CMP AH,10001000B	;按键1
		JNZ NEXT1
		;如果是该按键------------------------------------
		MOV BX,OFFSET SET_FLAG
		MOV AL,[BX]
		
		;如果已经是设置状态
		TEST AL,1
		JZ	SET_ZERO
		;MOV [BX],00H
		JMP NEXT1
SET_ZERO:	MOV [BX],01H
		CALL SET
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
		MOV SET_FLAG,0
		;mov dx,A
		;mov al,80h
		;out dx,al
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


;---------------------------------------------------------------MIR7

;---------------------------------------------------------------MIR6

;---------------------------------------------------------------SIR1

CODE	ENDS
END	START