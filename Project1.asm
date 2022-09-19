#********************************************************************************************
# Virtue Adowei, 04-10-2022, Project 1: Get Creative with Bitmap
#
#The purpose of this program is to give the user an interactive tutorial of Binary Tree traversal using the MARS Bitmap and Keyboard simulators
#
# Instructions:
#
#Before running: 
# 1. Connect to MIPS bitmap display:
# 2. set pixel dimensions to 4x4
# 3. set display dimensions to 512x256
# 4. use $gp as base address
# 5. Connect to MIPS keyboard simulator
#*******************************************************************************************


#constants for the dimensions
.eqv WIDTH 128	# width of screen in pixels, = 512/4 
.eqv HEIGHT 64	# height of screen in pixels, = 256/4
.eqv SQUARE_DIM 8#the length and width of the square that will be drawn

#constants for the colors
.eqv	RED 	0x00FF0000
.eqv	BLUE	0x000000FF
.eqv	HOTPINK	0x00FF66FF
.eqv	GREEN	0x66CC00
.eqv	TURQUOISE	0x00006666
.eqv	BABYBLUE	0x000080FF
.eqv	LAVENDER	0x006666FF

.data
#Prompts to be displayed throughout the course of the program
prompt1:	.asciiz	"Hello! This is a tutorial on how Binary tree traversal works\n\n"
prompt2:	.asciiz	"A Binary Tree is an abstract data type where each node has at most two children\n"
prompt3:	.asciiz "There are 3 main ways to \"visit\" all the nodes in a binary tree: inorder traversal, preorder traversal, and postorder traversal\n" 

inPrompt:	.asciiz "Inorder traversal processes nodes in this order: left child, current node, right child. Here is a recursive example:\n"
prePrompt:	.asciiz "Preorder traversal processes nodes in this order: current node, left child, right child. Here is a recursive example:\n"
postPrompt:	.asciiz "Postorder traversal processes nodes in this order: left child, right child, current node. Here is a recursive example:\n"

ready:		.asciiz "Are you ready to try it yourself? Press YES to practice, NO to replay the animation, or CANCEL to quit the tutorial\n"
quit:		.asciiz "Are you sure you want to quit? All progress will be lost. Press YES to quit\n"
continue:	.asciiz	"(press OK or hit Enter to continue)\n"
controls:	.asciiz "During the game, enter:\n a  to move to the left child\nd  to move to the right child\n/  to move to the parent from the left child\n\\  to move to the parent from the right child\no to visit the node\n\n"

wrongMsg:	.asciiz "Whoops, that's not right! That's ok- reset the keyboard, wait a few seconds, and try again. Number of tries left: "
backToTutorial:.asciiz "It seems like you're having trouble, reviewing the tutorial might help\n"
endOfInorder:	.asciiz "Great job! You're done with inorder traversal. Next stop, preorder traversal\n"
endOfPreorder:	.asciiz "Great job! You're done with preorder traversal. Next stop, postorder traversal\n"
endOfPostorder:	.asciiz "Great job! You're done with postorder traversal"
endingMsg:	.asciiz "Congrats, you're a tree traversal pro!\n"


#arrays to hold the correct sequnce of characters for each tpye of traversal
inorderCorrect: .byte  'a', 'a', 'a', 'o', '/', 'o', 'd', 'o', '\\', '/', 'o',
			'd','a', 'o', '/', 'o', 'd', 'o', '\\','\\','/', 'o',
			'd', 'a', 'a', 'o', '/', 'o', 'd', 'o', '\\', '/', 'o',
			'd','a', 'o', '/', 'o', 'd', 'o', '\0'

preorderCorrect: .byte 'o', 'a', 'o', 'a', 'o', 'a', 'o', '/','d', 'o','\\', '/',
			'd', 'o', 'a', 'o', '/','d', 'o', '\\','\\','/',
			'd', 'o', 'a', 'o', 'a', 'o', '/','d', 'o', '\\', '/',
			'd', 'o', 'a', 'o', '/','d', 'o', '\0'

