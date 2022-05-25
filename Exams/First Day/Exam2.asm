# Aluno: Rodrigo Mimura Shimomura 
# Matrícula: 202000560249
# 2) Dado um número natural n (maior ou igual a 10), verificar se n é palíndromo**.
# ** Dizemos que um número natural n é palíndromo se o 1o algarismo de n é igual ao
# seu último algarismo, o 2o algarismo de n é igual ao penúltimo algarismo, e assim
# sucessivamente. Ex. 567765 é palíndromo.

.data
	input: .asciiz "Insira o n (máximo de 200.000 algarismos, mínimo de 10 algarismos): "
	failure: .asciiz "\nO número não é palindromo!\n"
	success: .asciiz "\nO número é palindromo!\n"
	n: .space 200000
	number_size: .word 0
.text

main:
	jal reading
	jal find_size
	li $v0, 10
	syscall
	
reading:
	la $a0, input # Endereço da string carregada para receber do usuário
	li $v0, 4 # Print string
	syscall # syscall
	la $a0, n # Endereço da string
	li $a1, 200000 # Tamanho máximo do buffer
	li $v0, 8 # Leitura de string do usuário 
	syscall  # Syscall
	jr $ra # Voltar para main
	
find_size:

	li $t0, 0 # Tamanho da string
	la $s0, n # Endereço da string inputada
	
	loop_find:
	
		lb $t1, ($s0)
		
	beq $t1, 10, end_find # Checar se o byte carregado no registrador é igual ao \n
	
	add $t0, $t0, 1 # Aumenta o tamanho do número
	
	add $s0, $s0, 1 # Próximo byte
	
	j loop_find
	
end_find:

	rem $t1, $t0, 2 # Se tamanho % 2 == 1, o comprimento da string é ímpar, portanto não palíndromo
	beq $t1, 1, not_palindrome
	sw $t0, number_size	 # Se tamanho % 2 == 0,, vá para o loop de checar se o número é palíndromo
	j check_palindrome


check_palindrome:

	la $s0, n # Inicio do numero
	lw $t0, number_size # Tamanho do numero
	add $s1, $s0, $t0 # Final do número (Início do número + tamanho do número = final)
	add $s1, $s1, -1 # Voltar um espaço antes do \n
	div $t1, $t0, 2 # Número máximo de iterações = tamanho da string / 2
	li $t2, 0 # Contador para o número da iterações
	  
	loop_check_palindrome:
	
		lb $k0, ($s0)
		lb $k1, ($s1)
	
		bne $k0, $k1, not_palindrome # Comparação byte a byte do valor presente nas "duas pontas" do número
	
		add $s0, $s0, 1 # Andar para frente
		add $s1, $s1, -1 # Andar para trás
	
		add $t2, $t2, 1 # Aumentar a iteração
	
	blt $t2, $t1, loop_check_palindrome

	j palindrome

not_palindrome:

	la $a0, failure
	li $v0, 4
	syscall
	jr $ra
	
palindrome:

	la $a0, success
	li $v0, 4
	syscall
	jr $ra
