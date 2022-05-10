.data
	buffer: .asciiz " "
	Arquivo: .asciiz "dados1.txt"
	Erro: .asciiz "Arquivo não encontrado!\n"
	StartVetor: .word 0
	EndVetor: .word 0
	pos: .word 0
	file_desc: .word 0 
	msg: .asciiz "Comecando pelo indice 0, qual valor devemos mudar?: "
	brk: .asciiz "["
	brk_end: .asciiz "]\n"
	espaco: .asciiz ", "
	temp: .word 0
	chega: .word 0
	spac: .asciiz " "
	size: .word 0
.text

.macro write_number(%number)

	li $v0, 15 # Escrita de arquivo
	add $s7, $zero, %number
	li $s6, 10
	li $s3, 0
	
	loop_number:
	
		div $s7, $s6
		mfhi $s5
		add $s5, $s5, 48
		mflo $s7
		
		sb $s5, ($sp)
		add $sp, $sp, -1
		add $s3, $s3, 1
		
		bgt $s7, $zero, loop_number

	li $v0, 15 # Escrita de arquivo
	lw $a0, file_desc
	move $a1, $sp
	li $a2, 4
	syscall
	add $sp, $sp, $s3

.end_macro 

main:
        la $a0, Arquivo # Nome do arquivo
        li $a1, 0 # Somente leitura
        sw $sp, StartVetor
        li $k0, 0
        jal abertura # Retorna file descriptor no sucesso
        move $s0, $v0 # Salva o file descriptor em $s0
        move $a0, $s0 # Parâmetro file descriptro
        sw $s0, chega
        la $a1, buffer # Buffer de entrada
        li $a2, 1 # 1 caractere por leitura
        jal leitura # Retorna a soma dos números do arquivo
        
        jal ask
        
ask:
	la $a0, msg
	li $v0, 4
	syscall
        
        lw $s0, StartVetor
        
        li $k1, 0
        
        la $a0, brk
	li $v0, 4
	syscall
        
        loop:
        
        	lw $a0, ($s0)
        	li $v0, 1
        	syscall

		la $a0, espaco
		li $v0, 4
		syscall
        	        	        	
        	add $s0, $s0, -4
        	
        	add $k1, $k1, 1
        	
        	blt $k1, $k0, loop
        
        
        la $a0, brk_end
	li $v0, 4
	syscall
        
        li $v0, 5
	syscall
        
        sw $v0, pos
        move $t0, $v0
        
        lw $s0, StartVetor
        
        mul $t9, $t0, -4
        
        add $s0, $s0, $t9
        
        lw $t8, ($s0)
        
        add $t8, $t8, 1
        
        sw $t8, ($s0)
        
        j reescrever
        
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
        
leitura:

        li $v0, 14 # Código de leitura de arquivo
        syscall # Faz a leitura de 1 caractere
        beqz $v0, l # if (EOF) termina a leitura
        lb $t0, ($a1) # Carrega o caractere lido no buffer
        beq $t0, 13, leitura # if (carriage return) ignora
        beq $t0, 32, l # if (space ignora)
        beq $t0, 10, l # if (newline) goto 1
        subi $t0,$t0, 48 # char para decima1
        mul $t1, $t1, 10 # casa decimal para a esquerda
        add $t1, $t1, $t0 # soma a unidade lida
        j leitura	

l:
        add $t2, $t2, $t1 # Soma o número lido
        sw $t1, ($sp)
        sw $sp, EndVetor
        lw $k0, size
        add $k0, $k0, 1
        sw $k0, size
        addi $sp, $sp, -4
        li $t1, 0 # Zera o número
        bnez $v0, leitura # Leitura do próximo número
        
        lw $a0, chega
        li $v0, 16
        syscall
        
	jr $ra

reescrever:
        
        la $a0, Arquivo # Path ate o arquivo
	li $a1, 1 # Escrita
	li $v0, 13 # Abertura de arquivo
	syscall
	move $a0, $v0
	sw $a0, file_desc
	
        li $v0, 15 # Escrita de arquivo
        lw $s0, StartVetor
        lw $t5, EndVetor
        add $sp, $sp, 3
        
        loop_maior:

        	lw $s7, ($s0)
       	 	li $s6, 10
		li $s3, 0
		
		li $k0, 0
        
        	loooooop:
        
	        	div $s7, $s6
			mfhi $s5
			add $s5, $s5, 48
			mflo $s7
		
			sb $s5, ($sp)
			add $sp, $sp, -1
			add $k0, $k0, 1
			
			bgt $s7, $zero, loooooop
			
		li $v0, 15 # Escrita de arquivo
		lw $a0, file_desc
		add $sp, $sp, 1
		move $a1, $sp
		move $a2, $k0
		syscall
		
		li $a0, -1
		li $a1, 0
		
		li $v0, 15 # Escrita de arquivo
		lw $a0, file_desc
		la $a1, spac
		li $a2, 1
		syscall	
		
		add $s0, $s0, -4
		bge $s0, $t5, loop_maior
	
      	li $v0, 10
      	syscall
