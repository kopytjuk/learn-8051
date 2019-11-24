; Increments the 7-segment display from 0 to 9
; EdSim update frequency: 1s

; put low and high byte of the program memory address
; of the first 7-segment code into DPTR to use in MOVC command
MOV DPL, #LOW(LEDcodes)
MOV DPH, #HIGH(LEDcodes)

main:
    MOV R1, 0
    loop:
        MOV A, R1
        MOVC A, @A+DPTR ; loads a 7-seg code into memory
        LCALL delay1s
        INC R1
        MOV P1, A
        CJNE R1, #10, loop
    JMP main

delay1s:
	MOV R0, #1
	DJNZ R0, $
	RET


LEDcodes:	; points to the address of the first byte defined below
    ; 7-segment codes for 0, 1, ..., 9 digits
	DB 11000000B, 11111001B, 10100100B, 10110000B, 10011001B, 10010010B, 10000010B, 11111000B, 10000000B, 10010000B