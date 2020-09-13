#	void mm( double c[][], double a[][], double b[][] ) {
#	    int i, j, k;
#	    for(i = 0; i != 32; i++)
#	        for(j = 0; j != 32; j++)
#	            for(k = 0; k != 32; k++)
#	                c[i][j] = c[i][j] + a[i][k] + b[k][j];
#	}

mm:
	li $t1, 32	#t1 = 32
	li $s0, 0	# i = 0;
L1:	
	li $s1, 0	# j = 0;
L2:
	li $s2, 0	# k = 0;
	sll $t2, $s0, 5	# t2 = i*2^5
	addu $t2, $t2, $s1	# t2 = i + j
	sll $t2, $t2, 3	# double occupy 8 bytes  2^3
	addu $t2, $t0, $t2	# t2 = address of c[i][j]
	