.data

	limit: .word 0
	msg_input: .asciiz "Entre com o valor N (N >= 2): "
	msg_error: .asciiz "N deve ser maior ou igual a 2 !\n"
	msg_result: .asciiz " sao primos gemeos\n"
	msg_parentesis_open: .asciiz "("
	msg_middle: .asciiz ","
	msg_parentesis_close: .asciiz ")"
	file: .asciiz "Resultado.txt"
	print: .word 0
	file_desc: .word 0
.text
	
.macro read_input()

j begin_read

error_read:

	li $v0, 4
	la $a0, msg_error
	syscall

begin_read:

	li $v0, 4
	la $a0, msg_input
	syscall
	
	li $v0, 5
	syscall
	
	blt $v0, 2, error_read
	
	sw $v0, limit
	

.end_macro 
	
.macro twin_primes()

	# $k0 = i
	# $k1 = limit from loop i
	# $t0 = current_prime
	# $t1 = [$k0 % 2] or [i % j]
	# $t2 = j
	# $t3 = flag 
	# $t4 = current_prime + 2 (for comparison)

	li $t0, 2
	li $k0, 2
	lw $k1, limit

loop_i_start:

	bgt $k0, $k1, end	
	
	li $s0, 2
	
	div $k0, $s0
	mfhi $t1
	beqz $t1, add_and_return # i % 2 == 0 
	
	li $t2, 2
	li $t3, 0
	
	loop_j_start:
		
		bge $t2, $k0, check_twin # range(2, $k0)
		
		div $k0, $t2 # i / j
		mfhi $t1
		
		beqz $t1, not_prime
		
		add $t2, $t2, 1
		j loop_j_start
	
	not_prime: 
		
		li $t3, 1
		j continue
		
	check_twin:
	
		beqz $t3, second_check
		j continue
	
	second_check:
	
		add $t4, $t0, 2
		beq $t4, $k0, write
		add $t0, $zero, $t4
		j update
		
	write:

		la $a0, file # Path ate o arquivo
		li $a1, 9 # Escrita e append
		li $v0, 13 # Abertura de arquivo
		syscall
		move $a0, $v0
		sw $a0, file_desc
		
		li $v0, 15 # Escrita de arquivo
		la $a1, msg_parentesis_open
		li $a2, 1
		syscall

		write_number($t0)
		
		li $v0, 15 # Escrita de arquivo
		la $a1, msg_middle
		li $a2, 1
		syscall
		
		write_number($t4)
		
		li $v0, 15 # Escrita de arquivo
		la $a1, msg_parentesis_close
		li $a2, 1
		syscall
		
		li $v0, 15 # Escrita de arquivo
		la $a1, msg_result
		li $a2, 19
		syscall
		
		li $v0, 16
		syscall
							
		add $t0, $zero, $k0
		
		j continue
	
	update:
	
		add $t0, $zero, $k0
	
	continue:
	
		add $k0, $k0, 1
		j loop_i_start


	end:
	
		li $v0, 10
		syscall

add_and_return:

	add $k0, $k0, 1
	j loop_i_start

.end_macro

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

	read_input()
	twin_primes()
