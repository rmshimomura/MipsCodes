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

		jal power # Chama recursivamente a função
		
		mul $s0, $s0, $v0 # $s0 = X * N
		
		add $k0, $k0, 1 # $k0 = X + 1
			
	    ble $k0, $k1, loop # Verifica se X < N
		
		move $a0, $s0 # $a0 = X * N
		
		li $v0, 1 # $v0 = 1
		syscall # Imprime X * N
		
		li $v0,10 # $v0 = 10
		syscall	 # Finaliza o programa

		power: 
		
			bne $a1, $zero, recursion # Verifica se N = 0
			li $v0, 1 # $v0 = 1
			jr $ra # Retorna a função
			
		recursion:
		
			add $sp, $sp, -4 # Move o ponteiro da pilha
			sw $ra, ($sp) # Salva o endereço de retorno
			add $a1, $a1, -1 # $a1 = N - 1
			jal power # Chama recursivamente a função
			mul $v0, $a0, $v0 # $v0 = X * N
			lw $ra, ($sp) # Recupera o endereço de retorno
			add $sp, $sp, 4 # Move o ponteiro da pilha
			jr $ra # Retorna a função
		
		
        	
        	