	addi $s2,$zero,1	#h = 1
	addi $s3,$zero,0x10010000	#s3 = start of address of data segment
	addi $t0,$zero,0xEFE
	addi $t1,$zero,2
	addi $t2,$zero,3
	addi $t3,$zero,4
	addi $t4,$zero,5
	addi $t5,$zero,6
	addi $t6,$zero,7
	addi $t7,$zero,8	#arrays[] = {1,2,3,4,5,6,7,8}
	sw $t0,($s3)	#store the first element
	sw $t1,4($s3)	#store the second element
	sw $t2,8($s3)
	sw $t3,12($s3)
	sw $t4,16($s3)
	sw $t5,20($s3)
	sw $t6,24($s3)
	sw $t7,28($s3)
	lw $t0,32($s3)	#temporary register $t0 gets A[8]
	add $t0,$s2,$t0	#$t0 += $s2
	sw $t0,48($s3)
	lb $t0,($s3)	#store byte  signed
	lb $t1,1($s3)
	lbu $t2,($s3)	#store byte  unsigned
	lbu $t3,1($s3)