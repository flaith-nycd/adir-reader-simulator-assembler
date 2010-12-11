********************
***** 	test   *****
********************

IN	=	$32

	ORG	$300
	
	LDX #$50
	LDA IN+1,X
	STA *+2

	LDY #$02
	LDA DATA1,Y
	DEY
	STA IN,Y		;devra être converti en STA $0032,Y => 99 32 00
	RTS

data0	da	data1-1,data2-1,data3-1,data4-1,data5-1
data1	dfb	%11111111,%00000000,%11111111,%00000000
data2	dfb	$86,$77,$7F,$44,$80,$70,$0F,$04
data3	dfb	86,77,7F,44,80,70,0F,04
data4	asc "Hello World !",8d,00
data5	asc "Nicolas",8d,"say HELLO!",8d,00			;Hello