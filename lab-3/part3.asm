ADTCTL2  EQU $122 
ADTCTL4  EQU $124 
ADTCTL5  EQU $125 
ADTSTAT0 EQU $126 
ADT1DR1L EQU $133 
 
DDRA 	 EQU $02 
PORTA 	 EQU $00 
 
; Include .hc12 directive, in case you need MUL 
.hc12
 
		ORG $400 
		LDS #$4000 
 	 	 	 
		LDAA #%11000000; Initialize ADTCTL2 
		STAA ADTCTL2 
 	 	 	 
		JSR Delay1MS 
 	 	 	 
		LDAA #%11100101; Initialize ADTCTL4 
 	 	STAA ADTCTL4 
 	 	 	 
 	 	LDAA #%11111111; Initialize DDRA 
 	 	STAA DDRA 
 	 	 	 
LOOP: 	LDAA #%11000000; Initialize ADTCTL5 
		STAA ADTCTL5 
 	 	 	 
 	  	BRCLR ADTSTAT0,%10000000,* ; Spin on ADTSTAT0 ($126) bit 7 to detect conversion complete 
 	 	 	 
 	 	LDAB ADT1DR1L; load raw A/D data 
 	 	LDAA #!0; load 0 so the compare works 
 	 	 	 
 	 	CPD #!28; compare raw data to number 
 	 	BLT ZERO; loop if less than or equal 
 	 	 	 
		CPD #!56; compare raw data to number 
 	 	BLT ONE; loop if less than or equal 
 	 	 	 
 	 	CPD #!84; compare raw data to number 
 	 	BLT TWO; loop if less than or equal 
 	 	 	 
 	 	CPD #!112; compare raw data to number 
 	 	BLT THREE; loop if less than or equal 
 	 	 	 
 	 	CPD #!140; compare raw data to number 
 	 	BLT FOUR; loop if less than or equal 
 	 	 	 
 	 	CPD #!168; compare raw data to number 
 	 	BLT FIVE; loop if less than or equal 
 	 	 	 
 	 	CPD #!196; compare raw data to number 
		BLT SIX; loop if less than or equal 
 	 	 
 	 	CPD #!224; compare raw data to number 
 	 	BLT SEVEN; loop if less than or equal 
 	 	 	 
 	 	CPD #!255; compare raw data to number 
 	 	BLT EIGHT; loop if less than or equal 
 	 	 	 
 	 	BRA LOOP; loop forever 
 	 	 	 
ZERO: 	LDAA #%00000000; load value for zero 
 	 	BRA STORAGE; loop to sub routine 
ONE:  	LDAA #%00000001; load value for one 
 	 	BRA STORAGE; loop to sub routine 
TWO: 	LDAA #%00000011; load value for two 
 	 	BRA STORAGE; loop to sub routine 
THREE: 	LDAA #%00000111; load value for three 
 	 	BRA STORAGE; loop to sub routine 
FOUR: 	LDAA #%00001111; load value for four 
 	 	BRA STORAGE; loop to sub routine 
FIVE:  	LDAA #%00011111; load value for five 
 	 	BRA STORAGE; loop to sub routine 
SIX: 	LDAA #%00111111; load value for six 
 	 	BRA STORAGE; loop to sub routine 
SEVEN: 	LDAA #%01111111; load value for seven 
 	 	BRA STORAGE; loop to sub routine 
EIGHT: 	LDAA #%11111111; load value for eight 
 	 	BRA STORAGE; loop to sub routine 
 	 	 	 
Delay1MS: 	PSHX; push x value 
			LDX #!2000 ; load value in x 
zeroloop: 	DEX; decrement x 
 	 	 	BNE zero; loop if not zero 
 	 	 	PULX; pull x 
 	 	 	RTS; return to main routine 
 
 	 	 
STORAGE: 	STAA PORTA; store in port a 
 	 	 	BRA  LOOP; loop forever 	 
