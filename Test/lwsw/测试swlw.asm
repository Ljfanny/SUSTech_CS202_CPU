.data 0x0000				      		
	buf: .word 0x0000
.text 0x0000						
start: lui   $1,0xFFFF			
        ori   $28,$1,0xF000
bt_0:   lw $t2, 0xC50($28)
	beq $t2, $zero, bt_0	      
bt_1:
	lw $t2, 0xC50($28)
	#srl $t2, $t2, 2
	bne $t2, $zero, bt_1										
	lw   $1,0xC70($28)				
	sw   $1,0xC60($28)				
	lw   $1,0xC72($28)
	sw   $1,0xC62($28)	
	j bt_0
