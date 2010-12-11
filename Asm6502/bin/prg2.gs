*************************
*****               *****
*****  Hello World  *****
*****               *****
*************************

CH	EQU	$24
CV	EQU	$25
GBASL	EQU	$26
GBASH	EQU	$27
BASL	EQU	$28
BASH	EQU	$29
BAS2L	EQU	$2A
BAS2H	EQU	$2B
COUT	=	$FDED
PageZ	=	$0
stack	=	$100
P300	=	768
TheORG	=	P300
HOME	EQU	$FC58

	org	P300

	ldx	#textend-text
	jsr	clear

label0	lda	text,x					; Ici un label
	jsr	cout
	dex
	bpl	label0
	
clear
	jsr	home
	rts

; Hex value
dataa	hex	0001020304050607
datab	hex	08090A0B0C0D0E0F
datac	hex	1011121314151617

; Binary Font
data_A	dfb	%01111100
	dfb	%11000110
	dfb	%11000110
	dfb	%11111110
	dfb	%11000110
	dfb	%11000110
	dfb	%11000110
	dfb	%00000000

data_B	dfb	%11111100
	dfb	%11000110
	dfb	%11000110
	dfb	%11111100
	dfb	%11000110
	dfb	%11000110
	dfb	%11111100
	dfb	%00000000

text	asc	"Hello world !"
	hex	8d00
textend	=	*

madeby	asc	"Flaith"
	
;une remarque en plus

version	=	101		;1.01