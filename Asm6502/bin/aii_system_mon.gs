***************************
*                         *
*        APPLE II         *
*     SYSTEM MONITOR      *
*                         *
*    COPYRIGHT 1977 BY    *
*   APPLE COMPUTER, INC.  *
*                         *
*   ALL RIGHTS RESERVED   *
*                         *
*       S. WOZNIAK        *
*        A. BAUM          *
*                         *
***************************
                          ; TITLE "APPLE II SYSTEM MONITOR"
LOC0     EQU   $00
LOC1     EQU   $01
WNDLFT   EQU   $20
WNDWDTH  EQU   $21
WNDTOP   EQU   $22
WNDBTM   EQU   $23
CH       EQU   $24
CV       EQU   $25
GBASL    EQU   $26
GBASH    EQU   $27
BASL     EQU   $28
BASH     EQU   $29
BAS2L    EQU   $2A
BAS2H    EQU   $2B
H2       EQU   $2C
LMNEM    EQU   $2C
RTNL     EQU   $2C
V2       EQU   $2D
RMNEM    EQU   $2D
RTNH     EQU   $2D
MASK     EQU   $2E
CHKSUM   EQU   $2E
FORMAT   EQU   $2E
LASTIN   EQU   $2F
LENGTH   EQU   $2F
SIGN     EQU   $2F
COLOR    EQU   $30
MODE     EQU   $31
INVFLG   EQU   $32
PROMPT   EQU   $33
YSAV     EQU   $34
YSAV1    EQU   $35
CSWL     EQU   $36
CSWH     EQU   $37
KSWL     EQU   $38
KSWH     EQU   $39
PCL      EQU   $3A
PCH      EQU   $3B
XQT      EQU   $3C
A1L      EQU   $3C
A1H      EQU   $3D
A2L      EQU   $3E
A2H      EQU   $3F
A3L      EQU   $40
A3H      EQU   $41
A4L      EQU   $42
A4H      EQU   $43
A5L      EQU   $44
A5H      EQU   $45
ACC      EQU   $45
XREG     EQU   $46
YREG     EQU   $47
STATUS   EQU   $48
SPNT     EQU   $49
RNDL     EQU   $4E
RNDH     EQU   $4F
ACL      EQU   $50
ACH      EQU   $51
XTNDL    EQU   $52
XTNDH    EQU   $53
AUXL     EQU   $54
AUXH     EQU   $55
PICK     EQU   $95
IN       EQU   $0200
USRADR   EQU   $03F8
NMI      EQU   $03FB
IRQLOC   EQU   $03FE
IOADR    EQU   $C000
KBD      EQU   $C000
KBDSTRB  EQU   $C010
TAPEOUT  EQU   $C020
SPKR     EQU   $C030
TXTCLR   EQU   $C050
TXTSET   EQU   $C051
MIXCLR   EQU   $C052
MIXSET   EQU   $C053
LOWSCR   EQU   $C054
HISCR    EQU   $C055
LORES    EQU   $C056
HIRES    EQU   $C057
TAPEIN   EQU   $C060
PADDL0   EQU   $C064
PTRIG    EQU   $C070
BASIC    EQU   $E000
BASIC2   EQU   $E003
         ORG   $F800      ;ROM START ADDRESS
PLOT     LSR              ;Y-COORD/2
         PHP              ;SAVE LSB IN CARRY
         JSR   GBASCALC   ;CALC BASE ADR IN GBASL,H
         PLP              ;RESTORE LSB FROM CARRY
         LDA   #$0F       ;MASK $0F IF EVEN
         BCC   RTMASK
         ADC   #$E0       ;MASK $F0 IF ODD
RTMASK   STA   MASK
PLOT1    LDA   (GBASL),Y  ;DATA
         EOR   COLOR      ; EOR COLOR
         AND   MASK       ;  AND MASK
         EOR   (GBASL),Y  ;   EOR DATA
         STA   (GBASL),Y  ;    TO DATA
         RTS
HLINE    JSR   PLOT       ;PLOT SQUARE
HLINE1   CPY   H2         ;DONE?
         BCS   RTS1       ; YES, RETURN
         INY              ; NO, INC INDEX (X-COORD)
         JSR   PLOT1      ;PLOT NEXT SQUARE
         BCC   HLINE1     ;ALWAYS TAKEN
VLINEZ   ADC   #$01       ;NEXT Y-COORD
VLINE    PHA              ; SAVE ON STACK
         JSR   PLOT       ; PLOT SQUARE
         PLA
         CMP   V2         ;DONE?
         BCC   VLINEZ     ; NO, LOOP
