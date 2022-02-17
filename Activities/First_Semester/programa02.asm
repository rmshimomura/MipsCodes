#========================================================================================================================================================================================
# Atividade 2: Elaborar um programa que realize e apresente a soma dos valores positivos e a soma dos valores negativos contidos em um vetor
#=======================================================================================================================================================================================

.data 

vetor: .word -2, 4, 7, -3, 0, -3, 5, 6
msg1: .asciiz "A soma dos valores positivos = "
msg2: .asciiz "A soma dos valores negativos = "
msg3: .asciiz ".\n"

.text

main:
	add $t6, $zero, $zero # Zera o valor contido em $v0, será a soma dos positivos
	add $t7, $zero, $zero # Zera o valor contido em $v1, será a soma dos negativos
	li $t0, 8 # Contador da quantidade de números presentes no vetor
	la $t1, vetor # $t1 vai ser um apontador para vet
	li $t2, 0 # $t2 ira comecar a contagem de repeticoes 

	loop:
	
		beq $t2, $t0, exit # Checador da quantidade de vezes que o loop ocorreu
		lw $t3, 0($t1) # Carrega em $t3 o valor do endereço apontado por $t1
		slt $s0, $t3, $zero  # Checa se $t3 é menor do que zero
		beq $s0, 1, soma_negativo
		j soma_positivo
		
soma_negativo:
	
	add $t7, $t7, $t3 # Adiciona o valor à soma dos negativos
	addi $t1, $t1, 4 # Vai para a próxima posição do vetor
	addi $t2, $t2, 1 # Incrementa contador
	j loop
	
soma_positivo:
	
	add $t6, $t6, $t3 # Adiciona o valor à soma dos positivos
	addi $t1, $t1, 4 # Vai para a próxima posição do vetor
	addi $t2, $t2, 1 # Incrementa contador
	j loop
			
exit: 
	li $v0, 4 # Código syscall para imprimir strings
	la $a0, msg1 # "A soma dos valores positivos = "
	syscall
	li $v0, 1 # Código syscall para escrever inteiros
	add $a0, $zero, $t6 # Mostra valor da soma dos positivos
	syscall
	li $v0, 4 # Código syscall para imprimir strings
	la $a0, msg3
	syscall
	li $v0, 4 # Código syscall para imprimir strings
	la $a0, msg2 # "A soma dos valores negativos = "
	syscall
	li $v0, 1 # Código syscall para escrever inteiros
	add $a0, $zero, $t7 # Mostra valor da soma dos negativos
	syscall
	li $v0, 4 # Código syscall para imprimir strings
	la $a0, msg3
	syscall
	li $v0, 10
	syscall
	
