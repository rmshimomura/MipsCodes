# Aluno: Rodrigo Mimura Shimomura 
# Matrícula: 202000560249
# 2) Dado um número natural n (maior ou igual a 10), verificar se n é palíndrome**.
# ** Dizemos que um número natural n é palíndromo se o 1o algarismo de n é igual ao
# seu último algarismo, o 2o algarismo de n é igual ao penúltimo algarismo, e assim
# sucessivamente. Ex. 567765 é palíndromo.

.data
	entrada: .asciiz "Insira o n (máximo de 200.000 algarismos): "
	fracasso: .asciiz "\nO número não é palindromo!\n"
	sucesso: .asciiz "\nO número é palindromo!\n"
	n: .space 200000
	tamanho_numero: .word 0
.text

main:
	jal leitura
	jal encontrar_tamanho
	li $v0, 10
	syscall
	
leitura:
	la $a0, entrada # Endereço da string carregada para receber do usuário
	li $v0, 4 # Print string
	syscall # syscall
	la $a0, n # Endereço da string
	li $a1, 200000 # Tamanho máximo do buffer
	li $v0, 8 # Leitura de string do usuário 
	syscall  # Syscall
	jr $ra # Voltar para main
	
encontrar_tamanho:

	li $t0, 0 # Tamanho da string
	la $s0, n # Endereço da string inputada
	
	loop_encontrar:
	
		lb $t1, ($s0)
		
	beq $t1, 10, fim_encontrar # Checar se o byte carregado no registrador é igual ao \n
	
	add $t0, $t0, 1 # Aumenta o tamanho do número
	
	add $s0, $s0, 1 # Próximo byte
	
	j loop_encontrar
	
fim_encontrar:

	rem $t1, $t0, 2 # Se tamanho % 2 == 1, o comprimento da string é ímpar, portanto não palíndromo
	beq $t1, 1, nao_palindromo
	sw $t0, tamanho_numero	 # Se tamanho % 2 == 0,, vá para o loop de checar se o número é palíndromo
	j check_palindrome


check_palindrome:

	la $s0, n # Inicio do numero
	lw $t0, tamanho_numero # Tamanho do numero
	add $s1, $s0, $t0 # Final do número (Início do número + tamanho do número = final)
	add $s1, $s1, -1 # Voltar um espaço antes do \n
	div $t1, $t0, 2 # Número máximo de iterações = tamanho da string / 2
	li $t2, 0 # Contador para o número da iterações
	  
	loop_check_palindrome:
	
		lb $k0, ($s0)
		lb $k1, ($s1)
	
		bne $k0, $k1, nao_palindromo # Comparação byte a byte do valor presente nas "duas pontas" do número
	
		add $s0, $s0, 1 # Andar para frente
		add $s1, $s1, -1 # Andar para trás
	
		add $t2, $t2, 1 # Aumentar a iteração
	
	blt $t2, $t1, loop_check_palindrome

	j palindromo

nao_palindromo:

	la $a0, fracasso
	li $v0, 4
	syscall
	jr $ra
	
palindromo:

	la $a0, sucesso
	li $v0, 4
	syscall
	jr $ra
