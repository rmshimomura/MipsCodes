.data
str: .asciiz "Entre com k: "
str1: .asciiz "Entre com n: "
str2: .asciiz "K elevado a N �: "
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
	        
			bne $a1, $zero, recursion # se n for diferente de 0, entra na recursao
			li $v0, 1 # se n for 0, retorna 1
			jr $ra # retorna a funcao
			
		recursion:
		
			add $sp, $sp, -4 # decrementa o topo da pilha
			sw $ra, ($sp) # salva o endereco de retorno na pilha
			add $a1, $a1, -1 # decrementa o valor de n
			jal power # chama a funcao power
			mul $v0, $a0, $v0 # multiplica o resultado da funcao power pelo valor de k
			lw $ra, ($sp) # carrega o endereco de retorno da funcao
			add $sp, $sp, 4 # incrementa o topo da pilha
			jr $ra # retorna a funcao