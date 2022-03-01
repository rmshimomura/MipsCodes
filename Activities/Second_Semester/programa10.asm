.data 

	pair_sum_vet_A:	.word 0
	even_sum_vet_B: .word 0
	msgTamanho: .asciiz "Insira o tamanho do vetor:"
	msgInserirValores1A: .asciiz "Insira o valor (inteiro!) de VetA["
	msgInserirValores2A: .asciiz "]:"
	msgInserirValores1B: .asciiz "Insira o valor (inteiro!) de VetB["
	msgInserirValores2B: .asciiz "]:"
	msgFinal: .asciiz "A soma dos elementos das posicoes pares de VetA subtraida da soma dos elementos impares de VetB = "
	pulaLinha: .asciiz ".\n"
.text

main:
	jal array_size
	jal allocate_space_B
	jal resultado
	li $v0, 10
	syscall

array_size:
	li $t7, 2					# Divisor
	la $a0, msgTamanho
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $s7, $v0, $zero 				# $s7 vai segurar o valor do tamanho do vetor
	mul $k0, $s7, 4 				# $k0 vai segurar a quantidade de bytes a serem guardados para o vetor todo

allocate_space_A:
	
	li $t2, 1
	add $a0, $zero, $k0
	li $v0, 9
	syscall
	move $s0, $v0					# $s0 comeco A
	add $s1, $s0, $k0
	add $s1, $s1, -4				# $s1 fim A
	move $s2, $s0					# Runner
	j array_read_A

allocate_space_B:
	
	li $t2, 1
	add $a0, $zero, $k0
	li $v0, 9
	syscall
	move $s3, $v0					# $s3 comeco B
	add $s1, $s2, $k0
	add $s4, $s4, -4				# $s4 fim B
	move $s2, $s3					# $s2 runners
	j array_read_B
	
array_read_A:

	la $a0, msgInserirValores1A
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, msgInserirValores2A
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, ($s2)
	add $s2, $s2, 4
	
	div $t2, $t7 # Indice iniciado em $t2 
	mfhi $t8 # Resto da divisao do indice por 2 guardado em $t8 
	beq $t8, $zero, pair_sum
		
continue_A:

	addi $t2, $t2, 1 				# Contador
	ble $t2, $s7, array_read_A
	move $v0, $s0
	jr $ra
	
array_read_B:

	la $a0, msgInserirValores1B
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, msgInserirValores2B
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, ($s2)
	add $s2, $s2, 4
	
	div $t2, $t7 # Indice iniciado em $t2 
	mfhi $t8 # Resto da divisao do indice por 2 guardado em $t8 
	bnez $t8, even_sub # Se o resto da divisao nao for 0, entao o numero eh impar
	
continue_B:
	
	addi $t2, $t2, 1 				# Contador
	ble $t2, $s7, array_read_B
	move $v0, $s0
	jr $ra

pair_sum:
	
	add $s6, $s6, $v0
	j continue_A
	
even_sub:

	sub $s6, $s6, $v0
	j continue_B
	
resultado:

	la $a0, msgFinal
	li $v0, 4
	syscall
	move $a0, $s6
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall	
	jr $ra