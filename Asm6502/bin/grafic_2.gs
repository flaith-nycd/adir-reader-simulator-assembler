********************************
*                              *
*      ADRESSES GRAPHIQUE      *
*                              *
*          NYCD 1998           *
*                              *
********************************

         LST   OFF
TXTCLR   EQU   $C050
MIXSET   EQU   $C053
HIRES    EQU   $C057
PTR      EQU   0

         ORG   $7000

HGR      LDA   TXTCLR
         LDA   MIXSET
         LDA   HIRES

         LDX   #$00
BOUCLE   LDA   BAS,X
         STA   BASE+1
         LDA   HAUT,X
         STA   BASE+2

         LDA   COULEUR    ;COULEUR DU FOND
         LDY   #39        ;NBRE DE COLONNES
BASE     STA   $FFFF,Y
         DEY
         BPL   BASE

         INX
         CPX   #192       ;NBRE DE LIGNES
         BNE   BOUCLE
         RTS

PRINT    PLA
         STA   PTR
         PLA
         STA   PTR+1

         INC   PTR
         STA   POSX
         INC   PTR
         STA   POSY

LOOP     LDY   #0
         INC   PTR
         BNE   PRN
         INC   PTR+1
PRN      LDA   (PTR),Y
         AND   #$FF
         BEQ   END
         CMP   #$8D
         BEQ   NEWLINE
         CMP   #$A0
         BEQ   ESPACE
         CMP   #$C1
         BCC   CHIFFRE
         JSR   PRINTCAR
         JMP   LOOP

END      LDA   PTR+1      ;OCTET HAUT DU RTS
         PHA              ;ON EMPILE
         LDA   PTR        ;OCTET BAS
         PHA              ;IDEM EST
         RTS              ;ON RETOURNE D'OU ON VIENT

NEWLINE  LDA   #00
         STA   POSX
         INC   POSY
         CMP   #24
         BNE   CONTLINE
         LDA   #00
         STA   POSY
CONTLINE JMP   LOOP

CHIFFRE  SEC
         SBC   #$B0
         CLC
         ADC   #$1A
         JMP   PRINT0

PRINTCAR SEC
         SBC   #$C1
PRINT0   ASL
         TAY
         LDA   LETTRE,Y
         STA   CONTPRIN+1
         INY
         LDA   LETTRE,Y
         STA   CONTPRIN+2
         TAY
         JMP   PUTCAR

ESPACE   LDY   #ESP

PUTCAR   JSR   MAKEADR
         JMP   GOPRINT

MAKEADR  LDA   POSY
* ASL
* ASL  ;2 ASL POUR MUL PAR 8
         TAX
         LDA   BAS,X
         STA   ADR+1
         LDA   HAUT,X
         STA   ADR+2
         RTS

* GOPRINT LDX #$00
GOPRINT  LDA   POSX
         TAX
         LDY   #$00
CONTPRIN LDA   $0000,Y

ADR      STA   $FFFF,X
* INX
         INY
         INC   POSY
         STX   TEMPX
* STY TEMPY
         JSR   MAKEADR
         LDX   TEMPX
* LDY TEMPY
         CPY   #$08
         BNE   CONTPRIN
         INC   POSX
         CMP   #39
         BNE   OKGO
         JMP   NEWLINE
OKGO     SEC
         LDA   POSY
         SBC   #$08
         STA   POSY
         JMP   LOOP

COULEUR  HEX   00
POSX     HEX   00
POSY     HEX   00
TEMPX    HEX   00
TEMPY    HEX   00

LETTRE   DA    A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
         DA    C0,C1,C2,C3,C4,C5,C6,C7,C8,C9

ESP      DFB   %00000000
         DFB   %00000000
         DFB   %00000000
         DFB   %00000000
         DFB   %00000000
         DFB   %00000000
         DFB   %00000000
         DFB   %00000000

C0       DFB   %00111110
         DFB   %01100011
         DFB   %01110011
         DFB   %01101011
         DFB   %01100111
         DFB   %01100011
         DFB   %00111110
         DFB   %00000000

C1       DFB   %00011000
         DFB   %00011100
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00111100
         DFB   %00000000

C2       DFB   %00111110
         DFB   %01100011
         DFB   %01100000
         DFB   %00111110
         DFB   %00000011
         DFB   %00000011
         DFB   %01111111
         DFB   %00000000

C3       DFB   %00111111
         DFB   %01100000
         DFB   %01100000
         DFB   %01111000
         DFB   %01100000
         DFB   %01100000
         DFB   %00111111
         DFB   %00000000

C4       DFB   %01111000
         DFB   %01101100
         DFB   %01100110
         DFB   %01100011
         DFB   %01111111
         DFB   %01100000
         DFB   %01100000
         DFB   %00000000

C5       DFB   %01111110
         DFB   %00000011
         DFB   %00000011
         DFB   %00111111
         DFB   %01100000
         DFB   %01100011
         DFB   %00111110
         DFB   %00000000

C6       DFB   %00111110
         DFB   %00000011
         DFB   %00000011
         DFB   %00111111
         DFB   %01100011
         DFB   %01100011
         DFB   %00111110
         DFB   %00000000

C7       DFB   %01111111
         DFB   %01100000
         DFB   %00110000
         DFB   %00011000
         DFB   %00001100
         DFB   %00001100
         DFB   %00001100
         DFB   %00000000

