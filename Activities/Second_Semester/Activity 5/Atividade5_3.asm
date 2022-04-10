.data
	start_matrix: .word 0
	end_matrix: .word 0
	enter_matrix_size: .asciiz "Entre com o numero de linhas e colunas: "
	size_error: .asciiz "N nao pode ser maior do que 8!\n"
	Ent1: .asciiz "\nInsira o valor de Mat["
	Ent2: .asciiz "]["
	Ent3: .asciiz "]:"
	jump: .asciiz "\n"
	
	sum_msg: "\nSoma dos elementos acima - soma dos elementos abaixo da diagonal principal: "
	big_msg: "\nMaior elemento acima da diagonal principal: "
	small_msg: "\nMenor elemento abaixo da diagonal principal: "
	matrix_size: .word 0
	sum_above: .word 0
	sum_below: .word 0
	sum_result: .word 0
	biggest_above: .word 0
	smallest_below: .word 9999999
	
	
.macro alocar_espaco(%matrix_start, %matrix_end, %matrix_size)

	lw $v0, %matrix_size
	add $a0, $zero, $v0 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $a0, $a0, $a0 # Linhas * colunas
	mul $a0, $a0, 4 # *4 bytes
	
	li $v0, 9  # Alocacao dinamica
	syscall
	
	sw $v0, %matrix_start # Salvar comeco da matriz
	add $a0, $v0, $a0 
	sw $a0, %matrix_end # Salvar o final da matriz (endereco inicial + quantidade de bytes alocados)
	add $a0, $zero, $zero # Reset $a0
	add $t0, $zero, $zero 
	

.end_macro

.macro tamanho_da_matriz()

	input_size:
		la $a0, enter_matrix_size # Carrega o endereco da string
 		li $v0, 4 # Codigo de impressao de string
  		syscall # Imprime a string
 		li $v0, 5 # Tamanho da matriz em $v0
 		syscall
 	
	 	bgt $v0, 8, error

		sw $v0, matrix_size
		j continue
		
		error:
			li $v0, 4
			la $a0, size_error
			syscall
			j input_size
		
		continue:

.end_macro

.macro leitura(%matrix_start, %matrix_size)
	
	lw $a1, %matrix_size
	lw $a2, %matrix_size
	
	l: 
		la $a0, Ent1 # Carrega o endereco da string
		li $v0, 4 # Codigo de impressao de string
		syscall # Imprime a string
		move $a0, $t0 # Valor de i para impressao
		li $v0, 1 # Codigo de impressao de inteiro
		syscall # Imprime i
		la $a0, Ent2 # Carrega o endereco da string
		li $v0, 4 # Codigo de impressao de string
		syscall # Imprime a string
		move $a0, $t1 # Valor de j para impressao
		li $v0, 1 # Codigo de impressao de inteiro
		syscall # Imprime j
		la $a0, Ent3 # Carrega o endereco da string
		li $v0, 4 # Codigo de impressao de string
		syscall # Imprime a string
		
		li $v0, 5 # Codigo de leitura de inteiro
		syscall # Leitura do valor (retorna em $v0)
		
		move $t2, $v0 # aux = valor lido
		indice(%matrix_start, %matrix_size, $t0, $t1)
		sw $t2, ($v0) # mat [i] [j] = aux
		addi $t1, $t1, 1 # j++
		bgt $a2, $t1, l # if(j < ncol) goto 1
		li $t1, 0 #j = 0
		addi $t0, $t0, 1 # i++
		bgt $a1, $t0, l # if(i < nlin) goto 1
		li $t0, 0 # i = 0

.end_macro

.macro escrita(%matrix_start, %matrix_size)

	lw $a1, %matrix_size
	lw $a2, %matrix_size
	
	
	e: 
		indice(%matrix_start, %matrix_size, $t0, $t1)
		lw $a0, ($v0) # Valor em mat [i] [j]
		li $v0, 1 # Codigo de impressao de int
		syscall # Imprime mat [i] [j]
		la $a0, 32 # Codigo ASCII para espaco
		li $v0, 11 # Codigo de impressao de caractere
		syscall # Imprime o espaco
		addi $t1, $t1, 1 # j++
		blt $t1, $a2, e # if(j < ncol) goto e
		la $a0, 10 # Codigo ASCII para newline ('\n')
		syscall # Pula a linha
		li $t1, 0 #j = 0
		addi $t0, $t0, 1 # i++
		blt $t0, $a1, e # if(i < nlin) goto e
		li $t0, 0 #i = 0

.end_macro

.macro 	indice(%matrix_start, %matrix_size, %i, %j)
		lw $a2, %matrix_size
		lw $a3, %matrix_start
		mul $v0, %i, $a2 # i * ncol
		add $v0, $v0, %j # (i * ncol) + j
		mul $v0, $v0, 4 # *4 por ser int
		add $v0, $v0, $a3 # Soma o endereco base de mat
		
