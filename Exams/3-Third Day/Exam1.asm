# Aluno: Rodrigo Mimura Shimomura 
# Matricula: 202000560249
# Elaborar um programa, em código MIPS, capaz de ler os dados de uma matriz
# quadrada de inteiros. Ao final da leitura o programa deverá imprimir o número
# da linha que contém o menor dentre todos os números lidos e o número da linha
# com o maior elemento ímpar.
# Obs. Deve ser utilizado alocação dinâmica e as linhas e colunas da matriz devem
# ser numeradas a partir de 1 e não de 0.

.data
	start_matrix_1: .word 0
	enter_matrix_size: .asciiz "Entre com o numero de linhas e colunas: "
	Ent1: .asciiz "\nInsira o valor de Mat["
	Ent2: .asciiz "]["
	Ent3: .asciiz "]:"
	matrix_size: .word 0 # Tamanho da matriz
	smallest_number: .word 2147483647 # Maior valor de 32 bits para comparacoes 
	smallest_number_line: .word 0 # Numero da linha do menor numero da matriz
	biggest_odd: .word -2147483647 # Menor valor de 32 bits para comparacoes 
	biggest_odd_line: .word 0 # Numero da linha do maior impar
	result_smallest_number_msg_1: .asciiz "\nO menor valor encontrado na matriz é "
	result_smallest_number_msg_2: .asciiz " na linha "
	result_biggest_odd_msg_1: .asciiz "\nO maior ímpar encontrado na matriz é "
	result_biggest_odd_msg_2: .asciiz " na linha "
	result_biggest_odd_msg_error: .asciiz "\nNão foram inseridos números ímpares!\n"
	error_size: .asciiz "O valor deve sar maior do que 0!\n"

.macro alocar_espaco(%matrix_start, %matrix_size)

	lw $v0, %matrix_size
	add $a0, $zero, $v0 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $a0, $a0, $a0 # Linhas * colunas
	mul $a0, $a0, 4 # *4 bytes
	
	li $v0, 9  # Alocacao dinamica
	syscall
	
	sw $v0, %matrix_start # Salvar comeco da matriz
	add $a0, $zero, $zero # Reset $a0
	add $t0, $zero, $zero # Reset $t0
	

.end_macro

.macro tamanho_da_matriz()

	input_size:
		la $a0, enter_matrix_size # Carrega o endereco da string
 		li $v0, 4 # Codigo de impressao de string
  		syscall # Imprime a string
 		li $v0, 5 # Tamanho da matriz em $v0
 		syscall
		
		ble $v0, 0, problem # Se o n inserido for menor do que 0 (problemas!)
		
		sw $v0, matrix_size
		j continue_input
	
	problem:
	
		la $a0, error_size
		li $v0, 4
		syscall
		j input_size # Repita a leitura
		
	continue_input:
		

.end_macro

.macro leitura(%matrix_start, %matrix_size)
	
	lw $a1, %matrix_size
	lw $a2, %matrix_size
	lw $s0, smallest_number
	lw $s1, biggest_odd
	
	l: 
		la $a0, Ent1 
		li $v0, 4 # Print string
		syscall 
		add $k0, $t0, 1
		move $a0, $k0 
		li $v0, 1 # Print i ($t0)
		syscall 
		la $a0, Ent2 
		li $v0, 4 # Print string
		syscall 
		
		add $k0, $t1, 1
		move $a0, $k0 
		li $v0, 1 # Print j ($t1)
		syscall 
		la $a0, Ent3 
		li $v0, 4 # Print string
		syscall 
		
		li $v0, 5 # Ler valor inteiro
		syscall 
		
		ble $v0, $s0, update_smallest # Se o valor lido é menor ou igual que o menor
		
		j check_odd # Se deu falso na primeira comparacao com o menor, entao veja primeiro se o numero lido é impar ou nao
		
		update_smallest:
		
			move $s0, $v0 # O novo menor número é $v0
			sw $s0, smallest_number # Salvar novo menor número
			add $t8, $t0, 1
			sw $t8, smallest_number_line # Salvar a linha do novo menor número (i + 1)
		
		check_odd:
		
		
			rem $k0, $v0, 2 # Resto da divisao do numero lido por 2
		
			beq $k0, 1, test_biggest_odd # Se for impar, tente ver se é maior ou igual que o maior número
			j continue_reading # Caso contrário, continue a leitura
		
			test_biggest_odd:
			
				bge $v0, $s1, update_biggest_odd # Checa para ver se é maior ou igual ao maior numero
				j continue_reading # Caso falso, vá ler o proximo numero
				
				update_biggest_odd:
				
					move $s1, $v0 # O novo maior impar é $v0
					sw $s1, biggest_odd # Salva o novo maior impar 
					add $t8, $t0, 1
					sw $t8, biggest_odd_line # Salvar a linha do novo maior impar (i + 1) 
					
		continue_reading:
		
		
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

.macro jump_line()
	
	la $a0, 10 # Codigo ASCII para espaco
	li $v0, 11 # Codigo de impressao de caractere
	syscall # Imprime o espaco

.end_macro

.macro write_results()

	la $a0, result_smallest_number_msg_1
	li $v0, 4 # Print string
	syscall
	
	lw $a0, smallest_number
	li $v0,1 # Print menor numero
	syscall
	
	la $a0, result_smallest_number_msg_2
	li $v0, 4 # Print string
	syscall
	
	lw $a0, smallest_number_line
	li $v0,1 # Print linha do menor numero
	syscall
	
	lw $k0, biggest_odd
	beq $k0, -2147483647, error # Se o maior impar nao foi atualizado, imprima um aviso
	
	
	la $a0, result_biggest_odd_msg_1
	li $v0, 4 # Print string
	syscall
	
	lw $a0, biggest_odd
	li $v0,1 # Print maior impar
	syscall
	
	la $a0, result_biggest_odd_msg_2
	li $v0, 4 # Print string
	syscall
	
	lw $a0, biggest_odd_line
	li $v0,1 # Print da linha do maior impar
	syscall
	
	j continue_write_results
	
	error:
	
		la $a0, result_biggest_odd_msg_error
		li $v0, 4 # Print string
		syscall
	
	
	continue_write_results:
	

.end_macro

.text

	main:

		tamanho_da_matriz()
		alocar_espaco(start_matrix_1, matrix_size)
		leitura(start_matrix_1, matrix_size)
		jump_line()
		escrita(start_matrix_1, matrix_size)
		jump_line()
		write_results()
			
		finalizar()