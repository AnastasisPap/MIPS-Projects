# Computer Systems Organization
# Winter Semester 2021-2022
# 1st Assignment
# MIPS Code by Anastasios Papapanagiotou, p3200143@aueb.gr, 3200143


    .text
    .globl main

main:
    li $t0, 4
    li $t1, 0
loop:
# Read character until counter is 0 and then go to exit loop
    beqz $t0, exit_loop
# Read char, id = 12
    li $v0, 12
    syscall


# If val < 0 then not hex
    bltu $v0,'0',exit_on_error
# if val >= 0 and val > 9 then check if it's a letter
    bgtu $v0,'9',second_condition
# if between 0 and 9 then it's Hex
    j isHex

# if it's not between 0 and 9 check if letter
second_condition:
# if val < 'A' and val > 9 then not hex
    bltu $v0,'A',exit_on_error
# if val > 'F' then not hex
    bgtu $v0,'F',exit_on_error
# If between A and F then it's hex
    j isHex



isHex:
# Shift left by 8 bits
    sll $t1,$t1,8
# Pack this character to $t1
    or $t1,$v0,$t1
# Decrease counter by 1
    sub $t0, $t0, 1
# Go back to loop
    j loop

# Executed when first loop is done (all 4 characters are read)
exit_loop:
    # Print new line
    la $a0, CRLF
    li $v0, 4
    syscall

    # Result = 0
    li $t3,0
    # Counter = 4
    li $t0,4
    # power = 1
    li $t4,1
    # s1 = 255 (mask)
    li $s1,255
loop2:
    # while counter is not 0 when done go to exit_loop2
    beqz $t0,exit_loop2

    # unpack the character using the mask 1111 1111
    and $t2,$t1,$s1
    # shift right the characters so the next can be unpacked
    srl $t1,$t1,8

    # if not a letter go to being a number. This character is 100% a hex character so else means it's a number
    bltu $t2,'A',isNumber
    bgtu $t2,'F',isNumber
    # current char is a letter so subtract with 55
    sub $t2,$t2,55
    # contiune to the rest of the program in the loop
    j afterSub

# It's a number
isNumber:
    # subtract current character with 48
    sub $t2,$t2,48
    # continue to the rest of the program in the loop
    j afterSub

# When we get the decimal number continue
afterSub:
    # Multiply the decimal representation with the 16^(position) = power
    mul $t2,$t2,$t4
    # Multiply the power with 16
    mul $t4,$t4,16
    # Decrease the counter
    sub $t0,$t0,1
    # Add the current decimal to the result
    add $t3,$t3,$t2

    # Go back to loop
    j loop2
    
# When we get the result
exit_loop2:
    # Print the result
    move $a0,$t3
    li $v0,1
    syscall
    # Exit
    j exit

# Goes here when not a hex number
exit_on_error:
    # Print new line
    la $a0, CRLF
    li $v0, 4
    syscall
    
    # Prints error prompt
    la $a0, error
    li $v0, 4
    syscall
    # Exit
    j exit

# Exit the program
exit:
    li $v0, 10
    syscall

    .data

error: .asciiz "Wrong Hex number..."
CRLF: .asciiz "\n"