   addu $t0,$t1,$t2
   xor $t3,$t1,$t2
   slt $t3,$t3,$zero
   bne $t3,$zero,No_overflow
   xor $t3,$t0,$t1