.end_macro 


.macro jump_line()

	la $a0, jump
	li $v0, 4
	syscall	
	
.end_macro

.macro	finalizar()
		li $v0, 10 # Codigo para finalizar o programa
      		syscall # Finaliza o programa
.end_macro 

.macro subtracao(%start_matrix, %matrix_size)

	lw $a1, %matrix_size
	lw $a2, %matrix_size
	li $t0, 0
	li $t1, 0
	
	
	
	sum_up:
		lw $t8, biggest_above
		bge $t0, $t1, raise_return_up # Se i >= j aumente o contador e va para a proxima iteracao
		# Caso i < j some
		indice(%start_matrix, %matrix_size, $t0, $t1)
		lw $k0, ($v0) # Valor em mat [i] [j]
		
		bgt $k0, $t8, update_biggest # Se o valor em mat[i][j] > maior
		j not_biggest
		
			update_biggest:
				
				sw $k0, biggest_above
		not_biggest:
		
		lw $t2, sum_above
		
		add $t2, $t2, $k0
		
		sw $t2, sum_above
		
		raise_return_up:
			
			addi $t1, $t1, 1 # j++
			blt $t1, $a2, sum_up # if(j < ncol) goto e
			li $t1, 0
			addi $t0, $t0, 1 # i++
			blt $t0, $a1, sum_up # if(i < nlin) goto e
			li $t0, 0 #i = 0
			
	sum_down:
		lw $t9, smallest_below
		ble $t0, $t1, raise_return_down # Se i <= j aumente o contador e va para a proxima iteracao
		# Caso i > j some
		indice(%start_matrix, %matrix_size, $t0, $t1)
		lw $k0, ($v0) # Valor em mat [i] [j]
		
		blt $k0, $t9, update_smallest # Se o valor em mat[i][j] < menor
		j not_smallest
		
			update_smallest:
				
				sw $k0, smallest_below
		not_smallest:
		
		lw $t2, sum_below
		
		add $t2, $t2, $k0
		
		sw $t2, sum_below
		
		raise_return_down:
			
			addi $t1, $t1, 1 # j++
			blt $t1, $a2, sum_down # if(j < ncol) goto e
			li $t1, 0 #j = 0
			addi $t0, $t0, 1 # i++
			blt $t0, $a1, sum_down # if(i < nlin) goto e
			li $t0, 0 #i = 0
			
			lw $t8, sum_above
			lw $t9, sum_below
			sub $s0, $t8, $t9
			sw $s0, sum_result 
		
.end_macro 

.macro resultados_parciais()

	li $v0, 4
	la $a0, sum_msg
	syscall
	
	li $v0, 1
	lw $a0, sum_result
	syscall
	
	li $v0, 4
	la $a0, big_msg
	syscall
	
	li $v0, 1
	lw $a0, biggest_above
	syscall
	
	li $v0, 4
	la $a0, small_msg
	syscall
	
	li $v0, 1
	lw $a0, smallest_below
	syscall

.end_macro

.macro sort(%start_matrix, %end_matrix, %matrix_size)

    out_loop:
        add $t1, $zero, $zero
        lw  $a0, %start_matrix 			        # $a0 esta no comeco do matriz
        lw $t8, %end_matrix 				# $t8 esta no final da matriz
        
    inner_loop:
        lw  $t2, 0($a0)         	    # $t2 = elemento atual
        lw  $t3, 4($a0)         	    # $t3 = proximo elemento
            slt $t5, $t3, $t2       	# $t5 = 1 se $t3 < $t2
            beq $t5, $zero, continue    # Se $t5 = 1, troca os valores
            add $t1, $zero, 1          	# Checar novamente
            sw  $t2, 4($a0)         	# Trocar
            sw  $t3, 0($a0)			    # Trocar
    continue:
        addi $a0, $a0, 4            	# Proximo elemento
        addi $a1, $a0, 4	     	# Proximo do proximo elemento
        bne  $a1, $t8, inner_loop    	# Se o proximo elemento nao for o final, volta para o loop dentro
        bne  $t1, $zero, out_loop    	# Se $t1 = 1, volte para o out_loop

.end_macro

.text

	main:

		tamanho_da_matriz()
		alocar_espaco(start_matrix, end_matrix, matrix_size)	
		leitura(start_matrix, matrix_size)
		jump_line()
		jump_line()
		escrita(start_matrix, matrix_size)
		subtracao(start_matrix, matrix_size)
		resultados_parciais()
		sort(start_matrix, end_matrix, matrix_size)
		jump_line()
		jump_line()
		escrita(start_matrix, matrix_size)
		finalizar()
