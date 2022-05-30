.data 0x0000				      		
	buf: .word 0x0000
.text 0x0000						
start: lui   $1,0xFFFF			
       ori   $28,$1,0xF000
       addi   $s0, $zero, 0
       addi   $s2, $zero, 1
       addi   $s3, $zero, 2
# 测试两个数相加 -> 涵盖button功能
# 0xFFFFFC64 65 66 67       		
switled:
	lw   $t0, 0xC64($28)
	andi  $t0, $t0, 1
	beq  $t0, $s2, new_number
	j switled
new_number:									
	lw $t1, 0xC70($28)
	sw $zero, 0xC64($28)				
	addi $s0, $s0, 1
	beq $s0, $s3, cal
	add $s1, $zero, $t1
	j switled
cal:
	add $t2, $t1, $s1
	sw  $t2,0xC62($28)
	addi $s0, $zero, 1
	j switled
		
	