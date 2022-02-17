#========================================================================================================================================================================================
# Atividade 3: Elaborar um programa, em c�digo MIPS, que fa�a a leitura de dois n�meros
# inteiros (A e B) fornecidos pelo usu�rio pelo teclado e que forne�a como sa�da
# todos os m�ltiplos de A no intervalo de A at� AxB.
#========================================================================================================================================================================================

.data

msgA: .asciiz "Entre com o valor A:\n"
msgB: .asciiz "Entre com o valor B:\n"
msgZeroErroA: .asciiz "O valor A deve ser maior do que 0!\n\n"
msgZeroErroB: .asciiz "O valor B deve ser maior do que 0!\n\n"
pulaLinha: .asciiz "\n"
resultado: .asciiz "\n\nM�ltiplos de A no intervalo de A at� AxB:\n\n"

.text
start: 
	add $t0, $zero, 1 # Inicia o valor contido em $t0 como 1, o qual ser� o contador do loop
	j leituraA
	
leituraA:

	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, msgA # "Entre com o valor A:\n"
	syscall
	li $v0, 5 # C�digo syscall para ler inteiros
	syscall 
	ble $v0, $zero, erroA # Se o valor lido for menor ou igual a zero, v� para a mensagem de erro A
	add $s0, $zero, $v0 # Se o valor lido for maior do que zero, armazene A em $s0
	j leituraB

leituraB:

	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, msgB # "Entre com o valor B:\n"
	syscall
	li $v0, 5 # C�digo syscall para ler inteiros
	syscall 
	ble $v0, $zero, erroB # Se o valor lido for menor do que zero, v� para a mensagem de erro B
	add $s1, $zero, $v0 # Se o valor lido for maior do que zero, armazene B em $s1
	mul $t7, $s0, $s1 # $t7 vai ser o limite para imprimir os n�meros
	
	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, resultado # "\n\nM�ltiplos de A no intervalo de A at� AxB:\n\n"
	syscall
	j contas
#================================================================
contas:
	
	mul $t1, $t0, $s0 # Resultado de $t0 * $s0 (Ou seja, A * (1,2,3,4...) at� n�o superar A*B)
	li $v0, 1 # C�digo syscall para imprimir inteiros
	add $a0, $t1, $zero # Imprimir $t1
	syscall
	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, pulaLinha # "\n"
	syscall
	addi $t0, $t0, 1 # Aumenta o contador usado na linha 49
	bne $t1, $t7, contas # Se A * contador <= A * B, continue o loop
	j finalizar # Depois de A * contador > A*B, finalize o programa
	
finalizar: 
	
	li $v0, 10 # C�digo para exit
	syscall
	
#================================================================
erroA:
	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, msgZeroErroA # "O valor A deve ser maior do que 0!"
	syscall
	j leituraA
	
erroB:
	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, msgZeroErroB # "O valor B deve ser maior do que 0!"
	syscall
	j leituraB
#================================================================