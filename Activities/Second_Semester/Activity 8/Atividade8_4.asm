.data
	msg_enter_n: .asciiz "Entre com o valor de N: "
	jump_line: .asciiz "\n"
	n: .word 0
	start_vector_inputs: .word 0 # Guarda todos os valores unicos colocados pelo usuario
	cur_sum: .float 0
	max_sum: .float 0
	start: .float 0
	end: .float 0
	zero: .float 0
	msg_sum_1: .asciiz "\nA maior soma eh "
	msg_sum_2: .asciiz " do segmento ("
	msg_sum_3: .asciiz ", "
	msg_sum_4: .asciiz ").\n"
	
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
	
	li $k0, 0
	
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
	
	loop_input:
	
	li $v0, 6
	syscall
	
	s.s $f0, ($s0)
	add $s0, $s0, 4

	
	add $t0, $t0, 1
	blt $t0, $t1, loop_input
	
.end_macro

.macro print_values()

	lw $s1, start_vector_inputs

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
		
		la $a0, jump_line
		li $v0, 4
		syscall
		
		add $s1, $s1, 4
		add $k1, $k1, 1
	
	blt $k1, $k0, loop_print

	
	la $a0, msg_sum_1
	li $v0, 4
	syscall
	
	mov.s $f12, $f0
	li $v0, 2
	syscall
	
	la $a0, msg_sum_2
	li $v0, 4
	syscall
	
	mov.s $f12, $f2
	li $v0, 2
	syscall

	la $a0, msg_sum_3
	li $v0, 4
	syscall
	
	mov.s $f12, $f3
	li $v0, 2
	syscall
	
	la $a0, msg_sum_4
	li $v0, 4
	syscall

.end_macro

.macro sum()

	l.s $f0, max_sum
	l.s $f1, cur_sum
	
	lw $s0, start_vector_inputs
	
	li $k0, 0
	lw $k1, n
	
	
	loop_sum:
	
		l.s $f30, ($s0)
	
		c.eq.s $f1, $f26 # $f6 vai ser o zero para comparacao
		bc1t reset
		bc1f continue_1_sum
		
		reset:
		
			mov.s $f2, $f30
		
		continue_1_sum:
		
			add.s $f1, $f1, $f30
			
		c.lt.s $f0, $f1 # $f0 < $f1 
		bc1t update
		bc1f continue_2_sum
		
		update:
			
			mov.s $f0, $f1
			mov.s $f3, $f30
		
		continue_2_sum:
		
		c.lt.s $f1, $f26 # $f1 < 0
			
		bc1t rest
		bc1f continue_3_sum
		
		rest:
			mov.s $f1, $f26
		
		continue_3_sum:
			
	
		add $k0, $k0, 1
		add $s0, $s0, 4
	
	
	blt $k0, $k1, loop_sum

.end_macro


main:

	leitura_n()
	inputs()
	sum()
	print_values()
	
	li $v0, 10
	syscall
