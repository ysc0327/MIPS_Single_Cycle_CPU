.data
Array: .word 9, 2, 8, 1, 6, 5, 4, 10, 3, 7, 15, 14, 12, 11, 13  # you can change the element of array

.text
main:
	addi $t0, $zero, 4097      # $t0 = 0x00001001
	sll  $t0, $t0, 16          # set the base address of your array into $t0 = 0x10010000    

	#--------------------------------------#
	# \^o^/          ~Start~         \^o^/ #
	#--------------------------------------#

# Set Constraint
	li $s0, 16
	li $s1, 1
	j start

start:
	beq $s0, $s1, finish
	or  $t2, $s1, $zero
        j loop_c1

loop_c1:
	slt  $t6, $zero, $t2
	bne  $t6, $zero, loop_c2
	addi $s1, $s1, 1
	j start
	
loop_c2:		
	sll $t3, $t2, 2
	add $t4, $t0, $t3
	lw  $s2,  0($t4)
	lw  $s3, -4($t4)
	slt $t5, $s2, $s3 
	bne $t5, $zero, swap
	addi $t2, -1
	j loop_c1
		
swap:
	lw   $s4,  0($t4)
	lw   $s5, -4($t4)
	sw   $s4, -4($t4)
	sw   $s5,  0($t4)
	addi $t2, -1
	j loop_c1

finish:
	li   $v0, 10               # program stop
	syscall
	
