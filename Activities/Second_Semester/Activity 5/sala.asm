.data

    vector_start: .word 0
    vector_end:  .word 0
    vector_size: .word 0
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
        
        li $v0, 5 # Código de leitura de inteiro
        syscall # Leitura do valor (retorna em $v0)
        
        add $s3, $zero, $v0
        mul $a0, $s3, 4 # Multiplica o valor lido por 4
        
        li $v0, 9 # Código de alocação de memória
        syscall
        
	add $s0, $s0, $v0
       	
        add $v0, $v0, $a0
        add $s1, $zero, $v0 # fim

        jr $ra # Retorna para o main

    save_half:

        div $k0, $s3, 2
        add $t8, $zero, $s0 # Loop em $s0
        
        loop_save_half:

            lw $t0, 0($t8)
            sw $t0, 0($s4)
            add $s4, $s4, 4
            add $t8, $t8, 4
            sub $k0, $k0, 1
            bnez $k0, loop_save_half
            jr $ra
	
     save_second_half:

	div $k0, $s3, 2
        add $t9, $zero, $s4 # Metade do vetor resposta
        
        loop_save_second_half:

            lw $t0, ($s0)
            sw $t0, 0($t9)
            add $s0, $s0, 4
            add $t9, $t9, 4
            sub $k0, $k0, 1
            bnez $k0, loop_save_second_half
            div $k0, $s3, 2
            mul $t5, $k0, -4
            add $s4, $s4, $t5
            jr $ra
	
    allocate_answer:

            
            mul $a0, $s3, 4 # Multiplica o valor lido por 4
            
            li $v0, 9 # Código de alocação de memória
            syscall
            
            add $s4, $zero, $v0 # $s4 comeco
            add $s4, $s4, 4
            
            mul $a0, $s3, 4 # Multiplica o valor lido por 4
            
            add $s5, $s4, $a0
            

            jr $ra # Retorna para o main

    read_vector:

        add $t0, $zero, $zero

        add $t2, $zero, $s0 # Lê o endereço de memória alocado (do vetor)

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
            blt $t0, $s3, loop_read # Verifica se o contador é menor que o tamanho do vetor
            jr $ra # Retorna para o main

    print_vector:

        add $t0, $zero, $zero
        add $t7, $zero, $s4
        
        loop_print:

            lw $a0, 0($t7) # Lê o valor do vetor
            li $v0, 1 # Código de impressão de inteiro
            syscall # Impressão do valor 

            addi $t7, $t7, 4 # Incrementa o endereço de memória

            addi $t0, $t0, 1 # Incrementa o contador
            blt $t0, $s3, loop_print # Verifica se o contador é menor que o tamanho do vetor
            jr $ra # Retorna para o main

    sort: 

    out_loop:
        add $t1, $zero, $zero
        la  $a0, ($s0) 			        # $a0 esta no comeco do vetor
        
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
        bne  $a1, $s1, inner_loop    	# Se o proximo elemento nao for o final, volta para o loop dentro
        bne  $t1, $zero, out_loop    	# Se $t1 = 1, volte para o out_loop
        jr $ra


    reverse_sort: 
    

    reverse_out_loop:
        add $t1, $zero, $zero
        la  $a0, ($s0) 			        # $a0 esta no comeco do vetor
        
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
        bne  $a1, $s1, reverse_inner_loop    	# Se o proximo elemento nao for o final, volta para o loop dentro
        bne  $t1, $zero, reverse_out_loop    	# Se $t1 = 1, volte para o out_loop
        jr $ra