postorderCorrect:.byte 'a', 'a', 'a', 'o', '/','d', 'o', '\\', 'o', '/',
			'd','a', 'o', '/','d', 'o', '\\', 'o', '\\', 'o', '/',
			'd', 'a', 'a', 'o', '/','d', 'o', '\\', 'o', '/',
			'd','a', 'o', '/','d', 'o', '\\', 'o', '\\', 'o', '\\', 'o', '\0'


.text
main:
	#intro to tutorial
	la	$a0, prompt1	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall			#display the prompts as a dialog message
	
	#define binary tree
	la	$a0, prompt2	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall			#display the prompts as a dialog message
	
	#draw a binary tree
	li	$a2, RED	#register a2 will usually hold the color of the pixel to be drawn
	jal	starting_coordinates
	li	$t1, 4		#register t1 will usually hold the dimension of the border that is to be drawn
	jal	draw_tree
	
	#wait
	li	$v0, 32		 #use the pause syscall to pause the program for 5ms
	li	$a0, 300
	syscall
	
	#erase the binary tree
	li	$a2, 0
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	draw_tree
	
	#introduce the types of traversal
	la	$a0, prompt3	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall	



inorder_tutorial:	
	#introduce inorder traversal
	la	$a0, inPrompt	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall	
	
	#use recursive function to demonstrate inorder traversal
	li	$a2, BABYBLUE
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	inorder
	#erase
	li	$a2, 0
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	clear
	
confirm_inorder:
	#ask if the user is ready to move on. If not, replay the animation
	la	$a0, ready	#load the prompt to $a0
	li	$v0, 50		#load 50 (syscall for a confirm dialog) to $v0
	syscall	
	li	$t4, 3		#holds the number of tries you get for the test
	li	$t5, 1
	beq	$a0, $0, pre_inorder_test #if the user presses yes, go to the test
	beq	$t5, $a0, inorder_tutorial#if the user presses no, go to the tutorial
	
	#make sure the user wants to quit
	la	$a0, quit	#load the prompt to $a0
	li	$v0, 50		#load 50 (syscall for a confirm dialog) to $v0
	syscall	
	
	beq	$a0, $0, exit#if the user wants to quit, exit
	j	confirm_inorder#else, go back to the confirmation
	

#draw tree and initialize registers used for the test		
pre_inorder_test:
	jal	starting_coordinates
	li	$a2, BABYBLUE
	jal	draw_tree
	
	#explain the controls
	la	$a0, controls	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall	

	jal	starting_coordinates
	la	$t6, inorderCorrect	#t6 holds the address of the sequence array
	
#compares user input to a sequence of chracters to determine if they are traversing the tree correctly
inorder_test:
	li	$a2, GREEN
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	cursor		#call the cursor function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	#check for user input
	lw $t0, 0xffff0000  #t0 != 0 if input is available
    	beq $t0, 0, inorder_test   #If there is no user input, jump back to loop and keep displaying the square
	
	# process input
	lw 	$s1, 0xffff0004#load the input into register s1
	beq	$s1, '/', upleft_inorder 	# if the input is a  /, move the cursor to the parent
	beq	$s1, '\\', upright_inorder 	# if the input is a  \, move the cursor to the parent
	beq	$s1, 'a', left_inorder  	# if the input is an  a, move the cursor to the left child
	beq	$s1, 'd', right_inorder 	# if the input is a  d, move the cursor to the right child
	beq	$s1, 'o', draw_inorder		# if the input is an o, visit that node
	# if the input is any other key, do nothing and jump back to the loop
	j	inorder_test

#draw a node
draw_inorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	draw_node	#call the draw node function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_inorder #check if the input is correct

#move up from the left child
upleft_inorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	up_left		#call the up left function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_inorder#check if the input is correct
	
#move up from the right child
upright_inorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	up_right	#call the up right function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_inorder	#check if the input is correct

#move to the right child
right_inorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	right		#call the right function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_inorder	#check if the input is correct

#move to the left child
left_inorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	left		#call the left function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_inorder	#check if the input is correct

#check if the character entered follows the correct sequence
check_inorder:
	lbu	$t7, ($t6)	#t6 is a pointer to the current char in the array
	bne	$t7, $s1, wrong_inorder#branch if the wrong character was entered
	addi	$t6, $t6, 1	#move the pointer
	lbu	$t7, ($t6)	#check if the next character is null
	bne	$t7, $0, inorder_test#if the next character is not null, continue the test
	j	done_with_inorder#gets to this point if everything was entered correctly

