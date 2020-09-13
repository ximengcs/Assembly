	.globl printf
printf:
	addi $sp,$sp,-8
	sw $ra,4($sp)
	sw $v0,0($sp)
	li $v0,4
	syscall
	lw $v0,0($sp)
	lw $ra,4($sp)
	jr $ra
	