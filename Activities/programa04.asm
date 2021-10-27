#========================================================================================================================================================================================
# Atividade 4: Elaborar um programa, em c�digo MIPS, que fa�a a leitura de um n�mero inteiro
# N pelo teclado e apresente como sa�da: a) se N � um n�mero primo; b) se N for
# um n�mero primo, imprimir os n�meros primos at� N; c) imprima os N primeiro
# n�meros primos.
#========================================================================================================================================================================================

.data

pulaLinha: .asciiz "\n"
msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
input: .asciiz "Insira o valor N: "
sim: .asciiz "O n�mero N � primo!\n"
nao: .asciiz "O n�mero N n�o � primo!\n"
espaco: .asciiz " "
letraB: .asciiz "N�meros primos at� N: "
letraC: .asciiz "N primeiros n�meros primos: "

.text

start: 

	li $v0, 4 # Imprimir strings
	la $a0, input # Mensagem para o usu�rio inserir N
	syscall
	li $v0, 5 # Ler inteiros
	syscall 
	ble $v0, $zero, erroInput # Se o input for menor ou igual a 0, repita o procedimento at� receber um input v�lido
	add $s0, $zero, $v0 # Guarda em $s0 o valor de N
	add $s3, $zero, $v0 # Guarda em $s0 o valor original N (usado na letra B)
	add $t8, $zero, 1 # Guarda o metodo de funcionamento da funcao checar primo (1 para letra A e 2 para letra B e 3 para letra C)
	div $s1, $s0, 2 # Guarda em $s1 a metade de N
	beq $v0, 1, resultadoNaoPrimo # Caso especial N = 1
	beq $v0, 2, resultadoPrimo # Caso especial N = 2
	j checarPrimo

erroInput:
	
	li $v0, 4 # Imprimir strings
	la $a0, msgZeroErro # Mensagem de erro N <= 0
	syscall
	j start

#====================================================================================================================================	

checarPrimo:
	
	add $t0, $zero, 2 # Contador para as divis�es para checar os primos
	jal loopPrimo # V� para o loop para ver se o N passado � primo ou n�o
	j printResultado # Imprima o resultado proveniente do loop primo

loopPrimo:

	la $t9, ($ra) # Salva o endere�o da onde foi chamada essa instru��o
	link:
		div $t1, $s0, $t0 # $t1 = N // (contador)
	
		mul $t2, $t0, $t1 # $t2 = (contador) * (N//contador)
	
		sub $t3, $s0, $t2 # $t3 = N - (contador) * (N//contador)
		
		beq $t3, $zero, naoPrimo # Se o resto da divis�o for igual a 0, o n�mero n�o � primo
	
		jal aumentarContador # Checar se devemos aumentar o contador em 1 ou 2 unidades
	
		ble $t0, $s1, link # Se o contador for menor ou igual a N/2, continue o loop
	
		add $s2, $zero, 1 # Depois de sair do loop, e n�o ter entrado na branch naoPrimo, setar o resultado final em $s2 para 1 (verdadeiro)
	
		beq $t8, 1, modo1
		beq $t8, 2, modo2
		beq $t8, 3, modo3
	
		modo1:
			j continuar 
		modo2:
			jal printB # Imprimir o n�mero primo
			j continuar
		modo3:
			jal printB # Imprimir o n�mero primo
			j continuar

		continuar: 
			
			jr $t9 # Volte para onde foi chamado um jal
	
primosAteN:
	
	li $v0, 4 # Imprimir strings
	la $a0, letraB 
	syscall
	
	la $s4, ($ra) # Guardar a chamada se N for primo
	
	add $s0, $zero, 2 # Reseta $s0, para 2 (para procurar os valores primos menores iguais a $s3 (valor N original) )
	
	add $s2, $zero, 1   # Seta como verdadeiro que 2 � um n�mero primo
	jal printB
	
	add $s0, $s0, 1 # Aumenta o contador para ver se o n�mero � primo para 3
	
	add $t8, $zero, 2 # Seta o modo de opera��o para 2
	
	loopB:
		bgt $s0, $s3, fimB # Se o n�mero passado for maior que o N original
		add $t0, $zero, 2 # Zera contador usado no loop
		add $s2, $zero, 0 # Seta false para se o n�mero � primo ou n�o 
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		jal loopPrimo
		
		add $s0, $s0, 2 # Pr�ximo n�mero primo talvez esteja em 2 posi��es de dist�ncia
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		ble $s0, $s3, loopB
	fimB:
		li $v0, 4 # Imprimir strings
		la $a0, pulaLinha
		syscall
		jr $s4

printB:

	bne $t3, 0, ok # Printe o n�mero se ele for primo
	beq $s2, 1, ok 
	j voltar
	
	ok:
		li $v0, 1 # Imprimir n�meros
		la $a0, ($s0)
		syscall
		
		add $k0, $k0, 1 # Contador usado na letra C
		
		li $v0, 4 # Imprimir strings
		la $a0, espaco
		syscall
		j voltar
		
	voltar:
		jr $ra # Volte para onde foi chamado a fun��o de printB

nPrimos:

	li $v0, 4 # Imprimir strings
	la $a0, letraC
	syscall

	add $k0, $zero, $zero # $k0 vai ser o contador de n�meros primos para a letra C
	
	add $s0, $zero, 2 #Reseta $s0, para 2 (para procurar os valores primos menores iguais a $s3 (valor N original) )
	
	add $s2, $zero, 1 # Seta como verdadeiro que 2 � um n�mero primo
	jal printB
	
	add $s0, $s0, 1 # Aumenta o contador para ver se o n�mero � primo para 3
	
	add $t8, $zero, 3 # Seta o modo de opera��o para 3
	
	loopC:
		bgt $k0, $s3, fimC # Se o contador de n�meros primos for maior que N, pare
		add $t0, $zero, 2 # Zera contador usado no loop
		add $s2, $zero, 0 # Seta false para se o n�mero � primo ou n�o 
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		jal loopPrimo
		
		add $s0, $s0, 2 #Pr�ximo n�mero primo talvez esteja em 2 posi��es de dist�ncia
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		blt $k0, $s3, loopC # Se o contador de n�meros primos for menor do que N, continue o loop
	fimC:
		li $v0, 4 # Imprimir strings
		la $a0, pulaLinha
		syscall

	j finalizar
	
#====================================================================================================================================	
naoPrimo:
	
	add $s2, $zero, $zero # $s2 guarda se o valor � primo ou n�o
	jr $t9 # Volte para onde foi chamado um jal

#====================================================================================================================================	

printResultado:
	
	beq $s2, 0, resultadoNaoPrimo
	beq $s2, 1, resultadoPrimo

resultadoNaoPrimo:
	
	li $v0, 4 # Imprimir strings
	la $a0, nao # Mensagem do n�mero n�o primo
	syscall
	j nPrimos
	


resultadoPrimo:
	
	li $v0, 4 # Imprimir strings
	la $a0, sim # Mensagem do n�mero primo
	syscall
	jal primosAteN
	j nPrimos
	
	
#====================================================================================================================================	
aumentarContador:
	
	beq $t0, 2, aumentar1
	bne $t0, 2, aumentar2

aumentar1:
	
	addi $t0, $t0, 1
	jr $ra

aumentar2:

	addi $t0, $t0, 2
	jr $ra
	
#====================================================================================================================================	
finalizar:
	li $v0, 10
	syscall