#comes here when the user enters incorrect input	
wrong_inorder:
	addi	$t4, $t4, -1#the user has used up one try
	beq	$t4, $0, try_inorder_again
	addi	$sp, $sp, -8	  #save the coordinates to the stack
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	la	$a0, wrongMsg	#load the error message to $a0
	move	$a1, $t4	#move the number of tries left to $a1
	li	$v0, 56		#load 56 (syscall for a dialog message) to $v0
	syscall	
	lw	$a0, ($sp)	#restore the coordinates from the stack
	lw	$a1, 4($sp)
	addi	$sp, $sp, 8
	j	pre_inorder_test#restart the test
	
#comes here when the user has failed too many times
try_inorder_again:
	la	$a0, backToTutorial	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall			#display the prompts as a dialog message
	#erase the binary tree
	li	$a2, 0
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	draw_tree
	j	inorder_tutorial#go back to the tutorial
	
#comes here when the user successfully completes the test
done_with_inorder:
	#end the preorder traversal tutorial
	la	$a0, endOfInorder	#load the first prompt to $a0
	la	$a1, continue		#load the second prompt to $a1
	li	$v0, 59			#load 59 (syscall for a dialog message) to $v0
	syscall
	#clear the bitmap
	li	$a2, 0
	jal	starting_coordinates
	jal	draw_tree

preorder_tutorial:
	#introduce preorder traversal
	la	$a0, prePrompt	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall	
	
	#use recursive function to demonstrate inorder traversal
	li	$a2, BABYBLUE
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	preorder
	#erase
	li	$a2, 0
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	clear
	
confirm_preorder:
	#ask if the user is ready to move on. If not, replay the animation
	la	$a0, ready	#load the prompt to $a0
	li	$v0, 50		#load 50 (syscall for a confirm dialog) to $v0
	syscall	
	li	$t4, 3		#holds the number of tries you get for the test
	li	$t5, 1
	beq	$a0, $0, pre_preorder_test #if the user presses yes, go to the test
	beq	$t5, $a0, preorder_tutorial#if the user presses no, go to the tutorial
	
	#make sure the user wants to quit
	la	$a0, quit	#load the prompt to $a0
	li	$v0, 50		#load 50 (syscall for a confirm dialog) to $v0
	syscall	
	
	beq	$a0, $0, exit#if the user wants to quit, exit
	j	confirm_preorder#else, go back to the confirmation
	

#draw tree and initialize registers used for the test		
pre_preorder_test:
	jal	starting_coordinates
	li	$a2, HOTPINK
	jal	draw_tree
	
	#explain the controls
	la	$a0, controls	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall	

	jal	starting_coordinates
	la	$t6, preorderCorrect	#t6 holds the address of the sequence array
	
#compares user input to a sequence of chracters to determine if they are traversing the tree correctly
preorder_test:
	li	$a2, LAVENDER
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	cursor		#call the cursor function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	#check for user input
	lw $t0, 0xffff0000  #t0 != 0 if input is available
    	beq $t0, 0, preorder_test   #If there is no user input, jump back to loop and keep displaying the square
	
	# process input
	lw 	$s1, 0xffff0004#load the input into register s1
	beq	$s1, '/', upleft_preorder 	# if the input is a  /, move the cursor to the parent
	beq	$s1, '\\', upright_preorder 	# if the input is a  \, move the cursor to the parent
	beq	$s1, 'a', left_preorder  	# if the input is an  a, move the cursor to the left child
	beq	$s1, 'd', right_preorder 	# if the input is a  d, move the cursor to the right child
	beq	$s1, 'o', draw_preorder	# if the input is an o, visit that node
	# if the input is any other key, do nothing and jump back to the loop
	j	preorder_test

#draw a node
draw_preorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	draw_node	#call the draw node function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_preorder #check if the input is correct

#move up from the left child
upleft_preorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	up_left		#call the up left function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_preorder#check if the input is correct
	
#move up from the right child
upright_preorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	up_right	#call the up right function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_preorder	#check if the input is correct

#move to the right child
right_preorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	right		#call the right function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_preorder	#check if the input is correct

