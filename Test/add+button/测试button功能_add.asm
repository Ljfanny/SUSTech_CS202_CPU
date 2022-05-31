.data 0x0000
	buf: .word 0x0000
.text 0x0000						
start: lui   $1,0xFFFF			
       ori   $28,$1,0xF000
       addi   $t0, $zero, 0
       addi   $t1, $zero, 0
       addi   $s0, $zero, 0
       addi   $s1, $zero, 0
       #addi   $s2, $zero, 1
       addi   $s3, $zero, 2
	   lui $1, 0x00FF
	   ori $s4, $1, 0xFFFF

switled:
	lw $t0, 0xC70($28)
	bne $t0, $s4, new_number
	j switled
new_number:									
	addi $s0, $s0, 1
	beq $s0, $s3, cal
	add $s1, $zero, $t0
	j switled
cal:
	add $t1, $t0, $s1 #result
	sw  $t1, 0xC60($28)
	addi $s0, $zero, 0
	j switled
	
