.data
    buffer: .asciiz " "
    Arquivo: .asciiz "dados1.txt"
    Erro: .asciiz "Arquivo não encontrado!\n"
    MaiorValor: .word 0
    MenorValor: .word 999999999
    NumeroDeElementosPares: .word 0
    NumeroDeElementosImpares: .word 0
    Soma: .word 0
    StartVetor: .word 0
    EndVetor: .word 0
    Produtorio: .word 1
    NumeroDeCaracteres: .word 0

    MaiorMsg: .asciiz "\na) O maior valor é: "
    MenorMsg: .asciiz "\nb) O menor valor é: "
    ImparesMsg: .asciiz "\nc) O número de elementos impares é: "
    ParesMsg: .asciiz "\nd) O número de elementos pares é: "
    SomaMsg: .asciiz "\ne) A soma final é: "
    VetorOrdenadoMsg: .asciiz "\nf) Os números ordenados são: "
    VetorOrdenadoRevMsg: .asciiz "\ng) Os números ordenados ao contrário são: "
    ProdutorioMsg: .asciiz "\nh) O produtório dos elementos lidos do arquivo dados1.txt é: "
    NumeroDeCaracteresMsg: .asciiz "\ni) O número de caracteres lidos foi: "

.text
    main:
        la $a0, Arquivo # Nome do arquivo
        li $a1, 0 # Somente leitura
        sw $sp, StartVetor
        jal abertura # Retorna file descriptor no sucesso
        move $s0, $v0 # Salva o file descriptor em $s0
        move $a0, $s0 # Parâmetro file descriptro
        la $a1, buffer # Buffer de entrada
        li $a2, 1 # 1 caractere por leitura
        jal leitura # Retorna a soma dos números do arquivo
        jal sort
        
        la $a0, MaiorMsg
        li $v0, 4
        syscall
        lw $a0, MaiorValor
        li $v0, 1
        syscall
        
        la $a0, MenorMsg
        li $v0, 4
        syscall
        lw $a0, MenorValor
        li $v0, 1
        syscall
        
        la $a0, ImparesMsg
        li $v0, 4
        syscall
        lw $a0, NumeroDeElementosImpares
        li $v0, 1
        syscall
        
        la $a0, ParesMsg
        li $v0, 4
        syscall
        lw $a0, NumeroDeElementosPares
        li $v0, 1
        syscall
        
        la $a0, SomaMsg
        li $v0, 4
        syscall
        lw $a0, Soma
        li $v0, 1
        syscall
        
        jal escrita
        
        jal sort_rev
        
        jal escrita_rev
        
        jal prod
        
        la $a0, NumeroDeCaracteresMsg
        li $v0, 4
        syscall
        lw $a0, NumeroDeCaracteres
        li $v0, 1
        syscall
        
        li $v0, 16 # Código para fechar o arquivo
        move $a0, $s0 # Parâmetro file descriptor
        syscall # Fecha o arquivo
        
        li $v0, 10 # Código para finalizar o programa
        syscall # Finaliza o programa

    leitura:

        li $v0, 14 # Código de leitura de arquivo
        syscall # Faz a leitura de 1 caractere
        beqz $v0, l # if (EOF) termina a leitura
        lb $t0, ($a1) # Carrega o caractere lido no buffer
        beq $t0, 13, leitura # if (carriage return) ignora
        beq $t0, 32, l # if (space ignora)
        beq $t0, 10, l # if (newline) goto 1
        lw $s7, NumeroDeCaracteres
        add $s7, $s7, 1
        sw $s7, NumeroDeCaracteres
        subi $t0,$t0,48 # char para decima1
        mul $t1, $t1, 10 # casa decimal para a esquerda
        add $t1, $t1, $t0 # soma a unidade lida
        j leitura	

    l:
        add $t2, $t2, $t1 # Soma o número lido
        sw $t1, ($sp)
        sw $sp, EndVetor
        addi $sp, $sp, -4

    maior_e_menor:
        lw $t8, MaiorValor
        lw $t9, MenorValor
        
        bgt $t1, $t8, update_maior
        
        check_other:
            
            blt $t1, $t9, update_menor
            j pares_e_impares

        update_maior:
    
            sw $t1, MaiorValor
            j check_other
    
        update_menor:
    
            sw $t1, MenorValor

    pares_e_impares:

        div $t7, $t1, 2
        mfhi $k0
        beq $k0, 0, par
        beq $k0, 1, impar
        
        par:
            lw $t8, NumeroDeElementosPares
            add $t8, $t8, 1
            sw $t8, NumeroDeElementosPares
            j continue
        
        impar:

            lw $t9, NumeroDeElementosImpares
            add $t9, $t9, 1
            sw $t9, NumeroDeElementosImpares
            j continue

        continue:       
            li $t1, 0 # Zera o número
            bnez $v0, leitura # Leitura do próximo número
            beqz $v0, f
    f:
        sw $t2, Soma
        jr $ra

    abertura:
        li $v0, 13 # Codigo de abertura de arquivo
        syscall # Tenta abrir o aqurivo
        bgez $v0, a # if (file descriptor >=0) goto a
        la $a0, Erro # else erro: carrega o endereço da string
        li $v0, 4 # Código de impressão de string
        syscall # Imprime o erro
        li $v0, 10 # Código para finalizar o programa
        syscall # Finaliza o programa
    a:  jr $ra # Retorna para a main a:

