    addi $s1,$zero,0x10010000
again:
    addi $t0,$zero,3
    addi $t1,$zero,2
    sw $t0,0($s1)
    ll $t1,0($s1)
    
    sc $t0,0($s1)
    beq $t0,$zero,again
    add $s4,$zero,$t1