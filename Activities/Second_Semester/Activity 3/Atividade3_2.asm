.data

ent: .asciiz "Insira a string 1: "
str: .space 100
str_trim: .space 100
str_upper: .space 100
str_rev: .space 100
success: .asciiz "Palindromo!"
failure: .asciiz "Nao palindromo!"


resultado: .asciiz "Resultado final: "

.text

main: 
	la $a0, ent
	la $a1, str
	jal leitura
	jal format
	
#	la $a0, str_upper
#	li $v0, 4
#	syscall
	
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

format:

	la $t0, str
	la $t1, str_trim
	la $t2, str_rev
	la $t4, str_upper
	
	move $s1, $t0 # $s1 tera o final da string original
	
	find_str_end:
	
		lb $t3, 0($t0)
		move $s1, $t0
		beq $t3, 10, trim
		add $t0, $t0, 1
		j find_str_end
	
	trim:
	
		la $t0, str
			
		loop_trim:
			
			lb $t3, 0($t0)
			beq $t3, 10, find_str_trim_end # Se igual a \n
			bne $t3, 32, save_trim  # Se nao for igual a espaço, junte
			add $t0, $t0, 1
			j loop_trim
		save_trim:
			sb $t3, 0($t1)
			add $t0, $t0, 1
			add $t1, $t1, 1
			j loop_trim
			
	find_str_trim_end:
		 
		la $t1, str_trim
		move $s2, $t1 # $s2 vai guardar o final da string trim
		j find_str_trim_end_loop
		
	find_str_trim_end_loop:
	
		lb $t3, 0($t1)
		move $s2, $t1
		beq $t3, 0, upper
		add $t1, $t1, 1
		j find_str_trim_end_loop
	
	upper:
		
		la $t1, str_trim
		
		loop_upper:
		
			lb $t3, 0($t1)
			bne $t3, 0, save_upper
			j reverse
			
		save_upper:
			
			sge $t9, $t3, 97
			
			beq $t9, 1, raise
			j back_save
			
			raise:
				add $t3, $t3, -32
				
			back_save:
			
				sb $t3, 0($t4)
				add $t4, $t4, 1
				add $t1, $t1, 1
				j loop_upper
				
reverse:

	la $t6, str_upper
	add $t4, $t4, -1
	
	loop:
		seq $t7, $t4, $t6 
		beqz $t7, compare
		j palindrome
		
	compare:
		
		lb $t8, 0($t6) # comeco
		lb $t9, 0($t4) # fim
		
		seq $k0, $t8, $t9
		beqz $k0, no_palindrome
		
		add $t6, $t6, 1
		add $t4, $t4, -1
		
		j loop
	
palindrome:

	la $a0, success
	li $v0, 4
	syscall
	jr $ra
		
no_palindrome:

	la $a0, failure
	li $v0, 4
	syscall
	jr $ra
