TITLE Project One Cs271 Introduction to MASM  (Masam.asm)
; Author: Sean Murphy
; Last Modified: 11/15/19
; Course / Project Number : CS_271, Program #5
; OSU email address: Murphsea@oregonstate.edu
; Due Date:11/24/19
; Description: a program that will take in user request to generate random numbers [15 -> 200] the random integers are in range of high 999 and low 100 there will be 2 outputs
; one will be sort in decending order and the other will be to display before numbers are sorted.

INCLUDE Irvine32.inc

	Min = 15 ;constants
	MAX = 200
	LO = 100
	HI = 999

;Def of data types and strings the program will use!
.data
List DWORD 200  DUP (?)
Intro_One BYTE "Sorting Random Integers! ",0 ; First intro string for user
Intro_Two BYTE "Programmed By Sean Murphy ",0 ; Out put of authors name to user
Todo_One BYTE "This program generates random numbers in the range [100 .. 999], ",0 ; shows program instructions
Todo_Two BYTE "displays the original list, sorts the list, and calculates the",0 ;shows program instructions
Todo_Three BYTE "median value. Finally, it displays the list sorted in descending order.",0 ;shows program instructions
Get_input BYTE "How many numbers should be generated? [15 .. 200]:  ",0 ;asks user to give input in range
Get_Two BYTE "How many numbers should be generated? [15 .. 200]:  ",0 ;asks user to give input in range
Invalid BYTE "Invalid input Try again!",0 ; tells user that they entered a value that was out of bounds
RandomInts BYTE "The Unsorted Random Numbers are:",0 ; Header for random numbers
sortedInts BYTE "The Sorted list is: ",0 ; header for sorted numbers
Goodbye BYTE "Thanks for using my program!! have a nice day!",0;tells the user goodbye and that the program is finished.
spaces BYTE "     ",0; adds extra white spaces
DisplayMed BYTE "The median is: ",0 ;Text for display median
userinput DWORD ?


; (insert variable definitions here)

.code
main PROC
	Call	Randomize ;calling randomize at the start of my program!

	;Paramters sending references to these strings to be displayed by the introduction procedure
	Push	OFFSET Intro_One
	Push	OFFSET Intro_Two
	Call	Introduction ;calls the introduction Procedure

	;strings that will be used by the Displayinstructions procedure.
	Push	OFFSET Todo_One
	Push	OFFSET Todo_Two
	Push	OFFSET Todo_Three
	Call	DisplayInstructions


	;call	getdata procedure grabs the number the user would like to use for the number of randomly generated integers within the array
	push	OFFSET	Invalid	
	push	OFFSET  userinput
	push	OFFSET	Get_input
	call	getData

	;calls fillarray this call will fill the array of size n = userinput with random ints that will be used later
	push	OFFSET	List
	push	userinput
	call	fillarray


	;displaylist prints the unsorted list of array elements back to the user
	push	OFFSET	RandomInts
	push	OFFSET	spaces
	push	OFFSET	List
	push	userinput
	call	displayList

	;Call for display Median will display the medain value for the array
	;push	OFFSET	List
	;Push	userinput
	;Push	OFFSET DisplayMed
	;call	displayMedianText 
	call	displayMedian;got an odd error was very time consuming coulndt figure it out......

	;sortList sorts the list of array elements for user
	push	OFFSET	spaces
	push	userinput 
	push	OFFSET	List
	call	sortList

	;displaylist this call will return the sorted list of array elements back to the user
	call	crlf
	push	OFFSET	sortedInts
	push	OFFSET	spaces
	push	OFFSET	List
	push	userinput
	call	displayList



	;string that will be used by the goodbye procedure.
	Push	offset Goodbye
	Call	Finished;calls the ending statement of the program
	exit  ; exit to operating system
	main ENDP

;parameters being sent are some pre built strings 
;This Procedure will carry out the introduction of this program! giving the user basic info on the progams purpose!no pre or post conditions just called ,changes ebx content as well as ebp,esp,edx in order to grab strings by reference
Introduction PROC

	push	ebp
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+12] ;prints first intro string
	call	WriteString	
	pop		edx
	pop		ebp
	
	call	crlf
	
	push	ebp
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+8] ;prints Second intro string
	call	WriteString	
	pop		edx
	pop		ebp
	call	crlf

	ret		8 ;clean up
Introduction ENDP

;paramaters being passed are some pre made strings
;DisplayInstructions will output the instructions for the user it changes contents within the procedure of the edx,ebp,esp regis... The pre condition for this call to happen is that Introduction was called 
DisplayInstructions PROC

	push	ebp ;this will write the string todo_one
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+16]
	call	WriteString	
	pop		edx
	pop		ebp
	call	crlf

	push	ebp ;this will write the string todo_two
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+12]
	call	WriteString	
	pop		edx
	pop		ebp
	
	call	crlf;this will write the string todo_three
	push	ebp
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+8]
	call	WriteString	
	pop		edx
	pop		ebp
	call	crlf


	ret		12 ;clean up
DisplayInstructions ENDP


;paramters being passed are some strings for text and the empty int for the user input to be stored
;Pre conditions are just the other function calls must have been called
; procedure that will get the users data that is within range, gets request via reference and changes the edx,eax, and ebx regisiters and uses the ebp and esp regis as well as the edx, and eax regis contents is changed
getData PROC
	
	;create a ref to the userinput storage and the will print string that asks user to give an input
 	push	ebp 
	mov		ebp, esp
	mov		ebx, [ebp+12]

