.data

	n: .word 0
	start_v1: .word 0
	start_v2: .word 0
	end_v2: .word 0
	msg_start: .asciiz "\nEntre com n: "
	msg_input_1: .asciiz "\nEntre com o valor "
	msg_input_2: .asciiz " do vetor: "
.text

.macro read_inputs()

	la $a0, msg_start
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, n

	move $t0, $v0

	mul $a0, $t0, 4
	li $v0, 9
	syscall
	
	sw $v0, start_v1
	
	mul $a0, $t0, 4
	li $v0, 9
	syscall
	
	sw $v0, start_v2
	
	add $v0, $v0, $a0
	add $v0, $v0, -4
	
	sw $v0, end_v2

	li $t1, 0
	
	lw $s0, start_v1
	
	lw $t0, n

	loop_v1:

		la $a0, msg_input_1
		li $v0, 4
		syscall
		
		move $a0, $t1
		li $v0, 1
		syscall
		
		la $a0, msg_input_2
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, ($s0)
		
		add $s0, $s0, 4
		
		add $t1, $t1, 1
		
	blt $t1, $t0, loop_v1

.end_macro

.macro build_inverse()

	lw $s0, start_v1
	lw $s1, end_v2
	li $k0, 0
	lw $k1, n
	
	
	loop_build:
	
		lw $t0, ($s0)
		sw $t0, ($s1)
		
		add $s0, $s0, 4
		add $s1, $s1, -4
		
		add $k0, $k0, 1
		
		blt $k0, $k1, loop_build

.end_macro

.macro print_vector(%address, %n)

	lw $s0, %address
	lw $k1, %n
	
	li $k0, 0
	
	loop_print:
	
	lw $a0, ($s0)
	li $v0, 1
	syscall
	
	add $a0, $zero, 32
	li $v0, 11
	syscall
	
	add $k0, $k0, 1
	add $s0, $s0, 4
	
	blt $k0, $k1, loop_print
	
	li $a0, 10
	li $v0, 11
	syscall
	

.end_macro

main:

	read_inputs()
	build_inverse()
	print_vector(start_v1, n)
	print_vector(start_v2, n)
	
	li $v0, 10
	syscall
