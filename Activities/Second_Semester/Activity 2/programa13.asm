.data 
	
	msgSize: .asciiz "Insert array size:"
	msgInsertValues1: .asciiz "Insert the integer value of VetA["
	msgInsertValues2: .asciiz "]:"
	jumpLine: .asciiz ".\n"
	errorMessage: .asciiz "Size value must be greater than 0!\n\n"
.text

main:

	jal array_size
	jal fix
	li $v0, 10
	syscall

array_size:

	la $a0, msgSize
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	ble $v0, $zero, input_error 
	add $s7, $v0, $zero 				# $s7 = array size
	mul $k0, $s7, 4 				# $k0 = number of necessary bytes for the array
	j allocate_space
	
input_error :
	
	li $v0, 4 			# Imprimir strings
	la $a0, errorMessage 		# Mensagem de erro N <= 0
	syscall
	j array_size

	
allocate_space:
	
	li $t2, 1
	add $a0, $zero, $k0
	li $v0, 9
	syscall
	move $s0, $v0					# $s0 = array start
	add $s1, $s0, $k0
	add $s1, $s1, -4				# $s1 = array end
	move $s2, $s0					# Runner
	j array_read

array_read:

	la $a0, msgInsertValues1
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, msgInsertValues2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, ($s2)
	add $s2, $s2, 4

	addi $t2, $t2, 1 				# counter
	ble $t2, $s7, array_read
	move $v0, $s0
	jr $ra

fix:
	li $t8, 1
	move $s2, $s0 # Runner das iteracoes dentro
	move $s3, $s0 # Runner fora
	j loop_fix
	
back:
	add $t8, $t8, 1
	move $s2, $s3
	blt $t8, $s7, loop_fix
	beq $t8, $s7, escrita 

loop_fix:
	
	la $t0, 0($s2)
	la $t1, 4($s2)
	
	lw $t3, ($t0)
	lw $t4, ($t1)	

	beqz $t3, look
	add $s2, $s2, 4
	add $s3, $s3, 4
	add $t8, $t8, 1
	bne $s3, $s1, loop_fix
	j escrita

look:
	bgt $t1, $s1, back
	bnez $t4, swap
	beqz $t4, find
	
	find:
		add $t1, $t1, 4
		lw $t4, ($t1)
		j look
	
swap:
	
	sw $t3, ($t1)
	sw $t4, ($t0)
	
	add $s3, $s3, 4
	j back

escrita:
	li $t2, 0 			# Reseta para ser o contador
	move $s2, $s0 			# $s2 vai ser o runner
loop:  					# Loop da escrita
	lw $a0, ($s2) 
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $s2, $s2, 4
	addi $t2, $t2, 1
	blt $t2, $s7, loop
	move $v0, $s0
	jr $ra