.data
str1: .asciiz "Entre com n: "
str2: .asciiz "CATALAN:  "
one: .float 1
.text

    	main:

	        la $a0,str1
	        li $v0,4
	        syscall
	        li $v0,5
	        syscall
	        move $a1,$v0    	# $a1 = N    
	        move $a0, $v0		# $a0 = N
	
	        jal cat 			# chama a funcao cat

	        move $s0,$v0
	        la $a0,str2
	        li $v0,4
	        syscall
	        
	        
	        mov.s $f12, $f20
	        li $v0,2
	        syscall
	        li $v0,10

		syscall
	
	        cat: 
	        
			bne $a1, $zero, recursion 
			l.s $f20, one 		# $f20 = 1
			jr $ra 			# retorna ao main
			
		recursion:
		
			add $sp, $sp, -4 	# decrementa o topo da pilha
			sw $ra, ($sp) 		# salva o endereco de retorno
			add $a1, $a1, -1 	# decrementa o valor de N
			jal cat 			# chama a funcao cat
			# Resultado em $v0
			mul $s1, $a0, 2
			sub $s1, $s1, 1
			mul $s1, $s1, 2
			
			# s1 = 2(2n-1)
			
			add $s2, $a0, 1
			
			# s2 = n + 1
			
			mtc1 $s1, $f0 		# $f0 = s1
			cvt.s.w $f0, $f0 	# $f0 = 2(2n-1)
			
			mtc1 $s2, $f2 		# $f2 = n + 1
			cvt.s.w $f2, $f2 # $f2 = n + 1
					
			div.s $f10, $f0, $f2 	# $f10 = (2n-1)/(n+1)

			mul.s $f20, $f20, $f10 # $f20 = $f20 * $f10
			
			lw $ra, ($sp) 		# recupera o endereco de retorno
			add $sp, $sp, 4 	# incrementa o topo da pilha
			add $a0, $a0, -1 	# decrementa o valor de N
			jr $ra 			# retorna ao main