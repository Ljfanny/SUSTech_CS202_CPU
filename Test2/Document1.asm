.data 0x00000000
    Array: .word 0x00000000
.text 0x00000000

initialization:               #init
	lui $1, 0xFFFF
      ori $28, $1, 0xF000
	lui $2, 0x0000
      ori $s0, $zero, 0
      ori $s1, $zero, 1 
      ori $s2, $zero, 2 
      ori $s3, $zero, 3 
      ori $s4, $zero, 4 
      ori $s5, $zero, 5 
      ori $s6, $zero, 6 
      ori $s7, $zero, 7
	ori $s8, $zero, 8
	ori $s9, $zero, 9

caseLoop:                     #waiting case's number
	
     # lui $t9, 0x000a
    #  sw $t9, 0xC40($28)
      sw $s0, 0xC40($28)
      	
	lw $t1, 0xC50($28)
	beq $t1, $zero, caseLoop     

bt_1_0:
	lw $t1, 0xC50($28)
	bne $t1, $zero, bt_1_0  #button to be 0, then read input on sw

      lw $t1, 0xC70($28)
      sll $t1, $t1, 11
      srl $t1, $t1, 29
	beq $t1, $s0, loop0
	beq $t1, $s1, case1
	beq $t1, $s2, case2
	beq $t1, $s3, case3
	beq $t1, $s4, case4
	beq $t1, $s5, case5
	beq $t1, $s6, case6
	beq $t1, $s7, case7
      j caseLoop

loop0:                        #waiting number of array, saving to $t9
      
     # lui $t9, 0x0009
      #sw $t9, 0xC40($28)
      sw $s9, 0xC40($28)

	lw $t1, 0xC50($28)
	beq $t1, $zero, loop0 

bt_1_1:
	lw $t1, 0xC50($28)
	bne $t1, $zero, bt_1_1
      lw $t1, 0xC70($28)
      sw $t1, 0xC60($28) #print number

      addi $t9, $t1, 0
      addi $t3, $zero, 1
      addi $t4, $zero, 0
      addi $t2, $zero, 11     #judging number<=10
      sub $t2, $t1, $t2
      srl $t2, $t2, 31
      bne $t2, $s1, loop0

case0:                        #for cycle to read array
      
      #lui $t9, 0x0008
      #sw $t9, 0xC40($28)
      sw $s8, 0xC40($28)

	lw $t1, 0xC50($28)
	beq $t1, $zero, case0

bt_1_2:
	lw $t1, 0xC50($28)
	bne $t1, $zero, bt_1_2

      lw $t1, 0xC70($28)
      sw $t1, 0xC60($28)

      sll $t1, $t1, 24
      srl $t1, $t1, 24
	add $27, $t4, $2        #save into array
	sw $t1, 0($27)
      addi $t3, $t3, 1
      addi $t4, $t4, 4
      addi $t1, $t9, 1
      sub $t1, $t3, $t1       #$t3 is point, $t3 for address
      srl $t1, $t1, 31
      beq $t1, $s1, case0
      j exit

case1:
      
      #lui $t9, 0x0001
      #sw $t9, 0xC40($28)
      sw $s1, 0xC40($28)

      addi $t5, $t9, -1       #there is no problem
      addi $t3, $t3, 1
	add $27, $t4, $2        #t4 ->0?
	lw $t1, 0($27)
      addi $t2, $t4, 40       #?
      add $27, $t2, $2
	sw $t1, 0($27)
      addi $t4, $t4, 4
      sub $t1, $t3, $t9
      srl $t1, $t1, 31
      beq $t1, $s1, case1
      addi $t3, $zero, 0
loopOut:
      addi $t3, $t3, 1
      addi $t4, $zero, 1
      addi $t6, $zero, 40
loopIn:
      addi $t4, $t4, 1 #
      addi $t6, $t6, 4
      addi $t7, $t6, -4
	add $27, $t7, $2
	lw $t1, 0($27)
	add $27, $t6, $2
	lw $t2, 0($27)
      addi $t8, $t2, 1
      sub $t8, $t1, $t8
      srl $t8, $t8, 31
      beq $t8, $s1, NoSwtich
      addi $t8, $t1, 0
      addi $t1, $t2, 0
      addi $t2, $t8, 0   
	add $27, $t7, $2
	sw $t1, 0($27)
	add $27, $t6, $2
	sw $t2, 0($27)