sort: 

loopFora:
	add $t1, $zero, $zero
	lw  $a0, StartVetor 			# $a0 esta no comeco do vetor
	lw $s1, EndVetor 			# $s1 esta no final do vetor
	
loopDentro:
	lw  $t2, 0($a0)         	# $t2 = elemento atual
	lw  $t3, -4($a0)         	# $t3 = proximo elemento
    	slt $t5, $t3, $t2       	# $t5 = 1 se $t3 < $t2
    	beq $t5, $zero, continuar   	# Se $t5 = 1, troca os valores
    	add $t1, $zero, 1          	# Checar novamente
    	sw  $t2, -4($a0)         	# Trocar
    	sw  $t3, 0($a0)			# Trocar
continuar:
	addi $a0, $a0, -4            	# Proximo elemento
	addi $a1, $a0, -4	     	# Proximo do proximo elemento
	bge  $a1, $s1, loopDentro    	# Se o proximo elemento nao for o final, volta para o loop dentro
	bne  $t1, $zero, loopFora    	# Se $t1 = 1, volte para o loopFora
	jr $ra

escrita:
	li $t2, 0 			# Reseta para ser o contador
	lw $s0, StartVetor
	lw $s1, EndVetor
	li $v0, 4
	la $a0, VetorOrdenadoMsg
	syscall
	move $s2, $s0 			# $s2 vai ser o runner
	
loop:  					# Loop da escrita
	lw $a0, ($s2) 
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $s2, $s2, -4
	bge $s2, $s1, loop
	move $v0, $s0
	jr $ra
	
#======================================

sort_rev: 

loopFora_rev:
	add $t1, $zero, $zero
	lw  $a0, StartVetor 			# $a0 esta no comeco do vetor
	lw $s1, EndVetor 			# $s1 esta no final do vetor
	
loopDentro_rev:
	lw  $t2, 0($a0)         	# $t2 = elemento atual
	lw  $t3, -4($a0)         	# $t3 = proximo elemento
    	sgt $t5, $t3, $t2       	# $t5 = 1 se $t3 > $t2
    	beq $t5, $zero, continuar_rev   	# Se $t5 = 1, troca os valores
    	add $t1, $zero, 1          	# Checar novamente
    	sw  $t2, -4($a0)         	# Trocar
    	sw  $t3, 0($a0)			# Trocar
continuar_rev:
	addi $a0, $a0, -4            	# Proximo elemento
	addi $a1, $a0, -4	     	# Proximo do proximo elemento
	bge  $a1, $s1, loopDentro_rev    	# Se o proximo elemento nao for o final, volta para o loop dentro
	bne  $t1, $zero, loopFora_rev    	# Se $t1 = 1, volte para o loopFora
	jr $ra

escrita_rev:
	li $t2, 0 			# Reseta para ser o contador
	lw $s0, StartVetor
	lw $s1, EndVetor
	li $v0, 4
	la $a0, VetorOrdenadoRevMsg
	syscall
	move $s2, $s0 			# $s2 vai ser o runner
	
loop_rev:  					# Loop da escrita
	lw $a0, ($s2) 
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $s2, $s2, -4
	bge $s2, $s1, loop
	move $v0, $s0
	jr $ra
	
prod:

	lw $t0, Produtorio
	lw $s0, StartVetor
	lw $s1, EndVetor
	move $s2, $s0
	
	loop_prod:
		lw $a0, ($s2) 
		mul $t0, $t0, $a0
		add $s2, $s2, -4
		bge $s2, $s1, loop_prod
		li $v0, 4
		la $a0, ProdutorioMsg
		syscall
		li $v0, 1
		add $a0, $zero, $t0
		syscall
		jr $ra