#move to the left child
left_preorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	left		#call the left function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_preorder	#check if the input is correct

#check if the character entered follows the correct sequence
check_preorder:
	lbu	$t7, ($t6)	#t6 is a pointer to the current char in the array
	bne	$t7, $s1, wrong_preorder#branch if the wrong character was entered
	addi	$t6, $t6, 1	#move the pointer
	lbu	$t7, ($t6)	#check if the next character is null
	bne	$t7, $0, preorder_test#if the next character is not null, continue the test
	j	done_with_preorder#gets to this point if everything was entered correctly

#comes here when the user enters incorrect input
wrong_preorder:
	addi	$t4, $t4, -1#the user has used up one try
	beq	$t4, $0, try_preorder_again
	addi	$sp, $sp, -8	  #save the coordinates to the stack
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	la	$a0, wrongMsg	#load the error message to $a0
	move	$a1, $t4	#move the number of tries left to $a1
	li	$v0, 56		#load 56 (syscall for a dialog message) to $v0
	syscall	
	lw	$a0, ($sp)	#restore the coordinates from the stack
	lw	$a1, 4($sp)
	addi	$sp, $sp, 8
	j	pre_preorder_test#restart the test
	
#comes here when the user has failed too many times
try_preorder_again:
	la	$a0, backToTutorial	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall			#display the prompts as a dialog message
	#erase the binary tree
	li	$a2, 0
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	draw_tree
	j	preorder_tutorial#go back to the tutorial
	
#comes here when the user successfully completes the test
done_with_preorder:
	#end the preorder traversal tutorial
	la	$a0, endOfInorder	#load the first prompt to $a0
	la	$a1, continue		#load the second prompt to $a1
	li	$v0, 59			#load 59 (syscall for a dialog message) to $v0
	syscall
	#clear the bitmap
	li	$a2, 0
	jal	starting_coordinates
	jal	draw_tree


postorder_tutorial:	
	#introduce postorder traversal
	la	$a0,postPrompt	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall	
	
	#use recursive function to demonstrate postorder traversal
	li	$a2, BABYBLUE
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	postorder
	#erase
	li	$a2, 0
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	clear
	
confirm_postorder:
	#ask if the user is ready to move on. If not, replay the animation
	la	$a0, ready	#load the prompt to $a0
	li	$v0, 50		#load 50 (syscall for a confirm dialog) to $v0
	syscall	
	li	$t4, 3		#holds the number of tries you get for the test
	li	$t5, 1
	beq	$a0, $0, pre_postorder_test #if the user presses yes, go to the test
	beq	$t5, $a0, postorder_tutorial#if the user presses no, go to the tutorial
	
	#make sure the user wants to quit
	la	$a0, quit	#load the prompt to $a0
	li	$v0, 50		#load 50 (syscall for a confirm dialog) to $v0
	syscall	
	
	beq	$a0, $0, exit#if the user wants to quit, exit
	j	confirm_postorder#else, go back to the confirmation
	

#draw tree and initialize registers used for the test		
pre_postorder_test:
	jal	starting_coordinates
	li	$a2, BLUE
	jal	draw_tree
	
	#explain the controls
	la	$a0, controls	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall	

	jal	starting_coordinates
	la	$t6, postorderCorrect	#t6 holds the address of the sequence array
	
#compares user input to a sequence of chracters to determine if they are traversing the tree correctly
postorder_test:
	li	$a2, TURQUOISE
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	cursor		#call the cursor function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	#check for user input
	lw $t0, 0xffff0000  #t0 != 0 if input is available
    	beq $t0, 0, postorder_test   #If there is no user input, jump back to loop and keep displaying the square
	
	# process input
	lw 	$s1, 0xffff0004#load the input into register s1
	beq	$s1, '/', upleft_postorder 	# if the input is a  /, move the cursor to the parent
	beq	$s1, '\\', upright_postorder 	# if the input is a  \, move the cursor to the parent
	beq	$s1, 'a', left_postorder  	# if the input is an  a, move the cursor to the left child
	beq	$s1, 'd', right_postorder 	# if the input is a  d, move the cursor to the right child
	beq	$s1, 'o', draw_postorder		# if the input is an o, visit that node
	# if the input is any other key, do nothing and jump back to the loop
	j	postorder_test

