.data 0x0000	
    Array: .space 160
    buf: .word 0x0000
.text 0x0000
initialization:   #初始化
	lui $1, 0xFFFF
      ori $28, $1, 0xF000
      ori $s0, $zero, 0
      ori $s1, $zero, 1 
      ori $s2, $zero, 2 
      ori $s3, $zero, 3 
      ori $s4, $zero, 4 
      ori $s5, $zero, 5 	
      ori $s6, $zero, 6 	
      ori $s7, $zero, 7
      lui $t0, 0x0001
      addi $t0, $t0, 0xFFFF   #$t0是非法的数据不变了
caseLoop:   #读case，选case
      lw $t1, 0xC72($28)
      beq $t0, $t1, caseLoop
      sw $t0, 0xC72($28)
      sll $t1, $t1, 27
      srl $t1, $t1, 29
	beq $t1, $s0, loop0
	beq $t1, $s1, case1
	beq $t1, $s2, case2
	beq $t1, $s3, case3
	beq $t1, $s4, case4
	beq $t1, $s5, case5
	beq $t1, $s6, case6
	beq $t1, $s7, case7
loop0:      #要读个数，存到$t9
      lw $t1, 0xC70($28)
      beq $t0, $t1, loop0
      sw $t0, 0xC70($28)
      sll $t1, $t1, 24
      srl $t1, $t1, 24
      addi $t9, $t1, 0
      addi $t3, $zero, 1      #for计数
      addi $t4, $zero, 0      #存Array地址
      addi $t2, $s7, 4
      sub $t2, $t1, $t2
      srl $t2, $t2, 31
      bne $t2, $s1, loop0     #$t1>10就回去！
case0:      #读到Array
      lw $t1, 0xC70($28)
      beq $t0, $t1, case0
      sw $t0, 0xC70($28)
      sll $t1, $t1, 24
      srl $t1, $t1, 24
      sw $t1, Array($t4)
      addi $t3, $t3, 1
      addi $t4, $t4, 4
      addi $t1, $t9, 1
      sub $t1, $t3, $t1
      srl $t1, $t1, 31
      beq $t1, $s1, case0     #for循环~
      j exit
case1:      #先把base存到space
      addi $t5, $t9, -1
      addi $t3, $t3, 1
      lw $t1, Array($t4)
      addi $t2, $t4, 40       #40一个space，10个整数
      sw $t1, Array($t2)
      addi $t4, $t4, 4
      sub $t1, $t3, $t9
      srl $t1, $t1, 31
      beq $t1, $s1, case1
      addi $t3, $zero, 0
loopOut:    #外循环，$t3计数
      addi $t3, $t3, 1
      addi $t4, $zero, 1
      addi $t6, $zero, 40
loopIn:     #内循环，$t4计数
      addi $t4, $t4, 1
      addi $t6, $t6, 4        #$t6是j+1
      addi $t7, $t6, -4       #$t7是j
      lw $t1, Array($t7)
      lw $t2, Array($t6)
      addi $t8, $t2, 1
      sub $t8, $t1, $t8
      srl $t8, $t8, 31
      beq $t8, $s1, NoSwtich
      addi $t8, $t1, 0
      addi $t1, $t2, 0
      addi $t2, $t8, 0        
      sw $t1, Array($t7)
      sw $t2, Array($t6)
NoSwtich:
      sub $t7, $t4, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopIn
      sub $t7, $t3, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopOut
      addi $t6, $zero, 0
      addi $t7, $zero, 0
      addi $t8, $zero, 0      #排完啦！
      j exit 
case2:      #求补码
      addi $t3, $t3, 1
      lui $t5, 0xFFFF
      addi $t5, $t5, 0xFFFF   #全1备用$t5
      lw $t1, Array($t4)
      sll $t2, $t1, 24
      srl $t2, $t2, 31
      bne $t2, $s1, positive  #如果是正数直接弄过去
      xor $t1, $t5, $t1       #异或
      sll $t1, $t1, 24
      srl $t1, $t1, 24
      addi $t1, $t1, 1        #+1求补码
      sll $t1, $t1, 24
      srl $t1, $t1, 24
positive:
      addi $t2, $t4, 80
      sw $t1, Array($t2)      #存space2
      addi $t4, $t4, 4
      sub $t1, $t3, $t9
      srl $t1, $t1, 31
      beq $t1, $s1, case2     #循环~
      j exit
case3:      #copy case1
      addi $t5, $t9, -1
      addi $t3, $t3, 1
      addi $t4, $t4, 80
      lw $t1, Array($t4)
      addi $t2, $t4, 40       #40一个space，10个整数
      sw $t1, Array($t2)
      addi $t4, $t4, 4
      sub $t1, $t3, $t9
      srl $t1, $t1, 31
      beq $t1, $s1, case3
      addi $t3, $zero, 0
loopOut1:    #外循环，$t3计数
      addi $t3, $t3, 1
      addi $t4, $zero, 1
      addi $t6, $zero, 120
loopIn1:     #内循环，$t4计数
      addi $t4, $t4, 1
      addi $t6, $t6, 4        #$t6是j+1
      addi $t7, $t6, -4       #$t7是j
      lw $t1, Array($t7)
      lw $t2, Array($t6)
      addi $t8, $t2, 1
      sub $t8, $t1, $t8
      srl $t8, $t8, 31
      beq $t8, $s1, NoSwtich1
      addi $t8, $t1, 0
      addi $t1, $t2, 0
      addi $t2, $t8, 0        
      sw $t1, Array($t7)
      sw $t2, Array($t6)
