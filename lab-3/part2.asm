TSCR1  	EQU $46 
TSCR2  	EQU $4D 
TIOS   	EQU $40 
TCTL1  	EQU $48 
TCTL2  	EQU $49 
TFLG1  	EQU $4E 
TIE   	EQU $4C 
TSCNT 	EQU $44 
TC4  	EQU $58 
TC1  	EQU $52 
PORTB 	EQU $01 
DDRB  	EQU $03 
PORTM 	EQU $0250 
DDRM  	EQU $0252 
ADTCTL2 EQU $122 
ADTCTL4 EQU $124 
ADTCTL5 EQU $125 
ADTSTAT0 EQU $126 
ADT1DR1L EQU $133 
DDRA 	EQU $02 
PORTA 	EQU $00  
.hc12 
 	
ORG  $1000 
DutyCycle  	ds 2 
 	 	 	 	 
 	 	 	 	ORG $400 
 	 	 	 	 
 	 	 	 	LDAA #%10010000 ; Enable the timer and choose flag clearing mode 
 	 	 	 	STAA TSCR1 
 
				LDAA #%00000011; Divide by 8 to get 1Mhz clock 
 	 	 	 	STAA TSCR2 
 	 	 	 	 
 	 	 	 	LDAA #%00000010; Set pin 0 for output compare 
 	 	 	 	STAA TIOS 
 	 	 	 	 
 	 	 	 	LDAA #%10000000; load value 
 	 	 	 	STAA DDRB 
 	 	 	 	 
 	 	 	 	LDAA #%10000000; load value 
 	 	 	 	STAA PORTB; store as port b 
 	 	 	 	 
 	 	 	 	LDS #$4000 
 	 	 	 
 	 	 	 	LDAA #%11000000; Initialize ADTCTL2 
 	 	 	 	STAA ADTCTL2 
 	 	 	 
 	 	 	 
 	 	 	 	JSR Delay1MS; jump to subroutine 
 	 	 	 
 	 	 	 	LDAA #%11100101; Initialize ADTCTL4 
				STAA ADTCTL4 
 	 	 	 	LDAA #%11111111; Initialize DDRA 
 	 	 	 	STAA DDRA 
 	 	 	 	 
 	 	 	 	LDD #!500; load value  
 	 	 	 	ADDD DutyCycle; add duty cycle to d 
 	 	 	 	 
LOOP: 	 	 	LDAA #%11000000; Initialize ADTCTL5 
 	 	 	 	STAA ADTCTL5 
 	 	 	 	 
 	 	 	 	BRCLR ADTSTAT0,%10000000,* 
 	 	 	 	 
 	 	 	 	LDAA ADT1DR1L; load raw A/D data 
 	 	 	 	STAA PORTA; store in port a 
 	 	 	 	LDAB #!4; load 4 
 	 	 	 	MUL; multiply a and b and load in d 
 	 	 	 	 
 	 	 	 	STD DutyCycle; store d in duty cycle LDD TSCNT; load value 
				ADDD #!1024; add 1024 to d 
 	 	 	 	SUBD DutyCycle; subtract duty cycle from d 
 	 	 	 	STD TC1; store 
 	 	 	 	 
 	 	 	 	LDAA #%00001000; load value 
 	 	 	 	STAA TCTL2; store in TCTL2 
 	 	 	 	 
 	 	 	 
				BRCLR TFLG1,%00000010,*; spin until it indicates bit 4 on compare 
 	 	 	 	 
 	 	 	 	LDD TSCNT; load value into d 
 	 	 	 	ADDD DutyCycle; add duty cycle to d 
 	 	 	 	STD TC1; store in TC1 
 	 	 	 	 
 	 	 	 	LDAA #%00001100; load value 
 	 	 	 	STAA TCTL2; store value in TCTL2 
 	 	 	 	 
 	 	 	 
				BRCLR TFLG1,%00000010,*; spin until it indicates bit 4 on compare 
 	 	 	 	 
 	 	 	 	 
 	 	 	 	 
				BRA LOOP; loop forever 
 
 
				Delay1MS: PSHX; push x value 
				LDX #!2000 ; load value in x 

zeroloop: 		DEX; decrement x 
				BNE zero; loop if not zero 
				PULX; pull x 
				RTS; return to main routine  
