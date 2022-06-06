.data

	n: .word 0
	start_v1: .word 0
	start_v2: .word 0
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

	li $t1, 0
	
	lw $s0, start_v1

	loop_v1:

		la $a0, msg_input_1
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall
		
		la $a0, msg_input_2
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, ($s0)
		
		add $s0, $s0, 4
		
		add $t0, $t0, -1
		
	blt $t1, $t0, loop_v1

.end_macro


main:

	read_inputs()
	
	li $v0, 10
	syscall