C8       DFB   %00111110
         DFB   %01100011
         DFB   %01100011
         DFB   %00111110
         DFB   %01100011
         DFB   %01100011
         DFB   %00111110
         DFB   %00000000

C9       DFB   %00111110
         DFB   %01100011
         DFB   %01100011
         DFB   %01111110
         DFB   %01100000
         DFB   %00110000
         DFB   %00011111
         DFB   %00000000

A        DFB   %00111110
         DFB   %01100011
         DFB   %01100011
         DFB   %01111111
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00000000

B        DFB   %00111111
         DFB   %01100011
         DFB   %01100011
         DFB   %00011111
         DFB   %01100011
         DFB   %01100011
         DFB   %00111111
         DFB   %00000000

C        DFB   %01111110
         DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %01111110
         DFB   %00000000

D        DFB   %00111111
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00111111
         DFB   %00000000

E        DFB   %01111111
         DFB   %00000011
         DFB   %00000011
         DFB   %00001111
         DFB   %00000011
         DFB   %00000011
         DFB   %01111111
         DFB   %00000000

F        DFB   %01111111
         DFB   %00000011
         DFB   %00000011
         DFB   %00001111
         DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %00000000

G        DFB   %01111110
         DFB   %00000011
         DFB   %00000011
         DFB   %01111011
         DFB   %01100011
         DFB   %01100011
         DFB   %00111110
         DFB   %00000000

H        DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01111111
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00000000

I        DFB   %01111110
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %01111110
         DFB   %00000000

J        DFB   %01111111
         DFB   %00110000
         DFB   %00110000
         DFB   %00110000
         DFB   %00110011
         DFB   %00110011
         DFB   %00011110
         DFB   %00000000

K        DFB   %01100011
         DFB   %00110011
         DFB   %00011011
         DFB   %00001111
         DFB   %00011011
         DFB   %00110011
         DFB   %01100011
         DFB   %00000000

L        DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %00000011
         DFB   %01111111
         DFB   %00000000

M        DFB   %00111110
         DFB   %01101011
         DFB   %01101011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00000000

N        DFB   %01100011
         DFB   %01101111
         DFB   %01111011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00000000

O        DFB   %00111110
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00111110
         DFB   %00000000

P        DFB   %00111111
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00111111
         DFB   %00000011
         DFB   %00000011
         DFB   %00000000

Q        DFB   %00111110
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01110011
         DFB   %01111110
         DFB   %00000000

R        DFB   %00111111
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00111111
         DFB   %01100011
         DFB   %01100011
         DFB   %00000000

S        DFB   %00111110
         DFB   %00000011
         DFB   %00000011
         DFB   %00111110
         DFB   %01100000
         DFB   %01100000
         DFB   %00111111
         DFB   %00000000

T        DFB   %01111110
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00000000

U        DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00111110
         DFB   %00000000

V        DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %00110110
         DFB   %00011100
         DFB   %00000000

W        DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01100011
         DFB   %01101011
         DFB   %01101011
         DFB   %00110110
         DFB   %00000000

X        DFB   %01100011
         DFB   %01100011
         DFB   %00110110
         DFB   %00011100
         DFB   %00110110
         DFB   %01100011
         DFB   %01100011
         DFB   %00000000

Y        DFB   %01100110
         DFB   %01100110
         DFB   %01100110
         DFB   %00111100
         DFB   %00011000
         DFB   %00011000
         DFB   %00011000
         DFB   %00000000

Z        DFB   %01111111
         DFB   %01100000
         DFB   %00110000
         DFB   %00011000
         DFB   %00001100
         DFB   %00000110
         DFB   %01111111
         DFB   %00000000

BAS      HEX   0000000000000000
         HEX   8080808080808080
         HEX   0000000000000000
         HEX   8080808080808080
         HEX   0000000000000000
         HEX   8080808080808080
         HEX   0000000000000000
         HEX   8080808080808080

         HEX   2828282828282828
         HEX   A8A8A8A8A8A8A8A8
         HEX   2828282828282828
         HEX   A8A8A8A8A8A8A8A8
         HEX   2828282828282828
         HEX   A8A8A8A8A8A8A8A8
         HEX   2828282828282828
         HEX   A8A8A8A8A8A8A8A8

         HEX   5050505050505050
         HEX   D0D0D0D0D0D0D0D0
         HEX   5050505050505050
         HEX   D0D0D0D0D0D0D0D0
         HEX   5050505050505050
         HEX   D0D0D0D0D0D0D0D0
         HEX   5050505050505050
         HEX   D0D0D0D0D0D0D0D0

HAUT     HEX   2024282C3034383C
         HEX   2024282C3034383C
         HEX   2125292D3135393D
         HEX   2125292D3135393D
         HEX   22262A2E32363A3E
         HEX   22262A2E32363A3E
         HEX   23272B2F33373B3F
         HEX   23272B2F33373B3F

         HEX   2024282C3034383C
         HEX   2024282C3034383C
         HEX   2125292D3135393D
         HEX   2125292D3135393D
         HEX   22262A2E32363A3E
         HEX   22262A2E32363A3E
         HEX   23272B2F33373B3F
         HEX   23272B2F33373B3F

         HEX   2024282C3034383C
         HEX   2024282C3034383C
         HEX   2125292D3135393D
         HEX   2125292D3135393D
         HEX   22262A2E32363A3E
         HEX   22262A2E32363A3E
         HEX   23272B2F33373B3F
         HEX   23272B2F33373B3F

         LST   ON
