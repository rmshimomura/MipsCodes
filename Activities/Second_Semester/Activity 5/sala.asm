.data

    vector_start: .word 0
    vector_end:  .word 0
    vector_size: .word 0
    
    answer_start: .word 0
    answer_end: .word 0
    
    msg_vector_size_input: .asciiz "Entre com o tamanho do vetor: "
    msg_input_1: .asciiz "Entre com o valor Vet["
    msg_input_2: .asciiz "]: "

.text


    main:

        jal allocate_space
        
        jal read_vector

        jal sort
        
        jal allocate_answer
        
        jal save_half

        jal reverse_sort
    
	jal save_second_half
	
        jal print_vector

        li $v0, 10
        syscall
        

    allocate_space:

        la $a0, msg_vector_size_input # Carrega a string msg_vector_size_input em $a0
        li $v0, 4 # Escrita de string
        syscall
        
        li $v0, 5 # Codigo de leitura de inteiro
        syscall # Leitura do valor (retorna em $v0)
        
        sw $v0, vector_size
        
        mul $a0, $v0, 4 # Multiplica o valor lido por 4
        
        li $v0, 9 # Código de alocação de memória
        syscall
        
        sw $v0, vector_start
       	
        add $v0, $v0, $a0
        sw $v0, vector_end

        jr $ra # Retorna para o main

    save_half:

        lw $t7, vector_size
        div $k0, $t7, 2
        lw $t8, vector_start
        lw $t9, answer_start
        
        loop_save_half:

            lw $t0, 0($t8)
            sw $t0, 0($t9)
            add $t9, $t9, 4
            add $t8, $t8, 4
            sub $k0, $k0, 1
            bnez $k0, loop_save_half
            jr $ra
	
     save_second_half:

        lw $t7, vector_size
        div $k0, $t7, 2
        lw $t4, vector_start
        
        loop_save_second_half:

            lw $t0, ($t4)
            sw $t0, 0($t9)
            add $t4, $t4, 4
            add $t9, $t9, 4
            sub $k0, $k0, 1
            bnez $k0, loop_save_second_half
            jr $ra
	
    allocate_answer:

	    lw $t0, vector_size            
            mul $a0, $t0, 4 # Multiplica o tamanho do vetor resposta por 4
            
            li $v0, 9 # Código de alocação de memória
            syscall
            
            add $v0, $v0, 4 # Evitar invadir memoria
            
            sw $v0, answer_start
            
            mul $a0, $t0, 4 # Multiplica o valor do tamanho do vetor por 4
            
            add $v0, $v0, $a0 # Vai ate o final do vetor
            
            sw $v0, answer_end

            jr $ra # Retorna para o main

    read_vector:

        add $t0, $zero, $zero
	lw $t1, vector_size
        lw $t2, vector_start # Lê o endereço de memória alocado (do vetor)

        loop_read:

            la $a0, msg_input_1 # Carrega a string msg_vector_size_input em $a0
            li $v0, 4 # Escrita de string
            syscall

            move $a0, $t0 # Carrega a string msg_vector_size_input em $a0
            li $v0, 1 # Escrita de inteiro
            syscall

            la $a0, msg_input_2 # Carrega a string msg_vector_size_input em $a0
            li $v0, 4 # Escrita de string
            syscall

            li $v0, 5 # Código de leitura de inteiro
            syscall # Leitura do valor (retorna em $v0)

            sw $v0, 0($t2) # Armazena o valor lido no vetor
            addi $t2, $t2, 4 # Incrementa o endereço de memória
            addi $t0, $t0, 1 # Incrementa o contador
            blt $t0, $t1, loop_read # Verifica se o contador é menor que o tamanho do vetor
            jr $ra # Retorna para o main

    print_vector:

        add $t0, $zero, $zero
        lw $t7, answer_start
        lw $t9, vector_size
        
        loop_print:

            lw $a0, 0($t7) # Lê o valor do vetor
            li $v0, 1 # Código de impressão de inteiro
            syscall # Impressão do valor 

            addi $t7, $t7, 4 # Incrementa o endereço de memória

            addi $t0, $t0, 1 # Incrementa o contador
            blt $t0, $t9, loop_print # Verifica se o contador é menor que o tamanho do vetor
            jr $ra # Retorna para o main

    sort: 

    out_loop:
        add $t1, $zero, $zero
        lw  $a0, vector_start 			        # $a0 esta no comeco do vetor
        lw $t8, vector_end
        
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
        jr $ra


    reverse_sort: 
    

    reverse_out_loop:
        add $t1, $zero, $zero
        lw  $a0, vector_start 			        # $a0 esta no comeco do vetor
        lw $t8, vector_end
        
    reverse_inner_loop:
        lw  $t2, 0($a0)         	    # $t2 = elemento atual
        lw  $t3, 4($a0)         	    # $t3 = proximo elemento
            sgt $t5, $t3, $t2       	# $t5 = 1 se $t3 > $t2
            beq $t5, $zero, reverse_continue    # Se $t5 = 1, troca os valores
            add $t1, $zero, 1          	# Checar novamente
            sw  $t2, 4($a0)         	# Trocar
            sw  $t3, 0($a0)			    # Trocar
    reverse_continue:
        addi $a0, $a0, 4            	# Proximo elemento
        addi $a1, $a0, 4	     	# Proximo do proximo elemento
        bne  $a1, $t8, reverse_inner_loop    	# Se o proximo elemento nao for o final, volta para o loop dentro
        bne  $t1, $zero, reverse_out_loop    	# Se $t1 = 1, volte para o out_loop
        jr $ra
