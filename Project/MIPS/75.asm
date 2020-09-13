    .extern printf 0x10000000
    lui $s0,0x003D
    ori $s0,$s0,0x0900
    addi $t0,$zero,0x1111
    jal printf