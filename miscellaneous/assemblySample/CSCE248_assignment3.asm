#################################################################################
#
#	Blair Munro
#	bsmunro@gmail.com
#	Devan Haynes
#	dhaynes12@alaska.edu
#	Programming Assignment 3
#	March 28, 2018
#
#	PURPOSE:	This program sorts an arbitrary array of integers
#			from least to greatest order.
#
#	ALGORITHM:
#
#	int main()
#	{
#   		int array[] = {4, 5, 1, 354, 21, 45, 3};
#   	
#		selectionSort(array, 7);
#   		
#		for (int i = 0; i < 7; i++)
#			cout << array[i] << endl;
#
#		return 0;
#	}
#
#	INPUTS:		This program takes in a hardcoded array of integers 'array'.
#			It also takes an integer number representing the size of 'array'.
#		
#	OUTPUTS:	This program prints the sorted array 'array' to the terminal.
#
#
####################################################################################
							#
	.data						#
array:	.word 4, 5, 1, 354, 21, 45, 3			#
space:	.asciiz " "					#
							#
	.text						#
main:							# int main(){
	la	$a0, array				# int array[] = {4, 5, 1, 354, 21, 45, 3};
	addi	$a1, $zero, 6				#
	jal	selection				# selectionSort(array, 7);
							#
	sub	$t0, $t0, $t0				# for (int i = 0; i < 7; i++)
	add	$t1, $a0, $zero				# 	cout << a[i] << endl;
	printloopmain:					#
	li	$v0, 1					#
	lw	$a0, 0($t1)				#
	syscall						#
	li	$v0, 4					#
	la	$a0, space				#
	syscall 					#
	addi	$t1, $t1, 4				#
	addi	$t0, $t0, 1				#
	bgt	$t0, $a1, exit				#
	j	printloopmain				#
							#
exit:							# return 0;
	li	$v0, 10					#
	syscall						# }
							#
#################################################################################
#
#	Blair Munro
#	Devan Haynes
#	Programming Assignment 3
#	Subroutine 1
#
#	PURPOSE:	This subroutine selects integers two at a time,
#			and sorts the integers according to size.
#
#	ALGORITHM:
#
#	void selectionSort(int array[], int n)
#	{
#   		for (int i = 0; i < n-1; i++)
#		{
#       	int indexOfMin = i;
#       	for (int j = i+1; j < n; j++)
#       		{
#       	     	if (array[j] < a[indexOfMin])
#       	     	indexOfMin = j;
#        	 	}
#       	swap(array[i], array[indexOfMin]);
#		}
#	}
#
#
#	INPUTS:		Integer array address, and size of array.
#		
#	OUTPUTS:	No output, void function.
#
#
####################################################################################
							#
selection:						# void selectionSort(int array[], int n){
	addi	$sp, $sp, -4				#
	sw	$fp, 0($sp)				#
	addi	$fp, $sp, 0				#
	addi	$sp, $sp, -12				#
	sw	$ra, -4($fp)				#
	sw	$a0, -8($fp)				#
	sw	$a1, -12($fp)				#
							#
	add	$s0, $a0, $zero				#
	sll	$s1, $a1, 2				#
							# for
	sub	$s3, $s3, $s3				# int i = 0
	subi	$s2, $s1, 4				# i < n-1
							#
loop1:							# for
	addi	$t3, $s3, 4				# j = i+1
	add	$t0, $s0, $s3				# array[indexOfMin]
							#
loop2:							#
	add 	$t4, $s0, $t3				# array[j]
							#
	lw 	$t5, 0($t0)				#
	lw 	$t6, 0($t4)				#
	bge	$t6, $t5, branchif			# if (array[j] < a[indexOfMin]
	add	$t0, $t4, $zero				#
	branchif:					#
	bge 	$t3, $s1, out2				# j >= n, break loop
	addi	$t3, $t3, 4				# j++
	j	loop2					#
	out2:						# end for
	add 	$a0, $s0, $s3				# Array at i
	add	$a1, $t0, $zero				#
	jal	swap					# swap(array[i], array[indexOfMin]);
							#
	bge	$s3, $s2, out1				#
	addi	$s3, $s3, 4				# i++
	j	loop1					#
	out1:						# end for
							#
	lw	$a1, -12($fp)				#
	lw	$a0, -8($fp)				#
	lw	$ra, -4($fp)				#
	lw	$fp, 0($fp)				#
	addi	$sp, $sp, 16				#
	jr	$ra					# }
							#
#################################################################################
#
#	Blair Munro
#	Devan Haynes
#	Programming Assignment 3
#	Subroutine 2
#
#	PURPOSE:	This program swaps the position of two integers.
#
#	ALGORITHM:
#
#	void swap(int &a, int &b)
#	{
#		int temp = a;
#		a = b;
#		b = temp;
#	}
#
#
#	INPUTS:		Addresses of integers one and two.
#		
#	OUTPUTS:	No output, void function.
#
#
####################################################################################
							#
swap:							# void swap(int &a, int &b){
	addi	$sp, $sp, -4				#
	sw	$fp, 0($sp)				#
	addi	$fp, $sp, 0				#
	addi	$sp, $sp, -8				#
	sw	$a0, -4($fp)				#
	sw	$a1, -8($fp)				#
							#
	add	$t0, $zero, $a0				#
	add	$t1, $zero, $a1				# int temp = a;
	lw	$t2, 0($t0)				# 
	lw	$t3, 0($t1)				# a = b;
	sw	$t2, 0($t1)				#
	sw	$t3, 0($t0)				# b = temp;
							#
	lw 	$a1, -8($fp)				#
	lw	$a0, -4($fp)				#
	lw	$fp, 0($fp)				#
	addi	$sp, $sp, 12				#
	jr	$ra					# }
							#
####################################################################################