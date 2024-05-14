.data




.text
main:



					#################### Data Entry ####################

	
#lw 	$t0, 0($a1)		# Address of y(0)
#lw	$t1, 4($a1)		# Address of h
#lw	$t2, 8($a1)		# Address of n

#lb 	$t0, 0($t0)		# y(0)
#lb	$t1, 0($t1)		# h
#lb	$t2, 0($t2)		# n

#addi 	$a0, $t0, -48		
#addi 	$a1, $t1, -48		
#addi 	$a2, $t2, -48

addi 	$a0, $0, 1		# Address of y(0)
addi 	$a1, $0, 2		# Address of h
addi 	$a2, $0, 3		# Address of n

							

jal	euler_fn

lui	$t3, 0x1001
ori	$t3, $t3, 0x0000
sw	$v0, 0($t3)

j	END



############################################################################################################################################
euler_fn:

							
addi 	$sp , $sp , -24
sw	$ra , 20($sp)
sw	$s0 , 16($sp)
sw	$s1 , 12($sp)
sw	$s2 , 8($sp)
sw	$s3 , 4($sp)
sw	$s4 , 0($sp)

add 	$s0, $a0, $zero			# s0 = y(0)	
add 	$s1, $a1, $zero			# s1 = h		
add 	$s2, $a2, $zero			# s2 = n	




					#################### Initialising array X #####################

lui	$s3 , 0x1001
ori	$s3 , $s3 , 0x0060			# $s3 is the base of x  


add 	$t3 , $s3 , $0			# $t3  => base + offset
add 	$t1 , $0 , $0			# $t1 = 0 is a counter
add 	$t4 , $0 , $0			
sw  	$t1 , 0($t3) 	        	# X[0] = 0

Loop_x:

beq 	$t1 , $s2 , Exit_x

add 	$t4 , $s1 , $t4      		# $t4 += h

addi 	$t3 , $t3 , 4			# base + 4

sw  	$t4 , 0($t3)		

addi 	$t1 , $t1 , 1			# $t1 ++


j Loop_x

Exit_x:







#####################################################################################################################################

				     #################### Initialising array Y #####################

lui	$s4 , 0x1001
ori	$s4 , $s4 , 0x0100			# $s3 is the base of x  

  
add 	$t1 , $0 , $0			 	# $t1 = 0 is a counter

add 	$t4 , $s4 , $0		
add 	$t3 , $s3 , $0	
sw  	$s0 , 0($t4) 	       		 # Y[0] = y(0)


Loop_y:

beq 	$t1 , $s2 , Exit_y


#Y_n+1 = Y_n + h * f'(x,y)

lw	$a0  , 0($t4)			# $a0 = Y_n
lw	$a1  , 0($t3)			# $a1  = X_n
jal	Equation



						
addi 	$sp , $sp , -8
sw	$a0 , 4($sp)
sw	$a1 , 0($sp)



add 	$a0 , $v0 , $zero
add 	$a1 , $s1 , $zero
jal 	multiply 			# Y_n+1 = h * f'(x,y)

lw	$a1 , 0($sp)
lw	$a0 , 4($sp)
addi 	$sp , $sp , 8



add	$v0 , $v0 , $a0 		# Y_n+1 = Y_n + h * f'(x,y)



addi 	$t4  , $t4 , 4			# base + 4
addi 	$t3  , $t3 , 4			# base + 4

sw  	$v0 , 0($t4)


addi 	$t1  , $t1 , 1			# $t1 ++


j 	Loop_y

Exit_y:


lw	$s4 , 0($sp)
lw	$s3 , 4($sp)
lw	$s2 , 8($sp)
lw	$s1 , 12($sp)
lw	$s3 , 16($sp)
lw	$ra , 20($sp)
addi 	$sp , $sp , 24


jr 	$ra


#####################################################################################################################################
				#################### Calculate f'(X,Y)  #####################

Equation:
#f'(x,y) = - 1209x^3 + 95x^2 + 91x +190y^2 - 59y - 11

# $a1 = x
# $a0 = y

				#################### 95x^2   #####################

addi 	$sp , $sp , -12
sw	$ra , 8($sp)
sw	$a0 , 4($sp)
sw	$a1 , 0($sp)



