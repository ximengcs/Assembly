;8259 端口

CTR1 EQU 20H
CTR2 EQU 22H    

CODE SEGMENT
     ASSUME CS:CODE
ORG 0100H
START:  
          
    cli  ;关中断
    mov ax,0        ; 初始化中断向量表
    mov ds,ax
    mov si,0
    mov cx,40H    
    MOV AX,OFFSET int0
    MOV BX,SEG int0
    
lP: mov [si],ax
    mov [si+2],bx
    add si,4
    loop lP
   
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
    

    
 LP2:             ;等待中断
    NOP
    jmp LP2

int0  proc  ;中断0 中断服务程序
    jmp $+2
	
	MOV AL,20H
	OUT 20H,AL
    iret
int0 endp

CODE ENDS

END START   
