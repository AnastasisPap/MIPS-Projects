#       Computer Systems Organization
#       Winter Semester 2021-2022
#       3rd Assignment
#
#       MIPS Code by:
#       Anastasios Papapanagiotou, p3200143@aueb.gr, 3200143
#-------------------------------------------------------------
#   Important Variables
#   s0 = head
#   s2 = newNode
#   s3 = prev
#   s4 = currNode
#   t1 = tempNode
#   t5 = option chose by the user
#-------------------------------------------------------------

    .text
    .globl main
# Main will run only once
# no parameters or return values
main:
    # Initialize head = NULL
    li $s0, 0
    # Initialize currNode = NULL
    li $s4, 0


# Prints the Menu and reads the user input
# no parameters or return values
optionsMenu:
    # Print the menu prompt
    la $a0, prompt
    jal printString

    # Read the user input
    jal readInteger
    move $t5, $v0

    # If the answer is not 1,2, or 3, show an error, otherwise call the appropriate function
    beq $t5, 1, insert
    beq $t5, 2, delete
    beq $t5, 3, printList
    beq $t5, 4, exit
    blt $t5, 1, errorInput
    bgt $t5, 4, errorInput


# Exit the program
# no parameters or return values
exit:
    li $v0, 10
    syscall


# Insert a node in a way that the linkedlist is always sorted
# no parameters or return values
insert:
    # allocate memory for the new node
    jal allocateMemory
    # save the address of the newnode
    move $s2, $v0

    # Print prompt
    la $a0, options1Prompt
    jal printString

    jal readInteger # Get user input
    sw $v0, ($s2)   # newNode.value = input
    sw $zero, 4($s2)    # newNode.next = None

    beqz $s0, initializeList    # if head = None then initialize the currNode and head
    li $s3, 0   # prev = None
    jal initializeCurrPtr   # initialize currNode to be equal to the head

    # Program continues to findPosition


# Finds the correct position to insert the newNode
# It will iterate until currNode.value >= newNode.value
# and then insert it using the previous if it's not the head
# otherwise make head = newNode
# no parameters or return values
findPosition:
    lw $a0, ($s4)       # a0 = currNode.value
    lw $a1, ($s2)       # a1 = newNode.value
    bge $a0, $a1, foundPosition     # if currNode.value >= newNode.value then insert here

    move $s3, $s4       # prev = currNode
    lw $s4, 4($s4)      # currNode = currNode.next


# check if currNode is None
# no parameters or return values
checkIfValid:
    bnez $s4, findPosition  # if currNode is not None then iterate again otherwise we have reached the end of the list


# insert node before the currNode and after the prev
# no parameters or return values
foundPosition:
    sw $s4, 4($s2)  # newNode.next = currNode
    beqz $s3, insertFront   # checks we want to insert a number smaller than the current min, so head = newNode
    sw $s2, 4($s3)  # prev.next = newNode

    j optionsMenu   # finished insertion, go back to the program


# initialize currNode
# no parameters or return values
# we need to initialize currNode every time the user wants to insert
# because sometimes the currNode will point to the end of the list or in the middle
# but when the insertion starts we want to point to the head
initializeCurrPtr:
    la $s4, ($s0)   # currNode = head
    
    jr $ra  # return to the program


# Will run when the list is empty
# no parameters or return values
initializeList:
    la $s0, ($s2)   # head = newNode
    move $s4, $s2   # currNode = newNode

    j optionsMenu   # return back to the menu


# This will run if we want to insert a value smaller than the current minimum
# which means that head = newNode
# no parameters or return values
insertFront:
    la $s0, ($s2)   # head = newNode

    j optionsMenu   # return back to the menu


# Allocate new memory for the newNode
# does not have any parameters
# does not return anything (the memory address will be retrieved from $v0)
allocateMemory:
    li $a0, 8   # 8 bits, 4 for the next address, 4 for the current value
    li $v0, 9
    syscall
    jr $ra  # return back to the program


# Delete the smallest value
# We want to delete the smallest value (or the head.value) so the linkedlist
# will always be sorted
# no parameters or return values
delete:
    beqz $s0, makeEmptyList # if the list is empty then we can't remove anything
    lw $s0, 4($s0)  # head = head.next

    j optionsMenu   # return back to the menu


# this will run if the list is empty or we delete an item from a list with 1 item
# no parameters or return values
makeEmptyList:
    li $s0, 0   # head = None
    j optionsMenu   # return back to the menu


# Starts printing the linkedlist from head until the end
# no parameters or return values
printList:
    la $t1, ($s0)   # tempNode = head
    beqz $t1, printEmptyList   # if temp is None then print empty list


# iterate through each element in the linkedlist and print each element
# no parameters or return values
printElements:
    lw $a0, ($t1)   # print tempNode.value
    jal printInteger

    la $a0, arrow   # print an arrow
    jal printString

    lw $t1, 4($t1)  # tempNode = tempNode.next
    beqz $t1, finishedPrinting  # if tempNode is None then we have printed all of the items in the list
    j printElements # if tempNode is not None then continue printing


# reaches this function when we have printed all of the nodes
# no parameters or return values
finishedPrinting:
    la $a0, eol     # prints a NULL in end
    jal printString
    j optionsMenu   # return back to the menu


# will run if the list is empty
# no parameters or return values
printEmptyList:
    la $a0, emptyList   # print list is empty
    jal printString

    j optionsMenu   # return back to the menu


# reads an integer and saves the value in $v0
# no parameters, the return value will be retrieved from the reggister $v0
readInteger:
    li $v0, 5
    syscall
    jr $ra


# prints the contents (string) in the reggister $a0
# the parameters will be retrieved from $a0 which is the string we want to print
# does not return anything
printString:
    li $v0, 4
    syscall
    jr $ra


# prints the contents (integer) in the reggister $a0
# the parameters will be retrieved from $a0 which is the integer we want to print
# does not return anything
printInteger:
    li $v0, 1
    syscall

    jr $ra


    .data
prompt: .asciiz "\nUse the appropriate integer to choose the option: \n 1. Insert node \n 2. Delete node \n 3. Print Linked List \n 4. Exit \nOption: "
options1Prompt: .asciiz "Enter an integer to insert: "
errorPrompt: .asciiz "Wrong option, please choose between 1, 2, or 3\n"
arrow: .asciiz " -> "
eol: .asciiz " NULL\n"
emptyList: .asciiz "Linkedlist is empty\n"
