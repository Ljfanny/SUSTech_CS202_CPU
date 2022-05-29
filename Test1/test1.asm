.data 0x0000				      		
	buf: .word 0x0000
.text 0x0000
# ��ʼ��				
initialization: 
	lui $1, 0xFFFF			
        ori $28, $1, 0xF000
        # ��ʼ����0-7
        ori $s0, $zero, 0
        ori $s1, $zero, 1 
        ori $s2, $zero, 2 
        ori $s3, $zero, 3 
        ori $s4, $zero, 4 
        ori $s5, $zero, 5 	
        ori $s6, $zero, 6 	
        ori $s7, $zero, 7 		
loop:												
	lw $1, 0xC72($28)
	# 24 23 22 -> sw23 sw22 sw21
	srl $1, $1, 5
	beq $1, $s0, case0
	beq $1, $s1, case1
	beq $1, $s2, case2
	beq $1, $s3, case3
	beq $1, $s4, case4
	beq $1, $s5, case5
	beq $1, $s6, case6
	beq $1, $s7, case7
#�ж��Ƿ���Ĳ���ʾ����	
case0:	lw $t0, 0xC70($28)
	sw $t0, 0xC60($28)
	#���ڼ���
	addi $t1, $zero, 16
	#���ڱ���ԭ����
	addi $t2, $t0, 0
	addi $t5, $t0, 0
	#��ת��Ľ��
	addi $t4, $zero, 0
	for_case0: srl $t0, $t0, 1
	           sll $t0, $t0, 1
	           and $t3, $t0, $t2
	           beq $t2, $t3, is_zero
	           addi $t4, $t4, 1
	           sll $t4, $t4, 1
	           srl $t2, $t2, 1
	           addi $t1, $t1, -1
	           bne $t1, $zero, for_case0
	           j judge_huiwen 
	           is_zero: addi $t4, $t4, 0
	           sll $t4, $t4, 1
	           srl $t2, $t2, 1
	           addi $t1, $t1, -1
	           bne $t1, $zero, for_case0
	           j judge_huiwen
	judge_huiwen: 
		   beq $t4, $t5, is_huiwen
		   sw $s1, 0xC62($28)
		   j exit  
		   is_huiwen: sw $zero, 0xC62($28)
		   	      j exit  
#��ʾ�������ʱ��led�Ƶ���ʽ
case1: lw $t0, 0xC70($28)
       sw $t0, 0xC60($28)
       j exit
#����a&b
case2:       
      #��16bits��a, ��16bits��b
      lw $t0, 0xC70($28)
      srl $t1, $t0, 16
      sll $t2, $t0, 16
      srl $t2, $t2, 16
      and $t3, $t1, $t2
      sw $t3, 0xC60($28)
      j exit
#����a|b     
case3: 
      #��16bits��a, ��16bits��b
      lw $t0, 0xC70($28)
      srl $t1, $t0, 16
      sll $t2, $t0, 16
      srl $t2, $t2, 16
      or $t3, $t1, $t2
      sw $t3, 0xC60($28)
      j exit
#����a^b       
case4:
      #��16bits��a, ��16bits��b
      lw $t0, 0xC70($28)
      srl $t1, $t0, 16
      sll $t2, $t0, 16
      srl $t2, $t2, 16
      xor $t3, $t1, $t2
      sw $t3, 0xC60($28)
      j exit
#����a<<b
case5:
      #��16bits��a, ��16bits��b
      lw $t0, 0xC70($28)
      srl $t1, $t0, 16
      sll $t2, $t0, 16
      srl $t2, $t2, 16
      sllv $t3, $t1, $t2
      sw $t3, 0xC60($28)
      j exit
#����a>>b      
case6:
      #��16bits��a, ��16bits��b
      lw $t0, 0xC70($28)
      srl $t1, $t0, 16
      sll $t2, $t0, 16
      srl $t2, $t2, 16
      srlv $t3, $t1, $t2
      sw $t3, 0xC60($28)
      j exit      
#������������
case7:
      #��16bits��a, ��16bits��b
      lw $t0, 0xC70($28)
      srl $t1, $t0, 16
      sll $t2, $t0, 16
      srl $t2, $t2, 16
      srav $t3, $t1, $t2
      sw $t3, 0xC60($28)
      j exit                    	
exit: addi $t0, $zero, 0
      addi $t1, $zero, 0
      addi $t2, $zero, 0
      addi $t3, $zero, 0
      addi $t4, $zero, 0
      addi $t5, $zero, 0
      j loop