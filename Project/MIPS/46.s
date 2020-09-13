#	A[12] = h + A[8]
	lw $t0, 32($s3)	# 1 words == 4 bytes
	add $t0, $s3, $t0
	sw $t0, 48($s3)	# 1 words == 4 bytes
	
#	lw $t0, AddrConstant4($s1)
	
#	p59
	sll $t2, $s0, 4	# t2 = s0 << 4bits
		# use of attribute(shamt,shift amount)
		
	and $t0, $t1, $t2	# t0 = t1 and t2
	or $t0, $t1, $t2
	nor $t0, $t1, $t2	# nor == not or
 		# a nor 0  ==  not a