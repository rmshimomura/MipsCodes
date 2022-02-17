# 1) Elaborar um programa, em código MIPS, que dado um inteiro positivo n, verificar se
# n é um inteiro perfeito. Um inteiro positivo n é perfeito se for igual à soma de seus
# divisores positivos diferentes de n. Exemplo: 6 é perfeito, pois 1+2+3 = 6.

.data

pulaLinha: .asciiz "\n"

input: .asciiz "Insira o valor N: "
msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
naoEhPerfeito: .asciiz "N não é perfeito!\n\n"
ehPerfeito: .asciiz "N é perfeito!\n\n"

.text

start:

	li $v0, 4 # Imprimir strings
	la $a0, input # Mensagem para o usuário inserir N
	syscall
	li $v0, 5 # Ler inteiros
	syscall 
	ble $v0, $zero, erroInput # Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
	add $t0, $zero, $v0 # T0 segura o valor posto N
	div $s1, $t0, 2 # Guarda em $s1 a metade de N
	addi $s1, $s1, 1
	addi $t1, $zero, 1 # T1 será o contador
	j loopPerfeito
	
erroInput:
	
	li $v0, 4 # Imprimir strings
	la $a0, msgZeroErro # Mensagem de erro N <= 0
	syscall
	j start
	
loopPerfeito:
	
	beq $s1, $t1, finalizar
	
	div $t2, $t0, $t1
	mfhi $k1
	seq $t3, $k1, 0
	
	beq $t3, 1, somarPerfeito
	
	addi $t1, $t1, 1
	
	j loopPerfeito

somarPerfeito:
	
	add $s0, $s0, $t1
	addi $t1, $t1, 1
	j loopPerfeito

finalizar:
	
	seq $k0, $s0, $t0
	
	beq $k0, 1, perfeito
	beq $k0, 0, naoPerfeito

	
	
perfeito:
	
	li $v0, 4 # Imprimir strings
	la $a0, ehPerfeito # Mensagem para o usuário inserir N
	syscall
	li $v0, 10
	syscall

naoPerfeito:

	li $v0, 4 # Imprimir strings
	la $a0, naoEhPerfeito # Mensagem para o usuário inserir N
	syscall
	li $v0, 10
	syscall