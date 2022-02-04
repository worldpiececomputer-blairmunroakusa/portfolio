#################################################################################
#
#	Blair Munro
#	bsmunro@gmail.com
#	Devan Haynes
#	dhaynes12@alaska.edu
#	Programming Assignment 4
#	April 27, 2018
#
#	PURPOSE:	This program is a calculator for base 10 integer polynomials
#			of the form
#
#				C10*X^10 + C9*X^9 + ... + C1*X + C0 = result(X) .
#
#					where 'coefficients' are {C10,C9,...,C1,C0}
#					and 'degree' is highest power
#
#			Polynomials may be of any degree between 0 and 10. For each
#			term, an arbitrary integer must be specified for the coefficient.
#			After specifying coefficients, an x value is specified and the
#			result is computed, then stored to memory. Before evaluating a
#			new polynomial, all coeffients are reset to zero.
#
#	ALGORITHM:
#
#	int getDegree( void );
#	void getCoefficients(int ary[]);
#	void evaluatePolynomial(int ary[], const int &size);
#	void resetCoefficients(int ary[], int &size);
#
#	int main()
#	{
#		int ary[10] = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
#		int degree = 0;
#		int yesno = 1;
#
#		do
#		{
#			degree = getDegree( );
#
#			getCoefficients( ary[], &degree );
#
#			evaluatePolynomial( ary[], &degree );
#
#			resetCoefficients( ary[], &degree );
#
#			cout <<
#			"Would you like to evaluate a new polynomial? \n(1 for 'yes', 0 for 'no'):\n";
#			cin >> yesno;
#		}
#		while ( yesno );
#
#		return 0;
#	}
#
#	INPUTS:		This program takes in three user inputs. First is an integer
#			that represents the degree of the polynomial. Second is an
#			array of integers that represent the coefficients of the
#			polynomial. Last is an integer that represents the x value
#			of the polynomial. Additional inputs of 1 or 0 act as control
#			throughout the program, 1 for 'yes' and 0 for 'no'.
#		
#	OUTPUTS:	This program prints out for the user, the computed value for
#			the polynomial, given degree, coefficients, and x value. The
#			program saves the polynomial to memory.
#
####################################################################################
	.data						#
coeff:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
polyResult:	.word 0
enterDegree:	.asciiz "Please enter the degree of the polynomial (0-10):\n"
notValid:	.asciiz "Not a valid degree\n"
enterCoeff:	.asciiz "Please enter the coefficient for degree "
colon:		.asciiz ":\n"
intBuffer:	.asciiz "    "
enterX:		.asciiz "Please enter a value for x:\n"
newX:		.asciiz "\nWould you like to evaluate the polynomial with another value? \n
			 (1 for 'yes', 0 for 'no'):\n"
newPoly:	.asciiz "Would you like to evaluate a new polynomial? \n(1 for 'yes', 0 for 'no'):\n"
resultIs:	.asciiz "The result is: "
bye:		.asciiz "Goodbye. Have a lovely day."
	.text						#
main:							#				
	la	$a0, coeff				# int ary[10] = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
	sub	$a1, $a1, $a1				# int degree = 0,
	sub	$a2, $a2, $a2				# int yesno = 1;
							# do {
	jal	getDegree				#
	add	$a1, $v0, $zero				# degree = getDegree( );
	jal	getCoefficients				# getCoefficients( ary[], &degree );
	jal	evaluatePolynomial			# evaluatePolynomial( ary[], &degree );
	jal	resetCoefficients			# resetCoefficients( ary[], &degree );
		li	$v0, 4				#
		la	$a0, newPoly			# cout <<
		syscall					# "Would you like to evaluate a new polynomial?\n
		li	$v0, 5				# (1 for 'yes', 0 for 'no')"
		la	$a0, intBuffer			#
		li	$a1, 10				#
		syscall					#
	add	$a2, $v0, $zero				# cin >> yesno;
							# }
	beq	$a2, 1, main				# while ( yesno );
exit:							#
	li	$v0, 4					#
	la	$a0, bye				#
	syscall						# return 0;
	li	$v0, 10					#
	syscall						# }
							#
#################################################################################
#
#	Blair Munro
#	Devan Haynes
#	Programming Assignment 4
#	Subroutine 1, getDegree
#
#	PURPOSE:	This subroutine prompts the user to enter the polynomial degree
#			then returns this value to main as an integer. Integers outside
#			the range of 0-10 prompt an error message and the user must try
#			again.
#			
#	ALGORITHM:
#
#	int getDegree()
#	{
#	do
#	{
#		cout << "Please enter the degree of the polynomial (0-10): ";
#		cin >> num;
#
#		if (num < 0 || num > 10)
#		{
#			cout << "Not a valid degree" << endl;
#		}
#	} while (num < 0 || num > 10);
#	return;
#
#	}
#
#	INPUTS:		The input for this subroutine is a user-input integer between
#			0 and 10. Integers outside this range, or non-integer inputs
#			are not accepted.
#		
#	OUTPUTS:	The output for this subroutine is an integer back to main. This
#			integer is the degree of the polynomial to be evaluated.
#
####################################################################################
							#
