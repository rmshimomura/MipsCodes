.data

	cpf: .space 100
	input: .asciiz "Insira o CPF: "
	error: .asciiz "CPF inválido!\n"
	success: .asciiz "CPF válido!\n"
	first_digit: .byte 0
	second_digit: .byte 0

.text

main:

	reading_start:
	
		la $a0, input # Endereço da string carregada para receber do usuário
		li $v0, 4 # Print string
		syscall # syscall
		la $a0, cpf # Endereço da string
		li $a1, 100 # Tamanho máximo do buffer
		li $v0, 8 # Leitura de string do usuário 
		syscall  # Syscall
		
	li $t0, 0 # Tamanho da string
	la $s0, cpf # Endereço da string inputada
	
	loop_find:
	
		lb $t1, ($s0)
	
	beq $t1, 45, trace # Checa por -
				
	beq $t1, 10, end_find # Checar se o byte carregado no registrador é igual ao \n
	
	beq $t1, 0, end_find
	
	add $t0, $t0, 1 # Aumenta o tamanho do número
	
	j continue_loop_find
	
	trace:
	
		li $t2, 1 # Ve se a string recebida tem um traço
		move $t3, $s0
		add $t3, $t3, 1
		lb $t4, ($t3)
		sb $t4, first_digit # Guarda o primeiro digito
		add $t3, $t3, 1
		lb $t4, ($t3)
		sb $t4, second_digit # Guarda o segundo digito

		
	continue_loop_find:
	
		add $s0, $s0, 1 # Próximo byte
	
	j loop_find
	
	
	end_find:
	
		beq $t2, 0, trash # Se o cpf for invalido... (sem -...)
		bne $t0, 11, trash # Se o cpf for invalido... (menos de 11 digitos...)
		j start_check_first_digit
	trash:
	
		la $a0, error
		li $v0, 4
		syscall
		
		j reading_start # Recomece
		
	start_check_first_digit:
		
		la $s0, cpf
		lb $t0, first_digit
		add $t0, $t0, -48
		li $t2, 10 # Factor
		li $t3, 0 # Sum
		
		loop_first_check:
		
			lb $t1, ($s0)
			
			beq $t1, 45, end_first_check
			
			add $t1, $t1, -48 # Conversao ASCII -> number
			## Contas do .pdf
			mul $k0, $t1, $t2
			add $t3, $t3, $k0
			add $t2, $t2, -1
			
			add $s0, $s0, 1
			
			j loop_first_check
			
			
		end_first_check:
		
			rem $t4, $t3, 11 # Resto da divisao
		
			blt $t4, 2, zero_first # Caso 1
			
			add $t4, $t4, -11
			
			mul $t4, $t4, -1 # $t4 - 11 vira 11 - $t4
			
			j check_first
		
			zero_first: # Caso 2
			
			li $t4, 0
		
		check_first:
		
			beq $t0, $t4, start_check_second_digit # Checa com o primeiro digito posto pelo usuario
			bne $t0, $t4, error_digit # Deu errado?
		
	start_check_second_digit:
		
		la $s0, cpf
		
		lb $k1, first_digit # Usado no final do calculo do primeiro digito
		add $k1, $k1, -48 # Conversao ascii para numero
		
		lb $t0, second_digit
		add $t0, $t0, -48
		li $t2, 11 # Factor
		li $t3, 0 # Sum
		
		loop_second_check:
		
			lb $t1, ($s0)
			
			beq $t1, 45, end_second_check
			## Contas do .pdf
			add $t1, $t1, -48
			mul $k0, $t1, $t2
			add $t3, $t3, $k0
			add $t2, $t2, -1
			
			add $s0, $s0, 1
			
			j loop_second_check
			
			
		end_second_check:
			
			# Adicionar primeiro digito de verificacao
			mul $k0, $k1, $t2
			
			add $t3, $t3, $k0
		
			rem $t4, $t3, 11
		
			blt $t4, 2, zero_second
			
			# Caso 1
			add $t4, $t4, -11
			
			mul $t4, $t4, -1 # $t4 - 11 vira 11 - $t4
			
			j check_second
		
			# Caso 2
			zero_second:
			
			li $t4, 0
		
		check_second:
		
			beq $t0, $t4, valid
			bne $t0, $t4, error_digit
		
	valid:
	
		la $a0, success
		li $v0, 4
		syscall
		j end
		
	error_digit:
	
		la $a0, error
		li $v0, 4
		syscall
			
	end:
		
	li $v0, 10
	syscall 
	
