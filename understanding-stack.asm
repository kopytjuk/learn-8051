; 8051 family
; EdSim51

; stack pointer points to data memory (DM) where it places a 16bit program-memory (PM) address 
; of the operation right after ACALL, LCALL execution.
; After the RET call the programm counter jumps to the address DM(SP-2)

ORG 0000h
JMP start ; jumps to 0x50 in code memory

; main loop
ORG 0050h
start:
	MOV P1, #00H ; some arbitrary operation
	; Stack pointer points to 0x07 (data memory) before subroutine
	LCALL subroutine; SP points to 0x09 in data memory after LCALL execution, DM(0x07)=0x55, DM(0x08)=0x00
	MOV P1, #0FFH ; operation located in PM(0x0056)
	SJMP start

ORG 0BB60h; place following code in 0xBB60
subroutine:
	MOV P1, #12H
	; Stack pointer points to 0x09 (data memory) before subsubroutine
	LCALL subsubroutine; SP points to 0x1B in data memory after LCALL execution, DM(0x09)=0x66, DM(0x0A)=0xBB
	MOV P1, #34H; operation located in PM(0xBB66)
	RET ; jump to the PM address indicated by the stack pointer (0x0056)

ORG 0AFh
subsubroutine:
	MOV P1, #56H
	MOV P1, #78H
	RET; jump to the PM address indicated by the stack pointer (0xBB66)
