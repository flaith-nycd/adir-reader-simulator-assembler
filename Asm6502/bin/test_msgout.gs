********************
*                  *
*   TEST MSGOUT    *
*                  *
********************

PRINT EQU $8000
TABV EQU $FB5B
CH = $24

 ORG $300

DEBUT LDA #ENDTEXT-TEXT
 STA TEMP+1
 LDA #39
TEMP SBC #00

 STA CH
 LDA #10
 JSR TABV
 JSR PRINT
; HEX 8D
TEXT ASC "HELLO WORLD"
ENDTEXT ; HEX 8D8D
 HEX 00
 RTS