RTS1     RTS
CLRSCR   LDY   #$2F       ;MAX Y, FULL SCRN CLR
         BNE   CLRSC2     ;ALWAYS TAKEN
CLRTOP   LDY   #$27       ;MAX Y, TOP SCREEN CLR
CLRSC2   STY   V2         ;STORE AS BOTTOM COORD
                          ; FOR VLINE CALLS
         LDY   #$27       ;RIGHTMOST X-COORD (COLUMN)
CLRSC3   LDA   #$00       ;TOP COORD FOR VLINE CALLS
         STA   COLOR      ;CLEAR COLOR (BLACK)
         JSR   VLINE      ;DRAW VLINE
         DEY              ;NEXT LEFTMOST X-COORD
         BPL   CLRSC3     ;LOOP UNTIL DONE
         RTS
GBASCALC PHA              ;FOR INPUT 000DEFGH
         LSR
         AND   #$03
         ORA   #$04       ;  GENERATE GBASH=000001FG
         STA   GBASH
         PLA              ;  AND GBASL=HDEDE000
         AND   #$18
         BCC   GBCALC
         ADC   #$7F
GBCALC   STA   GBASL
         ASL
         ASL
         ORA   GBASL
         STA   GBASL
         RTS
NXTCOL   LDA   COLOR      ;INCREMENT COLOR BY 3
         CLC
         ADC   #$03
SETCOL   AND   #$0F       ;SETS COLOR=17*A MOD 16
         STA   COLOR
         ASL              ;BOTH HALF BYTES OF COLOR EQUAL
         ASL
         ASL
         ASL
         ORA   COLOR
         STA   COLOR
         RTS
SCRN     LSR              ;READ SCREEN Y-COORD/2
         PHP              ;SAVE LSB (CARRY)
         JSR   GBASCALC   ;CALC BASE ADDRESS
         LDA   (GBASL),Y  ;GET BYTE
         PLP              ;RESTORE LSB FROM CARRY
SCRN2    BCC   RTMSKZ     ;IF EVEN, USE LO H
         LSR
         LSR
         LSR              ;SHIFT HIGH HALF BYTE DOWN
         LSR
RTMSKZ   AND   #$0F       ;MASK 4-BITS
         RTS
INSDS1   LDX   PCL        ;PRINT PCL,H
         LDY   PCH
         JSR   PRYX2
         JSR   PRBLNK     ;FOLLOWED BY A BLANK
         LDA   (PCL,X)    ;GET OP CODE
INSDS2   TAY
         LSR              ;EVEN/ODD TEST
         BCC   IEVEN
         ROR              ;BIT 1 TEST
         BCS   ERR        ;XXXXXX11 INVALID OP
         CMP   #$A2
         BEQ   ERR        ;OPCODE $89 INVALID
         AND   #$87       ;MASK BITS
IEVEN    LSR              ;LSB INTO CARRY FOR L/R TEST
         TAX
         LDA   FMT1,X     ;GET FORMAT INDEX BYTE
         JSR   SCRN2      ;R/L H-BYTE ON CARRY
         BNE   GETFMT
ERR      LDY   #$80       ;SUBSTITUTE $80 FOR INVALID OPS
         LDA   #$00       ;SET PRINT FORMAT INDEX TO 0
GETFMT   TAX
         LDA   FMT2,X     ;INDEX INTO PRINT FORMAT TABLE
         STA   FORMAT     ;SAVE FOR ADR FIELD FORMATTING
         AND   #$03       ;MASK FOR 2-BIT LENGTH
                          ; (P=1 BYTE, 1=2 BYTE, 2=3 BYTE)
         STA   LENGTH
         TYA              ;OPCODE
         AND   #$8F       ;MASK FOR 1XXX1010 TEST
         TAX              ; SAVE IT
         TYA              ;OPCODE TO A AGAIN
         LDY   #$03
         CPX   #$8A
         BEQ   MNNDX3
MNNDX1   LSR
         BCC   MNNDX3     ;FORM INDEX INTO MNEMONIC TABLE
         LSR
MNNDX2   LSR              ;1) 1XXX1010->00101XXX
         ORA   #$20       ;2) XXXYYY01->00111XXX
         DEY              ;3) XXXYYY10->00110XXX
         BNE   MNNDX2     ;4) XXXYY100->00100XXX
         INY              ;5) XXXXX000->000XXXXX
MNNDX3   DEY
         BNE   MNNDX1
         RTS
         DFB   $FF,$FF,$FF
