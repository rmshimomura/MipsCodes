.data
msgTamanho: .asciiz "Insira o tamanho do vetor:"
msgAntes: .asciiz "Vetor original: "
msgDepois: .asciiz "Vetor mudado: "
msgInserirValores1: .asciiz "Insira o valor (inteiro!) de Vet["
msgInserirValores2: .asciiz "]:"
msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
msgShift: .asciiz "Insira o valor para o shift: "

pulaLinha: .asciiz "\n"

valor_shift: .word 0

.text

main:
	jal array_size
	jal obtain_shift
	jal start_shift
	li $v0, 10
	syscall
	
array_size:

	la $a0, msgTamanho
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	ble $v0, $zero, input_error 			# Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
	add $s7, $v0, $zero 				# $s7 vai segurar o valor do tamanho do vetor
	add $k1, $zero, -4				# Multiplicador
	mul $k0, $k1, $s7 				# $k0 vai segurar a quantidade de bytes a serem guardados para o vetor todo
	j add_space
	
input_error :
	
	li $v0, 4 			# Imprimir strings
	la $a0, msgZeroErro 		# Mensagem de erro N <= 0
	syscall
	j array_size

add_space:

	move $s0, $sp 					# $s0 = comeco do vetor
	add $sp, $sp, $k0 				# espaco adicionado "subtraido"
	move $s1, $sp 					# $s1 = final do vetor
	li $t2, 0
	move $s2, $s0

array_read:

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
	addi $t2, $t2, 1 				# Contador
	blt $t2, $s7, array_read 
	move $v0, $s0
	jr $ra

obtain_shift:
	
	la $a0, msgShift
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
before:
	li $t2, 0 			# Reseta para ser o contador
	move $s2, $s0 			# $s2 vai ser o runner
	la $a0, msgAntes
	li $v0, 4
	syscall
	
before_loop:  					# Loop da escrita
	lw $a0, ($s2) 
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $s2, $s2, -4
	addi $t2, $t2, 1
	blt $t2, $s7, before_loop
	move $v0, $s0
	
	la $a0, pulaLinha
	li $v0, 4
	syscall
	
	bge $v0, $s7, reduce 				# Modulo
	blt $v0, $s7, continue				# Normal
	
	
reduce:	

	div $v0, $s7
	mfhi $v0
	sw $v0, valor_shift
	jr $ra
	
continue:

	sw $v0, valor_shift
	jr $ra

start_shift:

	li $t0, 0 # i
	lw $s6, valor_shift
	
	
start_shift_loop_1:
	
	lw $s3, 4($s1) # Ultimo elemento do vetor
	
	add $t2, $s7, -1 # j (tamanho do vetor - 1)
	
	move $s2, $s1 # $s2 = runner do fim
	
	start_shift_loop_2:
		
		
		lw $k0, 4($s2)
		lw $k1, 8($s2)
		
		sw $k0, 8($s2)
		sw $k1, 4($s2)
		
		add $t2, $t2, -1
		
		add $s2, $s2, 4
		
		sle $t3, $t2, 0 # j <= 0
		beqz $t3, start_shift_loop_2

	sw $s3, 0($s0)
	
	add $t0, $t0, 1
	
	sge $t1, $t0, $s6 # $t1 = i >= valor_shift
	
	beqz $t1, start_shift_loop_1
	
	j escrita
	
escrita:
	li $t2, 0 			# Reseta para ser o contador
	move $s2, $s0 			# $s2 vai ser o runner
	la $a0, msgDepois
	li $v0, 4
	syscall
loop:  					# Loop da escrita
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
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra
