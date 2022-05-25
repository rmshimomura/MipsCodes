.data

	x: .double 0.0
	n: .word 0
	one: .double 1.0
	msg_x: .asciiz "\nEntre com o valor de x para saber o cosseno: "
	msg_n: .asciiz "\nEntre com um valor inteiro para a quantidade de termos a serem usados: "

.text

.macro signal(%iteration)

	add $t0, $zero, %iteration
	
	rem $t0, $t0, 2
	
	beq $t0, 1, negative_signal
	
	bge $t0, 0, positive_signal

	negative_signal:
	
		li $t0, -1
		j continue_signal
	
	positive_signal:
	
		li $t0, 1
		j continue_signal
	
	continue_signal:

.end_macro

.macro power(%exponent)

	l.d $f0, x
	l.d $f2, x
	li $t1, 1
	add $t2, $zero, %exponent
	beq $t2, 0, one_power
	
	loop_power:
	
		mul.d $f0, $f0, $f2
		add $t1, $t1, 1	
		blt $t1, $t2, loop_power
		j normal_return_power
		
	one_power:
		l.d $f0, one
	
	normal_return_power:

.end_macro

.macro factorial(%number)

	add $t0, $zero, %number
	beq $t0, 0, return_factorial
	beq $t0, 1, return_factorial
	
	add $t1, $zero, $t0
	add $t1, $t1, -1
	
	loop_factorial:
	
	mul $t0, $t0, $t1
	
	add $t1, $t1, -1
	
	bgt $t1, 1, loop_factorial
	
	j normal_return_factorial
	
	return_factorial:
	
		li $t0, 1

	normal_return_factorial:

.end_macro

.macro inputs()

	la $a0, msg_x
	li $v0, 4
	syscall

	li $v0, 7
	syscall

	s.d $f0, x

	la $a0, msg_n
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	
	sw $v0, n

.end_macro

.macro calculate()

	li $s0, 0
	lw $s1, n
	li $s2, 0

	loop_calculate:
	
		signal($s0) # return on $t0 the signal of the operation
		
		mtc1 $t0, $f20
		cvt.d.w $f20, $f20
		
		power($s2) # return on $f0 the power of the number to the power of $t2
		
		mul.d $f0, $f0, $f20 # Add signal to the power
		
		factorial($s2) # return on $t0 the factorial of $t2
		
		mtc1 $t0, $f20
		cvt.d.w $f20, $f20
		
		div.d $f0, $f0, $f20 # signal * power / factorial
	
		add.d $f30, $f30, $f0
	
		add $s2, $s2, 2
		add $s0, $s0, 1
	
	blt $s0, $s1, loop_calculate
	
	mov.d $f12, $f30
	li $v0, 3
	syscall

.end_macro

main:
	
	inputs()
	calculate()
	li $v0, 10
	syscall
	
