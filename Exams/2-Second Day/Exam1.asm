# Aluno: Rodrigo Mimura Shimomura 
# Matricula: 202000560249
# Elaborar um programa em MIPS que leia os valores de n e p fornecidos pelo
# usuário (teclado) e calcule o valor do arranjo.

.data

	enter_n: .asciiz "\nEntre com n:"
	enter_p: .asciiz "\nEntre com p:"

	n: .word 0
	p: .word 0
	error_msg: .asciiz "\nO numero deve ser maior que 0!\n"
	error_bigger_msg: .asciiz "\nn deve ser maior do que p!\n"
	result: .asciiz "\nO resultado do arranjo com os valores inseridos é: "

.text

.macro factorial(%number)

	add $t0, $zero, %number
	beq $t0, 0, return_factorial # Se o numero passado for 0 ou 1, o fatorial é 1
	beq $t0, 1, return_factorial
	
	add $t1, $zero, $t0
	add $t1, $t1, -1 # (n-1)
	
	loop_factorial:
	
	mul $t0, $t0, $t1 # n * (n-1)
	
	add $t1, $t1, -1
	
	bgt $t1, 1, loop_factorial
	
	j normal_return_factorial
	
	return_factorial:
	
		li $t0, 1

	normal_return_factorial:

.end_macro

.macro read_inputs()
	
	start_read:
	
		la $a0, enter_n
		li $v0, 4 # Imprimir strings
		syscall
	
		li $v0, 5 # Ler n
		syscall
	
	blt $v0, 0, error # Checadores de validez
	
		sw $v0, n
	
		la $a0, enter_p
		li $v0, 4 # Imprimir strings
		syscall
	
		li $v0, 5 # Ler p
		syscall
	
	blt $v0, 0, error # Checadores de validez
	
		sw $v0, p
	
	lw $v0, n
	lw $v1, p
	
	bgt $v1, $v0, error_bigger # Checadores de validez
	
	j continue_read
	
	error: 
	
		la $a0, error_msg
		li $v0, 4
		syscall
		j start_read
	
	error_bigger:
	
		la $a0, error_bigger_msg
		li $v0, 4
		syscall
		j start_read
	
	continue_read:
	
	
.end_macro

.macro calculate()

	lw $s0, n
	factorial($s0) # n!
	move $k0, $t0 # factorial($s0) retorna em $t0, o fatorial de $s0
	lw $s1, p
	sub $s2, $s0, $s1 # (n-p)
	factorial($s2) # (n-p)!
	move $k1, $t0
	
	la $a0, result
	li $v0, 4
	syscall
	
	div $a0, $k0, $k1 # n!/(n-p)!
	
	li $v0, 1
	syscall
	
	li $v0, 10 # Finalizar programa
	syscall
	
	
.end_macro

main:
	read_inputs()
	calculate()
