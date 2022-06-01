.data 0x0000				      		
      buf: .word 0x0000
.text 0x0000
# 初始化				
initialization: 
	lui $1, 0xFFFF			
        ori $28, $1, 0xF000
        #a0, a1存a, b
        # 初始化成0-7
        ori $s0, $zero, 0
        ori $s1, $zero, 1 
        ori $s2, $zero, 2 
        ori $s3, $zero, 3 
        ori $s4, $zero, 4 
        ori $s5, $zero, 5 	
        ori $s6, $zero, 6 	
        ori $s7, $zero, 7
      	addi $t0, $zero, 0
      	addi $t1, $zero, 0
      	addi $t2, $zero, 0
      	addi $t3, $zero, 0
      	addi $t4, $zero, 0
      	addi $t5, $zero, 0
      	#addi $t6, $zero, 1
# button!
	#sw $t6, 0xC60($28)
bt_0_cs:   
	lw $t0, 0xC50($28)
	beq $t0, $zero, bt_0_cs	      
bt_1_cs:
	lw $t0, 0xC50($28)
	bne $t0, $zero, bt_1_cs	
	
	#addi $t6, $t6, 1
	#sw $t6, 0xC60($28)	
								
	lw $1, 0xC70($28)
	# sw20 sw19 sw18
	sll $1, $1, 11
	srl $1, $1, 29
	
	sw $1, 0xC60($28)
	#addi $t6, $t6, 1
	#sw $t6, 0xC60($28)
	
	beq $1, $s0, case0
	beq $1, $s1, case1
	beq $1, $s2, case2
	beq $1, $s3, case3
	beq $1, $s4, case4
	beq $1, $s5, case5
	beq $1, $s6, case6
	beq $1, $s7, case7
#判断是否回文并显示数据	
case0:
	lui $t0, 0x0000
        sw $t0, 0xC40($28)
        #addi $t6, $t6, 1
	#sw $t6, 0xC60($28)
bt_00:	lw $t0, 0xC50($28)
	beq $t0, $zero, bt_00      
bt_01:
	lw $t0, 0xC50($28)
	bne $t0, $zero, bt_01
	#addi $t6, $t6, 1
	#sw $t6, 0xC60($28)
	lw $t0, 0xC70($28)
	sll $t0, $t0, 16
	srl $t0, $t0, 16
	addi $t1, $zero, 0
	addi $t2, $t0, 0
	#用于计数
cal_bits:
	srl $t2, $t2, 1
	addi $t1, $t1, 1
	bne $t2, $zero, cal_bits
	#位数 $t1
	#t2 位移
	addi $t2, $t0, 0
	#反转后的结果
	addi $t3, $zero, 0
	for_case0: 
		   #放结果
		   and $t4, $t2, $s1
		   add $t3, $t3, $t4
		   addi $t1, $t1, -1
		   beq $t1, $zero, jdg_huiwen
		   sll $t3, $t3, 1
		   srl $t2, $t2, 1
		   j for_case0
	jdg_huiwen: 	
		   beq $t3, $t0, is_huiwen
		   lui $t5, 0x0000
		   add $t4, $t0, $t5
		   sw $t4, 0xC60($28)
		   j exit
	is_huiwen: 
		   lui $t5, 0x0001
		   add $t4, $t0, $t5
		   sw $t4, 0xC60($28)
		   j exit
#显示输出，暂时以led灯的形式
case1: 
	lui $t0, 0x0001
        sw $t0, 0xC40($28)	
bt_10:	lw $t1, 0xC50($28)
	beq $t1, $zero, bt_10	      
bt_11:
	lw $t1, 0xC50($28)
	bne $t1, $zero, bt_11
	lw $t1, 0xC70($28)
	sll $t1, $t1, 16
	srl $t1, $t1, 16
	addi $t3, $t3, 1
	beq $t3, $s2, over
	add $t8, $zero, $t1
	add $t2, $t8, $t0				
	sw $t2, 0xC40($28)
	j case1
over:
	add $t9, $zero, $t1
	add $t2, $t9, $t0				
	sw $t2, 0xC40($28)
        j exit
#计算a&b
case2:
	lui $t0, 0x0002
        sw $t0, 0xC40($28)      
      	and $t1, $t8, $t9
      	sw $t1, 0xC60($28)
      	#sw $t0, 0xC40($28)
      	j exit
#计算a|b     
case3: 
	lui $t0, 0x0003
        sw $t0, 0xC40($28)
      	or $t1, $t8, $t9
      	sw $t1, 0xC60($28)
      	#sw $t0, 0xC40($28)
      	j exit
#计算a^b       
case4:
	lui $t0, 0x0004
        sw $t0, 0xC40($28)
      	xor $t1, $t8, $t9
      	sw $t1, 0xC60($28)
      	#sw $t0, 0xC40($28)
      	j exit
#计算a<<b
case5:
	lui $t0, 0x0005
        sw $t0, 0xC40($28)
      	sllv $t1, $t8, $t9
      	sw $t1, 0xC60($28)
      	#sw $t0, 0xC40($28)
      	j exit
#计算a>>b      
case6:
	lui $t0, 0x0006
        sw $t0, 0xC40($28)
      	srlv $t1, $t8, $t9
      	sw $t1, 0xC60($28)
      	#sw $t0, 0xC40($28)
      	j exit      
#计算算数右移
case7:
	lui $t0, 0x0007
        sw $t0, 0xC40($28)
      	srav $t1, $t8, $t9
      	sw $t1, 0xC60($28)
      	#sw $t0, 0xC40($28)                  	
exit: 
      	addi $t0, $zero, 0
      	addi $t1, $zero, 0
      	addi $t2, $zero, 0
      	addi $t3, $zero, 0
      	addi $t4, $zero, 0
      	addi $t5, $zero, 0
      	j bt_0_cs
