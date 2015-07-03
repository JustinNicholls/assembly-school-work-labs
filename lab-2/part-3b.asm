TSCR1  	EQU $46 		
TSCR2  	EQU	$4D 		
TIOS  	EQU $40 		
TCTL1  	EQU $48 		
TCTL2	EQU $49 		
TFLG1  	EQU $4E 		
TIE  	EQU $4C 			
TSCNT 	EQU $44 		
TC4  	EQU $58 		
TC1  	EQU $52 		
PORTB 	EQU $01 		
DDRB 	EQU $03 		
PORTM 	EQU $0250 		
DDRM 	EQU $0252 		
 	 	 	 	
ORG 	 	$1000 
DutyCycle  ds 2 		
 	 	 	
			ORG 	 	$400 
 
	 	LDAA #%10010000; Enable the timer and choose flag clearing mode 
	 	STAA TSCR1 
 	 	 
	 	LDAA #%00000011; Divide by 8 to get 1Mhz clock 
	 	STAA TSCR2 
 	 	 
	 	LDAA #%00000010; Set pin 0 for output compare 
	 	STAA TIOS 
 	 	 	 	 
	 	LDD #!1200; load value 
	 	STD DutyCycle; store as dutycycle 
 	 	 	 	 
		LDAA #%10000000; load value 
	 	STAA DDRB; store value 
 	 	 
	 	LDAA #%10000000; load value 
	 	STAA PORTB; store as port b 
 	 	 	 	 
ROOF 	LDD TSCNT; load value 
	 	ADDD DutyCycle; add dutycycle to it 
	 	STD TC1; store in TC1 
 	 	 	 	 
	 	LDAA #%00001000; load value into a 
	 	STAA TCTL2; store value in TCTL2 
 	 	 	 	 
	  	BRCLR TFLG1,%0000010,*; spin until it indicates bit 4 on compare 
 	 	 	 	 
	 	LDD TSCNT; load value 
		ADDD  #!2000; add 2000 
	  	SUBD DutyCycle; subtract dutycycle from d 
		STD TC1; store d in TC1 
 	 	 	 	 
	  	LDAA #%00001100; load value 
	 	STAA TCTL2; store value in TCTL2 
 	 	 	 	 
	 	BRCLR TFLG1,%00000010,*; spin until it indicates bit 4 on compare 
 	 	 	 	 
	 	BRA ROOF; loop    