add 	$a0 , $a1 , $zero
jal 	multiply
addi 	$a0, $zero, 95
add 	$a1, $0, $v0
jal 	multiply


lw	$a1 , 0($sp)
lw	$a0 , 4($sp)
lw	$ra , 8($sp)
addi 	$sp , $sp , 12

# $v0 = 95x^2
			

#####################################################################################################################################
				####################  91x   #####################


add	$t7,  $v0 , $zero	# $t7 will be final result


addi 	$sp , $sp , -12
sw	$ra , 8($sp)
sw	$a0 , 4($sp)
sw	$a1 , 0($sp)



addi 	$a0 , $zero , 91
jal 	multiply

lw	$a1 , 0($sp)
lw	$a0 , 4($sp)
lw	$ra , 8($sp)
addi 	$sp , $sp , 12


add	$t7,  $t7 , $v0	


#####################################################################################################################################

				####################  - 1209x^3   #####################



addi 	$sp , $sp , -12
sw	$ra , 8($sp)
sw	$a0 , 4($sp)
sw	$a1 , 0($sp)



add 	$a0 , $a1 ,  $zero
jal 	multiply
add 	$a0 , $v0 ,  $zero
jal 	multiply
add	$a0  , $v0 , $zero
addi	$a1  , $zero, -1209
jal 	multiply

lw	$a1 , 0($sp)
lw	$a0 , 4($sp)
lw	$ra , 8($sp)
addi 	$sp , $sp , 12

add	$t7 , $t7 , $v0


#####################################################################################################################################
				####################  190y^2   #####################
		
						
addi 	$sp , $sp , -12
sw	$ra , 8($sp)
sw	$a0 , 4($sp)
sw	$a1 , 0($sp)



add 	$a1 , $a0 ,  $zero
jal 	multiply

addi	$a0 , $zero  , 190
add	$a1 , $zero  , $v0
jal 	multiply

lw	$a1 , 0($sp)
lw	$a0 , 4($sp)
lw	$ra , 8($sp)
addi 	$sp , $sp , 12

add	$t7 , $t7 , $v0




#####################################################################################################################################
				#####################  - 59y   #####################
		
						
addi 	$sp , $sp , -12
sw	$ra , 8($sp)
sw	$a0 , 4($sp)
sw	$a1 , 0($sp)



addi 	$a1 , $0 ,  -59

jal 	multiply

lw	$a1 , 0($sp)
lw	$a0 , 4($sp)
lw	$ra , 8($sp)
addi 	$sp , $sp , 12

add	$t7 , $t7 , $v0



addi  	$v0  ,$t7 , -11




jr $ra

				


#####################################################################################################################################

				
multiply:


beq	$a0 , $0  , Zero
beq	$a1 , $0  , Zero

slt 	$t5 , $zero , $a0
slt 	$t6 , $zero , $a1
or	$v0 , $t5   , $t6		#$v0 = 1 => either one of them is positive. Else $v0 = 0

bne 	$v0 , $0  , mul_main_Loop2

# I made 2 main Labels (each has 2 loop) to get the closest number to zero. so  The program wouldn't take too much time
mul_main_Loop1:


slt 	$v0 , $a1 , $a0
bne	$v0 , $0    , mul_Loop1


add 	$v0 , $a0 , $zero
mul_Loop2:
addi 	$a1 , $a1 , 1
beq 	$a1 , $zero , mul_exit
add 	$v0 , $v0 , $a0 
j mul_Loop2


mul_Loop1:
add 	$v0 , $a1 , $zero
L:
addi 	$a0 , $a0 , 1
beq 	$a0 , $zero , mul_exit
add 	$v0 , $v0 , $a1 
j	L





mul_main_Loop2:

slt 	$v0 , $zero , $a0
bne	$v0 , $0    , mul_loop1




add 	$v0 , $a0 , $zero
mul_loop2:
addi 	$a1 , $a1 , -1
beq 	$a1 , $zero , mul_exit
add 	$v0 , $v0 , $a0 
j mul_loop2


mul_loop1:
add 	$v0 , $a1 , $zero
l:
addi 	$a0 , $a0 , -1
beq 	$a0 , $zero , mul_exit
add 	$v0 , $v0 , $a1 
j	l






mul_exit:
jr 	$ra
Zero: 
add	$v0 , $0  , $0
jr 	$ra

#####################################################################################################################################


END:
