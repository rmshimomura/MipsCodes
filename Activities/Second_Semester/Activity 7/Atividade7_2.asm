.data

	ent1: .asciiz "Insira o arquivo: "
	error: .asciiz "Arquivo inexistente!\n"
	file_input: .space 100
	file_output: .asciiz "output.txt"
	buffer: .asciiz " "	
	file_desc: .word 0
	inicio: .word 0
	fim: .word 0

.text


.macro leitura_paremetros(%string, %input_path)

	la $a0, %string
	la $a1, %input_path

	li $v0, 4
	syscall
	move $a0, $a1
	li $a1, 100
	li $v0, 8
	syscall 
	la $t0, file_input
	li $s0, 0
	fix_loop:
	
		lb $t1, 0($t0)
		add $t0, $t0, 1
		bne $t1, 10, fix_loop
		add $t0, $t0, -1
		sb $s0, ($t0) 

.end_macro

.macro leitura_arquivo()

	la $a0, file_input
	li $a1, 0
	li $v0, 13
	syscall

	move $a0, $v0
	
	la $a1, buffer
	li $a2, 1
	
	li $k0, 0
	
	sw $sp, inicio
	
	bgez $v0, read_loop
	
	# Error
	la $a0, error
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	# Error

	
			
	read_loop:
	
		li $v0, 14
		syscall
		
		# ^^^^^^^^^^^^^^^^^ Leitura
		
		beqz $v0, print
		lb $t0, ($a1)
		
		beq $t0, 10, end # \n
		beq $t0, 65, ast # A
		beq $t0, 69, ast # E
		beq $t0, 73, ast # I
		beq $t0, 79, ast # O
		beq $t0, 85, ast # U
		
		beq $t0, 97, ast  # a
		beq $t0, 101, ast # e
		beq $t0, 105, ast # i
		beq $t0, 111, ast # o
		beq $t0, 117, ast # u
		
		j write
		
		ast: 
			add $t0, $zero, 42 # *

		write:

		# vvvvvvvvvvvvvvv Escrita

			sb $t0, ($sp)
			add $sp, $sp, -1
		
			add $k0, $k0, 1
		
			j read_loop

print:

	la $a0, file_output # Path ate o arquivo
	li $a1, 9 # Escrita e append
	li $v0, 13 # Abertura de arquivo
	syscall
	move $a0, $v0
	sw $a0, file_desc
	
	sw $sp, fim
	
	lw $sp, inicio
	
	li $k1, 0
	
	loop:
		li $v0, 15 # Escrita de arquivo
		lw $a0, file_desc
		move $a1, $sp
		li $a2, 1
		syscall
		add $sp, $sp, -1
		add $k1, $k1, 1
		blt $k1, $k0, loop

	j end

end: 
	li $v0, 10
	syscall

.end_macro

main:

	leitura_paremetros(ent1, file_input)
	leitura_arquivo()