#draw a node
draw_postorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	draw_node	#call the draw node function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_postorder #check if the input is correct

#move up from the left child
upleft_postorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	up_left		#call the up left function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_postorder#check if the input is correct
	
#move up from the right child
upright_postorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	up_right	#call the up right function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_postorder	#check if the input is correct

#move to the right child
right_postorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	right		#call the right function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_postorder	#check if the input is correct

#move to the left child
left_postorder:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	left		#call the left function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	j	check_postorder	#check if the input is correct

#check if the character entered follows the correct sequence
check_postorder:
	lbu	$t7, ($t6)	#t6 is a pointer to the current char in the array
	bne	$t7, $s1, wrong_postorder#branch if the wrong character was entered
	addi	$t6, $t6, 1	#move the pointer
	lbu	$t7, ($t6)	#check if the next character is null
	bne	$t7, $0, postorder_test#if the next character is not null, continue the test
	j	done_with_postorder#gets to this point if everything was entered correctly

#comes here when the user enters incorrect input	
wrong_postorder:
	addi	$t4, $t4, -1#the user has used up one try
	beq	$t4, $0, try_postorder_again
	addi	$sp, $sp, -8	  #save the coordinates to the stack
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	la	$a0, wrongMsg	#load the error message to $a0
	move	$a1, $t4	#move the number of tries left to $a1
	li	$v0, 56		#load 56 (syscall for a dialog message) to $v0
	syscall	
	lw	$a0, ($sp)	#restore the coordinates from the stack
	lw	$a1, 4($sp)
	addi	$sp, $sp, 8
	j	pre_postorder_test#restart the test
	
#comes here when the user has failed too many times
try_postorder_again:
	la	$a0, backToTutorial	#load the first prompt to $a0
	la	$a1, continue	#load the second prompt to $a1
	li	$v0, 59		#load 59 (syscall for a dialog message) to $v0
	syscall			#display the prompts as a dialog message
	#erase the binary tree
	li	$a2, 0
	jal	starting_coordinates
	li	$t1, 4		#loop control, for the size of the border drawn
	jal	draw_tree
	j	postorder_tutorial#go back to the tutorial
	
#comes here when the user successfully completes the test
done_with_postorder:
	#end the postorder traversal tutorial
	la	$a0, endOfPostorder	#load the first prompt to $a0
	la	$a1, continue		#load the second prompt to $a1
	li	$v0, 59			#load 59 (syscall for a dialog message) to $v0
	syscall
	#clear the bitmap
	li	$a2, 0
	jal	starting_coordinates
	jal	draw_tree
	
cleared_tutorials:
	#end of tutorials
	la	$a0, endingMsg		#load the first prompt to $a0
	la	$a1, continue		#load the second prompt to $a1
	li	$v0, 59			#load 59 (syscall for a dialog message) to $v0
	syscall

exit:#exit the program
	li	$v0, 10
	syscall

###########################################################################

#This subroutine intializes the registers used for drawing trees
starting_coordinates:
	#initialize the starting position such that
	#the box is drawn in the top center of the display
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	li	$t0, SQUARE_DIM	  #t0 = SQUARE_DIM/-2 = 8/-2 = -4
	div	$t0, $t0, -2
	mflo	$t0
	
	#subtract 4 from the (X,Y) coordinates so that the square is perfectly centered
	add	$a0, $a0, $t0
	mul	$t0, $t0, 7
	add	$a1, $a1, $t0
	
	li	$t9, 64		#t9 will be used to position the children of each node
	li	$a3, 4		#a3 holds the height of the tree
	jr	$ra

draw_pixel:# subroutine to draw a pixel
	# t2 = address = $gp + 4*(x + y*width)
	mul	$t2, $a1, WIDTH   # $a1 = Y, t2 = y * WIDTH
	add	$t2, $t2, $a0	  # $a0 = X, t2 = (y * WIDTH) + x
	sll	$t2, $t2, 2	  # multiply by 4 to get word offset
	add	$t2, $t2, $gp	  # add to base address
	sw	$a2, ($t2)	  # store color at memory location in bitmap

	jr 	$ra		#exit the subroutine

	
