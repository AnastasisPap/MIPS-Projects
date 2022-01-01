#	Computer Systems Organization
#	Winter Semester 2021-2022
#	2nd Assignment
#
# 	Pseudocode by MARIA TOGANTZH (mst@aueb.gr)
#
# 	MIPS Code by Anastasios Papapanagiotou, p3200143@aueb.gr, 3200143 
# 	(Please note your name, e-mail and student id number)	

# Exercise: Write code in MIPS32 that reads from the user a string 
# with a max length of 128 characters. 
# The input consists only of lowercase characters.

# Objective: Convert the first characters of each word to uppercase

# Example Input: "in a hole in the ground lived a hobbit"
# Example Output: "In A hole In The Ground Lived A Hobbit" 


.text
.globl main
main:
    
    la $a0, str
	li $v0, 8	# str = read_string()
	syscall

		
	la $t2, str	
    
    lb $t0, ($t2)

    
    addi $t0, $t0, -32 # capitalize first char of strin

	sb $t0, ($t2) # store in his place 1st char


loop:
    addi $t2, $t2, 1
    lb $t0, ($t2) # load current char
	beqz $t0,exit	# if char is \0 go to exit
	beq $t0,32, space	# if char is ' ' go to space
    j loop

space:
    addi $t2, $t2, 1	# found space, so make capitalize next char
    
	lb $t0, ($t2)	# load next char

	addi $t0, $t0, -32	# capitalize next char

	sb $t0, ($t2)	# store is his place next char

	j loop	# go to next char

		
exit:	
    la $a0, str	# print (str)
    li $v0, 4
    syscall
		# exit 
    li $v0, 10
    syscall		
		
    .data

str: .space 128
