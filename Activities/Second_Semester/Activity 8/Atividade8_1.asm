.data
	msg_enter_n: .asciiz "Entre com o valor de N: "
	appear: .asciiz " aparece "
	times: .asciiz " vezes.\n"
	time: .asciiz " vez.\n"
	jump_line: .asciiz "\n"
	n: .word 0
	start_vector_inputs: .word 0 # Guarda todos os valores unicos colocados pelo usuario
	start_vector_counts: .word 0 # Guarda o numero de vezes que cada valor aparece
	
.text

.macro leitura_n()
	
	la $a0, msg_enter_n
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, n
	
	move $v1, $v0 # $v1 vai guardar o valor para que a multiplicacao com o numero de bytes
	
	mul $a0, $v1, 4 # N * 4 bytes por ser float
	li $v0, 9
	syscall
	
	sw $v0, start_vector_inputs
	
	mul $a0, $v1, 4 # N * 4 bytes por ser float
	li $v0, 9
	syscall
	
	sw $v0, start_vector_counts
	
	li $k0, 0
	li $k1, 1
	
	loop_start_counts:
		
		sw $k1, ($v0)
		add $v0, $v0, 4
		add $k0, $k0, 1
		
		blt $k0, $v1, loop_start_counts
	
.end_macro

.macro inputs()

	li $t0, 0
	lw $t1, n
	lw $s0, start_vector_inputs
	li $k0, 0 # Numero de valores nao repetidos
	
	loop_input:
	
	li $v0, 6
	syscall
	
	check_dupes($f0, $t0)
	
	beq $s7, 1, dont
	
	yes:
		s.s $f0, ($s0)
		add $s0, $s0, 4
		add $k0, $k0, 1
	
	dont:
	
	add $t0, $t0, 1
	blt $t0, $t1, loop_input
	
.end_macro


.macro check_dupes(%value, %limit)

	lw $s1, start_vector_inputs
	lw $s2, start_vector_counts
	li $s7, 0
	
	li $t9, 0 # Contador da posicao
	
	beqz %limit, end_dupes  # Numero de valores inseridos ate agora
	
	loop_dupes:
	
		l.s $f1, ($s1)
		c.eq.s $f1, %value # O numero inserido a igual a algum ja inserido?
		bc1t add_dupe
		bc1f continue_dupes
		
		add_dupe:
		
			lw $s3, ($s2)
			add $s3, $s3, 1
			sw $s3, ($s2)
			li $s7, 1
		continue_dupes:
		
			add $s1, $s1, 4
			add $s2, $s2, 4
			add $t9, $t9, 1
		
		blt $t9, %limit, loop_dupes
	
	end_dupes:

.end_macro

.macro print_values()

	lw $s1, start_vector_inputs
	lw $s2, start_vector_counts
	li $k1, 0
	
	li $v0, 4
	la $a0, jump_line
	syscall
	
	li $v0, 4
	la $a0, jump_line
	syscall
	
	loop_print:
	
		li $v0, 2
		l.s $f12, ($s1)
		syscall
		
		li $v0, 4
		la $a0, appear
		syscall
		
		li $v0, 1
		lw $a0, ($s2)
		syscall
		
		beq $a0, 1, one
		bgt $a0, 1, more
		
		one:
		
			li $v0, 4
			la $a0, time
			syscall
			j continue_print
		more:
		
			li $v0, 4
			la $a0, times
			syscall
		
		continue_print:
		
			add $s1, $s1, 4
			add $s2, $s2, 4
			add $k1, $k1, 1
	
	blt $k1, $k0, loop_print

.end_macro


main:

	leitura_n()
	inputs()
	print_values()
	
	li $v0, 10
	syscall
