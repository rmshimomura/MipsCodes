.data

ent: .asciiz "Insira a string 1: "
str: .space 100
str_trim: .space 100
str_rev: .space 100

resultado: .asciiz "Resultado final: "

.text

main: 
	la $a0, ent1
	la $a1, str1
	jal leitura
	jal format
	
leitura:

	li $v0, 4
	syscall
	move $a0, $a1
	li $a1, 100
	li $v0, 8
	syscall 
	jr $ra

format:

	la $t0, str
	la $t1, str_rev
	move $s1, $t0
	
	find_str_end:
	
		lb $t2, 0($t0)
		beq $t2, 10, trim
		move $s1, $t0
		add $t0, $t0, 1
	
	trim:
	
		la $t0, str
			
		loop_trim:
		
			lb $t2, 0($t0)
			bne $t2, 32, save
		
		save:
			sb $t2, 