#========================================================================================================================================================================================
# Atividade 4: Elaborar um programa, em código MIPS, que faça a leitura de um número inteiro
# N pelo teclado e apresente como saída: a) se N é um número primo; b) se N for
# um número primo, imprimir os números primos até N; c) imprima os N primeiro
# números primos.
#========================================================================================================================================================================================

.data

pulaLinha: .asciiz "\n"
msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
input: .asciiz "Insira o valor N: "
sim: .asciiz "O número N é primo!\n"
nao: .asciiz "O número N não é primo!\n"
espaco: .asciiz " "
letraB: .asciiz "Números primos até N: "
letraC: .asciiz "N primeiros números primos: "

.text

start: 

	li $v0, 4 # Imprimir strings
	la $a0, input # Mensagem para o usuário inserir N
	syscall
	li $v0, 5 # Ler inteiros
	syscall 
	ble $v0, $zero, erroInput # Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
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
	
	add $t0, $zero, 2 # Contador para as divisões para checar os primos
	jal loopPrimo # Vá para o loop para ver se o N passado é primo ou não
	j printResultado # Imprima o resultado proveniente do loop primo

loopPrimo:

	la $t9, ($ra) # Salva o endereço da onde foi chamada essa instrução
	link:
		div $t1, $s0, $t0 # $t1 = N // (contador)
	
		mul $t2, $t0, $t1 # $t2 = (contador) * (N//contador)
	
		sub $t3, $s0, $t2 # $t3 = N - (contador) * (N//contador)
		
		beq $t3, $zero, naoPrimo # Se o resto da divisão for igual a 0, o número não é primo
	
		jal aumentarContador # Checar se devemos aumentar o contador em 1 ou 2 unidades
	
		ble $t0, $s1, link # Se o contador for menor ou igual a N/2, continue o loop
	
		add $s2, $zero, 1 # Depois de sair do loop, e não ter entrado na branch naoPrimo, setar o resultado final em $s2 para 1 (verdadeiro)
	
		beq $t8, 1, modo1
		beq $t8, 2, modo2
		beq $t8, 3, modo3
	
		modo1:
			j continuar 
		modo2:
			jal printB # Imprimir o número primo
			j continuar
		modo3:
			jal printB # Imprimir o número primo
			j continuar

		continuar: 
			
			jr $t9 # Volte para onde foi chamado um jal
	
primosAteN:
	
	li $v0, 4 # Imprimir strings
	la $a0, letraB 
	syscall
	
	la $s4, ($ra) # Guardar a chamada se N for primo
	
	add $s0, $zero, 2 # Reseta $s0, para 2 (para procurar os valores primos menores iguais a $s3 (valor N original) )
	
	add $s2, $zero, 1   # Seta como verdadeiro que 2 é um número primo
	jal printB
	
	add $s0, $s0, 1 # Aumenta o contador para ver se o número é primo para 3
	
	add $t8, $zero, 2 # Seta o modo de operação para 2
	
	loopB:
		bgt $s0, $s3, fimB # Se o número passado for maior que o N original
		add $t0, $zero, 2 # Zera contador usado no loop
		add $s2, $zero, 0 # Seta false para se o número é primo ou não 
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		jal loopPrimo
		
		add $s0, $s0, 2 # Próximo número primo talvez esteja em 2 posições de distância
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		ble $s0, $s3, loopB
	fimB:
		li $v0, 4 # Imprimir strings
		la $a0, pulaLinha
		syscall
		jr $s4

printB:

	bne $t3, 0, ok # Printe o número se ele for primo
	beq $s2, 1, ok 
	j voltar
	
	ok:
		li $v0, 1 # Imprimir números
		la $a0, ($s0)
		syscall
		
		add $k0, $k0, 1 # Contador usado na letra C
		
		li $v0, 4 # Imprimir strings
		la $a0, espaco
		syscall
		j voltar
		
	voltar:
		jr $ra # Volte para onde foi chamado a função de printB

nPrimos:

	li $v0, 4 # Imprimir strings
	la $a0, letraC
	syscall

	add $k0, $zero, $zero # $k0 vai ser o contador de números primos para a letra C
	
	add $s0, $zero, 2 #Reseta $s0, para 2 (para procurar os valores primos menores iguais a $s3 (valor N original) )
	
	add $s2, $zero, 1 # Seta como verdadeiro que 2 é um número primo
	jal printB
	
	add $s0, $s0, 1 # Aumenta o contador para ver se o número é primo para 3
	
	add $t8, $zero, 3 # Seta o modo de operação para 3
	
	loopC:
		bgt $k0, $s3, fimC # Se o contador de números primos for maior que N, pare
		add $t0, $zero, 2 # Zera contador usado no loop
		add $s2, $zero, 0 # Seta false para se o número é primo ou não 
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		jal loopPrimo
		
		add $s0, $s0, 2 #Próximo número primo talvez esteja em 2 posições de distância
		div $s1, $s0, 2 # Guarda em $s1 a metade de N
		blt $k0, $s3, loopC # Se o contador de números primos for menor do que N, continue o loop
	fimC:
		li $v0, 4 # Imprimir strings
		la $a0, pulaLinha
		syscall

	j finalizar
	
#====================================================================================================================================	
naoPrimo:
	
	add $s2, $zero, $zero # $s2 guarda se o valor é primo ou não
	jr $t9 # Volte para onde foi chamado um jal

#====================================================================================================================================	

printResultado:
	
	beq $s2, 0, resultadoNaoPrimo
	beq $s2, 1, resultadoPrimo

resultadoNaoPrimo:
	
	li $v0, 4 # Imprimir strings
	la $a0, nao # Mensagem do número não primo
	syscall
	j nPrimos
	


resultadoPrimo:
	
	li $v0, 4 # Imprimir strings
	la $a0, sim # Mensagem do número primo
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
