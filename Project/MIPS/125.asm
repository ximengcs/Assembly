    addi $t0,$zero,0xF8259
    addi $t1,$zero,0xF
    multu $t0,$t1 	#if $hi is equal to 0, there is no overflow
    mult $t0,$t0	#if $hi is equal to the singal bit of $lo, no overflow
    
    mfhi $t0