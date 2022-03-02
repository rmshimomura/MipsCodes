.data 

	pair_sum_vet_A:	.word 0
	even_sum_vet_B: .word 0
	msgTamanho: .asciiz "Insira o tamanho do vetor:"
	msgInserirValores1A: .asciiz "Insira o valor (inteiro!) de VetA["
	msgInserirValores2A: .asciiz "]:"
	msgInserirValores1B: .asciiz "Insira o valor (inteiro!) de VetB["
	msgInserirValores2B: .asciiz "]:"
	msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
	msgFinal: .asciiz "A soma dos elementos das posicoes pares de VetA subtraida da soma dos elementos impares de VetB = "
	pulaLinha: .asciiz ".\n"
	startC: .word 0
.text

main:
	jal array_size
	jal allocate_space_B
	jal allocate_space_C
	jal escrita
	li $v0, 10
	syscall

array_size:
	li $t7, 2					# Divisor
	la $a0, msgTamanho
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	ble $v0, $zero, input_error 			# Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
	add $s7, $v0, $zero 				# $s7 vai segurar o valor do tamanho do vetor
	mul $k0, $s7, 4 				# $k0 vai segurar a quantidade de bytes a serem guardados para o vetor todo
	j allocate_space_A

input_error :
	
	li $v0, 4 			# Imprimir strings
	la $a0, msgZeroErro 		# Mensagem de erro N <= 0
	syscall
	j array_size	

allocate_space_A:
	
	li $t2, 1
	add $a0, $zero, $k0
	li $v0, 9
	syscall
	move $s0, $v0					# $s0 comeco A
	move $s2, $s0					# Runner
	j array_read_A

allocate_space_B:
	
	li $t2, 1
	add $a0, $zero, $k0
	li $v0, 9
	syscall
	move $s1, $v0					# $s1 comeco B
	move $s2, $s1					# $s2 runners
	j array_read_B
	
allocate_space_C:

	li $t2, 1
	mul $k0, $k0, 2					# Dobro de espaco
	add $a0, $zero, $k0
	li $v0, 9
	syscall
	move $s3, $v0					# $s3 comeco C
	sw $s3, startC
	j build_vector_C

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
	
	addi $t2, $t2, 1 				# Contador
	ble $t2, $s7, array_read_B
	move $v0, $s0
	jr $ra
	
build_vector_C:

	move $t0, $s0 # $t0 no comeco do vetor A
	move $t1, $s1 # $t1 no comeco do vetor B
	li $t9, 1 # $t9 eh o contador
	mul $s7, $s7, 2 # Tamanho do vetor C = 2*tamanho dos outros dois

loop_C:

	lw $t2, ($t0)
	lw $t3, ($t1)

	sw $t2, 0($s3)
	sw $t3, 4($s3)
	
	add $t9, $t9, 2
	
	add $t0, $t0, 4
	add $t1, $t1, 4
	
	add $s3, $s3, 8
	
	ble $t9, $s7, loop_C
	
	jr $ra
	
escrita:

	li $t2, 1 			# Reseta para ser o contador
	lw $t7, startC
	move $s2, $t7 			# $s2 vai ser o runner
loop:  					# Loop da escrita
	lw $a0, ($s2) 
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $s2, $s2, 4
	addi $t2, $t2, 1
	ble $t2, $s7, loop
	move $v0, $s0
	jr $ra
