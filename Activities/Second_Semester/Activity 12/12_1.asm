.data 

	n: .word 0
	entr: .asciiz "Entre com o número de elementos: "
	ent1: .asciiz "Entre com Vet["
	ent2: .asciiz "]: "
	letraA: .asciiz "\na) O número de elementos menores que a soma dos N elementos lidos é = "
	letraB: .asciiz "\nb) O número de elementos ímpares é = "
	letraC: .asciiz "\nc) O produto da posição do menor elemento par do vetor com a posição do maior elemento ímpar do vetor é = "
	letraD: .asciiz "\nd) O vetor ordenado de forma decrescente = "
	start_vector: .word 0
	end_vector: .word 0
	sum: .word 0
	smaller: .word 0
	impares: .word 0
	not_impares: .asciiz "\nb) Não há elementos ímpares no vetor!"
	smallest_pair: .word 0
	biggest_odd: .word 0
	espaco: .asciiz " "
	msg_error_pair: .asciiz "\nc) Não há elementos pares no vetor!"
	msg_error_odd: .asciiz "\nc) Não há elementos ímpares no vetor!"
	
.text


.macro input_size()

	la $a0, entr
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, n

	li $a0, 0
	
	mul $a0, $v0, 4
	li $v0, 9
	syscall
	
	sw $v0, start_vector
	
	add $v0, $v0, $a0
	sw $v0, end_vector

.end_macro


.macro inputs()

	li $t0, 1
	lw $t1, n
	lw $s0, start_vector
	lw $s1, sum
	lw $s2, impares
	lw $s3, smallest_pair
	lw $s4, biggest_odd
	
	loop_inputs:
	
		la $a0, ent1
		li $v0, 4
		syscall
		
		add $a0, $zero, $t0
		li $v0, 1
		syscall
			
		la $a0, ent2
		li $v0, 4
		syscall
	
		li $v0, 5
		syscall
	
		sw $v0, ($s0)
	
		add $s1, $s1, $v0
		
		rem $t9, $v0, 2
		
		beq $t9, 1, odd
		
		beq $t9, 0, pair
		
		odd: 
		
			add $s2, $s2, 1
			bgt $v0, $s4, update_biggest_odd
			
			j continue_inputs
			
			update_biggest_odd:
			
				add $s4, $zero, $v0
				j continue_inputs
			
		pair:
		
			blt $v0, $s3, update_smallest_pair
			
			j continue_inputs
			
			update_smallest_pair:
			
				add $s3, $zero, $v0
				j continue_inputs
			
	
		continue_inputs:
	
		add $t0, $t0, 1
		add $s0, $s0, 4
		
	ble $t0, $t1, loop_inputs


	sw $s1, sum
	sw $s2, impares
	sw $s3, smallest_pair
	sw $s4, biggest_odd

.end_macro

.macro letterA()
	
	li $t0, 0
	lw $t1, n
	lw $s0, start_vector
	lw $s1, sum
	lw $s2, smaller
	
	loop_A:
	
	
		lw $k0, ($s0)
		
		blt $k0, $s1, menor
		
		j continue_A
		
		menor: 
		
			add $s2, $s2, 1	
		
	
		continue_A:
		
		add $t0, $t0, 1
		add $s0, $s0, 4
	
	blt $t0, $t1, loop_A
	
	sw $s2, smaller
	
	la $a0, letraA
	li $v0, 4
	syscall
	
	add $a0, $zero, $s2
	li $v0, 1
	syscall
	

.end_macro

.macro letterB()

	lw $t0, impares
	
	beq $t0, 0, no_impares
	
	bgt $t0, 0, yes_impares
	
	no_impares:
		
		la $a0, not_impares
		li $v0, 4
		syscall
		j continue_letterB
		
	yes_impares:
	
		la $a0, letraB
		li $v0, 4
		syscall
		
		add $a0, $zero, $t0
		li $v0, 1
		syscall
	
	continue_letterB:
	
		
.end_macro

.macro start_vars()

	lw $t0, smallest_pair
	
	add $t0, $zero, 2147483646
	
	sw $t0, smallest_pair
	
	lw $t0, biggest_odd
	
	add $t0, $zero, -2147483647
	
	sw $t0, biggest_odd

.end_macro

.macro letterC()

	lw $s0, impares
	lw $s1, smallest_pair
	lw $s2, biggest_odd
	
	beq $s1, 2147483646, error_pair
	beq $s2, -2147483647, error_odd
	j continue_letterC
	
	error_pair:
	
		la $a0, msg_error_pair
		li $v0, 4
		syscall
		
		beq $s2, -2147483647, error_odd
		j continue_letterC_error
	
	error_odd:
	
		la $a0, msg_error_odd
		li $v0, 4
		syscall
	
		j continue_letterC_error
		
	continue_letterC:
		
	la $a0, letraC
	li $v0, 4
	syscall
	
	mul $a0, $s1, $s2
	li $v0, 1
	syscall
	
	continue_letterC_error:
	

.end_macro 

.macro letterD()

	sort(start_vector, end_vector, n)
	
	li $t0, 0
	lw $t1, n
	
	la $a0, letraD
	li $v0, 4
	syscall
	
	lw $s0, start_vector
	
	loop_letterD:
	
		lw $a0, ($s0)
		li $v0, 1
		syscall
		
		la $a0, espaco
		li $v0, 4
		syscall
		
		add $s0, $s0, 4
		add $t0, $t0, 1
	
	blt $t0, $t1, loop_letterD
	
	li $v0, 10
	syscall
	
.end_macro

.macro sort(%start_vector, %end_vector, %vector_size)

    out_loop:
        add $t1, $zero, $zero
        lw  $a0, %start_vector		        	
        lw $t8, %end_vector 				
    inner_loop:
        lw  $t2, 0($a0)         	    		
        lw  $t3, 4($a0)         	    		
        sgt $t5, $t3, $t2       			
        beq $t5, $zero, continue    			
        ### TROCA DE VALORES AQUI ###
        add $t1, $zero, 1          			# Checar novamente
        sw  $t2, 4($a0)         			# Trocar
        sw  $t3, 0($a0)			  		# Trocar
        ### PRÓXIMO VALOR ###
    continue:
        addi $a0, $a0, 4            			
        addi $a1, $a0, 4	     			
        bne  $a1, $t8, inner_loop    			# Se o proximo elemento nao for o final, volta para o loop
        bne  $t1, $zero, out_loop    			# Se $t1 = 1, volte para o out_loop para checar novamente porque houve uma troca de valores

.end_macro

main:
	start_vars()
	input_size()
	inputs()
	letterA()
	letterB()
	letterC()
	letterD()
