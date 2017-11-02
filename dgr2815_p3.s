@ Daniel Ramirez 1001322815
@ CSE 2312
.global main
.func main

main:

_loop:
	BL _scanf				@ scan for n
	MOV R1, R0
	PUSH {R1}				@ backup R1 since scanf uses it
	BL _scanf				@ scan for m
	MOV R2, R0
	POP {R1}				@ restore R1
	MOV R0, #0				@ initialize return value R0
	BL _count_partitions
	MOV R3, R2
	MOV R2, R1
	MOV R1, R0
	LDR R0, =answer_str		@ print answer
	BL printf
	B _loop					@ infinite loop
	
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =operand        @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL  scanf               @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return

_count_partitions:
	PUSH {LR}				@ store the return address
	CMP R1, #0				@ is n <= 0
	ADDEQ R0, R0, #1		@ if n == 0 "return 1;"
	POPLE {PC}			    @ early return if n <= 0
	CMP R2, #0				@ is m == 0
	POPEQ {PC}			    @ early return if m == 0
	
	PUSH {R1}				@ back up n and m
	PUSH {R2}
	SUB R1, R1, R2			@ n = n - m
	BL _count_partitions	@ count_partitions(n - m, m)
	POP {R2}				@ back up n and m
	POP {R1}
	PUSH {R1}				@ back up n and m
	PUSH {R2}
	SUB R2, R2, #1			@ m = m - 1
	BL _count_partitions	@ count_partitions(n, m - 1)
	POP {R2}				@ back up n and m
	POP {R1}
	POP {PC}				@ restore SP and return
  
.data
operand:	.asciz	    "%d"
answer_str:	.asciz		"There are %d partitions of %d using integers up to %d\n"
exit_str:   .ascii      "Terminating program.\n"