draw_borders:#endless loop that draws the square until the user presses space

	li	$t0, 0		#loop control, start here
top:#draw the top of the square
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	draw_pixel	#call the draw pixel function
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	addi	$a0, $a0, 1	#move the X coordinate right by one pixel
	addi	$t0, $t0, 1	#increment the loop control variable
	blt	$t0, $t1, top	#iterate 8 times
	
	li	$t0, 0		#reset the loop counter

rightSide:#draw the right side of the square
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	draw_pixel	#call the draw pixel function
	lw	$ra, ($sp)	#restore the color from the stack
	addi	$sp, $sp, 4
	
	addi	$a1, $a1, 1	#move the Y coordinate down by one pixel
	addi	$t0, $t0, 1	#increment the loop control variable
	blt	$t0, $t1, rightSide#iterate 8 times
	
	li	$t0, 0		#reset the loop counter

bottom:#draw the bottom of the square
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	draw_pixel	#call the draw pixel function
	lw	$ra, ($sp)	#restore the color from the stack
	addi	$sp, $sp, 4
	
	addi	$a0, $a0, -1	#move the X coordinate left by one pixel
	addi	$t0, $t0, 1	#increment the loop control variable
	blt	$t0, $t1, bottom#iterate 8 times
	
	li	$t0, 0		#reset the loop counter

leftSide:#draw the left side of the square
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal 	draw_pixel	#call the draw pixel function
	lw	$ra, ($sp)	#restore the color from the stack
	addi	$sp, $sp, 4
	
	addi	$a1, $a1, -1	#move the Y coordinate up by one pixel
	addi	$t0, $t0, 1	#increment the loop control variable
	blt	$t0, $t1, leftSide#iterate 8 times
	
	jr	$ra		

#draws a node by drawing concentric borders
draw_node:
#loops and draws a border, reducing the dimensions of the border each iteration
draw_node_loop:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal     draw_borders	#draw border
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	addi 	$t1, $t1, -1	#reduce the border dimensions by 1
	bne	$t1, $0, draw_node_loop
	li	$t1, 4		#restore the original dimension
	addi	$sp, $sp, -4	  #save the coordinate to the stack
	sw	$a0, ($sp)
	li	$v0, 32		 #use the pause syscall to pause the program for 500ms
	li	$a0, 300
	syscall
	lw	$a0, ($sp)	#restore the coordinate from the stack
	addi	$sp, $sp, 4
	jr	$ra

#move the X,Y coordinates to the right child
move_right:
	div	$t9, $t9, 2
	add	$a0, $a0, $t9
	addi 	$a1, $a1, 10
	jr	$ra

#move the X,Y coordinates to the left child	
move_left:
	div	$t9, $t9, 2
	sub	$a0, $a0, $t9
	addi 	$a1, $a1, 10
	jr	$ra

#move the X,Y coordinates to the parent from the left child
left_to_parent:
	subi	$a1, $a1, 10
	add	$a0, $a0, $t9
	mul	$t9, $t9, 2
	jr	$ra

#move the X,Y coordinates to the parent from the right child
right_to_parent:
	subi	$a1, $a1, 10
	sub	$a0, $a0, $t9
	mul	$t9, $t9, 2
	jr	$ra

#draws the left child
left_child:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	move_left	#move left
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_node	#draw the node
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	jr	$ra

#draws the right child	
right_child:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	move_right	#move right
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_node	#draw the node
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	jr	$ra
	
#moves the cursor up from the left child
up_left:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	left_to_parent	#move to the parent
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	cursor		#draw the cursor
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	jr	$ra

#moves the cursor up from the right child
up_right:	
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	right_to_parent	#move to the parent
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	cursor		#draw the cursor
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	jr	$ra
	
#moves the cursor to the right child
right:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	move_right	#move to the right child
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	cursor		#draw the cursor
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	jr	$ra

#moves the cursor to the left child
left:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	move_left	#move to the left child
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	cursor		#draw the cursor
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	jr	$ra
	
