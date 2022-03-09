.data
msgTamanho: .asciiz "Insira o tamanho do vetor: "
msgInserirValores1: .asciiz "Insira o valor (inteiro!) de Vet["
msgInserirValores2: .asciiz "]:"
msgZeroErro: .asciiz "O valor informado deve ser maior do que 0!\n\n"
msgSomaElementosPares: .asciiz "Soma dos elementos pares: "
msgNumeroMaiorMenor: .asciiz "Numero de elementos k < vet[i] < 2k: "
msgNumeroIgual: .asciiz "Numero de elementos iguais a k: "
msgValorK: .asciiz "Insira o valor K: "
pulaLinha: .asciiz "\n"
msgOrdenado: .asciiz "Vetor esta organizado!\n"
msgFinal: .asciiz "Perfeitos - Semiprimos =  "

soma_perfeitos: .word 0
soma_semiprimos: .word 0

.text

main:
	jal tamanho_vetor
	jal sort			
	jal escrita 
	jal somarPares 			
	jal maior_menor 		
	jal iguais
	jal perfect 			
	jal semiPrime
	jal showLastResult
	
	li $v0, 10
	syscall
	
tamanho_vetor:

	la $a0, msgTamanho
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	ble $v0, $zero, erroInput 	# Se o input for menor ou igual a 0, repita o procedimento até receber um input válido
	add $s7, $v0, $zero 		# $s7 vai segurar o valor do tamanho do vetor
	add $k1, $zero, -4
	mul $k0, $k1, $s7 		# $k0 vai segurar a quantidade de bytes a serem guardados para o vetor todo
	
	j adicionar_espaco
	
erroInput:
	
	li $v0, 4 			# Imprimir strings
	la $a0, msgZeroErro 		# Mensagem de erro N <= 0
	syscall
	j tamanho_vetor
	
adicionar_espaco:

	move $s0, $sp 			# $s0 = comeco do vetor
	add $sp, $sp, $k0 		# espaco adicionado "subtraido"
	move $s1, $sp 			# $s1 = final do vetor
	li $t2, 0
	move $s2, $s0

leitura_vetor:

	la $a0, msgInserirValores1
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, msgInserirValores2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, ($s2)
	add $s2, $s2, -4
	addi $t2, $t2, 1 		# Contador
	blt $t2, $s7, leitura_vetor 
	move $v0, $s0
	jr $ra

sort: 

	beq $s7, 1, return_sort
	j loopFora
	return_sort:
		
		li $v0, 4 			# Imprimir strings
		la $a0, msgOrdenado 		# Mensagem de vetor ordenado
		syscall 
		jr $ra

loopFora:
	add $t1, $zero, $zero
	la  $a0, ($s0) 			# $a0 esta no comeco do vetor
	
loopDentro:
	lw  $t2, 0($a0)         	# $t2 = elemento atual
	lw  $t3, -4($a0)         	# $t3 = proximo elemento
    	slt $t5, $t3, $t2       	# $t5 = 1 se $t3 < $t2
    	beq $t5, $zero, continuar   	# Se $t5 = 1, troca os valores
    	add $t1, $zero, 1          	# Checar novamente
    	sw  $t2, -4($a0)         	# Trocar
    	sw  $t3, 0($a0)			# Trocar
continuar:
	addi $a0, $a0, -4            	# Proximo elemento
	addi $a1, $a0, -4	     	# Proximo do proximo elemento
	bne  $a1, $s1, loopDentro    	# Se o proximo elemento nao for o final, volta para o loop dentro
	bne  $t1, $zero, loopFora    	# Se $t1 = 1, volte para o loopFora
	jr $ra

escrita:
	li $t2, 0 			# Reseta para ser o contador
	move $s2, $s0 			# $s2 vai ser o runner
loop:  					# Loop da escrita
	lw $a0, ($s2) 
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	add $s2, $s2, -4
	addi $t2, $t2, 1
	blt $t2, $s7, loop
	move $v0, $s0
	jr $ra

somarPares:

	li $t2, 0 			# Reseta para ser o contador
	move $s2, $s0 			# $s2 vai ser o runner
	add $t3, $zero, 2

