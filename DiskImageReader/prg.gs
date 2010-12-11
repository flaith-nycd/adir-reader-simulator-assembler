*************************
*****               *****
*****  Hello World  *****
*****               *****
*************************

CV	=	$24
COUT	=	$FDED
HOME	EQU	$FC58

	org	$0300

	ldx	textend-text
	jsr	clear

label0	lda	text,x					; Ici un label
	jsr 	cout
	dex
	bpl	label0
	
clear
	jsr	home
	rts

text	asc	"Hello world !"
	hex	8d00
textend	=	*
	
;on met ce qu'on veut maintenant
