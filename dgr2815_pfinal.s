/******************************************************************************
* @file dgr2815_pfinal.s
* @brief Final program for CSE 2312. Creates and searches array based on user input.
*
* Simple example of declaring a fixed-width array and traversing over the
* elements for searching.
*
* @author Daniel Gerard Ramirez
******************************************************************************/
 
.global main
.func main
   
main:
    MOV R0, #0              @ initialze index variable
writeloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of array_a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before _scanf call
    PUSH {R2}               @ backup element address before _scanf call
	PUSH {R1}				@ backup R1 for _scanf call
    BL _scanf            	@ get user input
	POP {R1} 				@ restore R1
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of array_a[i] to array_a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable
readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of array_a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
	BL _prompt				@ branch to prompt procedure with return
	BL _scanf				@ branch to scanf procedure with return
	MOV R5, R0				@ move scanf value to R5
	MOV R4, #0				@ initialze search successful boolean
	MOV R0, #0              @ reinitialze index variable
searchloop:
	CMP R0, #10             @ check to see if we are done iterating
    BEQ searchdone          @ exit loop if done
    LDR R1, =a              @ get address of array_a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 

	CMP R1, R5				@ compare array value to search element
	MOVEQ R4, #1			@ change search successful boolean to true if equal
    PUSHEQ {R0}             @ backup register before printf if equal
    PUSHEQ {R1}             @ backup register before printf if equal
    PUSHEQ {R2}             @ backup register before printf if equal
    MOVEQ R2, R1            @ move array value to R2 for printf if equal
    MOVEQ R1, R0            @ move array index to R1 for printf if equal
    BLEQ  _printf           @ branch to print procedure with return if equal
    POPEQ {R2}              @ restore register if equal
    POPEQ {R1}              @ restore register if equal
    POPEQ {R0}              @ restore register if equal
	
    ADD R0, R0, #1          @ increment index
    B   searchloop          @ branch to next loop iteration
searchdone:
	CMP R4, #0				@ determine of search failed
	BLEQ _search_failed		@ display fail_str if search failed
    B _exit                 @ exit if done
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
	
_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
	
_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #22             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
 
_search_failed:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #41             @ print string length
    LDR R1, =fail_str       @ string at label fail_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
	
.data

.balign 4
a:              .skip       40
prompt_str:		.asciz		"ENTER A SEARCH VALUE: "
fail_str:		.asciz		"That value does not exist in the array!\n"
format_str:     .asciz      "%d"
printf_str:     .asciz      "array_a[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"
