	.data
int_str:	.asciiz"%d"
	.text
	.macro print_int($arg)
	la $a0,int_str
	li $v0,4
	syscall
	.end_macro
	
	print_int($7)
