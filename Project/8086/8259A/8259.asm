    
 ;;;--------------------------
 ;;; 8259中断实验实验
 ;;;8255控制8个发光二极管，初始状态左边4个亮，右边4个灭
 ;;;当按下按键时，申请一个中断，中断服务程序中，将8个二极管的状态取反，
 ;;;即原来亮的灭，原来灭的亮  
 ;;;--------------------------   
 ;8255 端口 
PORTA EQU 20H      ;A口
PORTB EQU 22H      ;B口
PORTC EQU 24H      ;C口
PORTCTR EQU 26H    ;控制口     
;8259 端口

CTR1 EQU 28H
CTR2 EQU 2AH    

CODE SEGMENT
     ASSUME CS:CODE
ORG 0100H
START:  
          
    cli  ;关中断
    mov ax,0        ; 初始化中断向量表
    mov ds,ax
    mov si,180H  
    MOV AX,OFFSET int0
    MOV BX,SEG int0
    
	mov [si],ax
    mov [si+2],bx

     MOV DX,PORTCTR    ;初始化8255
     MOV AL,10000010B ;A口输出，方式0，B口输入，方式0
     OUT DX, AL
     
     ;8255 A口输出数据,控制8个LED ，低电平亮，高电平灭
     MOV BL,0FH   
     MOV AL,BL
     MOV DX,PORTA
     OUT DX,AL
         
     
    mov al,00010011b  ;  初始化  8259
    mov dx,CTR1
    out dx,al         ; ICW1
    JMP $+2
    mov al,60h  ;中断类型号
    mov dx,CTR2
    out dx,al         ; ICW2
    JMP $+2
    mov ax,00000001h
    out dx,al         ; ICW4
    JMP $+2
    mov ax,0
    out dx,al         ; OCW1
    JMP $+2 
    sti  ;开中断  
    

    MOV DX,0EEEEH
	MOV AL,60H
	OUT DX,AL
 LP2:             ;等待中断
    NOP
    jmp LP2

int0  proc  ;中断0 中断服务程序
    NOT BL  
    MOV AL,BL
    MOV dx, PORTA
    out dx, al
    jmp $+2   
    
    mov al,20h
    mov dx,CTR1
    out dx,al
    jmp $+2
	MOV DX,0EEEEH
	MOV AL,60H
	OUT DX,AL
    iret
int0 endp

CODE ENDS

END START   