cursor:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_borders	#draw the border
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	addi	$sp, $sp, -4	  #save the offset to the stack
	sw	$a0, ($sp)
	li	$v0, 32		 #use the pause syscall to pause the program for 5ms
	li	$a0, 100
	syscall
	lw	$a0, ($sp)	#restore the offest from the stack
	addi	$sp, $sp, 4
	
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	addi	$sp, $sp, -4	  #save the color to the stack
	sw	$a2, ($sp)
	li	$a2, 0
	jal	draw_borders
	lw	$a2, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	addi	$sp, $sp, -4	  #save the offset to the stack
	sw	$a0, ($sp)
	li	$v0, 32		 #use the pause syscall to pause the program for 5ms
	li	$a0, 100
	syscall
	lw	$a0, ($sp)	#restore the offest from the stack
	addi	$sp, $sp, 4
	
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_borders
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	addi	$sp, $sp, -4	  #save the offset to the stack
	sw	$a0, ($sp)
	li	$v0, 32		 #use the pause syscall to pause the program for 5ms
	li	$a0, 100
	syscall
	lw	$a0, ($sp)	#restore the offest from the stack
	addi	$sp, $sp, 4
	
	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	
	jr $ra
	
#erase the tree that was drawn
clear:
	li	$a2, 0		#make the pixels black
	addi 	$sp, $sp, -8	#save the return address and coordinates
	addi	$a3, $a3, -1
	sw	$a3, ($sp)
	sw	$ra, 4($sp)
	jal	draw_node	#draw a node
	lw	$ra, 4($sp)	#restore the ra from the stack
	beq	$a3, $0, clear_up#if the height is zero, branch
	
	addi 	$sp, $sp, -8	#restore the coordinates from the stack
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	jal	move_left	#move left

	lw	$ra, 12($sp)	#restore the ra from the stack
	jal	clear		#recursively call clear
	lw	$ra, 12($sp)	#restore the values from the stack
	lw	$a1, 4($sp)
	lw	$a0, ($sp)
	jal	draw_node	#draw a node
	lw	$ra, 4($sp)	#restore the ra from the stack

	jal	move_right	#move right
	lw	$ra, 4($sp)	#restore the ra from the stack
	addi	$t9, $t9, 8	#adjust the position
	jal	clear		#recursively call clear
	
	lw	$ra, 12($sp)	#restore the ra from the stack
	addi 	$sp, $sp, 8

clear_up:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_node	#draw a node
	#restore the values from the stack and adjust the position
	lw	$ra, ($sp)	
	addi	$sp, $sp, 4
	div	$t9, $t9, 2
	mul	$t9, $t9, 3
	addi 	$sp, $sp, 8
	lw	$a3, 8($sp)
	jr	$ra


#perform a recursive inorder traversal of a binary tree
inorder:
	addi 	$sp, $sp, -8#save the return address and coordinates
	addi	$a3, $a3, -1
	sw	$a3, ($sp)
	sw	$ra, 4($sp)
	jal	cursor		#draw a cursor
	lw	$ra, 4($sp)	#restore the ra from the stack
	beq	$a3, $0, back_up#if the height is zero, branch (base case)
	
	addi 	$sp, $sp, -8	#restore the coordinates from the stack
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	jal	move_left	#move left

	lw	$ra, 12($sp)	#restore the ra from the stack
	jal	inorder		#recursively call inorder
	lw	$ra, 12($sp)	#restore the values from the stack
	lw	$a1, 4($sp)
	lw	$a0, ($sp)
	jal	draw_node	#draw a node
	lw	$ra, 4($sp)	#restore the ra from the stack

	jal	move_right	#move right
	lw	$ra, 4($sp)	#restore the ra from the stack
	addi	$t9, $t9, 8	#adjust the position
	jal	inorder
	
	lw	$ra, 12($sp)	#restore the ra from the stack
	addi 	$sp, $sp, 8	#recursively call inorder

back_up:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_node	#draw a node
	#restore the values from the stack and adjust the position
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	div	$t9, $t9, 2
	mul	$t9, $t9, 3
	addi 	$sp, $sp, 8
	li	$a2, BLUE	#change color to highlight changes
	lw	$a3, 8($sp)
	jr	$ra

