.data 
	squares: .space 256
	pulaLinha: .asciiz "\n"
	input: .asciiz "Insira o valor N: "
	msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
	somaResultado: .asciiz "A soma final é "

.text

start:

	li $v0, 4 # Imprimir strings
	la $a0, input # Mensagem para o usuário inserir N
	syscall
	li $v0, 5 # Ler inteiros
	syscall 
	ble $v0, $zero, erroInput # Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
	add $t0, $zero, $v0 # T0 segura o valor posto N
	j main
	
erroInput:
	
	li $v0, 4 # Imprimir strings
	la $a0, msgZeroErro # Mensagem de erro N <= 0
	syscall
	j start

main:
	jal storeValues
	jal computeSum
	j end

storeValues:

	la $t9, ($ra) # Salva o endereço da onde foi chamada essa instrução (linha 33)
	add $t1, $zero, $zero # T1 = contador
	add $t2, $zero, $zero # T2 = index do array
	jal loopStoreValues
	jr $t9 # Volta para a "main"
	
loopStoreValues:
	
	beq $t1, $t0, pararLoop # Se o contador i == n, pare o loop
	add $s0, $zero, $zero  # Guarda o resultado da multiplicacao
	mul $s0, $t1, $t1 # Resultado da multiplicacao
	sw $s0, squares($t2) # Guarda no vetor
	addi $t1, $t1, 1 # Aumenta 1 em i
	addi $t2, $t2, 4 # Proximo index do array
	j loopStoreValues # Volta para o loop

computeSum:

	la $t9, ($ra) # Salva o endereço da onde foi chamada essa instrução (linha 33)
	add $t1, $zero, $zero # T1 = contador
	add $t2, $zero, $zero # T2 = index do array
	add $t3, $zero, $zero # T3 = soma
	jal loopComputeSum
	jr $t9 # Volta para a "main"

loopComputeSum:

	beq $t1, $t0, pararLoop # Se o contador i == n, pare o loop
	lw $s0, squares($t2)
	add $t3, $t3, $s0
	addi $t1, $t1, 1 # Aumenta 1 em i
	addi $t2, $t2, 4 # Proximo index do array
	j loopComputeSum

pararLoop: 

	jr $ra
	
end:

	li $v0, 4 # Imprimir strings
	la $a0, somaResultado # Mensagem para o usuário inserir N
	syscall
	
	li $v0,1
	la $a0, ($t3)
	syscall
	
	li $v0, 4 # Imprimir strings
	la $a0, pulaLinha # Mensagem para o usuário inserir N
	syscall
	
	li $v0, 10
	syscall