NoSwtich:
      sub $t7, $t4, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopIn
      sub $t7, $t3, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopOut
      addi $t6, $zero, 0
      addi $t7, $zero, 0
      addi $t8, $zero, 0
      j exit 

case2:
      #lui $t9, 0x0002
      #sw $t9, 0xC40($28)
      sw $s2, 0xC40($28)

      addi $t3, $t3, 1
      lui $t5, 0xFFFF
      addi $t5, $t5, 0xFFFF
	add $27, $t4, $2
	lw $t1, 0($27)
      sll $t2, $t1, 24
      srl $t2, $t2, 31
      bne $t2, $s1, positive  	#judge +- to compute complement
      xor $t1, $t5, $t1
      sll $t1, $t1, 24
      srl $t1, $t1, 24
      addi $t1, $t1, 1        
      sll $t1, $t1, 24
      srl $t1, $t1, 24
positive:
      addi $t2, $t4, 80
	add $27, $t2, $2
	sw $t1, 0($27)
      addi $t4, $t4, 4
      sub $t1, $t3, $t9
      srl $t1, $t1, 31
      beq $t1, $s1, case2    
      j exit

case3:    			# similar to case1, a bubble sort

      #lui $t9, 0x0003
      #sw $t9, 0xC40($28)
      sw $s3, 0xC40($28)

      addi $t4, $t4, 80
      addi $t5, $t9, -1
case3haha:
      addi $t3, $t3, 1
	add $27, $t4, $2
	lw $t1, 0($27)

      addi $t2, $t4, 40       
	add $27, $t2, $2
	sw $t1, 0($27)
      addi $t4, $t4, 4
      sub $t1, $t3, $t9
      srl $t1, $t1, 31
      beq $t1, $s1, case3haha
      addi $t3, $zero, 0
loopOut1:    
      addi $t3, $t3, 1
      addi $t4, $zero, 1
      addi $t6, $zero, 120
loopIn1:     
      addi $t4, $t4, 1
      addi $t6, $t6, 4        
      addi $t7, $t6, -4 
	add $27, $t7, $2
	lw $t1, 0($27)
	add $27, $t6, $2
	lw $t2, 0($27)
      addi $t8, $t2, 1
      sub $t8, $t1, $t8
      srl $t8, $t8, 31
      beq $t8, $s1, NoSwtich1
      addi $t8, $t1, 0
      addi $t1, $t2, 0
      addi $t2, $t8, 0        
	add $27, $t7, $2
	sw $t1, 0($27)
	add $27, $t6, $2
	sw $t2, 0($27)
NoSwtich1:
      sub $t7, $t4, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopIn1
      sub $t7, $t3, $t9
      srl $t7, $t7, 31
      beq $t7, $s1, loopOut1
      addi $t6, $zero, 0
      addi $t7, $zero, 0
      addi $t8, $zero, 0      
      j exit 

case4:			# space 1, max - min

      #lui $t9, 0x0004
      #sw $t9, 0xC40($28)
      sw $s4, 0xC40($28)

      addi $t5, $t5, 40
      addi $t6, $t5, 0
      addi $t3, $t3, 1
case40:
      addi $t3, $t3, 1
      addi $t5, $t5, 4
      sub $t4, $t3, $t9
      srl $t4, $t4, 31       
      beq $t4, $s1, case40
	add $27, $t6, $2
	lw $t1, 0($27)
	add $27, $t5, $2
	lw $t2, 0($27)
      sub $t1, $t2, $t1
      sw $t1, 0xC60($28)
      addi $t6, $zero, 0
      j exit

case5:			# space 3, max - min

      #lui $t9, 0x0005
      #sw $t9, 0xC40($28)
	sw $s5, 0xC40($28)

      addi $t5, $t5, 120      
      addi $t6, $t5, 0
      addi $t3, $t3, 1
