.data
n: .word 0
str1: .asciiz "Entre com n: "
.text

    	main:

	        la $a0,str1
	        li $v0,4
	        li $s0, 1
	        syscall
	        li $v0,5
	        syscall
	        
	        move $k1, $v0
	        li $k0, 1
	        
	loop:
	        move $a0, $k0    	# $a0 = X
	        move $a1, $k0    	# $a1 = N   

		jal power
		
		mul $s0, $s0, $v0
		
		add $k0, $k0, 1
			
	        ble $k0, $k1, loop
		
		move $a0, $s0
		
        	li $v0, 1
        	syscall
        	
	        li $v0,10
	        syscall	
	
	        power: 
	        
			bne $a1, $zero, recursion
			li $v0, 1
			jr $ra
			
		recursion:
		
			add $sp, $sp, -4
			sw $ra, ($sp)
			add $a1, $a1, -1
			jal power
			mul $v0, $a0, $v0
			lw $ra, ($sp)
			add $sp, $sp, 4
			jr $ra
		
		
        	
        	