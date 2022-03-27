.data

Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]:"

vect1: .asciiz "Insira o valor de Vect["
vect2: .asciiz "]:"

escreve_vetor: .asciiz "\nVetor = "
escreve_vetor_resposta: .asciiz "\nVetor resposta = "
espaco: .asciiz " "

vetor: .space 12
comecoDaMatriz: .word 0

vetor_resposta: .space 16

nDeLinhas: .word 4
nDeColunas: .word 3

.text 
main:
	jal alocar_espaco
	la $a0, comecoDaMatriz # Endereço base de Mat
      	lw $a1, nDeLinhas # Número de linhas
     	lw $a2, nDeColunas # Número de colunas
      	jal leitura # leitura (mat, nlin, ncol)
      	move $a0, $v0 # Endereço da matriz lida
      	
      	jal leitura_vetor
      	
	lw $a0, comecoDaMatriz     	      		      	      	      		      	
      	      	      		      	      	      		      	      	      		      	      	      		      	      	      		      	      	      		      	
      	jal escrita # escrita (mat, nlin, ncol)
      	
      	jal escrita_vetor
      	
      	jal multiplica
      	
      	end:
      	
      		jal escrita_vetor_resposta
	
	     	li $v0, 10 # Código para finalizar o programa
	      	syscall # Finaliza o programa

alocar_espaco:
 	
 	lw $t0, nDeLinhas
 	lw $t1, nDeColunas
 	
	mul $a0, $t0, $t1 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $a0, $a0, 4 # x4 bits por ser int
	li $v0, 9  # Alocacao dinamica
	sw $v0, comecoDaMatriz # Salvar comeco da matriz
	add $a0, $zero, $zero # Reset $a0
	add $t0, $zero, $zero # Reset $t0
	add $t1, $zero, $zero # Reset $t1
	jr $ra	

indice:
	mul $v0, $t0, $a2 # i * ncol
	add $v0, $v0, $t1 # (i * ncol) + j
	sll $v0, $v0, 2 # [(i * ncol) + j] * 4 (inteiro)
	add $v0, $v0, $a3 # Soma o endereço base de mat
	jr $ra # Retorna para o caller
	
leitura: # leitura(matriz, nlinhas, ncolunas)
	subi $sp, $sp, 4 # Espaço para 1 item na pilha
	sw $ra, ($sp) # Salva o retorno para a main
	move $a3, $a0 # aux = endereço base de mat
	
	l: 
		la $a0, Ent1 # Carrega o endereço da string
 		li $v0, 4 # Código de impressão de string
  		syscall # Imprime a string
 		move $a0, $t0 # Valor de i para impressão
 		li $v0, 1 # Código de impressão de inteiro
  		syscall # Imprime i
 		la $a0, Ent2 # Carrega o endereço da string
 		li $v0, 4 # Código de impressão de string
  		syscall # Imprime a string
 		move $a0, $t1 # Valor de j para impressão
 		li $v0, 1 # Código de impressão de inteiro
  		syscall # Imprime j
  		la $a0, Ent3 # Carrega o endereço da string
  		li $v0, 4 # Código de impressão de string
		syscall # Imprime a string
		li $v0, 5 # Código de leitura de inteiro
		syscall # Leitura do valor (retorna em $v0)
		move $t2, $v0 # aux = valor lido
		jal indice # Calcula o endereço de mat [i] [j]
		sw $t2, ($v0) # mat [i] [j] = aux
		addi $t1, $t1, 1 # j++
		blt $t1, $a2, l # if(j < ncol) goto 1
		li $t1, 0 #j = 0
		addi $t0, $t0, 1 # i++
		blt $t0, $a1, l # if(i < nlin) goto 1
		li $t0, 0 # i = 0
		lw $ra, ($sp) # Recupera o retorno para a main
		addi $sp, $sp, 4 # Libera o espaço na pilha
		move $v0, $a3 # Endereço base da matriz para retorno
		jr $ra # Retorna para a main

escrita:
   	subi $sp, $sp, 4 # Espaço para 1 item na pilha
   	sw $ra, ($sp) # Salvao retorno para a main
	la $a3, comecoDaMatriz # aux = endereço base de mat 
	e: 
		jal indice # Calcula o endereço de mat [i] [j]
   		lw $a0, ($v0) # Valor em mat [i] [j]
   		li $v0, 1 # Código de impressão de inteiro
   		syscall # Imprime mat [i] [j]
   		la $a0, 32 # Código ASCII para espaço
   		li $v0, 11 # Código de impressão de caractere
   		syscall # Imprime o espaço
   		addi $t1, $t1, 1 # j++
   		blt $t1, $a2, e # if(j < ncol) goto e
   		la $a0, 10 # Código ASCII para newline ('\n')
   		syscall # Pula a linha
   		li $t1, 0 #j = 0
   		addi $t0, $t0, 1 # i++
   		blt $t0, $a1, e # if(i < nlin) goto e
   		li $t0, 0 #i = 0
   		lw $ra, ($sp) # Recupera o retorno para a main
   		addi $sp, $sp, 4 # Libera o espaço na pilha
   		move $v0, $a3 # Endereço base da matriz para retorno
    		jr $ra # Retorna para a main
    		
leitura_vetor:

	add $s0, $zero, $zero
	add $t0, $zero, $zero
	
	loop:
		la $a0, vect1 # Carrega o endereço da string
 		li $v0, 4 # Código de impressão de string
  		syscall # Imprime a string
 		move $a0, $t0 # Valor de i para impressão
 		li $v0, 1 # Código de impressão de inteiro
  		syscall # Imprime i
 		la $a0, vect2 # Carrega o endereço da string
 		li $v0, 4 # Código de impressão de string
  		syscall # Imprime a string
		li $v0, 5 # Código de leitura de inteiro
		syscall # Leitura do valor (retorna em $v0)
		move $t2, $v0 # aux = valor lido
		sb $t2, vetor($s0)
		add $s0, $s0, 4
		add $t0, $t0, 1
		blt $t0, 3, loop
		add $t0, $zero, $zero
		jr $ra
		
escrita_vetor:
	
	li $s0, 0
	add $t0, $zero, $zero
	la $a0, escreve_vetor # Carrega o endereço da string
	li $v0, 4 # Código de impressão de string
	syscall # Imprime a string
	
	loop_escrita:
		
 		lb $a0, vetor($s0) # Valor de i para impressão
 		li $v0, 1 # Código de impressão de inteiro
  		syscall # Imprime i
 		la $a0, espaco # Carrega o endereço da string
 		li $v0, 4 # Código de impressão de string
  		syscall # Imprime a string
		add $s0, $s0, 4
		add $t0, $t0, 1
		blt $t0, 3, loop_escrita
		jr $ra

escrita_vetor_resposta:
	
	la $s0, vetor_resposta
	add $t0, $zero, $zero
	la $a0, escreve_vetor_resposta # Carrega o endereço da string
	li $v0, 4 # Código de impressão de string
	syscall # Imprime a string
	
	loop_escrita_resposta:
		
 		lw $a0, 0($s0) # Valor de i para impressão
 		li $v0, 1 # Código de impressão de inteiro
  		syscall # Imprime i
 		la $a0, espaco # Carrega o endereço da string
 		li $v0, 4 # Código de impressão de string
  		syscall # Imprime a string
		add $s0, $s0, 4
		add $t0, $t0, 1
		blt $t0, 4, loop_escrita_resposta
		jr $ra

multiplica:

	lw $s1, comecoDaMatriz
	la $s2, vetor
	la $k1, vetor_resposta
	add $s0, $zero, $zero # Somatorio das multiplicacoes
	la $a3, comecoDaMatriz
	li $t1, 0
	li $t0, 0
	
	
	loop_mul:
	
		jal indice # Calcula o endereço de mat [i] [j]
		lw $t8, ($v0) # Valor em mat [i] [j]
		lb $t9, 0($s2) # Valor em vetor[i]
		mul $t7, $t8, $t9 # Elemento da matriz * elemento do vetor
		add $s0, $s0, $t7 # Adicionar no valor final
		addi $t1, $t1, 1 # j++
		addi $s2, $s2, 4
   		blt $t1, $a2, loop_mul # if(j < ncol) goto loop_mul
   		mul $k0, $t0, 4
   		add $s2, $s2, $k0
		la $s2, vetor
		sb $s0, 0($k1)
		add $k1, $k1, 4
		li $t1, 0 #j = 0
		addi $t0, $t0, 1 # i++
		add $s0, $zero, $zero
		la $s2, vetor
		blt $t0, $a1, loop_mul # if(i < nlin) goto 1
		li $t0, 0 # i = 0
		j end
