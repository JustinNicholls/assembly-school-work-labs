TSCR1	EQU		$46	
TSCR2	EQU		$4D	
TIOS	EQU		$40	
TCTL1	EQU		$48	
TCTL2	EQU		$49	
TFLG1	EQU		$4E	
TIE		EQU		$4C	
TSCNT	EQU		$44	
TC4		EQU		$58
TC1		EQU		$52
PORTB	EQU		$01	
DDRB	EQU		$03	
PORTM 	EQU		$0250 
DDRM  	EQU		$0252


ORG	$1000
DutyCycle	ds 2

 



	ORG	$400
	LDAA #%10010000; Enable the timer and choose flag clearing mode
	STAA TSCR1
	LDAA #%00000011; Divide by 8 to get 1Mhz clock
 


	STAA TSCR2
	LDAA #%00010000; Set pin 0 for output compare
	STAA TIOS
	LDAA #%00000001 STAA TCTL1

TOP	LDD TSCNT 
	ADDD #!1000 STD TC4
	BRCLR TFLG1,%00010000,* 
	BRA TOP