INSTDSP  JSR   INSDS1     ;GEN FMT, LEN BYTES
         PHA              ;SAVE MNEMONIC TABLE INDEX
PRNTOP   LDA   (PCL),Y
         JSR   PRBYTE
         LDX   #$01       ;PRINT 2 BLANKS
PRNTBL   JSR   PRBL2
         CPY   LENGTH     ;PRINT INST (1-3 BYTES)
         INY              ;IN A 12 CHR FIELD
         BCC   PRNTOP
         LDX   #$03       ;CHAR COUNT FOR MNEMONIC PRINT
         CPY   #$04
         BCC   PRNTBL
         PLA              ;RECOVER MNEMONIC INDEX
         TAY
         LDA   MNEML,Y
         STA   LMNEM      ;FETCH 3-CHAR MNEMONIC
         LDA   MNEMR,Y    ;  (PACKED IN 2-BYTES)
         STA   RMNEM
PRMN1    LDA   #$00
         LDY   #$05
PRMN2    ASL   RMNEM      ;SHIFT 5 BITS OF
         ROL   LMNEM      ;  CHARACTER INTO A
         ROL              ;    (CLEARS CARRY)
         DEY
         BNE   PRMN2
         ADC   #$BF       ;ADD "?" OFFSET
         JSR   COUT       ;OUTPUT A CHAR OF MNEM
         DEX
         BNE   PRMN1
         JSR   PRBLNK     ;OUTPUT 3 BLANKS
         LDY   LENGTH
         LDX   #$06       ;CNT FOR 6 FORMAT BITS
PRADR1   CPX   #$03
         BEQ   PRADR5     ;IF X=3 THEN ADDR.
PRADR2   ASL   FORMAT
         BCC   PRADR3
         LDA   CHAR1-1,X
         JSR   COUT
         LDA   CHAR2-1,X
         BEQ   PRADR3
         JSR   COUT
PRADR3   DEX
         BNE   PRADR1
         RTS
PRADR4   DEY
         BMI   PRADR2
         JSR   PRBYTE
PRADR5   LDA   FORMAT
         CMP   #$E8       ;HANDLE REL ADR MODE
         LDA   (PCL),Y    ;SPECIAL (PRINT TARGET,
         BCC   PRADR4     ;  NOT OFFSET)
RELADR   JSR   PCADJ3
         TAX              ;PCL,PCH+OFFSET+1 TO A,Y
         INX
         BNE   PRNTYX     ;+1 TO Y,X
         INY
PRNTYX   TYA
PRNTAX   JSR   PRBYTE     ;OUTPUT TARGET ADR
PRNTX    TXA              ;  OF BRANCH AND RETURN
         JMP   PRBYTE
PRBLNK   LDX   #$03       ;BLANK COUNT
PRBL2    LDA   #$A0       ;LOAD A SPACE
PRBL3    JSR   COUT       ;OUTPUT A BLANK
         DEX
         BNE   PRBL2      ;LOOP UNTIL COUNT=0
         RTS
PCADJ    SEC              ;0=1-BYTE, 1=2-BYTE
PCADJ2   LDA   LENGTH     ;  2=3-BYTE
PCADJ3   LDY   PCH
         TAX              ;TEST DISPLACEMENT SIGN
         BPL   PCADJ4     ;  (FOR REL BRANCH)
         DEY              ;EXTEND NEG BY DEC PCH
PCADJ4   ADC   PCL
         BCC   RTS2       ;PCL+LENGTH(OR DISPL)+1 TO A
         INY              ;  CARRY INTO Y (PCH)
RTS2     RTS
* FMT1 BYTES:    XXXXXXY0 INSTRS
* IF Y=0         THEN LEFT HALF BYTE
* IF Y=1         THEN RIGHT HALF BYTE
*                   (X=INDEX)
FMT1     DFB   $04,$20,$54,$30,$0D

         DFB   $80,$04,$90,$03,$22

         DFB   $54,$33,$0D,$80,$04

         DFB   $90,$04,$20,$54,$33

         DFB   $0D,$80,$04,$90,$04

         DFB   $20,$54,$3B,$0D,$80

         DFB   $04,$90,$00,$22,$44

         DFB   $33,$0D,$C8,$44,$00

         DFB   $11,$22,$44,$33,$0D

         DFB   $C8,$44,$A9,$01,$22

         DFB   $44,$33,$0D,$80,$04

         DFB   $90,$01,$22,$44,$33

         DFB   $0D,$80,$04,$90

         DFB   $26,$31,$87,$9A ;$ZZXXXY01 INSTR'S