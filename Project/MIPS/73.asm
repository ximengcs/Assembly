addi $a0,$zero,0x10010000
addi $t0,$zero,48532
addi $t1,$zero,49
sw $t0,0($a0)
sw $t1,4($a0)
jal printf
j exit

strcpy:
    addi $sp,$sp,-4
    sw $s0,0($sp)
    add $s0,$zero,$zero
loop:
    add $t1,$s0,$a1
    lbu $t2,0($t1)
    add $t3,$s0,$a0
    sb $t2,0($t3)
    beq $t2,$zero,loop2
    addi $s0,$s0,1
    j loop
loop2:
    lw $s0,0($sp)
    addi $sp,$sp,4
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