.data
	start_matrix: .word 0
	end_matrix: .word 0
	start_vector: .word 0
	enter_number_of_students: .asciiz "Entre com o numero de alunos: "
	size_error: .asciiz "O valor deve ser positivo!"
	Ent1: .asciiz "\nInsira do aluno ["
	Ent2: .asciiz "] a nota ["
	Ent3: .asciiz "]:"
	jump: .asciiz "\n"
	msg_aluno1: .asciiz "A média do aluno "
	msg_aluno2: .asciiz " foi de "
	msg_aluno3: .asciiz " pontos.\n"
	msg_sala: .asciiz "A média da sala foi de "
	msg_reprovados: .asciiz " alunos foram reprovados.\n"
	msg_aprovados: .asciiz " alunos foram aprovados.\n"
	number_of_students: .word 0
	zero: .float 0.0
	tres: .float 3.0
	media_sala: .float 0
	minimo: .float 6
	aprovados: .word 0
	reprovados: .word 0
	
.macro alocar_espaco(%matrix_start, %matrix_end, %number_of_students)

	lw $v0, %number_of_students
	add $a0, $zero, $v0 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $a0, $a0, 3 # Linhas * colunas
	mul $a0, $a0, 4 # *4 bytes
	
	li $v0, 9  # Alocacao dinamica
	syscall
	
	sw $v0, %matrix_start # Salvar comeco da matriz
	add $a0, $v0, $a0 
	sw $a0, %matrix_end # Salvar o final da matriz (endereco inicial + quantidade de bytes alocados)
	add $a0, $zero, $zero # Reset $a0
	
	## Vetor das mÃ©dias
	
	lw $v0, %number_of_students
	add $a0, $zero, $v0 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $a0, $a0, 4 # *4 bytes
	
	li $v0, 9  # Alocacao dinamica
	syscall
	
	sw $v0, start_vector
	

.end_macro

.macro tamanho_da_matriz()

	input_size:
		la $a0, enter_number_of_students # Carrega o endereco da string
 		li $v0, 4 # Codigo de impressao de string
  		syscall # Imprime a string
 		li $v0, 5 # Tamanho da matriz em $v0
 		syscall
 	
	 	blt $v0, 0, error

		sw $v0, number_of_students
		j continue
		
		error:
			li $v0, 4
			la $a0, size_error
			syscall
			j input_size
		
		continue:

.end_macro

.macro leitura(%matrix_start, %number_of_students)
	
	lw $a1, %number_of_students
	li $a2, 3
	
	l: 
		la $a0, Ent1 # Carrega o endereco da string
		li $v0, 4 # Codigo de impressao de string
		syscall # Imprime a string
		move $a0, $t0 # Valor de i para impressao
		add $a0, $a0, 1
		li $v0, 1 # Codigo de impressao de inteiro
		syscall # Imprime i
		la $a0, Ent2 # Carrega o endereco da string
		li $v0, 4 # Codigo de impressao de string
		syscall # Imprime a string
		move $a0, $t1 # Valor de j para impressao
		add $a0, $a0, 1
		li $v0, 1 # Codigo de impressao de inteiro
		syscall # Imprime j
		la $a0, Ent3 # Carrega o endereco da string
		li $v0, 4 # Codigo de impressao de string
		syscall # Imprime a string
		
		li $v0, 6 # Codigo de leitura de float
		syscall # Leitura do valor (retorna em $f0)
		
		indice(%matrix_start, %number_of_students, $t0, $t1)
		s.s $f0, ($v0) # mat [i] [j] = aux
		addi $t1, $t1, 1 # j++
		bgt $a2, $t1, l # if(j < ncol) goto 1
		li $t1, 0 #j = 0
		addi $t0, $t0, 1 # i++
		bgt $a1, $t0, l # if(i < nlin) goto 1
		li $t0, 0 # i = 0

.end_macro

.macro escrita(%matrix_start, %number_of_students)

	lw $a1, %number_of_students
	li $a2, 3
	
	
	e: 
		indice(%matrix_start, %number_of_students, $t0, $t1)
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

.macro 	indice(%matrix_start, %number_of_students, %i, %j)

	li $a2, 3
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


.macro medias(%matrix_start, %number_of_students)

	lw $s0, start_matrix
	lw $s1, start_vector
	
	lw $a1, %number_of_students
	li $a2, 3
	
	l.s $f0, zero
	l.s $f5, tres
	
	m: 
		indice(%matrix_start, %number_of_students, $t0, $t1)
		l.s $f12, ($v0) # Valor em mat [i] [j]
		add.s $f0, $f0, $f12
		addi $t1, $t1, 1 # j++
		blt $t1, $a2, m # if(j < ncol) goto m
		div.s $f1, $f0, $f5
		s.s $f1, ($s1)
		add $s1, $s1, 4
		
		li $t1, 0 #j = 0
		addi $t0, $t0, 1 # i++
		l.s $f0, zero
		blt $t0, $a1, m # if(i < nlin) goto m
		li $t0, 0 #i = 0
	
	# Média da turma
	
	li $t0, 0
	lw $t1, %number_of_students
	lw $s1, start_vector
	
	l.s $f10, zero
	l.s $f30, %number_of_students
	cvt.s.w $f30, $f30
	
	loop_media:
		
		l.s $f8, ($s1)
		
		add.s $f10, $f10, $f8
	
		add $t0, $t0, 1
		
		add $s1, $s1, 4
	
		blt $t0, $t1, loop_media
		
	div.s $f10, $f10, $f30
	
	s.s $f10, media_sala
	
.end_macro 

.macro resultados(%number_of_students)

	li $t0, 0
	lw $t1, %number_of_students
	lw $s1, start_vector
	l.s $f28, minimo
	
	loop_resultados:
		
		la $a0, msg_aluno1
		li $v0, 4
		syscall
		
		add $a0, $t0, 1
		li $v0, 1
		syscall
		
		la $a0, msg_aluno2
		li $v0, 4
		syscall
		
		l.s $f12, ($s1)
		li $v0, 2
		syscall
		
		la $a0, msg_aluno3
		li $v0, 4
		syscall
	
		c.lt.s $f12, $f28
		
		bc1t reprovado
		bc1f aprovado
		
		reprovado:
		
			lw $t8, reprovados
			add $t8, $t8, 1
			sw $t8, reprovados
			
			j continue_resultado 
			
		aprovado:
		
			lw $t9, aprovados
			add $t9, $t9, 1
			sw $t9, aprovados
	
		continue_resultado:
	
			add $t0, $t0, 1
		
			add $s1, $s1, 4
	
		blt $t0, $t1, loop_resultados
		
	la $a0, msg_sala
	li $v0, 4
	syscall
	
	l.s $f12, media_sala
	li $v0, 2
	syscall
	
	la $a0, msg_aluno3
	li $v0, 4
	syscall
	
	lw $a0, aprovados
	li $v0, 1
	syscall
	
	la $a0, msg_aprovados
	li $v0, 4
	syscall
	
	lw $a0, reprovados
	li $v0, 1
	syscall
	
	la $a0, msg_reprovados
	li $v0, 4
	syscall
	

.end_macro

.text

	main:

		tamanho_da_matriz()
		alocar_espaco(start_matrix, end_matrix, number_of_students)	
		leitura(start_matrix, number_of_students)
		jump_line()
		medias(start_matrix, number_of_students)
		resultados(number_of_students)
		finalizar()