NoSwtich1:
      sub $t7, $t4, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopIn1
      sub $t7, $t3, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopOut1
      addi $t6, $zero, 0
      addi $t7, $zero, 0
      addi $t8, $zero, 0      #排完啦！
      j exit 
case4:
      addi $t5, $t5, 40
      addi $t6, $t5, 0
      addi $t3, $t3, 1
case40:
      addi $t3, $t3, 1
      addi $t5, $t5, 4
      sub $t4, $t3, $t9
      srl $t4, $t4, 31        #$t5是大的
      beq $t4, $s1, case40
      lw $t1, Array($t6)
      lw $t2, Array($t5)
      sub $t1, $t2, $t1
      sw $t1, 0xC60($28)
      addi $t6, $zero, 0
      j exit
case5:
      addi $t5, $t5, 120      #和case4只有地址有差
      addi $t6, $t5, 0
      addi $t3, $t3, 1
case50:
      addi $t3, $t3, 1
      addi $t5, $t5, 4
      sub $t4, $t3, $t9
      srl $t4, $t4, 31        #$t5是大的
      beq $t4, $s1, case50
      lw $t1, Array($t6)
      lw $t2, Array($t5)
      sub $t1, $t2, $t1
      sw $t1, 0xC60($28)
      addi $t6, $zero, 0
      j exit
case6:      #read space
      lw $t1, 0xC70($28)      #$t1是数据集(1~3)~
      sw $t0, 0xC70($28)
      beq $t1, $s1, case60
      beq $t1, $s2, case60
      beq $t1, $s3, case60
      j case6
case60:     #read index
      lw $t2, 0xC70($28)      #$t2是下标(0~$t9-1)~
      sw $t0, 0xC70($28)
      beq $t2, $t0, case60
      sub $t4, $t2, $t9
      srl $t4, $t4, 31        
      bne $t4, $s1, case60
case61:     #find space
      addi $t3, $t3, 1        #$t3计数器
      addi $t5, $t5, 40       #$t5地址
      bne $t3, $t1, case61
      addi $t3, $zero, 0
      addi $t2, $t2, 1
      addi $t5, $t5, -4
case62:     #find address
      addi $t3, $t3, 1
      addi $t5, $t5, 4
      bne $t3, $t2, case62
      lw $t4, Array($t5)
      sll $t4, $t4, 24
      srl $t4, $t4, 24
      sw $t4, 0xC60($28)
      j exit
case7:
      lw $t2, 0xC70($28)      #$t2是下标(0~$t9-1)~
      sw $t0, 0xC70($28)
      beq $t2, $t0, case7
      sub $t4, $t2, $t9
      srl $t4, $t4, 31        
      bne $t4, $s1, case7
      addi $t4, $zero, 0
      addi $t2, $t2, 1
      addi $t4, $t4, -4
case71:
      addi $t3, $t3, 1
      addi $t4, $t4, 4        #$t4是space0的地址
      bne $t3, $t2, case71
      addi $t5, $t4, 80       #$t5是space2的地址
      addi $t2, $t2, -1
      sll $t7, $s1, 13
      sll $t2, $t2, 8
      add $t6, $zero, $t2
      add $t7, $t7, $t2
      lw $t3, Array($t4)
      add $t6, $t6, $t3
      lw $t3, Array($t5)
      add $t7, $t7, $t5
      sll $t8, $s1, 19        #循环里俩指令所以暂定2^19
case70:     #0, 下标， 0中对应8bit
      sw $t6, 0xC60($28)
      addi $t3, $zero, 0
case700:    #5s
      add $t3, $t3, $s1
      bne $t3, $t8, case700
      lw $t1, 0xC72($28)
      beq $t0, $t1, case72
      addi $t2, $zero, 0
      addi $t3, $zero, 0
      addi $t4, $zero, 0
      addi $t5, $zero, 0
      addi $t6, $zero, 0
      addi $t7, $zero, 0
      addi $t8, $zero, 0
      sw $t0, 0xC72($28)
      sll $t1, $t1, 27
      srl $t1, $t1, 29
	beq $t1, $s0, loop0
	beq $t1, $s1, case1
	beq $t1, $s2, case2
	beq $t1, $s3, case3
	beq $t1, $s4, case4
	beq $t1, $s5, case5
	beq $t1, $s6, case6
	beq $t1, $s7, case7
case72:     #2, 下标， 2中对应8bit
      sw $t7, 0xC60($28)
      addi $t3, $zero, 0
case720:    #5s
      add $t3, $t3, $s1
      bne $t3, $t8, case720
      lw $t1, 0xC72($28)
      beq $t0, $t1, case70
      addi $t2, $zero, 0
      addi $t3, $zero, 0
      addi $t4, $zero, 0
      addi $t5, $zero, 0
      addi $t6, $zero, 0
      addi $t7, $zero, 0
      addi $t8, $zero, 0
      sw $t0, 0xC72($28)
      sll $t1, $t1, 27
      srl $t1, $t1, 29
	beq $t1, $s0, loop0
	beq $t1, $s1, case1
	beq $t1, $s2, case2
	beq $t1, $s3, case3
	beq $t1, $s4, case4
	beq $t1, $s5, case5
	beq $t1, $s6, case6
	beq $t1, $s7, case7
exit: 
      lui $t0, 0x0001
      addi $t0, $t0, 0xFFFF 
      addi $t1, $zero, 0
      addi $t2, $zero, 0
      addi $t3, $zero, 0
      addi $t4, $zero, 0
      addi $t5, $zero, 0
      j caseLoop