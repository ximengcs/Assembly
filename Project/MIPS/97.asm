   move $t0,$a0	# p = array
loop2:
   sw $zero,0($t0)	# *p = 0
   addi $t0,$t0,4	# p++
   sll $t1,$a1,2	# size * 4
   add $t2,$a0,$t1	# array+size == length
   slt $t3,$t0,$t2	# p < length?
   bne $t3,$zero,loop2