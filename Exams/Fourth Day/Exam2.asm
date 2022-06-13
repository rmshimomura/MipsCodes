# Aluno: Rodrigo Mimura Shimomura 
# Matricula: 202000560249
# Em álgebra linear, a diagonal secundária de uma matriz A é a coleção das
# entradas Aij em que i + j é igual a n + 1 (onde n é a ordem da matriz). Elaborar
# um programa, em código MIPS, que receba como entrada uma matriz de ordem
# 3x3 e apresente como saída todos os valores da matriz e a soma dos elementos
# da diagonal secundária.
# Obs. Elaborar uma versão para valores de entrada inteiros e outra para valores
# reais.

.data
	start_matrix: .word 0
	enter_matrix_size: .asciiz "Entre com o numero de linhas e colunas: "
	Ent1: .asciiz "\nInsira o valor real de Mat["
	Ent2: .asciiz "]["
	Ent3: .asciiz "]:"
	jump: .asciiz "\n"
	sum: .float 0
	msg_sum: .asciiz "A soma da diagonal secundária é: "
	
	matrix_size: .word 0
	
	
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
		
 	
	 	li $v0, 3

		sw $v0, matrix_size

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
		
		li $v0, 6 # Codigo de leitura de inteiro
		syscall # Leitura do valor (retorna em $v0)
		
		indice(%matrix_start, %matrix_size, $t0, $t1)
		s.s $f0, ($v0) # mat [i] [j] = aux
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
		l.s $f12, ($v0) # Valor em mat [i] [j]
		li $v0, 2 # Codigo de impressao de int
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

.macro sum_secondary(%start_matrix, %matrix_size)
	
	lw $a1, %matrix_size
	lw $a2, %matrix_size
	li $t0, 0
	li $t1, 0
	li $t2, 0
	
	sum_sec_diag:
		
		# Caso i < j some
		indice(%start_matrix, %matrix_size, $t0, $t1)
		l.s $f8, ($v0) # Valor em mat [i] [j]
		
		add $k1, $t0, $t1 # i + j
		add $s0, $a2, -1 # tamanho -1
		beq $s0, $k1, update_sum
		j raise_return_up
		
		update_sum:
		
			add.s $f10, $f10, $f8
	
		
		raise_return_up:
			
			addi $t1, $t1, 1 # j++
			blt $t1, $a2, sum_sec_diag # if(j < ncol) goto e
			li $t1, 0
			addi $t0, $t0, 1 # i++
			blt $t0, $a1, sum_sec_diag # if(i < nlin) goto e
			li $t0, 0 #i = 0
			
		s.s $f10, sum
	
.end_macro

.macro print_results()

	la $a0, msg_sum
	li $v0, 4
	syscall
	
	l.s $f12, sum
	li $v0, 2
	syscall

.end_macro

.macro	finalizar()
		li $v0, 10 # Codigo para finalizar o programa
      		syscall # Finaliza o programa
.end_macro  

.text

	main:

		tamanho_da_matriz()
		alocar_espaco(start_matrix, matrix_size)	
		leitura(start_matrix, matrix_size)
		jump_line()
		jump_line()
		escrita(start_matrix, matrix_size)
		jump_line()
		sum_secondary(start_matrix, matrix_size)
		print_results()
		finalizar()