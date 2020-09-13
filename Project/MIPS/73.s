#	void strcpy( char x[], char y[] ) {
#	    int i = 0;
#	    while((x[i]=y[i])!=0)
#	        i++;
strcpy:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	add $s0, $zero, $zero
L1:	
	add $t1, $s0, $a1	# address of y[i]
	lbu $t2, 0($t1)
	
	