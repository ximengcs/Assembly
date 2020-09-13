    addi $a0,$zero,4
    jal fact
    addi $t0,$zero,0x10010000
    addi $v0,$zero,52
    sw $v0,0($t0)
    add $a0,$zero,$t0  
    jal printf
loop:j exit

fact:
    addi $sp,$sp,-8	#I:001000 11101 11101 11111 11111 111000
    sw $ra,4($sp)	#I:101001 11101 11111 00000 00000 000100
    sw $a0,0($sp)	#I:101001 11101 10000 00000 00000 000000
    slti $t0,$a0,1	#I
    beq $t0,$zero,L1	
    addi $v0,$zero,1	#I:001000 00000 00010 00000 00000 000001
    addi $sp,$sp,8	#I:001000 11101 11101 00000 00000 001000
    jr $ra
L1:
    addi $a0,$a0,-1	#I:001000 00100 00100 11111 11111 111111
    jal fact
    lw $a0,0($sp)	#I:100101 11101 00100 00000 00000 000000
    lw $ra,4($sp)	#I:100101 11101 11111 00000 00000 000100
    addi $sp,$sp,8	#I:001000 11101 11101 00000 00000 001000
    mul $v0,$a0,$v0
    jr $ra

printf:
	addi $sp,$sp,-8
	sw $ra,4($sp)
	sw $v0,0($sp)
	li $v0,4
	syscall
	lw $v0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	jr $ra
exit: