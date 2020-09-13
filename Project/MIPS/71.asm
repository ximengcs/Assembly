    addi $a0,$zero,2
    addi $a1,$zero,0
    addi $s0,$zero,0x10010000
    jal sum
    addi $v0,$v0,48
    sw $v0,0($s0)
    add $a0,$zero,$s0
    jal printf
    j exit
sum:   
    slti $t0,$a0,1
    bne $t0,$zero,sum_exit
    add $a1,$a1,$a0
    addi $a0,$a0,-1
    j sum
sum_exit:
    add $v0,$a1,$zero
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