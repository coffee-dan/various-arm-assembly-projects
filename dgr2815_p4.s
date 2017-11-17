@ Daniel Ramirez 1001322815
@ CSE 2312
.global main
.func main

main:

_loop:
	BL _scanf				@ scan for numerator
	VMOV S0, R0             @ move the numerator to floating point register
	BL _scanf				@ scan for denominator
	VMOV S1, R1             @ move the denominator to floating point register
	
	VCVT.F32.U32 S0, S0     @ convert unsigned bit representation to single float
    VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
	
	VDIV.F32 S2, S0, S1     @ compute S2 = S0 * S1
	
	VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
	
	BL _printf_result
	
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

_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return
  
.data
operand:	.asciz	    "%d"
result_str:	.asciz		"%The result is:%f\n"
exit_str:   .ascii      "Terminating program.\n"
