*************************
*****               *****
*****  Hello World  *****
*****               *****
*************************

;CV	=	$24
org	=	$0300
=	=	=
data	=	org
CH	EQU	$24
CV	EQU	$25
GBASL	EQU	$26
GBASH	EQU	$27
BASL	EQU	$28
BASH	EQU	$29
BAS2L	EQU	$2A
BAS2H	EQU	$2B
CV	EQU	$25
COUT	=	$FDED
PageZ	=	$0
stack	=	$100
P300	=	768
HOME	EQU	$FC58A
PRINT@118	EQU	$C1014Z

;	org	$0300
	org	ORG

 dba 325										; erreur token dba inconnu

	lda	#$ABC
	lda	#$ABCDE
	bra	start

start:
	ldx	#textend-text
	jsr	clear

label_is_too_long						;Err: this is a too long label
10label											;Err: start with num
label,r											;Err: contains separator

label0	lda	text,x					; Ici un label
	jsr	cout
	dex
	bpl	label0
	
clear
	jsr	home
	rts

dataa	hex	0001020304050607
dataa	hex	08090A0B0C0D0E0F
dataa	hex	1011121314151617

datab	dfb	%01101001
	dfb	%01101002

datac	dfb	%11112111
	dfb	%11112111
	dfb	%11111211
	dfb	%11211121
	dfb	%11111012
	dfb	%111110111
	dfb	%11111111,%00000000,%11111111,%00000000

text	asc	"Hello world !"
	hex	8d00
textend	=	*

madeby	asc	"Flaith"

;une remarque en plus

version	=	101		;1.01