case50:
      addi $t3, $t3, 1
      addi $t5, $t5, 4
      sub $t4, $t3, $t9
      srl $t4, $t4, 31        
      beq $t4, $s1, case50
	add $27, $t6, $2
	lw $t1, 0($27)
	add $27, $t5, $2
	lw $t2, 0($27)
      sub $t1, $t2, $t1
      sw $t1, 0xC60($28)
      addi $t6, $zero, 0
      j exit

case6:
      #lui $t9, 0x0006
      #sw $t9, 0xC40($28)
	sw $s6, 0xC40($28)

	lw $t1, 0xC50($28)
	beq $t1, $zero, case6  

bt_1_3:
	lw $t1, 0xC50($28)
	bne $t1, $zero, bt_1_3

      lw $t1, 0xC70($28)		#input space's number
      beq $t1, $s1, case60
      beq $t1, $s2, case60
      beq $t1, $s3, case60
      j case6

case60:
	lw $t2, 0xC50($28)
	beq $t2, $zero, case60  

bt_1_4:
	lw $t2, 0xC50($28)
	bne $t2, $zero, bt_1_4

      lw $t2, 0xC70($28)		#input index
      sw $t0, 0xC70($28)
      beq $t2, $t0, case60
      sub $t4, $t2, $t9
      srl $t4, $t4, 31        
      bne $t4, $s1, case60

case61:
      addi $t3, $t3, 1
      addi $t5, $t5, 40
      bne $t3, $t1, case61		#to find space

      addi $t3, $zero, 0
      addi $t2, $t2, 1
      addi $t5, $t5, -4
case62:
      addi $t3, $t3, 1
      addi $t5, $t5, 4
      bne $t3, $t2, case62		#to find index

	add $27, $t5, $2
	lw $t4, 0($27)
      sll $t4, $t4, 24
      srl $t4, $t4, 24
      sw $t4, 0xC60($28)
      j exit

case7:                         
    #  lui $t9, 0x0007
    #  sw $t9, 0xC40($28)
	sw $s7, 0xC40($28)

	lw $t2, 0xC50($28)
	beq $t2, $zero, case7   
bt_1_5:
	lw $t2, 0xC50($28)
	bne $t2, $zero, bt_1_5
      lw $t2, 0xC70($28)		#input point
      sw $t0, 0xC70($28)
      beq $t2, $t0, case7
      sub $t4, $t2, $t9
      srl $t4, $t4, 31        
      bne $t4, $s1, case7
      addi $t4, $zero, 0
      addi $t2, $t2, 1
      addi $t4, $t4, -4
case71:					#all save to $t7 and $t6, displayed on leds
      addi $t3, $t3, 1
      addi $t4, $t4, 4
      bne $t3, $t2, case71
      addi $t5, $t4, 80
      addi $t2, $t2, -1
      sll $t7, $s1, 13
      sll $t2, $t2, 8
      add $t6, $zero, $t2
      add $t7, $t7, $t2
	add $27, $t4, $2
	lw $t3, 0($27)
      add $t6, $t6, $t3
	add $27, $t5, $2
	lw $t3, 0($27)
      add $t7, $t7, $t5
      sll $t8, $s1, 19
case70:
      sw $t6, 0xC60($28)
      addi $t3, $zero, 0
case700:    #5s
      add $t3, $t3, $s1
      bne $t3, $t8, case700
	lw $t1, 0xC50($28)
	bne $t1, $zero, exit
      j case72
case72:
      sw $t7, 0xC60($28)
      addi $t3, $zero, 0
case720:
      add $t3, $t3, $s1
      bne $t3, $t8, case720
	lw $t1, 0xC50($28)
	bne $t1, $zero, exit
      j case70

exit: 					#init some regs
	lw $t2, 0xC50($28)
	bne $t2, $zero, exit
      lui $t0, 0x0001
      addi $t0, $t0, 0xFFFF 
      addi $t1, $zero, 0
      addi $t2, $zero, 0
      addi $t3, $zero, 0
      addi $t4, $zero, 0
      addi $t5, $zero, 0
      j caseLoop
