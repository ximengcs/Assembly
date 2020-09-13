    addi $a1,$a1,9
    addi $a0,$a0,0x10010000
    move $t0,$zero	#i = 0
loop1:
    sll $t1,$t0,2	#i *= 4
    add $t2,$a0,$t1	#&array + i
    sw $zero,0($t2)	#*array+i = 0
    addi $t0,$t0,1	# i++
    slt $t3,$t0,$a1	# if i < size then t3 = 1 else t3 = 0
    bne $t3,$zero,loop1
    