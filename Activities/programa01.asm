#========================================================================================================================================================================================
# Atividade 1: Elaborar um programa que realize a soma dos inteiros de 1 at� N, onde N � um valor de entrada digitado pelo usu�rio do programa.
#========================================================================================================================================================================================

.data

msg1: .asciiz "Entre com um valor inteiro (N>1):\n"
msg2: .asciiz "O valor digitado N tem que ser maior que 1.\n"
msg3: .asciiz "A soma dos valores inteiros de 1 at� N = "

.text

main:
	add $t0, $zero, $zero # Zera o valor contido em $t0, o qual ser� o contador do loop
	add $t1, $zero, $zero # Zera o valor contido em $t1, o qual ser� a soma total do loop
	j somador
	
somador:
	
	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, msg1 # "Entre com um valor inteiro (N>1):\n"
	syscall
	li $v0, 5 # C�digo syscall para ler inteiros
	syscall 
	add $s0,$v0,$zero # Salva o n�mero N em $s0 para comparar dentro do loop e fazer a checagem antes de entrar
	add $t2, $zero, 2 # Salva o limite m�nimo para conseguir entrar no loop de soma
	
	slt $t3, $s0, $t2 # Se $s0 (Valor passado pelo usu�rio) for menor do que 2, seta o $t3 para 1
	beq $t3, 1, erro_input # Se $t3 = 1, repete o procedimento "somador" at� achar um input v�lido
	j loop_soma

erro_input:

	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, msg2 # "O valor digitado N tem que ser maior que 1.\n"
	syscall
	j somador

loop_soma:

	slt $t3, $s0, $t0 # Se o N for menor do que o contador atual, seta $t3 para 1
	beq $t3, 1, final
	add $t1, $t1, $t0 # Adiciona o contador na soma total
	addi $t0, $t0, 1 # Aqui ficar� salvo o contador do loop
	j loop_soma
	
final:
	
	li $v0, 4 # C�digo syscall para imprimir strings
	la $a0, msg3 # "A soma dos valores inteiros de 1 at� N = "
	syscall
	li $v0, 1 # C�digo syscall para escrever inteiros
	add $a0, $zero, $t1 # Exibir $t2 em $a0
	syscall
	li $v0, 10 # C�digo para exit
	syscall
