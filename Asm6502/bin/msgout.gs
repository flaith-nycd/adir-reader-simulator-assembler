         AST   32
*                              *
*         PRINTSTRING          *
*                              *
*     BY  ANDY HERTZFELD       *
*                              *
* PRINTSTRING is always init-  *
* ialized with a JSR to MSGOUT *
* then followed (usually) with *
* HEX 8D (for a carriage rtn), *
* then the ASCII message.  The *
* ASCII must be terminated     *
* with a HEX 00.               *
*                              *
         AST   32
*
*
*
TEMP     EQU   0
COUT     EQU   $FDED
*
*
*
* Andy Hertzfeld's famous and handy l'il
*  string printing routine.
*
*
MSGOUT   PLA              ;PULL LO BYTE OF RTS OFF STACK
         STA   TEMP       ;SAVE IT
         PLA              ;PULL HI BYTE
         STA   TEMP+1     ;AND SAVE IT TOO
         LDY   #0         ;TO INDEX STRING
LOOP     INC   TEMP       ;ADVANCE RTS ADR FOR EACH CHR
         BNE   SKIPADD    ;IF IT'S ZERO THEN WE GOTTA
         INC   TEMP+1     ;INCREMENT THE HI BYTE
SKIPADD  LDA   (TEMP),Y   ;GET A CHR FROM ASCII STRING
         BEQ   MSGRTS     ;IF CHR=0, END OF STRING
         ORA   #$80       ;IF STD ASCII CONV TO NEG FOR COUT
         JSR   COUT       ;OUTPUT THE CHR
         JMP   LOOP       ;GET A NEW CHR
MSGRTS   LDA   TEMP+1     ;GET HI BYTE OF RTS
         PHA              ;PUSH IT BACK ON STACK
         LDA   TEMP       ;FETCH NEW LO BYTE OF RTS
         PHA              ;AND PUT IT ON THE STACK
         RTS              ;NOW WE KNOW WHERE WE'RE GOING
*
*
         AST   32
*                              *
* If this subroutine is to be  *
* used with FLS or INV, then   *
* all normal ASCII must have   *
* the high bit set, i.e., with *
* the " as a delimiter, not '. *
*                              *
* In addition, delete the line *
* "ORA #$80".                  *
*                              *
         AST   32


         AST   32
*                              *
* CHRIN: Keyboard read routine *
*                              *
* Gets a single character from *
* keyboard input and returns   *
* it in the accumulator.       *
*                              *
         AST   32
*
*
KEYBRD   EQU   $C000
STROBE   EQU   $C010
*
CHRIN    BIT   STROBE     ;RESET KEYBOARD STROBE
KEY      BIT   KEYBRD     ;CHECK FOR KEYPRESS
         BPL   KEY        ;NO, NOT YET
         LDA   KEYBRD     ;YES, SAVE IN ACC
         BIT   STROBE     ;CLEAR IT
         JSR   COUT       ;PRINT IT
         RTS              ;DONE


         AST   32
*                              *
* MSGIN: This routine gets a   *
* string of ASCII characters   *
* representing the user's hex  *
* input, converts each two     *
* characters to a single byte, *
* which is returned in A2L.    *
*                              *
         AST   32
*
*
A2L      EQU   $3E
PROMPT   EQU   $33
GETLN    EQU   $FD6A
CROUT    EQU   $FD8E
GETNUM   EQU   $FFA7
ZMODE    EQU   $FFC7
*
MSGIN    LDA   #" "       ;BLANK OUT PROMPT
         STA   PROMPT
         JSR   GETLN      ;MONITOR INPUT ROUTINE
         JSR   ZMODE      ;INITIALIZE FOR HEX INPUT
         JSR   GETNUM     ;CLEAR A2, THEN GET CHR FM KBD BUF
         JSR   CROUT      ;PRINT A C/R
         LDA   A2L        ;GET CONVERTED DATA
         RTS              ;DONE
