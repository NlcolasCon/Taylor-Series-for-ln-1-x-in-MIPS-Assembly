################################################################################
#Program Name		: HW1 EPL221
#Programmer		: Nicolas Constantinou	ID:1135533
#Date Last Modif.	: 21 Sep 2024
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
	li.s $f12, 0.0		#set i to 0.0
	li $a1, 100		#set n to 100
	li.s $f10, 2.0		#set loop until 2.0

L:	c.le.s $f12, $f10	#if i<=2.0 set FCSR flag to 1
	bc1f exit		#brach to exit if FCSR flag is 0		
	addi $sp, $sp, -8	#make space on stack
	swc1 $f12, 0($sp)	#store i on stack
	sw $a1, 4($sp)		#store n on stack

	jal Taylor_ln		#call Taylor_ln
	addi $sp, $sp, -4
	swc1 $f0, 0($sp)		#store return value on stack
				
	la $a0, msg1		#load string "terms[ and print on screen
	li $v0, 4		
	syscall			
	
	lw $a0, 8($sp)		#load n from stack on print on screen
	li $v0, 1		
	syscall 		
			
	la $a0, msg2		#load string ] : ln( and print on screen
	li $v0, 4		
	syscall			

	lwc1 $f12, 4($sp)	#load i from stack and print on screen
	li $v0, 2		
	syscall 		
				
	la $a0, msg3		#load string )= and print on screen
	li $v0, 4		
	syscall			

	lwc1 $f12, 0($sp)	#load Taylor_ln(i, n) from stack and print on screen
	li $v0, 2		
	syscall 		
			
	la $a0, newLine		#load and print new line on screen
	li $v0, 4		
	syscall	

	lwc1 $f12, 4($sp)	#load i from stack
	lw $a1, 8($sp)		#load n from stack
			
	jal Taylor_lnRecursive	#call Taylor_lnRecursive
	swc1 $f0, 0($sp)	#store return value on stack

	la $a0, msg1		#load string "terms[ and print on screen
	li $v0, 4		
	syscall			
	
	lw $a0, 8($sp)		#load n from stack on print on screen
	li $v0, 1		
	syscall 		
			
	la $a0, msg4		#load string ]R: ln( and print on screen
	li $v0, 4		
	syscall			

	lwc1 $f12, 4($sp)	#load i from stack and print on screen
	li $v0, 2		
	syscall 		
				
	la $a0, msg3		#load string )= and print on screen
	li $v0, 4		
	syscall			

	lwc1 $f12, 0($sp)	#load and print Taylor_lnRecursive(i, n) from stack
	li $v0, 2		
	syscall 		
			
	la $a0, newLine		#load and print new line on screen
	li $v0, 4		
	syscall				

	lwc1 $f12, 4($sp)	#load i from stack
	lw $a1, 8($sp)		#load n from stack
	lwc1 $f0, 0($sp)		#load return value frome stack
	addi $sp, $sp, 12	#free space on stack

	li.s $f9, 0.1
	add.s $f12, $f12, $f9	#incremeant i by 0.1
	j L			#redo the loop

exit:	li $v0, 10		#end program	
	syscall			

#################################################################################
powerR: 
	beq $a1, $0, exitP	#if n==o return 1.0
	addi $sp, $sp, -12	#make space on stack
	sw $ra, 0($sp)		#store return add in stack
	sw $a1, 4($sp)		#store n in stack
	swc1 $f12, 8($sp)	#store x in stack

	addi $a1, $a1, -1	#decrement n by 1
	jal powerR		#recursive call
	lwc1 $f12, 8($sp)	#load back saved x
	mul.s $f0, $f0, $f12	#multiply return value with x

	lw $ra, 0($sp)		#load return add from stack
	lw $a1, 4($sp)		#load n from stack
	addi $sp, $sp, 12	#restore stack pointer
	jr $ra			#return to caller
exitP:  
	li.s $f0, 1.0		#load 1.0 to return value
	jr $ra			#return to caller