#perform a recursive preorder traversal of a binary tree
preorder:
	addi 	$sp, $sp, -8#save the return address and coordinates
	addi	$a3, $a3, -1
	sw	$a3, ($sp)
	sw	$ra, 4($sp)
	jal	cursor		#draw a cursor
	lw	$ra, 4($sp)	#restore the ra from the stack
	jal	draw_node	#draw a node
	lw	$ra, 4($sp)	#restore the ra from the stack
	beq	$a3, $0, back_up1#if the height is zero, branch (base case)
	
	addi 	$sp, $sp, -8	#restore the coordinates from the stack
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	jal	move_left	#move left

	lw	$ra, 12($sp)	#restore the ra from the stack
	jal	preorder	#recursively call preorder
	lw	$ra, 12($sp)	#restore the values from the stack
	lw	$a1, 4($sp)
	lw	$a0, ($sp)
	jal	draw_node	#draw a node
	lw	$ra, 4($sp)	#restore the ra from the stack

	jal	move_right	#move right
	lw	$ra, 4($sp)	#restore the ra from the stack
	addi	$t9, $t9, 8	#adjust the position
	jal	preorder	#recursively call preorder
	
	lw	$ra, 12($sp)	#restore the ra from the stack
	addi 	$sp, $sp, 8

back_up1:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_node	#draw a node
	#restore the values from the stack and adjust the position
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	div	$t9, $t9, 2
	mul	$t9, $t9, 3
	addi 	$sp, $sp, 8
	li	$a2, BLUE	#change color to highlight changes
	lw	$a3, 8($sp)
	jr	$ra

#perform a recursive preorder traversal of a binary tree
postorder:
	addi 	$sp, $sp, -8#save the return address and coordinates
	addi	$a3, $a3, -1
	sw	$a3, ($sp)
	sw	$ra, 4($sp)
	jal	cursor		#draw a cursor
	lw	$ra, 4($sp)	#restore the ra from the stack
	beq	$a3, $0, back_up2#if the height is zero, branch (base case)
	
	addi 	$sp, $sp, -8	#restore the coordinates from the stack
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	jal	move_left	#move left

	lw	$ra, 12($sp)	#restore the ra from the stack
	jal	postorder	#recursively call postorder
	lw	$ra, 12($sp)	#restore the ra from the stack
	lw	$a1, 4($sp)
	lw	$a0, ($sp)

	jal	move_right
	lw	$ra, 4($sp)	#restore the ra from the stack
	addi	$t9, $t9, 8	#adjust the position
	jal	postorder	#recursively call postorder
	lw	$ra, 12($sp)	#restore the values from the stack
	lw	$a1, 4($sp)
	lw	$a0, ($sp)
	jal	draw_node	#draw a node
	lw	$ra, 12($sp)	#restore the ra from the stack
	addi 	$sp, $sp, 8
	

back_up2:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	jal	draw_node	#draw a node
	lw	$ra, ($sp)	#restore the ra from the stack
	#restore the values from the stack and adjust the position
	addi	$sp, $sp, 4
	div	$t9, $t9, 2
	mul	$t9, $t9, 3
	addi 	$sp, $sp, 8
	li	$a2, BLUE	#change color to highlight changes
	lw	$a3, 8($sp)
	jr	$ra

#subroutine to draw a complete binary tree of height 3
draw_tree:
	addi	$sp, $sp, -4	  #save the ra to the stack
	sw	$ra, ($sp)
	#draw the parent
	jal	draw_node
	#go to the leftmost child, drawing nodes as you go
	jal	left_child
	jal	left_child
	jal	left_child
	jal	left_to_parent
	#move up the left subtree drawing the right children as well
	jal	right_child
	jal	right_to_parent
	jal	left_to_parent
	jal	right_child
	jal	left_child
	jal	left_to_parent
	jal	right_child
	jal	right_to_parent
	
	jal	starting_coordinates #return to the root
	#go to the leftmost child of the right subtree, drawing nodes as you go
	jal	right_child
	jal	left_child
	jal	left_child
	jal	left_to_parent
	#move up the left subtree drawing the right children as well
	jal	right_child
	jal	right_to_parent
	jal	left_to_parent
	jal	right_child
	jal	left_child
	jal	left_to_parent
	jal	right_child
	jal	right_to_parent

	lw	$ra, ($sp)	#restore the ra from the stack
	addi	$sp, $sp, 4
	jr	$ra