getDegree:						# int getDegree( void )
	addi	$sp, $sp, -4				#
	sw	$fp, 0($sp)				#
	addi	$fp, $sp, 0				#
	addi	$sp, $sp, -8				#
	sw	$a0, -4($fp)				#
	sw	$a1, -8($fp)				#
degreeLoop:						# do {
	li	$v0, 4					#
	la	$a0, enterDegree			# cout << "Please enter the degree of 
	syscall						#	   the polynomial (0-10): ";
	li	$v0, 5					#
	la	$a0, intBuffer				# cin >> num;
	li	$a1, 10					#
	syscall						#
	blt	$v0, 0, degreeError			# if (num < 0 || num > 10)		
	bgt	$v0, 10, degreeError			# cout << "Not a valid degree" << endl;
	j	degreeLoopExit				# } while (num < 0 || num > 10);
degreeError:						#
	li	$v0, 4					#
	la	$a0, notValid				#
	syscall						#
	j	degreeLoop				#
degreeLoopExit:						#
	lw 	$a1, -8($fp)				# return;
	lw	$a0, -4($fp)				#
	lw	$fp, 0($fp)				#
	addi	$sp, $sp, 12				#
	jr	$ra					# }
							#
#################################################################################
#
#	Blair Munro
#	Devan Haynes
#	Programming Assignment 4
#	Subroutine 2, getCoefficients
#
#	PURPOSE:	This subroutine retrieves the necessary polynomial coefficients from
#			the user. The number of coefficients retrieved is degree + 1.
#
#	ALGORITHM:
#
#	void getCoefficients()
#	{
#	for (int i = 0; i <= size; i++)
#	{
#		cout << "Please enter the coefficient for degree " << i << ": ";
#		cin >> ary[i];
#	}
#	return;
#
#	}
#
#	INPUTS:		This subroutine requires an array pointer to the coefficient array,
#			as well as the address for the degree of the polynomial. The subroutine
#			takes input directly from the user after prompting accordingly.
#		
#	OUTPUTS:	This subroutine populates the coefficient array with all the integer
#			coefficients needed to evaluate the polynomial. This is a void
#			subroutine, so no values are passed directly back to main.
#
####################################################################################
							#
getCoefficients:					# void getCoefficients(  )
	addi	$sp, $sp, -4				#
	sw	$fp, 0($sp)				#
	addi	$fp, $sp, 0				#
	addi	$sp, $sp, -8				#
	sw	$a0, -4($fp)				#
	sw	$a1, -8($fp)				#
							#
	sub	$t0, $t0, $t0				#
	add	$t1, $a0, $zero				#
	add	$t2, $a1, $zero				#
coeffLoop:						# for (int i = 0; i <= size; i++)
		li	$v0, 4				#
		la	$a0, enterCoeff			#
		syscall					#
		li	$v0, 1				#
		la	$a0, ($t0)			#
		syscall					# 
		li	$v0, 4				#
		la	$a0, colon			# cout << "Please enter the coefficient
		syscall					#	   for degree " << i << ": ";
		li	$v0, 5				#
		la	$a0, intBuffer			#
		li	$a1, 10				#
		syscall					# 
	sw	$v0, 0($t1)				# cin >> ary[i];
	beq	$t0, $t2, exitCoeffLoop			#
	addi	$t0, $t0, 1				#
	addi	$t1, $t1, 4				#
	j	coeffLoop				#
exitCoeffLoop:						# return;
	lw 	$a1, -8($fp)				#
	lw	$a0, -4($fp)				#
	lw	$fp, 0($fp)				#
	addi	$sp, $sp, 12				#
	jr	$ra					# }
							#
#################################################################################
#
#	Blair Munro
#	Devan Haynes
#	Programming Assignment 4
#	Subroutine 3, evaluatePolynomial
#
#	PURPOSE:	This subroutine evaluates the polynomial for given coefficient
#			values and a user input value for x. The result is printed to
#			the terminal, and saved into memory. After evaluating the polynomial
#			for a given x, the user is given the opportunity to evaluate the
#			polynomial for a different x value.
#
#	ALGORITHM:
#
#	void evaluatePolynomial()
#	{
#	bool exit = false;
#	do
#	{
#		int x = 0;
#		int result = 0;
#		cout << "Please enter a value for x: ";
#		cin >> x;
#
#		for (int i = 0; i <= size; i++)
#		{
#			result += pow(x,i)*ary[i]; 
#		}
#		cout << "The result is: " << result << endl;
#		cout << "Would you like to evaulate the polynomial with another value?
#			 (1 for yes, 0 for no): ";
#		char exit;
#		cin >> exit;
#		} while (exit);
#	return;
#
#	}
#
#	INPUTS:		This subroutine requires an array pointer to the coefficient array,
#			as well as the the degree of the polynomial. The routine also
#			prompts the user to enter a value for x from the keyboard.
#		
#	OUTPUTS:	This subroutine prints the polynomial result, and saves the
#			result to memory, variable named polyResult.
#
####################################################################################					
							#
