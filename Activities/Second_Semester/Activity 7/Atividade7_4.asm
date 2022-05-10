.data

    file: .asciiz "matrix.txt"
    result: .asciiz "matrix_result.txt"
    file_desc: .word 0
    result_desc: .word 0
    error: .asciiz "Error: file not found"
    buffer: .asciiz " "
    start_vetor: .word 0
    one: .asciiz "1"
    zero: .asciiz "0"
    end_vector: .word 0
    jump_line: .asciiz "\n"
    space: .asciiz " "

    current_instruction: .word 0

    start_matrix: .word 0
    matrix_size: .word 0
    matrix_rows: .word 0

.text	

.macro 	indice(%matrix_start, %matrix_size, %i, %j)

		lw $a2, %matrix_size
		lw $a3, %matrix_start
		mul $v0, %i, $a2 # i * ncol
		add $v0, $v0, %j # (i * ncol) + j
		mul $v0, $v0, 4 # *4 por ser int
		add $v0, $v0, $a3 # Soma o endereco base de mat
		
.end_macro 


main:
        la $a0, file # Nome do arquivo
        li $a1, 0 # Somente leitura
        sw $sp, start_vetor
        li $k0, 0
        jal abertura # Retorna file descriptor no sucessotor no sucesso
        move $s0, $v0 # Salva o file descriptor em $s0ptor em $s0
        move $a0, $s0 # Parametro file descriptorriptor
        sw $s0, file_desc
        la $a1, buffer # Buffer de entrada
        li $a2, 1 # 1 caractere por leitura
        jal leitura 
        jal prepare_arguments
        jal transform_matrix
        jal write_on_file
        li $v0, 10
        syscall
        
abertura:

        li $v0, 13 # Codigo de abertura de arquivo
        syscall # Tenta abrir o arquivo
        bgez $v0, a # if (file descriptor >=0 goto a)
        la $a0, error # else erro: carrega o endereco da string endereco da string
        li $v0, 4 # Codigo de impressao de string
        syscall # Imprime o erro
        li $v0, 10 # Codigo para finalizar o programa
        syscall # Finaliza o programa
    a:  jr $ra # Retorna para a main a:
        
leitura:

        li $v0, 14 # Codigo de leitura de arquivo
        syscall # Faz a leitura de 1 caractere
        beqz $v0, l # if (EOF) termina a leitura
        lb $t0, ($a1) # Carrega o caractere lido no buffer lido no buffer
        beq $t0, 13, leitura # if (carriage return) ignora return) ignora
        beq $t0, 32, l # if (space ignora)
        beq $t0, 10, l # if (newline) goto l
        subi $t0,$t0, 48 # char para decimal
        mul $t1, $t1, 10 # casa decimal para a esquerda
        add $t1, $t1, $t0 # soma a unidade lida
        j leitura	

l:
        add $t2, $t2, $t1 # Soma o numero lido
        sw $t1, ($sp)
        sw $sp, end_vector
        addi $sp, $sp, -4
        li $t1, 0 # Zera o numero
        bnez $v0, leitura # Leitura do proximo numero
        
        lw $a0, file_desc
        li $v0, 16
        syscall
        
	jr $ra

prepare_arguments:

    lw $t0, start_vetor
    lw $t1, ($t0) # Rows
    add $t0, $t0, -4 
    lw $t2, ($t0) # Columns
    add $t0, $t0, -4

    sw $t0, current_instruction
    sw $a0, matrix_rows # Salva o numero de elementos
    mul $a0, $t1, $t2 # Total de elementos
    sw $a0, matrix_size # Salva o numero de elementos
    mul $a0, $a0, 4 # Total de bytes
    li $v0, 9 # Codigo de alocacao de memoriaia
    syscall

    sw $v0, start_matrix

    li $t0, 0 # Zera o contador
    lw $t1, matrix_size # Limit
    li $t2, 1 # O que vai ser posto em cada posicao da matriz

    loop_for_start_matrix:

        sw $t2, ($v0)

        add $v0, $v0, 4

        add $t0, $t0, 1

        blt $t0, $t1, loop_for_start_matrix

    jr $ra

transform_matrix:

    lw $s0, current_instruction

    lw $s1, ($s0) # Numero total de operacoes
    add $s0, $s0, -4
    li $s2, 0 # Posicoes zeradas sao marcadas com zero 
    li $s3, 0 # Contagem de operacoes

    loop_for_transform_matrix:

        lw $t2, ($s0) # i
        add $s0, $s0, -4
        lw $t3, ($s0) # j
        add $s0, $s0, -4

	li $v0, 0

        indice(start_matrix, matrix_rows, $t2, $t3)

        sw $s2, ($v0)

        add $s3, $s3, 1

        blt $s3, $s1, loop_for_transform_matrix

    jr $ra

write_on_file:

    la $a0, result # Nome do arquivo
    li $a1, 1 # Somente escrita
    li $v0, 13 # Codigo de abertura de arquivo
    syscall # Tenta abrir o arquivo
    move $a0, $v0 # Parametro file descriptor

    sw $a0, result_desc

    lw $s0, start_matrix

    lw $s1, matrix_size

    li $s2, 0 # Contador posicoes

    li $s3, 0 # Contador de formato

    lw $s4, matrix_rows

    loop_for_write_on_file:

        lw $t0, ($s0) # Valor da posicao

        beq $t0, 0, insert_zero
        beq $t0, 1, insert_one

        insert_zero:

            la $a1, zero # Carrega o endereco da string zero
        
            j continue_write_on_file

        insert_one:

            la $a1, one # Carrega o endereco da string one

            j continue_write_on_file

        continue_write_on_file:
            li $v0, 15
            lw $a0, result_desc
            li $a2, 1 # 1 caractere por escrita
            syscall
            li $v0, 15
            lw $a0, result_desc
            la $a1, space # Carrega o endereco da string space
            li $a2, 1 # 1 caractere por escrita
            syscall

        add $s2, $s2, 1
        add $s3, $s3, 1

        beq $s3, $s4, print_next_line
        
        j wow

        print_next_line:
	    li $v0, 15
            lw $a0, result_desc
            la $a1, jump_line # Carrega o endereco da string space
            li $a2, 1 # 1 caractere por escrita
            syscall
            li $s3, 0 # Zera o contador de formato
	wow:
        add $s0, $s0, 4
        blt $s2, $s1, loop_for_write_on_file

        jr $ra