.data 0x0000
	buf: .word 0x0000
.text 0x0000						
start: lui   $1,0xFFFF			
       ori   $28,$1,0xF000
       addi   $t0, $zero, 0
       addi   $t1, $zero, 0
       addi   $t2, $zero, 0
       addi   $s0, $zero, 0
       addi   $s1, $zero, 0
       addi   $s2, $zero, 1
       addi   $s3, $zero, 2
      # lui $1, 0x00FF
      # ori $s4, $1, 0xFFFF
      # addi   $s4, $zero, 0x0001FFFF
      # sw $s4, 0xC70($28)
      
#get pos when load 1 word
bt_second1:
	lw $t2, 0xC50($28)
	bne $t2, $zero, bt_second1
bt_0:   
	lw $t2, 0xC50($28)
	beq $t2, $zero, bt_0	      
bt_1:
	lw $t2, 0xC50($28)
	bne $t2, $zero, bt_1
loop:
	lw $t0, 0xC70($28)
	addi $s0, $s0, 1
	sw $t0, 0xC60($28)
	sw $t0, 0xC40($28)
	beq $s0, $s3, cal
	add $s1, $zero, $t0
	j bt_0
cal:
	add $t1, $t0, $s1
	sw  $t1,0xC60($28)
	addi $s0, $zero, 0
	j bt_0