# Aluno: Rodrigo Mimura Shimomura 
# Matricula: 202000560249
# Elaborar um programa em MIPS que calcule o desvio padrão de um vetor v
# contendo n = 10 números reais, onde m e a média do vetor.

.data

	vector: .word 0
	msg_insert_1: .asciiz "\nEntre com o valor " 
	msg_insert_2: .asciiz " do vetor : " 
	msg_result: .asciiz "\nO desvio padrao dos 10 valores é: "
	jumpLine: .asciiz "\n"
	multiply: .float 0
	mean: .float 0
	zero: .float 0
	one: .float 1
	nine: .float 9
	ten: .float 10
.text


.macro read_inputs()

	lw $s0, vector # Endereco do vetor
	li $t0, 0 # Contador
 	
	l.s $f12, zero
	l.s $f10, ten
	
	loop_read_inputs:
	
		la $a0, msg_insert_1
		li $v0, 4 # Imprimir strings
		syscall
		
		add $a0, $zero, $t0 
		li $v0, 1 # Imprimir indice no vetor
		syscall
		
		la $a0, msg_insert_2
		li $v0, 4 # Imprimir strings
		syscall
		
		li $v0, 6 # Ler float
		syscall
		
		s.s $f0, ($s0) # Salvar na memoria
		add.s $f12, $f12, $f0 # Adicionar para fazer media depois
		
		add $t0, $t0, 1 # i++
		add $s0, $s0, 4 # Proximo endereco
		blt $t0, 10, loop_read_inputs # Condicao de parada
		 
	div.s $f12, $f12, $f10 # Media

	s.s  $f12, mean
		

.end_macro

.macro allocate_vector()

	li $a0, 40 # Alocar 10 posicoes (4bytes * 10 posicoes)
	li $v0, 9
	syscall
	
	sw $v0, vector

.end_macro


.macro exit()

	li $v0, 10
	syscall

.end_macro

.macro calculate()
	
	l.s $f1, one
	l.s $f2, nine
	div.s $f0, $f1, $f2 # Fator 1/(n-1), no caso 1/9
	s.s $f0, multiply 
	
	li $t0, 0 # Contador de iteracoes
	lw $s0, vector # Percorrer o vetor
	l.s $f30, mean # Media
	
	loop_sum:
	
		l.s $f14, ($s0) # v[i]
		sub.s $f16, $f14, $f30 # v[i] - media
		mul.s $f16, $f16, $f16 # (v[i] - media)^2
		
		add.s $f18, $f18, $f16 # Somatorio
		
		add $s0, $s0, 4 # Proximo endereco
		add $t0, $t0, 1 # i++
	
	blt $t0, 10, loop_sum # Condicao de parada do loop 
	
	mul.s $f0, $f0, $f18 # Somatoria * 1 / 9
	
	sqrt.s $f0, $f0 # Raiz quadrada
	
	la $a0, msg_result
	li $v0, 4 # Imprimir strings
	syscall
	
	li $v0, 2 # Imprimir float
	mov.s $f12, $f0 
	syscall

	la $a0, jumpLine # Imprimir \n	
	li $v0, 4
	syscall

.end_macro

main:
	allocate_vector()
	read_inputs()
	calculate()
	
	exit()
	
