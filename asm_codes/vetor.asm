.data


vet: .word 10,15,-5,0,2

.text
	li $t0,5 # $t0 = contador
	la  $t1, vet # $t1 é um ponteiro para vet
	li $v0, 0 # $v0 = 0
	
	loop:
		beq $t0, $s0, exit
		lw $t2, 0($t1)
		add $v0, $v0, $t2
		addi $t1, $t1, 4
		addi $t0, $t0, -1
		j loop
		
	exit:
	li $v0, 10
	syscall