.data 
	primes: .space 256
	pulaLinha: .asciiz "\n"
	input: .asciiz "Insira o valor N: "
	msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
.text

start:

	li $v0, 4 # Imprimir strings
	la $a0, input # Mensagem para o usuário inserir N
	syscall
	li $v0, 5 # Ler inteiros
	syscall 
	ble $v0, $zero, erroInput # Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
	add $s3, $zero, $v0 # T0 segura o valor posto N
	j main
	
erroInput:

	li $v0, 4 # Imprimir strings
	la $a0, msgZeroErro # Mensagem de erro N <= 0
	syscall
	j start

main:

	add $s1, $zero, 2 # i da main 
	add $s2, $zero, $zero # k da main
	#s3 = n
	sw $s1, primes($s2) # Salva no vetor o valor 2
	
	jal primeLoop
	
	add $s1, $zero, $zero
	add $a3, $zero, $zero
	j resultLoop
	
primeLoop:
	
	la $k0, ($ra) # salva o local de chamada da funcao primeLoop
	j primeLoop1
	
store:

	addi $s2, $s2, 1 # ++k
	add $s4, $zero, $zero 
	mul $s4, $s2, 4 # index
	sw $s1, primes($s4) # primes[index] = i
	add $s1, $s1, 1
	
primeLoop1:

	bge $s1, $s3, returnLoopPrime # Compara se i >= n
	jal isPrime
	beq $t8, 1, store
	add $s1, $s1, 1
	j primeLoop1

isPrime:

	la $k1, ($ra)# salva o local de chamada da funcao isPrime loop
	add $s4, $zero, $zero # J da funcao (J = 0)
	add $s5, $zero, $zero # index
	j loopIsPrime
	
loopIsPrime:

	bgt $s4, $s2, returnIsPrime # Checa se j > k para parar o loop
	lw $a3, primes($s5)
	div $t8, $s1, $a3 # divide i por primes[index] 
	mfhi $t7 # T7 = $s1 % $a3 (T7 = i % primes[j])
	seq $t8,$t7, 0 # T8 guarda se o resto da divisao de i é igual a zero
	beq $t8, 1, returnIsPrime
	addi $s4, $s4, 1 # Aumenta o J da funcao
	addi $s5, $s5, 4 # Aumenta o index
	j loopIsPrime
	
returnLoopPrime:

	jr $k0

returnIsPrime:
	
	sgt $t8, $s4, $s2 # j > k ? 0 : 1 
	jr $k1
	
end:
	li $v0, 10
	syscall
	
resultLoop:

	bgt $s1, $s2, end # i > k ?
	li $v0, 1
	lw $a0,	primes($a3)
	syscall
	addi $a3, $a3, 4
	li $v0, 4 # Imprimir strings
	la $a0, pulaLinha
	syscall
	add $s1, $s1, 1
	j resultLoop