#################################################################################
#
#	Blair Munro
#	blairmunro89@gmail.com
#	Devan Haynes
#	dhaynes12@alaska.edu
#	CSCE 248, Homework #2
#	
#	Due Mar. 2, 2018
#
#	PURPOSE: 	The purpose of this program is to
#			read itself instruction by instruction,
#			starting from 'main'. Each instruction
#			is counted as either I-type, J-type, or
#			R-type. The final tally is printed at
#			program end.
#
#	ALGORITHM:	int main( void ) {
#
#				char *pointer = address of 'main';
#				
#				int i = 0;
#				int j = 0;
#				int r = 0;
#				int s = 0;
#
#				do {
#
#				char temp1 = pointer;
#				
#				temp1 = shiftrightlogical( temp1, 26 places );
#
#					if ( temp1 == 0 )
#
#						r++;
#
#					elseif ( (temp == 2) || (temp == 3) )
#
#						j++;
#
#					else
#
#						i++;
#
#
#					end
#
#				pointer = pointer + 4;
#
# 				if( temp1 == 12 ){
#					s++
#				}
#
#				if( s > 7 )  { break; }
#
#				while( 1 )
#			}
#
#	INPUTS:		The only input for this program is
#			the program itself.
#		
#	OUTPUTS:	The outputs for this program are three
#			variables 'I', 'J', and 'R'. 'I' is
#			the I-type instruction count, 'J' is the
#			J-type instruction count, and 'R' is the
#			R-type instruction count.
#
####################################################################################
							#
		.data					#
thisProgram:	.asciiz	"This program contains:\n"	#
Iinst:		.asciiz	" I-type instructions\n"	#
Jinst:		.asciiz	"  J-type instructions\n"	#
Rinst:		.asciiz	" R-type instructions\n"	#
							#
		.text					#
main:							# int mainInCode;
		la	$s0, main			# char* pointer = &mainInCode;
		sub	$s1, $s1, $s1			# int i = 0;
		sub	$s2, $s2, $s2			# int j = 0;
		sub	$s3, $s3, $s3			# int r = 0;
		sub	$s4, $s4, $s4			# int s = 0;
							#
loop:							# do {
		lw	$t0, 0($s0)			# char temp1 = *pointer;
							#
		srl	$t1, $t0, 26			# temp1 >>= 26;
							#
		beq	$t1, $zero, incR		# if ( temp1 == 0 )
		beq	$t1, 2, incJ			# else if ( (temp1 == 2) 
		beq	$t1, 3, incJ			#	|| (temp1 == 3) )
							#
incI:							#
		addi	$s1, $s1, 1			#	{ i++; }
		j	exitcheck			#
							#
incJ:							#
		addi	$s2, $s2, 1			#	{ j++; }
		j	exitcheck			#
							#
incR:							#
		addi	$s3, $s3, 1			#	{ r++; }
		j	exitcheck			#
							#
exitcheck:						# 
		addi	$s0, $s0, 4			# 	pointer = pointer + 4;
		beq	$t0, 12, syscallCount		# 	if( temp1 == 12 )
		j	loop				#
							#
syscallCount:						#
		addi	$s4, $s4, 1			# 	s++;
		bgt 	$s4, 7, exit			# 	if( s > 7 )  { break; }
		j	loop				# }while( 1 )
							#
exit:							#
		li	$v0, 4				#   	
		la	$a0, thisProgram		# 
		syscall 				# cout << "This program contains:" << endl;
							#
		li	$v0, 1				#   	
		move	$a0, $s1			# 
		syscall 				# cout << i
		li	$v0, 4				#   	
		la	$a0, Iinst			#     
		syscall					# << "I-type instructions" << endl;
							#
		li	$v0, 1				#   
		move	$a0, $s2			#    
		syscall 				# cout << j
		li	$v0, 4				#   
		la	$a0, Jinst			#    
		syscall					# << "J-type instructions" << endl;
							#
		li	$v0, 1				#   
		move	$a0, $s3			#     
		syscall 				# cout << r
		li	$v0, 4				#   	
		la	$a0, Rinst			#  
		syscall					# << "R-type instructions" << endl;
							#
		li	$v0, 10				#
		syscall					# return 0;
