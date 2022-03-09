.data 

ent1: .asciiz "Insira a string 1: "
ent2: .asciiz "Insira a string 2: "
str1: .space 100
str2: .space 100
str3: .space 200
resultado: .asciiz "String resultante: "

.text 
main:

	la $a0, ent1
	la $a1, str1
	jal leitura
	la $a0, ent2
	la $a1, str2
	jal leitura
	la $a0, str1
	la $a1, str2
	la $a2, str3
	jal intercala
	la $a0, resultado 
	li $v0, 4
	syscall
	la $a0, str3
	li $v0, 4
	syscall 
	li $v0, 10
	syscall 

leitura:

	li $v0, 4
	syscall
	move $a0, $a1
	li $a1, 100
	li $v0, 8
	syscall 
	jr $ra
	
intercala:
	
	la $t1, str1
	la $t2, str2
	la $t3, str3
	
	check1:
		lb $t4, 0($t1)
		bne $t4, 10, save1
		j check2
		
	check2:
		lb $t4, 0($t2)
		bne $t4, 10, save2
		j return
		
	save1:
		sb $t4, 0($t3)
		add $t1, $t1, 1
		add $t3, $t3, 1
		j check2
	save2:
		sb $t4, 0($t3)
		add $t2, $t2, 1
		add $t3, $t3, 1
		j check1
	
	return:
		jr $ra
	# $s0 segura o valor do final da str1
	# $s1 segura o valor do final da str2
		