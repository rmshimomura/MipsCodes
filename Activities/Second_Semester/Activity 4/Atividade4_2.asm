.data 

entrarTamanhoMatriz: .asciiz "Entre com o número de linhas e colunas: "
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]:"
problemas: .asciiz "\nA matriz não é de permutação!"
sucesso: .asciiz "\nA matriz é de permutação!"
tamanhoDaMatriz: .word 0
comecoDaMatriz: .word 0
quantidadeDe1: .word 0


.text 
main:
	jal alocar_espaco
	la $a0, comecoDaMatriz # Endereço base de Mat
      	lw $a1, tamanhoDaMatriz # Número de linhas
     	lw $a2, tamanhoDaMatriz # Número de colunas
      	jal leitura # leitura (mat, nlin, ncol)
      	move $a0, $v0 # Endereço da matriz lida
      	
      	jal linhas
      	
      	move $a0, $v0
      	
      	jal colunas

      	move $a0, $v0
      	      		      	
      	#jal escrita # escrita (mat, nlin, ncol)
      	
      	la $a0, sucesso # Carrega o endereço da string
 	li $v0, 4 # Código de impressão de string
  	syscall # Imprime a string
      	
     	li $v0, 10 # Código para finalizar o programa
      	syscall # Finaliza o programa

alocar_espaco:
	
	la $a0, entrarTamanhoMatriz # Carrega o endereço da string
 	li $v0, 4 # Código de impressão de string
  	syscall # Imprime a string
 	li $v0, 5 # Tamanho da matriz em $v0
 	syscall
 	
 	sw $v0, tamanhoDaMatriz
	add $a0, $zero, $v0 # $a0 vai segurar o tamanho da matriz para alocar na memoria
	mul $a0, $a0, 4 # x4 bits por ser int
	li $v0, 9  # Alocacao dinamica
	sw $v0, comecoDaMatriz # Salvar comeco da matriz
	add $a0, $zero, $zero # Reset $a0
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
	move $a3, $a0 # aux = endereço base de mat 
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

# ======================================================================================================
linhas:
	subi $sp, $sp, 4 # Espaço para 1 item na pilha
   	sw $ra, ($sp) # Salva o retorno para a main
	move $a3, $a0 # aux = endereço base de mat 
	add $s0, $zero, $zero # $s0 é o número de '1's na linha
	
	loop1:
		jal indice # Calcula o endereço de mat [i] [j]
   		lw $a0, ($v0) # Valor em mat [i] [j]
   		
   		seq $t9, $a0, 1
   		
   		beq $t9, 1, adicionar1
   		
   		back1:
   		
   			addi $t1, $t1, 1 # j++
   			bgt $s0, 1, fail
   			blt $t1, $a2, loop1 # if(j < ncol) goto loop1
   			li $t1, 0 #j = 0
   			addi $t0, $t0, 1 # i++
   			add $s0, $zero, $zero # Reset para próxima linha
   			blt $t0, $a1, loop1 # if(i < nlin) goto loop1
   			li $t0, 0 #i = 0
   			bgt $s0, 1, fail
   			
   			back2:
   			
   				lw $ra, ($sp) # Recupera o retorno para a main
   				addi $sp, $sp, 4 # Libera o espaço na pilha
   				move $v0, $a3 # Endereço base da matriz para retorno
    				jr $ra # Retorna para a main

adicionar1: 

	add $s0, $s0, 1
	j back1
	
# ======================================================================================================
	
colunas:
	subi $sp, $sp, 4 # Espaço para 1 item na pilha
   	sw $ra, ($sp) # Salva o retorno para a main
	move $a3, $a0 # aux = endereço base de mat 
	add $s0, $zero, $zero # $s0 é o número de '1's na linha
	
	loop2:
		jal indice # Calcula o endereço de mat [i] [j]
   		lw $a0, ($v0) # Valor em mat [i] [j]
   		
   		seq $t9, $a0, 1
   		
   		beq $t9, 1, adicionar2
   		
   		back3:
   			addi $t0, $t0, 1 # i++
   			blt $t0, $a1, loop2 # if(i < nlin) goto e
   			li $t0, 0 #i = 0
   			
   			bgt $s0, 1, fail
   			
   			addi $t1, $t1, 1 # j++
   			add $s0, $zero, $zero # Reset para próxima coluna
   			blt $t1, $a2, loop2 # if(j < ncol) goto e
   			li $t1, 0 #j = 0
   			
   			bgt $s0, 1, fail
   			
   			back4:
   			
   				lw $ra, ($sp) # Recupera o retorno para a main
   				addi $sp, $sp, 4 # Libera o espaço na pilha
   				move $v0, $a3 # Endereço base da matriz para retorno
    				jr $ra # Retorna para a main

adicionar2: 

	add $s0, $s0, 1
	j back3
	
# ======================================================================================================
	
fail:
	la $a0, problemas # Carrega o endereço da string
 	li $v0, 4 # Código de impressão de string
  	syscall # Imprime a string
	
	li $v0, 10
	syscall
	