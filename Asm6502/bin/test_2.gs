**********************
***** 	test 2   *****
**********************
	AST	22

	ORG	$300

	JSR	START
	JSR COMPARE
	RTS

START
	LDX #$FF
BOUCLE	LDA $FC58,X
	STA DATA,X
	DEX
	BCC BOUCLE
	RTS

COMPARE
	LDX	#$2F
	LDA DATA,X
	CMP	#03				;Compare accumulator to 3
	BCS	EQGT3			;Branch is Greater or equal
	STA	$20				;Accumulator less than 3
	JMP	DONE
EQGT3	BNE	GT3			;Not equal to 3 so it's greater > GT3
	STA	$21				;Accumulator equal to 3
	JMP	DONE
GT3	STA	$22				;Accumulator greater than 3
DONE	RTS

DATA	DS	$FF
