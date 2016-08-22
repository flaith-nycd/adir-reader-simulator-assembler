* LC/UC CONVERTER
* BY TOM ZUCHOWSKI
* JULY 1987
*
* CONVERTS LOWER CASE STRINGS TO UPPER CASE
* SYNTAX: &A$
*
*
PTRGET	EQU	$DFE3
A1		EQU	$E0
A2		EQU	$E1
B1		EQU	$E2
B2		EQU	$E3
*
*
		ORG	$300
*
*
		JSR	PTRGET				;GET STRING POINTERS
		STA	A1
		STY	A2
		LDY	#2
GETADR	LDA	(A1),Y				;GET STRING ADDRESS
		DEY
		STA	B1,Y
		BNE	GETADR
		LDA	(A1),Y				;GET STRING LENGTH
		TAY
		INY
GETCHR	DEY						;DECREMENT COUNTER
		BEQ	EXIT				;BRANCH IF DONE
		LDA	(B1),Y				;GET CHAR.
		CMP	#$61				;LOWER CASE?
		BCC	GETCHR				;BRANCH IF NOT
		AND	#$DF				;CONVERT TO UPPER CASE
		STA	(B1),Y				;PUT IT BACK IN MEMORY
		CLC
		BCC	GETCHR				;GET NEXT CHAR.
EXIT	RTS 