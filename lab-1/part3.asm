PORTA	EQU 0
DDRA	EQU 2
DELAY	EQU	500; Choose number of ms to delay

		org $400
		lds #$4000
		ldaa #$FF
		staa DDRA

loop:		inca
		STAA PORTA
		LDX #DELAY
		PSHX
		JSR Delay1
		LEAS 2,SP
		CLR PORTA
		LDX #DELAY
		PSHX
		JSR Delay1
		LEAS 2,SP
		bra loop		; call only once.


Delay1MS:	ldx #!2000
onemsloop:  	dex
		bne onemsloop
		rts			; Students to implement

				
Delay1:		tsx
			ldy 2,x
loop1:		
			jsr Delay1MS
			dey
			bne loop1;	
			rts		; Implement a variable delay using a stack parameter
