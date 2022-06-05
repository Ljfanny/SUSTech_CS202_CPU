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

      lui $t0, 0x0000
      sw $t0, 0xC40($28)

bt1:
      lw $t9, 0xC50
      beq $t9, $zero, bt1
bt2:
      lw $t9, 0xC50
      bne $t9, $zero, bt2

      lw $t2, 0xC70
      lui $t0, 0x0001
      ori 