somarParesLoop:
	lw $t4, ($s2) 			# Carrega em $t4, o valor do endereco $s2
	div $t4, $t3 			# Divide $t4 por $t3
	mfhi $s3 			# Resto da divisao vai para $s3
	beq $s3, 0, soma 		# Se o resto for igual a zero, entao o numero eh par
	add $s2, $s2, -4 		# Proximo elemento do vetor
	addi $t2, $t2, 1 		# Contador
	blt $t2, $s7, somarParesLoop
	move $v0, $s0
	j resultadoPares
	
soma: 
	add $s4, $s4, $t4
	add $s2, $s2, -4 		# Proximo elemento do vetor
	addi $t2, $t2, 1 		# Contador
	blt $t2, $s7, somarParesLoop
	
resultadoPares:
	la $a0, pulaLinha
	li $v0, 4
	syscall
	la $a0, msgSomaElementosPares
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra

maior_menor:
	add $s4, $zero, $zero 		# Reseta o numero de valores maiores que K e menores que 2k
	li $t2, 0 			# Reseta para ser o contador
	move $s2, $s0 			# $s2 vai ser o runner
	la $a0, msgValorK
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $t5, $zero, $v0 		# $t5 = K
	mul $t6, $v0, 2    		# $t6 = 2K
	j loop_maior_menor

loop_maior_menor:
	
	lw $t4, ($s2) 			# Carrega em $t4, o valor do endereco $s2
	
	sgt $t8, $t4, $t5 		# vet[i] > k
	slt $t9, $t4, $t6 		# vet[i] < 2k
	
	beqz $t8, return 
	beqz $t9, return
	
	add $s4, $s4, 1 		# S4 = numero de [k < valor < 2k]
	add $s2, $s2, -4
	addi $t2, $t2, 1
	blt $t2, $s7, loop_maior_menor
	move $v0, $s0
	
	la $a0, msgNumeroMaiorMenor
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra

return:

	add $s2, $s2, -4
	addi $t2, $t2, 1 
	blt $t2, $s7, loop_maior_menor
	move $v0, $s0

	la $a0, msgNumeroMaiorMenor
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra
	
iguais:
	add $s4, $zero, $zero 		# Reseta o numero de valores iguais a K
	li $t2, 0 			# Reseta para ser o contador
	move $s2, $s0 			# $s2 vai ser o runner
	la $a0, msgValorK
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $t5, $zero, $v0 		# $t5 = K
	j loop_iguais

loop_iguais:

	lw $t4, ($s2) 			# Carrega em $t4, o valor do endereco $s2
	
	seq $t8, $t4, $t5 		# vet[i] == k
	
	beq $t8, 1, adicionar_igual
	
	add $s2, $s2, -4 		# Andar endereco
	addi $t2, $t2, 1 		# Andar contador 
	blt $t2, $s7, loop_iguais
	
	move $v0, $s0
	la $a0, msgNumeroIgual
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra
	
	
adicionar_igual:

	add $s4, $s4, 1  		# Aumentar numero de iguais
	add $s2, $s2, -4 		# Andar endereco
	addi $t2, $t2, 1 		# Andar contador 
	blt $t2, $s7, loop_iguais
	move $v0, $s0
	la $a0, msgNumeroIgual
	li $v0, 4
	syscall
	la $a0, ($s4)
	li $v0, 1
	syscall
	la $a0, pulaLinha
	li $v0, 4
	syscall
	jr $ra
	
perfect:

	li $t1, 1 			# $t1 reset (Divisor atual)
	li $t2, 0 			# $t2 reset (Contador Loop)
	li $s4, 0 			# $s4 reset (soma dos divisores do numero atual)
	move $s2, $s0 			# $s2 vai ser o runner
			
loopPerfeito:
	
	lw $t4, ($s2) 			# Carrega em $t4, o valor do endereco $s2
	beq $t1, $t4, end		
	div $t9, $t4, $t1 		# $t9 = $t4/$t1 (Valor do vetor)/contador
	mfhi $k1			# $k1 = $t4 % $t1
	seq $t3, $k1, 0			# $t3 guarda se o numero em questao eh divisivel pelo contador
	
	beq $t3, 1, somarPerfeito
	
	addi $t1, $t1, 1
	
	j loopPerfeito

