	addi $t0,$zero,1
	addi $t1,$zero,2
	addi $t2,$zero,3
	addi $t3,$zero,4
	addi $s3,$zero,0x10010000
	sw $t0,0($s3)
	sw $t1,4($s3)
	sw $t2,8($s3)
	sw $t3,12($s3)
	sw $t4,16($s3)
	lw $t0,8($s3)	#load word