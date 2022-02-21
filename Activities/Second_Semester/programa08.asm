.data
msgTamanho: .asciiz "Insira o tamanho do vetor:"
msgInserirValores1: .asciiz "Insira o valor de Vet["
msgInserirValores2: .asciiz "]:"
msgSomaElementosPares: .asciiz "Soma dos elementos pares: "
msgNumeroMaiorMenor: .asciiz "Numero de elementos k < vet[i] < 2k: "
msgNumeroIgual: .asciiz "Numero de elementos iguais a k: "
msgValorK: .asciiz "Insira o valor K: "
pulaLinha: .asciiz "\n"

.text

main:
	jal tamanho_vetor
	jal sort # A
	jal escrita 
	jal somarPares # B
	jal maior_menor # C
	jal iguais # D
	
	li $v0, 10
	syscall
	
tamanho_vetor:

	la $a0, msgTamanho
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $s7, $v0, $zero # $s7 vai segurar o valor do tamanho do vetor
	add $k1, $zero, -4
	mul $k0, $k1, $s7 # $k0 vai segurar a quantidade de bytes a serem guardados para o vetor todo
	
	j adicionar_espaco
	
adicionar_espaco:

	move $s0, $sp # $s0 = comeco do vetor
	add $sp, $sp, $k0 # espaco adicionado "subtraido"
	move $s1, $sp # $s1 = final do vetor
	li $t2, 0
	move $s2, $s0

leitura_vetor:

	la $a0, msgInserirValores1
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, msgInserirValores2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, ($s2)
	add $s2, $s2, -4
	addi $t2, $t2, 1 # Contador
	blt $t2, $s7, leitura_vetor 
	move $v0, $s0
	jr $ra

# Letra A
sort: 

loopFora:
	add $t1, $zero, $zero
	la  $a0, ($s0) # $a0 esta no comeco do vetor
	
loopDentro:
	lw  $t2, 0($a0)         # $t2 = elemento atual
	lw  $t3, -4($a0)         # $t3 = proximo elemento
    	slt $t5, $t3, $t2       # $t5 = 1 se $t3 < $t2
    	beq $t5, $zero, continuar   # Se $t5 = 1, troca os valores
    	add $t1, $zero, 1          # Checar novamente
    	sw  $t2, -4($a0)         # Trocar
    	sw  $t3, 0($a0)		# Trocar
continuar:
	addi $a0, $a0, -4            # Proximo elemento
	addi $a1, $a0, -4	     # Proximo do proximo elemento
	bne  $a1, $s1, loopDentro    # Se o proximo elemento nao for o final, volta para o loop dentro
	bne  $t1, $zero, loopFora    # Se $t1 = 1, volte para o loopFora
	jr $ra

escrita:
	li $t2, 0 # Reseta para ser o contador
	move $s2, $s0 # $s2 vai ser o runner
loop:  # Loop da escrita
	lw $a0, ($s2) 
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $s2, $s2, -4
	addi $t2, $t2, 1
	blt $t2, $s7, loop
	move $v0, $s0
	jr $ra

# Letra B
somarPares:

	li $t2, 0 # Reseta para ser o contador
	move $s2, $s0 # $s2 vai ser o runner
	add $t3, $zero, 2

somarParesLoop:
	lw $t4, ($s2) # Carrega em $t4, o valor do endereco $s2
	div $t4, $t3 # Divide $t4 por $t3
	mfhi $s3 # Resto da divisao vai para $s3
	beq $s3, 0, soma # Se o resto for igual a zero, entao o numero eh par
	add $s2, $s2, -4 # Proximo elemento do vetor
	addi $t2, $t2, 1 # Contador
	blt $t2, $s7, somarParesLoop
	move $v0, $s0
	j resultadoPares
	
soma: 
	add $s4, $s4, $t4
	add $s2, $s2, -4 # Proximo elemento do vetor
	addi $t2, $t2, 1 # Contador
	blt $t2, $s7, somarParesLoop
	
resultadoPares:
	la $a0, pulaLinha
	li $v0, 4
	syscall
	la $a0, msgSomaElementosPares
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra

# Letra C

maior_menor:
	add $s4, $zero, $zero # Reseta o numero de valores maiores que K e menores que 2k
	li $t2, 0 # Reseta para ser o contador
	move $s2, $s0 # $s2 vai ser o runner
	la $a0, msgValorK
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $t5, $zero, $v0 # $t5 = K
	mul $t6, $v0, 2    # $t6 = 2K
	j loop_maior_menor

loop_maior_menor:
	
	lw $t4, ($s2) # Carrega em $t4, o valor do endereco $s2
	
	sgt $t8, $t4, $t5 # vet[i] > k
	slt $t9, $t4, $t6 # vet[i] < 2k
	
	beqz $t8, return 
	beqz $t9, return
	
	add $s4, $s4, 1 # S4 = numero de [k < valor < 2k]
	add $s2, $s2, -4
	addi $t2, $t2, 1
	blt $t2, $s7, loop_maior_menor
	move $v0, $s0
	
	la $a0, msgNumeroMaiorMenor
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra

return:

	add $s2, $s2, -4
	addi $t2, $t2, 1 
	blt $t2, $s7, loop_maior_menor
	move $v0, $s0

	la $a0, msgNumeroMaiorMenor
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra
	
iguais:
	add $s4, $zero, $zero # Reseta o numero de valores iguais a K
	li $t2, 0 # Reseta para ser o contador
	move $s2, $s0 # $s2 vai ser o runner
	la $a0, msgValorK
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $t5, $zero, $v0 # $t5 = K
	j loop_iguais

loop_iguais:

	lw $t4, ($s2) # Carrega em $t4, o valor do endereco $s2
	
	seq $t8, $t4, $t5 # vet[i] == k
	
	beq $t8, 1, adicionar_igual
	
	add $s2, $s2, -4 # Andar endereco
	addi $t2, $t2, 1 # Andar contador 
	blt $t2, $s7, loop_iguais
	
	move $v0, $s0
	la $a0, msgNumeroIgual
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra
	
	
adicionar_igual:

	add $s4, $s4, 1  # Aumentar numero de iguais
	add $s2, $s2, -4 # Andar endereco
	addi $t2, $t2, 1 # Andar contador 
	blt $t2, $s7, loop_iguais
	move $v0, $s0
	la $a0, msgNumeroIgual
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra
	