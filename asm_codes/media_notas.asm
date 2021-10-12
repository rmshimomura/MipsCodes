#----------------------------------------------------------------------------------------
# Programa que calcula a m�dia de n (fornecido pelo usu�rio) avalia��es de uma disciplina
#----------------------------------------------------------------------------------------

.data 
msg1: .asciiz "Entre com o n�mero de avalia��es da disciplina:\n"
msg2: .asciiz "Entre com o valor da nota "
msg3: .asciiz ": "
msg4: .asciiz "A m�dia das notas �: "
msg5: .asciiz "."

.text

main:
	add $t0, $zero, $zero # Zera o valor contido em $t0
	add $t1, $zero, $zero # Zera o valor contido em $t1
	
	numnotas:
		li $v0, 4 # C�digo syscall para imprimir strings
		la $a0, msg1
		syscall
		li $v0, 5 # C�digo syscall para ler inteiros
		syscall 
		add $s0,$v0,$zero # Salvar a quantidade de notas em $s0 para comparar dentro do loop
		
		loop_notas:
			addi $t0, $t0, 1 # $t0 = Contador de notas
			li $v0, 4 # C�digo syscall para imprimir strings
			la $a0, msg2 # "Entre com o valor da nota"
			syscall
			li $v0, 1 # C�digo syscall para escrever inteiros
			add $a0, $zero, $t0 # Colocar o valor de $t0 em $a0 e imprime na tela (nota 1, nota 2, nota 3 ...)
			syscall
			li $v0, 4 # C�digo syscall para imprimir strings
			la $a0, msg3
			syscall
			li $v0, 5 # C�digo syscall para ler inteiros
			syscall
			add $t1, $t1, $v0 # $t1 = soma total
			bne $t0, $s0, loop_notas
			
			calcula_notas:
				div $t1, $s0 # Divide o total pelo n�mero de notas
				mflo $t2 # Move o resultado (quociente) para $t2
				li $v0, 4
				la $a0, msg4 # Escrever "A m�dia das notas � "
				syscall
				li $v0, 1 # C�digo syscall para escrever inteiros
				add $a0, $zero, $t2 # Exibir $t2 em $a0
				syscall
				li $v0, 4 # C�digo syscall para imprimir strings
				la $a0, msg5
				syscall
				li $v0, 10 # C�digo para exit
				syscall