################################################################################
Taylor_lnR: 
	bgt $a1, $a2, exitT	#if i>n return 0.0
	addi $sp, $sp, -20	#make space on stack
	sw $ra, 0($sp)		#store return add on stack
	swc1 $f12, 4($sp)	#store x on stack
	sw $a1, 8($sp)		#store i on stack
	sw $a2, 12($sp)		#store n on stack

	li.s $f12, -1.0		#arg 0 set to -1.0 for powerR
	addi $a1, $a1, 1	#arg 1 set to i+1 for powerR
	jal powerR		#call powerR

	swc1 $f0, 16($sp)	#store return value in stack
	lwc1 $f12, 4($sp)	#load x from stack
	lw $a1, 8($sp)		#load i from stack
	jal powerR		#call powerR with these parameters

	lwc1 $f6, 16($sp)	#load powerR(-1, i+1) result from stack
	lw $a1, 8($sp)		#load i from stack
	mtc1 $a1, $f13		#move int i to $f13
	cvt.s.w $f13, $f13	#convert i to float single precision
	div.s $f0, $f0, $f13	#divide power(x, i)/i in $f0
	mul.s $f0, $f0, $f6	#multiply the above with powerR(-1, i+1)
	swc1 $f0, 16($sp)	#store result on stack

	lwc1 $f12, 4($sp)	#load x from stack
	lw $a1, 8($sp)		#load i from stack
	addi $a1, $a1, 1	#increament i by 1
	lw $a2, 12($sp)		#load n from stack
	jal Taylor_lnR		#recursive call
	lwc1 $f6, 16($sp)	#load the previous result in $f12
	add.s $f0, $f0, $f6	#add resutls to $f0
			
	lw $ra, 0($sp)		#load return add from stack
	lwc1 $f12, 4($sp)	#load x from stack
	lw $a1, 8($sp)		#load i from stack
	lw $a2, 12($sp)		#load n from stack
	addi $sp, $sp, 20	#free space from stack
	jr $ra			#return to caller
exitT:
	li.s $f0, 0.0		#load 0.0 on $f0.0
	jr $ra			#return to caller
################################################################################
Taylor_lnRecursive:
	addi $sp, $sp, -12	#make space on stack
	sw $ra, 0($sp)		#store return add on stack
	swc1 $f12, 4($sp)	#store x on stack
	sw $a1, 8($sp)		#store n on stack

	li.s $f6, -1.0
	add.s $f12, $f12, $f6	#arg0 is x-1
	move $a2, $a1		#arg2 is n
	li $a1, 1		#arg1 is 1
	jal Taylor_lnR		#call Taylor_lnR

	lw $ra, 0($sp)		#load return ad from stack
	lwc1 $f12, 4($sp)	#load x from stack
	lw $a1, 8($sp)		#load n from stack
	addi $sp, $sp, 12	#free space from stack
	jr $ra			#return to caller
################################################################################
Taylor_ln:
	li $t0, 1		#initialize i to 1
	li.s $f20, 0.0		#initialize sum to 0.0

	li.s $f9, -1.0
	add.s $f12, $f12, $f9	#decremeant x by 1
	move $t1, $a1		#copy n to $t1
	
Loop:	bgt $t0, $t1, exitLoop	#if i>n then return sum to caller
	
	addi $sp, $sp, -28	#make space on stack
	sw $ra, 0($sp)		#store return add on stack
	swc1 $f12, 4($sp)	#store x on stack
	sw $a1, 8($sp)		#store n on stack
	swc1 $f20, 12($sp)	#store sum on stack
	sw $t0, 16($sp)		#store i on stack
	sw $t1, 20($sp)		#store n copy on stack
	
	li.s $f12, -1.0		#arg0 set to -1.0
	addi $a1, $t0, 1	#arg1 set to i+1
	jal powerR		#call powerR

	swc1 $f0, 24($sp)	#store return value on stack

	lwc1 $f12, 4($sp)	#arg0 set to x
	lw $a1, 16($sp)		#arg1 set to i
	jal powerR		#call powerR

	lw $a1, 16($sp)		#load i from stack 
	mtc1 $a1, $f13 		#move int i to $f13
	cvt.s.w $f13, $f13	#convert i to float single precision
	div.s $f0, $f0, $f13	#divide powerR(x, i)/i
	lwc1 $f12, 24($sp)	#load powerR(-1, i+1) from stack
	mul.s $f0, $f0, $f12	#multiply powerR(-1, i+1) and powerR(x, i)/i
	lwc1 $f20, 12($sp)	#load sum from stack
	add.s $f20, $f20, $f0	#add sum + (powerR(-1, i+1)*powerR(x, i)/i)
			
	lw $ra, 0($sp)		#load return add from stack
	lwc1 $f12, 4($sp)	#load x from stack
	lw $a1, 8($sp)		#load n from stack
	lw $t0, 16($sp)		#load i from stack
	lw $t1, 20($sp)		#load n copy from stack
	addi $sp, $sp, 28	#free space on stack

	addi $t0, $t0, 1	#incremeant i by 1	
	j Loop			#redo the loop

exitLoop:		
	mov.s $f0, $f20		#move sum to return register
	jr $ra			#return to caller
	