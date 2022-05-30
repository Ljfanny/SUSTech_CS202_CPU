.data 0x0000
.text 0x0000						
start: lui   $1,0xFFFF			
       ori   $28,$1,0xF000
       addi   $s0, $zero, 0
       addi   $s2, $zero, 1
       addi   $s3, $zero, 2
       addi   $s4, $zero, 0x0001FFFF
# 测试两个数相加 -> 涵盖button功能	
switled:
	lw $t0, 0xC70($28)
	bne $t0, $s4, new_number
	j switled
new_number:									
	sw $s4, 0xC70($28)				
	addi $s0, $s0, 1
	beq $s0, $s3, cal
	add $s1, $zero, $t0
	j switled
cal:
	add $t2, $t0, $s1
	sw  $t2,0xC62($28)
	addi $s0, $zero, 1
	j switled
	
