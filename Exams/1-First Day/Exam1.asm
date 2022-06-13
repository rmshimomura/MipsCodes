# Aluno: Rodrigo Mimura Shimomura 
# Matrícula: 202000560249
# 1) Dado um número inteiro positivo n verificar se n é perfeito.
# * um inteiro positivo n é perfeito se for igual à soma de seus divisores positivos
# diferentes de n. Exemplo: 6 é perfeito, pois 1+2+3 = 6.

.data

	jump_line: .asciiz "\n"
	input: .asciiz "Insira o valor N: "
	message_error_zero: .asciiz "O valor informado deve ser maior do que 0!\n\n"
	message_is_not_perfect: .asciiz "N não é perfeito!\n\n"
	message_is_perfect: .asciiz "N é perfeito!\n\n"

.text

start:

	li $v0, 4 # Imprimir strings
	la $a0, input # Mensagem para o usuário inserir N
	syscall
	li $v0, 5 # Ler inteiros
	syscall 
	ble $v0, $zero, input_error # Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
	add $t0, $zero, $v0 # T0 segura o valor posto N
	div $s1, $t0, 2 # Guarda em $s1 a metade de N
	addi $s1, $s1, 1
	addi $t1, $zero, 1 # T1 será o contador
	j perfect_loop
	
input_error:
	
	li $v0, 4 # Imprimir strings
	la $a0, message_error_zero # Mensagem de erro N <= 0
	syscall
	j start
	
perfect_loop:
	
	beq $s1, $t1, end # Se o divisor for igual a metade do número, pare
	
	div $t2, $t0, $t1 # $t2  = N dividido por $t1
	mfhi $k1
	seq $t3, $k1, 0 # $t3 ve se o restante da divisao de n pelo $t1 é 0, ou seja, exato
	
	beq $t3, 1, perfect_sum # Se for divisao exata, some no resultado
	
	addi $t1, $t1, 1 # Proximo valor
	
	j perfect_loop

perfect_sum:
	
	add $s0, $s0, $t1 # $s0 é a soma dos divisores do número
	addi $t1, $t1, 1 # Proximo valor
	j perfect_loop

end:
	
	seq $k0, $s0, $t0 # Veja se a soma dos divisores é igual ao valor N
	
	beq $k0, 1, perfect
	beq $k0, 0, not_perfect

perfect:
	
	li $v0, 4 # Imprimir strings
	la $a0, message_is_perfect # Mensagem de sucesso
	syscall
	li $v0, 10
	syscall

not_perfect:

	li $v0, 4 # Imprimir strings
	la $a0, message_is_not_perfect # Mensagem de fracasso
	syscall
	li $v0, 10
	syscall
