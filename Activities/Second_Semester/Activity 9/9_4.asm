.data

	x: .word 0
	y: .word 0
	n: .word 0
	input_x: .asciiz "Entre com x: "
	input_y: .asciiz "Entre com y: "
	input_n: .asciiz "Entre com n: "
.text

.macro read_inputs()

	la $a0, input_x
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, x
	
	la $a0, input_y
	li $v0, 4
	syscall
	li $v0, 5
	syscall

	sw $v0, y
			
	la $a0, input_n
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, n

.end_macro

.macro results()

	lw $s0, x
	lw $s1, y
	li $k0, 0
	lw $k1, n
	li $t0, 1
	
	loop_results:
	
		rem $t1, $t0, $s0
		rem $t2, $t0, $s1
		
		beq $t1, 0, check_both
		beq $t2, 0, print_number # i % y == 0
		j continue
		
		check_both:
		
			beq $t2, 0, print_number # i % x == 0 and i % y == 0
			bne $t2, 0, print_number # i % x == 0
			j  continue
			
		print_number:
		
			add $k0, $k0, 1
		
			move $a0, $t0
			li $v0, 1
			syscall
			
			li $a0, 32
			li $v0, 11
			syscall
			
		continue:
		
			add $t0, $t0, 1
	
	blt $k0, $k1, loop_results
	

.end_macro

.macro end()

	li $v0, 10
	syscall

.end_macro

	main:
	
		read_inputs()
		results()
		end()
