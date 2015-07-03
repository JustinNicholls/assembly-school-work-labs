ADTCTL2  	EQU $122 
ADTCTL4  	EQU $124 
ADTCTL5  	EQU $125 
ADTSTAT0 	EQU $126 
ADT1DR1L 	EQU $133  
DDRA 	 	EQU $02 
PORTA 	 	EQU $00 
 
; Include .hc12 directive, in case you need MUL 
.hc12 
 
 	 	 	ORG $400 
 	 	 	LDS #$4000 
 	 	 	 
 	 	 	LDAA #%11000000; Initialize ADTCTL2 
 	 	 	STAA ADTCTL2 
 	 	 	 
 	 	 	 
 	 	 	JSR Delay1MS; jump to subroutine 
 	 	 	 
 	 	 	LDAA #%11100101; Initialize ADTCTL4 
 	 	 	STAA ADTCTL4 
 	 	 	 
 	 	 	LDAA #%11111111; Initialize DDRA 
 	 	 	STAA DDRA 
 	 	 	 
LOOP: 	 	LDAA #%11000000; Initialize ADTCTL5 
 	 	 	STAA ADTCTL5 
 	 	 	 
 	 	 	BRCLR ADTSTAT0,%10000000,* ; Spin on ADTSTAT0 ($126) bit 7 to detect conversion complete 
			LDAA ADT1DR1L; load raw A/D data 
 	 	 	STAA PORTA; store in port a 
 	 	 	BRA LOOP; loop forever 
 	 	 	 
zeroloop: 	DEX; decrement x	9
			BNE zero; loop if not zero	9
 	 	 	RTS; return to main routine 
