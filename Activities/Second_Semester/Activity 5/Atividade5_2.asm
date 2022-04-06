.data
	start_matrix_1: .word 0
	start_matrix_2: .word 0
	enter_matrix_size: .asciiz "Entre com o numero de linhas e colunas: "
	size_error: .asciiz "N nao pode ser maior do que 6!\n"
	Ent1: .asciiz "\nInsira o valor de Mat["
	Ent2: .asciiz "]["
	Ent3: .asciiz "]:"
	msg_numbers_matching: .asciiz "\nQuantidade de numeros iguais nas matrizes = "
	numbers_matching: .word 0
	matrix_size: .word 0
	position_sum: .word 0
	msg_position_sum: .asciiz "\nSomatorio das posicoes dos numeros iguais = "

.macro alocar_espaco(%matrix_start, %matrix_size)

	lw $v0, %matrix_size
	add $a0, $zero, $v0 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $a0, $a0, $a0 # Linhas * colunas
	mul $a0, $a0, 4 # *4 bytes
	
	li $v0, 9  # Alocacao dinamica
	syscall
	
	sw $v0, %matrix_start # Salvar comeco da matriz
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
 	
	 	bgt $v0, 6, error

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
		
		li $v0, 5 # Codigo de leitura de char
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

.macro	finalizar()
		li $v0, 10 # Codigo para finalizar o programa
      		syscall # Finaliza o programa
.end_macro 

.macro	check_same(%start_matrix_1, %start_matrix_2, %matrix_size)
	
	lw $a1, %matrix_size
	lw $a2, %matrix_size
	li $t0, 0
	li $t1, 0
	
	loop_same:
	
		indice(%start_matrix_1, %matrix_size, $t0, $t1)
		lw $k0, ($v0) # Valor em mat_1 [i] [j]
		
		indice(%start_matrix_2, %matrix_size, $t0, $t1)
		lw $k1, ($v0) # Valor em mat_2 [i] [j]
				
		seq $t4, $k0, $k1
		
		beq $t4, 1, add_same
		
		beqz $t4, pass
		
		add_same:
		
			lw $t5, numbers_matching
			add $t5, $t5, 1
			sw $t5, numbers_matching
			
			lw $t6, position_sum
			add $t9, $t0, $t1
			add $t6, $t6, $t9
			sw $t6, position_sum
		
		pass:
				
			addi $t1, $t1, 1 # j++
			blt $t1, $a2, loop_same # if(j < ncol) goto e
			li $t1, 0 #j = 0
			addi $t0, $t0, 1 # i++
			blt $t0, $a1, loop_same # if(i < nlin) goto e
			li $t0, 0 #i = 0
			
			la $a0, msg_numbers_matching
			li $v0, 4
			syscall
			
			lw $a0, numbers_matching
			li $v0, 1
			syscall
			
			la $a0, msg_position_sum
			li $v0, 4
			syscall
			
			lw $a0, position_sum
			li $v0, 1
			syscall
		
	
.end_macro 

.text

	main:

		tamanho_da_matriz()
		alocar_espaco(start_matrix_1, matrix_size)
		alocar_espaco(start_matrix_2, matrix_size)
		leitura(start_matrix_1, matrix_size)
		leitura(start_matrix_2, matrix_size)
		#escrita(start_matrix_1, matrix_size)
		#escrita(start_matrix_2, matrix_size)
			
		check_same(start_matrix_1, start_matrix_2, matrix_size)
			
		finalizar()
