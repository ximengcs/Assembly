addi $s0,$zero,1	#I:001000 00000 10000 00000 00000 000001 
addi $s1,$zero,2	#I:001000 00000 10001 00000 00000 000010
addi $s2,$zero,3	#I:001000 00000 10010 00000 00000 000011
addi $s3,$zero,4	#I:001000 00000 10011 00000 00000 000100
addi $s4,$zero,5	#I:001000 00000 10100 00000 00000 000101
           bne $s3,$s4,else     #
           add $s0,$s1,$s2      #R:000000 10001 10010 10000 00000 100000
           #bne $zero,$zero,done or the following derective
           j done
else:      
           sub $s0,$s1,$s2      #R:000000 10001 10010 10000 00000 100010
done:
