.data 

entrarTamanhoMatriz: .asciiz "Entre com o n�mero de linhas e colunas: "
erroTamanho: .asciiz "N nao pode ser maior do que 8!\n"
Ent1: .asciiz "\nInsira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]:"
tamanhoDaMatriz: .word 0
comecoDaMatriz: .word 0

.text 
main:
	jal alocar_espaco
	lw $a0, comecoDaMatriz # Endere�o base de Mat
      	lw $a1, tamanhoDaMatriz # N�mero de linhas
     	lw $a2, tamanhoDaMatriz # N�mero de colunas
      	jal leitura # leitura (mat, nlin, ncol)
      	move $a0, $v0 # Endere�o da matriz lida
      	
      	jal escrita
      	
     	li $v0, 10 # C�digo para finalizar o programa
      	syscall # Finaliza o programa

alocar_espaco:
	
	la $a0, entrarTamanhoMatriz # Carrega o endere�o da string
 	li $v0, 4 # C�digo de impress�o de string
  	syscall # Imprime a string
 	li $v0, 5 # Tamanho da matriz em $v0
 	syscall
 	
 	bgt $v0, 8, erro
 	
 	sw $v0, tamanhoDaMatriz
	add $a0, $zero, $v0 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $t0, $a0, $a0 # Linhas * colunas
	
	li $v0, 9  # Alocacao dinamica
	syscall
	
	sw $v0, comecoDaMatriz # Salvar comeco da matriz
	add $a0, $zero, $zero # Reset $a0
	add $t0, $zero, $zero 
	jr $ra	

erro:
	la $a0, erroTamanho # Carrega o endere�o da string
 	li $v0, 4 # C�digo de impress�o de string
  	syscall # Imprime a string
	
	j alocar_espaco

indice:
	mul $v0, $t0, $a2 # i * ncol
	add $v0, $v0, $t1 # (i * ncol) + j
	add $v0, $v0, $a3 # Soma o endere�o base de mat
	jr $ra # Retorna para o caller
	
leitura: # leitura(matriz, nlinhas, ncolunas)
	subi $sp, $sp, 4 # Espa�o para 1 item na pilha
	sw $ra, ($sp) # Salva o retorno para a main
	move $a3, $a0 # aux = endere�o base de mat
	
	l: 
		la $a0, Ent1 # Carrega o endere�o da string
 		li $v0, 4 # C�digo de impress�o de string
  		syscall # Imprime a string
 		move $a0, $t0 # Valor de i para impress�o
 		li $v0, 1 # C�digo de impress�o de inteiro
  		syscall # Imprime i
 		la $a0, Ent2 # Carrega o endere�o da string
 		li $v0, 4 # C�digo de impress�o de string
  		syscall # Imprime a string
 		move $a0, $t1 # Valor de j para impress�o
 		li $v0, 1 # C�digo de impress�o de inteiro
  		syscall # Imprime j
  		la $a0, Ent3 # Carrega o endere�o da string
  		li $v0, 4 # C�digo de impress�o de string
		syscall # Imprime a string
		
		li $v0, 12 # C�digo de leitura de char
		syscall # Leitura do valor (retorna em $v0)
		
		move $t2, $v0 # aux = valor lido
		jal indice # Calcula o endere�o de mat [i] [j]
		sb $t2, ($v0) # mat [i] [j] = aux
		addi $t1, $t1, 1 # j++
		blt $t1, $a2, l # if(j < ncol) goto 1
		li $t1, 0 #j = 0
		addi $t0, $t0, 1 # i++
		blt $t0, $a1, l # if(i < nlin) goto 1
		li $t0, 0 # i = 0
		lw $ra, ($sp) # Recupera o retorno para a main
		addi $sp, $sp, 4 # Libera o espa�o na pilha
		move $v0, $a3 # Endere�o base da matriz para retorno
		jr $ra # Retorna para a main

escrita:
   	subi $sp, $sp, 4 # Espa�o para 1 item na pilha
   	sw $ra, ($sp) # Salvao retorno para a main
	move $a3, $a0 # aux = endere�o base de mat 
	e: 
		jal indice # Calcula o endere�o de mat [i] [j]
   		lb $a0, ($v0) # Valor em mat [i] [j]
   		add $a0, $a0, 3
   		li $v0, 11 # C�digo de impress�o de char
   		syscall # Imprime mat [i] [j]
   		la $a0, 32 # C�digo ASCII para espa�o
   		li $v0, 11 # C�digo de impress�o de caractere
   		syscall # Imprime o espa�o
   		addi $t1, $t1, 1 # j++
   		blt $t1, $a2, e # if(j < ncol) goto e
   		la $a0, 10 # C�digo ASCII para newline ('\n')
   		syscall # Pula a linha
   		li $t1, 0 #j = 0
   		addi $t0, $t0, 1 # i++
   		blt $t0, $a1, e # if(i < nlin) goto e
   		li $t0, 0 #i = 0
   		lw $ra, ($sp) # Recupera o retorno para a main
   		addi $sp, $sp, 4 # Libera o espa�o na pilha
   		move $v0, $a3 # Endere�o base da matriz para retorno
    		jr $ra # Retorna para a main

# ======================================================================================================
