	.text
	.globl main
main:	
	subu $sp,$sp,32
	sw $ra,20($sp)
	sw $fp,16($sp)
	addiu $fp,$sp,28