evaluatePolynomial:					# void evaluatePolynomial(  )
	addi	$sp, $sp, -4				#
	sw	$fp, 0($sp)				#
	addi	$fp, $sp, 0				#
	addi	$sp, $sp, -8				#
	sw	$a0, -4($fp)				#
	sw	$a1, -8($fp)				#
							#
	add	$t6, $a1, $zero				#
	add	$t7, $a0, $zero				#
evaluateLargeLoop:					#
		li	$v0, 4				# int x = 0;
		la	$a0, enterX			#
		syscall					# cout << "Please enter a value for x: ";
		li	$v0, 5				#
		la	$a0, intBuffer			#
		li	$a1, 10				# 
		syscall					# cin >> x;
	add	$t4, $v0, $zero				# t6 is degree
	add	$t0, $zero, $zero			# Result
	add	$t1, $t6, $zero				# i = degree
	add	$t2, $t7, $zero				# address pointer
	mul  	$t3, $t1, 4				#
	add	$t2, $t2, $t3				#
evaluateSmallLoop:					#
		addi	$t9, $zero, 1			#
		add	$t5, $t1, $zero			# for (int i = 0; i <= size; i++)
	evaluatePowerLoop:				# {
		beq	$t1, $zero, exitPowerLoop	#
		mul	$t9, $t9, $t4			# result += pow(x,i)*ary[i]; 
		subi	$t5, $t5, 1			#
		beq	$t5, $zero, exitPowerLoop	# }
		j	evaluatePowerLoop		#
	exitPowerLoop:					#
		lw	$t3, 0($t2)			#
		mul	$t3, $t3, $t9			#
		add	$t0, $t3, $t0			#
		sub	$t1, $t1, 1			#
		sub	$t2, $t2, 4			#
	beq	$t1, -1, exitSmallLoop			#
	j	evaluateSmallLoop			#
exitSmallLoop:						#
	sw	$t0, polyResult				#
		li	$v0, 4				#
		la	$a0, resultIs			#
		syscall					# cout << "The result is: " 
		li	$v0, 1				#	<< result << endl;
		la	$a0, ($t0)			#
		syscall					#
		la	$a0, newX			# cout << "Would you like to evaulate the polynomial
		li	$v0, 4				# with another value? (y for yes, else for no):"
		syscall					#
		li	$v0, 5				#
		la	$a0, intBuffer			#
		li	$a1, 10				#
		syscall					# cin >> exit;
	add	$a0, $v0, $zero				#
	bne	$a0, 1, exitLargeLoop			# if (exit)
	j	evaluateLargeLoop			# } while (exit);
exitLargeLoop:						# return;
	lw 	$a1, -8($fp)				#
	lw	$a0, -4($fp)				#
	lw	$fp, 0($fp)				#
	addi	$sp, $sp, 12				#
	jr	$ra					# }
							#
#################################################################################
#
#	Blair Munro
#	Devan Haynes
#	Programming Assignment 4
#	Subroutine 4, resetCoefficients
#
#	PURPOSE:	This subroutine resets the polynomial coefficients to zero
#			before evaluating a new polynomial.
#
#	ALGORITHM:
#
#	void resetCoefficients()
#	{
#	for (int i = 0; i <= size; i++) 
#	{
#		ary[i] = 0;
#		i++;
#	}
#	}
#
#	INPUTS:		An array pointer to the coeffients is the only input for
#			this subroutine.
#		
#	OUTPUTS:	Although there is no direct output to main (this is a void
#			subroutine), the subroutine sets all integers located at the
#			address for the coefficient array to integer zeros.
#
####################################################################################
							#
resetCoefficients:					# void resetCoefficients( ary[], degree )
	sub	$t0, $t0, $t0				#
	add	$t1, $a0, $zero				#
resetLoop:						# for (int i = 0; i <= size; i++)
	sw	$zero, 0($t1)				# 	ary[i] = 0;
	addi	$t1, $t1, 4				#
	addi	$t0, $t0, 1				# 	i++;
	bgt	$t0, 10, resetLoopExit			# }
	j	resetLoop				#
resetLoopExit:						# return;
	jr	$ra					# }
	nop						#
	nop						#
	nop						#
	nop						#
	#nom nom nom nom (for nop-flex' sake)	
