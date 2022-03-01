.data 
	
	msgSize: .asciiz "Insert array size:"
	msgInsertValues1: .asciiz "Insert the integer value of VetA["
	msgInsertValues2: .asciiz "]:"
	jumpLine: .asciiz ".\n"
	smallestMessage: "Smallest value of the array = "
	biggestMessage: "Biggest value of the array = "
	andMessage: " and it is on position: "
	smallerPos: .word 0
	biggerPos: .word 0
.text

main:
	li $s6, 999999
	jal array_size
	jal result
	li $v0, 10
	syscall

array_size:

	la $a0, msgSize
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	add $s7, $v0, $zero 				# $s7 = array size
	mul $k0, $s7, 4 				# $k0 = number of necessary bytes for the array
	
allocate_space:
	
	li $t2, 1
	add $a0, $zero, $k0
	li $v0, 9
	syscall
	move $s0, $v0					# $s0 = array start
	add $s1, $s0, $k0
	add $s1, $s1, -4				# $s1 = array end
	move $s2, $s0					# Runner
	j array_read

array_read:

	la $a0, msgInsertValues1
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, msgInsertValues2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	sw $v0, ($s2)
	add $s2, $s2, 4
	
	bgt $v0, $s5, bigger
	blt $v0, $s6, smaller

continue:

	addi $t2, $t2, 1 				# counter
	ble $t2, $s7, array_read
	move $v0, $s0
	jr $ra

bigger:

	add $s5, $zero, $v0
	sw $t2, biggerPos
	j continue

smaller:

	add $s6, $zero, $v0
	sw $t2, smallerPos
	j continue
	
result:

	la $a0, smallestMessage
	li $v0, 4
	syscall

	move $a0, $s6
	li $v0, 1
	syscall
	
	la $a0, andMessage
	li $v0, 4
	syscall
	
	lw $a0, smallerPos
	li $v0, 1
	syscall
	
	la $a0, jumpLine
	li $v0, 4
	syscall
	
	# --
	
	la $a0, biggestMessage
	li $v0, 4
	syscall

	move $a0, $s5
	li $v0, 1
	syscall
	
	la $a0, andMessage
	li $v0, 4
	syscall
	
	lw $a0, biggerPos
	li $v0, 1
	syscall
	
	la $a0, jumpLine
	li $v0, 4
	syscall
	
	jr $ra