enterValue:
	mov		edx,[ebp + 8]
	call	writestring
	call	readint

	;makes sure that the entered value is in range of what the program requests 
	cmp		eax,MAX
	jg		error
	cmp		eax,Min ;compares to globals and jumps to error message if invalide entry 
	jl		error
	jmp		runProgram


error: ; prints an error message if the number was not within the proper range
	mov		edx,[ebp + 16]
	call	writestring
	call	crlf
	jmp		enterValue

runProgram:

	mov		[ebx],eax
	pop		ebp
	ret	12 ;resores the stack

 getData ENDP


 
 ;procedure will carry out the population of the users array with random ints until size n has been met which n is the value the user input
 ;this procedure will take in the address locations of the array and the value that the user gave stored in userinput
 ;Changes the content of the ebp,eax,edi,ecx registers 
 ;and return an array that has been populated with n random values, Pre conditions are just the other function calls must have been called post condition is that it needs n value of user inputs
 fillArray PROC

	push	ebp
	mov		ebp, esp
	mov		edi,[ebp + 12]
	mov		ecx,[ebp + 8];lecture 19 slide 12

	addvalue:
	
	mov		eax, HI
	sub		eax, LO	;alllows us to get a random number in range from 999-100
	inc		eax
	call	RandomRange
	add		eax,LO ;eax in [0......100] ; this can be found in lecure 20
	mov		[edi],eax    ;adds an elements to the new array
	add		edi,4
	loop	addvalue

	
	pop		ebp
	ret		8 ;clean up
 fillArray ENDP


 ; will genereate my sorted list that the user array content in a sorted out format it utilizes ecx,esi,ebx,edx,eax registers and changes the array content into an order list
 ;that this procedure returns the pre conditions to this procedure are just that the other function procedure calls are carried out and that a random array has been generated and that the users input has been given

 sortList PROC 
	mov		eax,4
 	push	ebp
 	mov		ebp,esp
	mov		ecx,[ebp+12];moves ecx into users input value
	sub		ecx,1
	mov		ebx,[ebp+16];grabs the spaces 
	

Updateaddress:
	push	ecx											
	mov		esi, [ebp+8];moves esi into the array of user elements 

CompareContenet: ;this loop will compare the content the array element if the next element is smaller than the current one then the porgram will jump to indext content 
	mov		edx, [esi]									
	cmp		[esi + eax],edx								
	jle		IndexContent											
	xchg	edx, [esi + eax];exchanges regi content 
	mov		[esi], edx			

IndexContent:
	mov		edx, 4; move to next element That is in the esi register
	add		esi,edx
	loop	CompareContenet	
	jmp		RestoreContent
	
RestoreContent:
	pop		ecx												
	loop	Updateaddress												
	pop		ebp
	ret		8;cleans up the stack 

 sortList ENDP
 
	;Will take an array of n elements given by the user (pre-conidition as well as other procedure calls before this one)  post none it will utilze the edx,ebx,esi,ecx,ebp,esp registers
	;This procedure will find the median value of the array that was generated by the user that contains random integers 

 displayMedian PROC

	;push	ebp    ;couldnt program this procedure Couldnt figure out my issue you with this error Exception thrown at 0x0019FF80 in Project.exe: 0xC0000005: Access violation executing location 0x0019FF80.
	;spent like 2 hours trying to figure it out
	;mov		ebp, esp
	;mov		edx, [ebp+8]

	;To discribe what I would of done here I would have given the array list and the number of elements in order to find the top and the bottom of the array that has been sorted
	; I would then average the values out to give the median value of the array

	;couldnt figure out what would of been a bigger point hit so went the route of keeping the program compartmentalized.

	call	crlf
 	mov 	edx,offset DisplayMed ;dont know if this allowed just used to see if I could get something to print/work..........
	call	writeString
	
 
	ret 4
 displayMedian ENDP


 ;display list procedure will display the # of value that the user requested that are stored in an array generated with random numbers this procedure gets the address of some strings,an array and the 
 ;users input. the registers that are changed during run time are the ecx,ebp,edx,ebx,eax it will display the list of elements and the title of the list that the user requested.Ref Lecture 20
 ;pre conditions are the user array and the users int value of elements as well as the type of list ie sorted or unsorted.

 displayList Proc

	push	ebp
	mov		ebp,esp
	mov		esi,[ebp+12] ;grabs the list (array)
	mov		ecx,[ebp+8] ;grabs total elements the user wanted to be stored in array
	mov		edx,[ebp + 20]
	call	writestring   ;prints the type of list 
	call	crlf

	mov		ebx,10 ;will fill ebs so that when it hits zero it will print a white space

	GenerateElements:
	cmp		ebx,0
	je		GenerateSpace
	mov		eax,[esi] ;gets the current element we want to print out from our list current element
	call	WriteDec
	mov		edx,[ebp + 16];prints the 6 white spaces in between elements 
	call	writestring		
	add		esi,4 
	jmp		NextElement


	NextElement: ;will dec the ebc and continue the loop counter for N elements
	dec		ebx        
	loop	GenerateElements
	jmp		Finish       ;calls the end of the procedure

	
	GenerateSpace: ;generates a white spce and adds 10 back to the ebx register 
	call	crlf
	mov		ebx,10
	jmp		GenerateElements


	Finish: 
	pop ebp     
	ret 16 ;clean up

 displayList ENDP

 ;  lets the user know that the program is over this procedure changes only the content of the edx,ebp,esp regis the pre condition is only that all other procedures have been called and excuted
 ;	this procedure just displays the exiting string back to the user 
Finished Proc
	
	call	crlf
	push	ebp;grabs the goodbye string and then prints it out
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+8]
	call	WriteString	
	pop		edx
	pop		ebp

	ret 4
Finished ENDP


END main


	 