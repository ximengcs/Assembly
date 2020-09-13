main:
    #array = 9 3 4 1 2 1
    addi $a0,$zero,0x10010000
    addi $a1,$zero,6
    addi $t0,$zero,0x39
    sw $t0,0($a0)
    addi $t0,$zero,0x33
    sw $t0,4($a0)
    addi $t0,$zero,0x34
    sw $t0,8($a0)
    addi $t0,$zero,0x31
    sw $t0,12($a0)
    addi $t0,$zero,0x32
    sw $t0,16($a0)
    addi $t0,$zero,0x31
    sw $t0,20($a0)
    jal sort
loop: j loop    
sort:
            # save $ra,$s0,$s1,$s2,$s3 5*4=20
            addi $sp,$sp,-20
            sw $ra,16($sp)
            sw $s0,12($sp)
            sw $s1,8($sp)
            sw $s2,4($sp)
            sw $s3,0($sp)

    move $s2,$a0
    move $s3,$a1

    move $s0,$zero	#i = 0;
    for1tst:
        slt $t0,$s0,$s3	# if $s0<$a1 then t0 = 1
        beq $t0,$zero,exit1
        
        addi $s1,$s0,-1 # j = i - 1;
        for2tst:
            slti $t0,$s1,0
            bne $t0,$zero,exit2
            sll $t1,$s1,2 # j*4
            add $t2,$s2,$t1 # get the address of v[j]
            lw $t3,0($t2) # get the value of v[j]
            lw $t4,4($t2) # get the value of v[k+1]
            slt $t0,$t4,$t3 # if t4 < t3 then t0 = 1
            beq $t0,$zero,exit2
            move $a0,$s2
            move $a1,$s1
            jal swap
        addi $s1,$s1,-1 # j--;
        j for2tst
        exit2:
    addi $s0,$s0,1	#i++;
    j for1tst
    exit1:
        lw $s3,0($sp)
        lw $s2,4($sp)
        lw $s1,8($sp)
        lw $s0,12($sp)
        lw $ra,16($sp)
        addi $sp,$sp,20
jr $ra

swap:
    sll $t1,$a1,2	# a1 multipy by 4  args1
    add $t1,$a0,$t1	# args0 = args0 + 4
    lw $t0,0($t1)
    lw $t2,4($t1)
    sw $t2,0($t1)
    sw $t0,4($t1)
    jr $ra
