addi $s3,$zero,0	#I:001000 00000 10011 00000 00000 000001
addi $s5,$zero,2	#I:001000 00000 10101 00000 00000 000010
addi $s6,$zero,0x10010000
addi $t1,$zero,0	#I:001000 00000 01001 00000 00000 000011
add $s6,$s6,$s3	#R:000000 10110 10011 10110 00000 100000
loop:  sll $t1,$s3,2	#R:000000 00000 10011 01001 00010 000000
       add $t1,$t1,$s6	#R:000000 01001 10110 01001 00000 100000
       lw $t0,0($t1)	#I:100101 01001 01000 00000 00000 000000
       bne $t0,$s5,exit
       addi $s3,$s3,1	#I:001000 10011 10011 00000 00000 000001
       j loop
exit:  j exit