somarPerfeito:
	
	add $s4, $s4, $t1		# Soma dos divisores += Divisor atual
	addi $t1, $t1, 1		# Divisor atual++
	j loopPerfeito
	
end:
	seq $k1, $s4, $t4 		# Se a soma dos divisores for igual ao numero original, seta k1 para 1
	beq $k1, 1, perfeito
	beq $k1, 0, naoPerfeito

perfeito:
	
	add $t6, $t6, $s4		# $t6 ira ser a soma dos numeros perfeitos
	sw $t6, soma_perfeitos		# Salvar na "variavel"
	add $s2, $s2, -4 		# Andar endereco
	addi $t2, $t2, 1 		# Andar contador 
	li $t1, 1 			# $t1 reset (Divisor atual)
	li $s4, 0 			# $s4 reset (soma dos divisores)
	blt $t2, $s7, loopPerfeito
	jr $ra

naoPerfeito:
	
	add $s2, $s2, -4 		# Andar endereco
	addi $t2, $t2, 1 		# Andar contador 
	li $t1, 1 			# $t1 reset (Divisor atual)
	li $s4, 0 			# $s4 reset (soma dos divisores)
	blt $t2, $s7, loopPerfeito
	jr $ra	

semiPrime:
	
	li $t0, 0 			# $t0 reset (cnt)
	li $t1, 2			# $t1 reset (i)
	li $t2, 0 			# $t2 reset (Contador Loop numero de elementos ja percorridos)
	li $k1, 0			# $k1 reset (Soma dos semi primos)
	move $s2, $s0 			# $s2 vai ser o runner
	j loop1SemiPrime
	
loop1SemiPrime:
	
	lw $t4, ($s2) 			# Carrega em $t4, o valor do endereco $s2
	add $a3, $zero, $t4		# Valor original
	
	wow:
	sge $t3, $t0, 2			# cnt >= 2
	mul $t5, $t1, $t1		# $t5 = i * i
	sgt $t6, $t5, $t4 		# i * i > num
	
	beqz $t3, tryOther		# Se cnt < 2
	
	sle $t8, $t4, 1			# num <= 1 ? 
	
	beqz $t8, raiseCnt			# se num > 1 go to raiseCnt
	
	seq $t9, $t0, 2			# cnt == 2 ?
	beq $t9, 1, raiseSemiPrimeCount # Se sim, adicione na soma dos semiprimos 
	beqz $t9, continueLoop		# Se nao, continue o loop com o proximo elemento
	
	tryOther:
		beqz $t6, loop2SemiPrime # Se i * i <= numero em analise
		sle $t8, $t4, 1		 # num <= 1 ? 
		beqz $t8, raiseCnt	 # se num > 1 go to raiseCnt
		
	j continueLoop
		
loop2SemiPrime:

	div $t4, $t1			# num % i
	mfhi $t7			# num % i
	beqz $t7, prepareAgain		# num % i == 0 ?
	add $t1, $t1, 1			# i++
	j wow
	
prepareAgain:
	
	div $t4, $t4, $t1		# num /= i
	add $t0, $t0, 1			# cnt++
	j loop2SemiPrime

raiseCnt:
	
	add $t0, $t0, 1			# cnt++
	seq $t9, $t0, 2			# cnt == 2 ?
	beq $t9, 1, raiseSemiPrimeCount # Se sim, adicione na soma dos semiprimos 
	beqz $t9, continueLoop		# Se nao, continue o loop com o proximo elemento
	
raiseSemiPrimeCount:
	 
	add $k1, $k1, $a3
	sw $k1, soma_semiprimos
	
	continueLoop:
	
		add $s2, $s2, -4 	# Andar endereco
		addi $t2, $t2, 1 	# Andar contador
		li $t0, 0 		# $t0 reset (cnt)
		li $t1, 2		# $t1 reset (i)
		blt $t2, $s7, loop1SemiPrime 
		jr $ra
		
showLastResult:

	li $t0, 0
	lw $t1, soma_perfeitos
	lw $t2, soma_semiprimos
	
	li $t3, 0
	
	sub $t3, $t1, $t2

	la $a0, msgFinal
	li $v0, 4
	syscall
	la $a0, ($t3)
	li $v0, 1
	syscall
	jr $ra