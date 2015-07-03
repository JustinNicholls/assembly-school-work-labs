TSCR1  	EQU $46 			
TSCR2  	EQU $4D 			
TIOS  	EQU $40 			
TCTL1  	EQU $48 			
TCTL2  	EQU $49 			
TFLG1  	EQU $4E 			
TIE  	EQU $4C 			
TSCNT 	EQU $44 			
TC4 	EQU $58 		
TC1 	EQU $52 		
PORTB 	EQU $01 			
DDRB 	EQU $03 			
PORTM 	EQU $0250 			
DDRM 	EQU $0252 			
 	 	 	 	
				
ORG $1000 
DutyCycle ds 2 			
UpDown ds 1 		
 	 	 	 	ORG 	 	$400 
 
		LDAA #$90 ; Enable the timer and choose flag clearing mode 
	  	STAA TSCR1 
		LDAA #%00000011 ; Divide by 8 to get 1Mhz clock 
		STAA TSCR2 
		LDAA #%00010000 ; Set pin 0 for output compare 
		STAA TIOS 
 
		LDD #0; Value for Duty Cycle 
		STD DutyCycle 
 
 	 	 	 	 
INCREASE 	LDD TSCNT 
	 	 	ADDD DutyCycle 
	 	 	STD TC4 
 	 	 	 	 
	 	 	LDAA #%00000010 
	 	 	STAA TCTL1 
 
	 	 	BRCLR TFLG1,%00010000,* 
 
 	 	 	 	 
	 	 	LDD TSCNT 
	 	 	ADDD #!1000 
	 	 	SUBD DutyCycle 
	 	 	STD TC4 
 	 	 	 	 
	 	 	LDAA #%00000011 
	 	 	STAA TCTL1 
 
	 	 	BRCLR TFLG1,%00010000,* 
 
	 	 	LDAA UpDown; load value 
	 	 	BEQ DECREASE; just to decrease 
	 	 	LDX DutyCycle; load value 
	 	 	INX; increase 

			STX DutyCycle; store value 
			CPX #!900; compare duty cycle to value 
 	 	 	BLT INCREASE; loop back if duty cycle is not 900 
 	 	 	CLR UpDown; clear updown 
 	 	 	BRA INCREASE; loop to increase 
 	 	 	 	 
DECREASE  	LDX DutyCycle; load dutycycle 
 	 	  	DEX; decrease x 
 	 	 	STX DutyCycle; store value 
 	 	 	CPX #!100; compare duty cycle to value 
			BGE INCREASE; loop until dutycycle is 100 
			LDAA 1; load 1 
			STAA UpDown; store 1 back into updown 
 	 	 	BRA INCREASE ; loop back to increase 
