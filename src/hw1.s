################################################################################
#Program Name		: HW1
#Programmer		: Nicolas Constantinou	ID:1135533
#Date Last Modif.	: 21 Sep 2024
################################################################################
#Comments: 
################################################################################

	.data					# data segment
msg1:   .asciiz "terms["
msg2:   .asciiz "] : ln("
msg3:   .asciiz ")="
msg4:   .asciiz "]R: ln("
newLine: .asciiz "\n"

################################################################################

	.text					# text segment
	.globl main
main:   
	li $a0, 0
	li $a1, 200
	li $t0, 10

L:	bgt $a0, $t0, exit
	addi $sp, $sp, -12
	sw $a0, 0($sp)	
	sw $a1, 4($sp)

	jal Taylor_ln
	sw $v0, 8($sp)

	la $a0, msg1
	li $v0, 4
	syscall
	
	lw $a0, 4($sp)
	li $v0, 1
	syscall 
	
	la $a0, msg2
	li $v0, 4
	syscall

	lw $a0, 0($sp)
	li $v0, 1
	syscall 

	la $a0, msg3
	li $v0, 4
	syscall

	lw $a0, 8($sp)
	li $v0, 1
	syscall 

	la $a0, newLine
	li $v0, 4
	syscall

	lw $a0, 0($sp)	
	lw $a1, 4($sp)
	lw $v0, 8($sp)
	addi $sp, $sp, 12	

	addi $sp, $sp, -12
	sw $a0, 0($sp)	
	sw $a1, 4($sp)

	jal Taylor_lnRecursive
	sw $v0, 8($sp)

	la $a0, msg1
	li $v0, 4
	syscall
	
	lw $a0, 4($sp)
	li $v0, 1
	syscall 
	
	la $a0, msg4
	li $v0, 4
	syscall

	lw $a0, 0($sp)
	li $v0, 1
	syscall 

	la $a0, msg3
	li $v0, 4
	syscall

	lw $a0, 8($sp)
	li $v0, 1
	syscall 

	la $a0, newLine
	li $v0, 4
	syscall

	lw $a0, 0($sp)	
	lw $a1, 4($sp)
	lw $v0, 8($sp)
	addi $sp, $sp, 12

	addi $a0, $a0, 1
	j L

exit:	li $v0, 10
	syscall

#################################################################################
powerR: 
	beq $a1, $0, exitP
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a0, 8($sp)

	addi $a1, $a1, -1
	jal powerR
	mul $v0, $a0, $v0

	lw $a0, 8($sp)
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
exitP:  
	li $v0, 1
	jr $ra
################################################################################
Taylor_lnR: 
	bgt $a1, $a2, exitT
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)

	li $a0, -1
	addi $a1, $a1, 1
	jal powerR

	addi $sp, $sp, -4
	sw $v0, 0($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	jal powerR

	lw $a0, 0($sp)
	div $v0, $a1
	mflo $v0
	mul $v0, $v0, $a0
	sw $v0, 0($sp)

	lw $a0, 8($sp)
	lw $a1, 12($sp)
	addi $a1, $a1, 1
	jal Taylor_lnR
	lw $a0, 0($sp)
	add $v0, $v0, $a0
	
	lw $ra, 4($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	addi $sp, $sp, 16
	jr $ra	
exitT:
	li $v0, 0
	jr $ra
################################################################################
Taylor_lnRecursive:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)

	addi $a0, $a0, -1
	move $a2, $a1
	li $a1, 1
	jal Taylor_lnR

	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
################################################################################
Taylor_ln:
	li $t0, 1
	li $s0, 0
	addi $a0, $a0, -1
	move $t1, $a1
	
Loop:	bgt $t0, $t1, exitLoop
	
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $s0, 12($sp)
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	
	li $a0, -1
	addi $a1, $t0, 1
	jal powerR

	sw $v0, 24($sp)

	lw $a0, 4($sp)
	lw $a1, 16($sp)
	jal powerR

	lw $a1, 16($sp)
	div $v0, $a1
	mflo $v0
	lw $a0, 24($sp)
	mul $v0, $v0, $a0
	lw $s0, 12($sp)
	add $s0, $s0, $v0

	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $t0, 16($sp)
	lw $t1, 20($sp)
	addi $sp, $sp, 28

	addi $t0, $t0, 1
	j Loop

exitLoop:
	move $v0, $s0
	jr $ra
	
	

	
	







