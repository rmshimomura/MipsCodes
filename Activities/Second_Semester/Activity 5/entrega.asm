.data
	buffer: .asciiz " "
	Arquivo: .asciiz "data.txt"
	Erro: .asciiz "Arquivo não encontrado!\n"
	resultado: .asciiz "O resultado final eh: "
.text
main:
	la $a0, Arquivo # Nome do arquivo
	li $a1, 0 # Somente leitura
	jal abertura # Retorna file descriptor no sucesso
	move $s0, $v0 # Salva o file descriptor em $s0
	move $a0, $s0 # Parâmetro file descriptor
	la $a1, buffer # Buffer de entrada
	li $a2, 1 # 1 caractere por leitura
	
	jal contagem # Retorna em $vo o num. de carac.
	
	move $a0, $v0 # Move o resultado para impressão
	li $v0, 1 # Código de impressão de inteiro
	syscall # Imprime o resultado
	
	final_sum_and_close:
	
		div $t1, $t1, 10
		add $t2, $t2, $t1
		li $v0, 16 # Código para fechar o arquivo
		move $a0, $s0 # Parâmetro file descriptor
		syscall # Fecha o arquivo
		li $v0, 4
		la $a0, resultado
		syscall
		
		li $v0, 1
		add $a0, $0, $t2
		syscall
		
		li $v0, 10 # Código para finalizar o programa
		syscall # Finaliza o programa
	
	
reset:
	div $t1, $t1, 10
	add $t2, $t2, $t1
	li $t0, 0
	li $t1, 0
	
contagem:
	li $v0, 14 # Código de leitura de arquivo
	syscall # Faz a leitura de 1 caractere
	beqz $v0, final_sum_and_close
	lb $t0, ($a1)
	
	beq $t0, 32, reset	
	sub $t0, $t0, 48 # $t0 valor lido transformado em int
	add $t1, $t1, $t0
	mul $t1, $t1, 10 # $t1 soma intermediaria
	# $t2 soma final
	bnez $v0, contagem # if (ch != EOF) goto contagem
	move $v0, $t0 # Move o resultado para retorno
 	jr $ra # Retorna para a main
 	
 abertura:
	li $v0, 13 # Código de abertura de arquivo
	syscall # Tenta abrir o arquivo
	bgez $v0, a # if (file_descriptor >= 0) goto a
	la $a0, Erro # else erro: carrega o endereço da string
	li $v0, 4 # Código de impressão de string
	syscall # Imprime o erro
	li $v0, 10 # Código para finalizar o programa
	syscall # Finaliza o programa
a: jr $ra # Retorna para a main