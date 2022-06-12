.data
str: .asciiz "Entre com k: "
str1: .asciiz "Entre com n: "
str2: .asciiz "K elevado a N é: "
.text

    	main:

        	la $a0,str
	        li $v0,4
	        syscall
	        li $v0,5
        	syscall
	        move $t0,$v0
	        la $a0,str1
	        li $v0,4
	        syscall
	        li $v0,5
	        syscall
	        move $a0, $t0    	# $a0 = X
	        move $a1,$v0    	# $a1 = N    
	
	        jal power

	        move $s0,$v0
	        la $a0,str2
	        li $v0,4
	        syscall
	        move $a0,$s0
	        li $v0,1
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