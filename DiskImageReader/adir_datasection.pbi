; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***        Datasection        ***
; ***                           ***
; *********************************
UsePNGImageDecoder()

DataSection

CompilerIf #COMPILER_CONSOLE = #False
  Label_track_img: IncludeBinary "data/adir_track.png"
  Label_sector_img: IncludeBinary "data/adir_sector.png"
  Label_char_img_40: IncludeBinary "data/adir_char_40.png"
  Label_char_img_80: IncludeBinary "data/adir_char_80.png"
  Label_button_disk: IncludeBinary "data/adir_icone.png"
CompilerEndIf

  basic_token:
    Data.s "END","FOR ","NEXT","DATA","INPUT","DEL","DIM","READ","GR","TEXT"
    Data.s "PR#","IN#","CALL","PLOT","HLIN","VLIN","HGR2","HGR","HCOLOR=","HPLOT"
    Data.s "DRAW","XDRAW","HTAB","HOME","ROT=","SCALE=","SHLOAD","TRACE","NOTRACE","NORMAL"
    Data.s "INVERSE","FLASH","COLOR=","POP","VTAB","HIMEM:","LOMEM:","ONERR","RESUME","RECALL"
    Data.s "STORE","SPEED=","LET","GOTO","RUN","IF","RESTORE","&","GOSUB ","RETURN"
    Data.s "REM","STOP","ON","WAIT","LOAD","SAVE","DEF","POKE","PRINT","CONT"
    Data.s "LIST","CLEAR","GET","NEW","TAB(","TO","FN","SPC(","THEN","AT"
    Data.s "NOT"," STEP ","+","-","*","/","^","AND","OR",">"
    Data.s "=","<","SGN","INT","ABS","USR","FRE","SCRN(","PDL","POS"
    Data.s "SQR","RND","LOG","EXP","COS","SIN","TAN","ATN","PEEK","LEN"
    Data.s "STR$","VAL","ASC","CHR$","LEFT$","RIGHT$","MID$"
    Data.s "@@@@@"

  basic_integer_token:
    Data.s "HIMEM:","<EOL>","_ ",":","LOAD ","SAVE ","CON ","RUN "
    Data.s "RUN ","DEL ",",","NEW ","CLR ","AUTO ",",","MAN "
    Data.s "HIMEM:","LOMEM:","+","-","*","/","=","#"
    Data.s ">=",">","<=","<>","<","AND ","OR ","MOD "
    Data.s "^ ","+","(",",","THEN ","THEN ",",",","
    Data.s #QUOTE,#QUOTE,"(","!","!","(","PEEK ","RND "
    Data.s "SGN ","ABS ","PDL ","RNDX ","(","+","-","NOT "
    Data.s "(","=","#","LEN(","ASC( ","SCRN( ",",","("
    Data.s "$","$","(",",",",",";",";",";"
    Data.s ",",",",",","TEXT ","GR ","CALL ","DIM ","DIM "
    Data.s "TAB ","END ","INPUT ","INPUT ","INPUT ","FOR ","=","TO "
    Data.s "STEP ","NEXT ",",","RETURN ","GOSUB ","REM ","LET ","GOTO "
    Data.s "IF ","PRINT ","PRINT ","PRINT ","POKE ",",","COLOR= ","PLOT "
    Data.s ",","HLIN ",",","AT ","VLIN ",",","AT ","VTAB "
    Data.s "=", "=",")",")","LIST ",",","LIST ","POP "
    Data.s "NODSP ","NODSP ","NOTRACE ","DSP ","DSP ","TRACE ","PR# ","IN# "
    Data.s "@@@@@"

  ; http://6502.org/tutorials/6502opcodes.html
  ; http://en.wikibooks.org/wiki/6502_Assembly

  OPCODE_FLAG_6502:
    ; Data.s Mnemonic,Desciption
    ; Data.i Flags affected
    ; Data.i MNEMONIC(#IMM,#ZP,#ZPX,#ZPY,#ABS,#ABSX,#ABSY,#IND,#INDX,#INDY,#ACC,IMPL,#REL)

    ; Mode example
    ; ------------
    ; Immediate     ADC #$44
    ; Zero Page     STA $44
    ; Zero Page,X   STY $44,X
    ; Zero Page,Y   STX $44,Y
    ; Absolute      AND $4400
    ; Absolute,X    ASL $4400,X
    ; Absolute,Y    CMP $4400,Y
    ; Indirect      JMP ($5597)
    ; Indirect,X    EOR ($44,X)
    ; Indirect,Y    LDA ($44),Y 
    ; Accumulator   ROL
    ; Implied       BRK
    ; Relative      BPL

    Data.s "ADC","ADd with Carry"
    Data.i #FLAG_N | #FLAG_V | #FLAG_Z | #FLAG_C
    Data.i $69,$65,$75,$00,$6D,$7D,$79,$00,$61,$71,$00,$00,$00                       ; ADC
    Data.s "AND","bitwise AND With accumulator"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $29,$25,$35,$00,$2D,$3D,$39,$00,$21,$31,$00,$00,$00                       ; AND
    Data.s "ASL","Arithmetic Shift Left"
    Data.i #FLAG_N | #FLAG_Z | #FLAG_C
    Data.i $00,$06,$16,$00,$0E,$1E,$00,$00,$00,$00,$0A,$00,$00                       ; ASL
    Data.s "BIT","test BITs"
    Data.i #FLAG_N | #FLAG_V | #FLAG_Z
    Data.i $00,$24,$00,$00,$2C,$00,$00,$00,$00,$00,$00,$00,$00                       ; BIT
    ; A branch not taken requires two machine cycles. 
    ; Add one If the branch is taken and add one more if the branch crosses a page boundary. 
    Data.s "BPL","Branch on PLus"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10                       ; BPL
    Data.s "BMI","Branch on MInus"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$30                       ; BMI
    Data.s "BVC","Branch on oVerflow Clear"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$50                       ; BVC
    Data.s "BVS","Branch on oVerflow Set"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$70                       ; BVS
    Data.s "BCC","Branch on Carry Clear"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$90                       ; BCC
    Data.s "BCS","Branch on Carry Set"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$B0                       ; BCS
    Data.s "BNE","Branch on Not Equal"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$D0                       ; BNE
    Data.s "BEQ","Branch on EQual"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F0                       ; BEQ
    ; BRK causes a non-maskable interrupt And increments the program counter by one. 
    ; Therefore an RTI will go To the address of the BRK +2 so that BRK may be used 
    ; to replace a two-byte instruction For debugging And the subsequent RTI will be correct.
    Data.s "BRK","Break"
    Data.i #FLAG_B
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00                       ; BRK
    Data.s "CMP","CoMPare accumulator"
    Data.i #FLAG_N | #FLAG_Z | #FLAG_C
    Data.i $C9,$C5,$D5,$00,$CD,$DD,$D9,$00,$C1,$D1,$00,$00,$00                       ; CMP
    Data.s "CPX","ComPare X register"
    Data.i #FLAG_N | #FLAG_Z | #FLAG_C
    Data.i $E0,$E4,$00,$00,$EC,$00,$00,$00,$00,$00,$00,$00,$00
    Data.s "CPY","ComPare Y register"
    Data.i #FLAG_N | #FLAG_Z | #FLAG_C
    Data.i $C0,$C4,$00,$00,$CC,$00,$00,$00,$00,$00,$00,$00,$00
    Data.s "DEC","DECrement memory"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$C6,$D6,$00,$CE,$DE,$00,$00,$00,$00,$00,$00,$00
    Data.s "EOR","bitwise Exclusive Or"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $49,$45,$55,$00,$4D,$5D,$59,$00,$41,$51,$00,$00,$00
    ; Notes:
    ; 
    ;   The Interrupt flag is used To prevent (SEI) Or enable (CLI) maskable interrupts (aka IRQ's).
    ;   It does not signal the presence or absence of an interrupt condition. 
    ;   The 6502 will set this flag automatically in response to an interrupt and restore it to its 
    ;   prior status on completion of the interrupt service routine. 
    ;   If you want your interrupt service routine to permit other maskable interrupts, 
    ;   you must clear the I flag in your code.
    ; 
    ;   The Decimal flag controls how the 6502 adds And subtracts. If set, arithmetic is carried out 
    ;   in packed binary coded decimal. This flag is unchanged by interrupts And is unknown on power-up. 
    ;   The implication is that a CLD should be included in boot Or interrupt coding.
    ; 
    ;   The Overflow flag is generally misunderstood And therefore under-utilised. 
    ;   After an ADC Or SBC instruction, the overflow flag will be set if the twos complement result 
    ;   is less than -128 Or greater than +127, And it will cleared otherwise. 
    ;   In twos complement, $80 through $FF represents -128 through -1, 
    ;   and $00 through $7F represents 0 through +127. 
    ;
    ;   Thus, after: 
    ;    
    ;   CLC
    ;   LDA #$7F ;   +127
    ;   ADC #$01 ; +   +1
    ; 
    ; the overflow flag is 1 (+127 + +1 = +128), And after:
    ; 
    ;   CLC
    ;   LDA #$81 ;   -127
    ;   ADC #$FF ; +   -1
    ; 
    ; the overflow flag is 0 (-127 + -1 = -128). 
    ; The overflow flag is Not affected by increments, decrements, shifts And logical operations 
    ; i.e. only ADC, BIT, CLV, PLP, RTI And SBC affect it. 
    ; There is no op code To set the overflow but a BIT test on an RTS instruction will do the trick. 
    ; These instructions are implied mode, have a length of one byte and require
    ; two machine cycles.
    Data.s "CLC","CLear Carry"
    Data.i #FLAG_C
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00
    Data.s "SEC","SEt Carry"
    Data.i #FLAG_C
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$38,$00
    Data.s "CLI","CLear Interrupt"
    Data.i #FLAG_I
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$58,$00
    Data.s "SEI","SEt Interrupt"
    Data.i #FLAG_I
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$78,$00
    Data.s "CLV","CLear oVerflow"
    Data.i #FLAG_V
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$B8,$00
    Data.s "CLD","CLear Decimal"
    Data.i #FLAG_D
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$D8,$00
    Data.s "SED","SEt Decimal"
    Data.i #FLAG_D
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F8,$00
    Data.s "INC","INCrement memory"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$E6,$F6,$00,$EE,$FE,$00,$00,$00,$00,$00,$00,$00
    ; JMP transfers program execution To the following address (absolute) or to
    ; the location contained in the following address (indirect). 
    ; Note that there is no carry associated With the indirect jump so:
    ;
    ; AN INDIRECT JUMP MUST NEVER USE A
    ; VECTOR BEGINNING ON THE LAST BYTE
    ; OF A PAGE
    ;
    ; For example if address $3000 contains $40, $30FF contains $80, and $3100 contains $50, 
    ; the result of JMP ($30FF) will be a transfer of control To $4080 rather than $5080 as 
    ; you intended i.e. the 6502 took the low byte of the address from $30FF And the high byte from $3000.
    Data.s "JMP","JuMP"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$4C,$00,$00,$6C,$00,$00,$00,$00,$00
    ; JSR pushes the address-1 of the Next operation on To the stack before transferring 
    ; program control To the following address. Subroutines are normally terminated by a RTS op code. 
    Data.s "JSR","Jump to SubRoutine"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00
    Data.s "LDA","LoaD Accumulator"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $A9,$A5,$B5,$00,$AD,$BD,$B9,$00,$A1,$B1,$00,$00,$00
    Data.s "LDX","LoaD X register"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $A2,$A6,$B6,$00,$AE,$00,$BE,$00,$00,$00,$00,$00,$00
    Data.s "LDY","LoaD Y register"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $A0,$A4,$B4,$00,$AC,$BC,$00,$00,$00,$00,$00,$00,$00
    ; LSR shifts all bits right one position. 0 is shifted into bit 7
    ; and the original bit 0 is shifted into the Carry.
    Data.s "LSR","Logical Shift Right"
    Data.i #FLAG_N | #FLAG_Z | #FLAG_C
    Data.i $00,$46,$56,$00,$4E,$5E,$00,$00,$00,$00,$4A,$00,$00
    ; -------------------------------------------------------------------------------
    ; Wrap-Around
    ; 
    ; Use caution With indexed zero page operations as they are subject To wrap-around. 
    ; For example, If the X register holds $FF And you execute LDA $80,X you will not access $017F
    ; as you might expect; instead you access $7F i.e. $80-1. 
    ; This characteristic can be used to advantage but make sure your code is well commented.
    ; 
    ; It is possible, however, To access $017F when X = $FF by using the Absolute,X addressing mode 
    ; of LDA $80,X. That is, instead of:
    ; 
    ;   LDA $80,X    ; ZeroPage,X - the resulting object code is: B5 80
    ; 
    ; which accesses $007F when X=$FF, use:
    ; 
    ;   LDA $0080,X  ; Absolute,X - the resulting object code is: BD 80 00
    ; 
    ; which accesses $017F when X = $FF (a at cost of one additional byte And one additional cycle). 
    ; All of the ZeroPage,X And ZeroPage,Y instructions except STX ZeroPage,Y And STY ZeroPage,X have a 
    ; corresponding Absolute,X And Absolute,Y instruction. 
    ; Unfortunately, a lot of 6502 assemblers don't have an easy way to force Absolute addressing, 
    ; i.e. most will assemble a LDA $0080,X as B5 80. One way to overcome this is to insert the bytes 
    ; using the .BYTE pseudo-op (on some 6502 assemblers this pseudo-op is called DB or DFB, 
    ; consult the assembler documentation) as follows:
    ; 
    ;   .BYTE $BD,$80,$00  ; LDA $0080,X (absolute,X addressing mode)
    ; 
    ; The comment is optional, but highly recommended For clarity.
    ; 
    ; In cases where you are writing code that will be relocated you must consider wrap-around 
    ; when assigning dummy values For addresses that will be adjusted. 
    ; Both zero And the semi-standard $FFFF should be avoided For dummy labels. 
    ; The use of zero Or zero page values will result in assembled code With zero page opcodes 
    ; when you wanted absolute codes. With $FFFF, the problem is in addresses+1 As you wrap around To page 0.
    ; -------------------------------------------------------------------------------
    ; Program Counter
    ; 
    ; When the 6502 is ready For the Next instruction it increments the program counter before 
    ; fetching the instruction. Once it has the op code, it increments the program counter by 
    ; the length of the operand, if any. 
    ; This must be accounted For when calculating branches Or when pushing bytes To create a 
    ; false Return address (i.e. jump table addresses are made up of addresses-1 when it is 
    ; intended To use an RTS rather than a JMP).
    ; 
    ; The program counter is loaded least signifigant byte first. 
    ; Therefore the most signifigant byte must be pushed first when creating a false Return address.
    ; 
    ; When calculating branches a forward branch of 6 skips the following 6 bytes so, effectively 
    ; the program counter points To the address that is 8 bytes beyond the address of the branch opcode; 
    ;and a backward branch of $FA (256-6) goes to an address 4 bytes before the branch instruction.
    ; 
    ;  
    ; Execution Times
    ; 
    ; Op code execution times are measured in machine cycles; one machine cycle equals one clock cycle. 
    ; Many instructions require one extra cycle for execution if a page boundary is crossed
    ; these are indicated by a + following the time values shown.
    ; ------------------------------------------------------------------------------- 
    ; NOP is used to reserve space for future modifications or effectively REM out existing code.
    Data.s "NOP","No OPeration"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$EA,$00
    Data.s "ORA","bitwise OR With Accumulator"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $09,$05,$15,$00,$0D,$1D,$19,$00,$01,$11,$00,$00,$00
    ; Register Instructions
    ; These instructions are implied mode, have a length of one byte And require two machine cycles.
    Data.s "TAX","Transfer A to X"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$AA,$00
    Data.s "TXA","Transfer X to A"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8A,$00
    Data.s "DEX","DEcrement X"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CA,$00
    Data.s "INX","INcrement X"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E8,$00
    Data.s "TAY","Transfer A to Y"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$A8,$00
    Data.s "TYA","Transfer Y To A"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$98,$00
    Data.s "DEY","DEcrement Y"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$88,$00
    Data.s "INY","INcrement Y"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C8,$00
    ; ROL shifts all bits left one position. The Carry is shifted into bit 0 
    ; and the original bit 7 is shifted into the Carry.
    Data.s "ROL","ROtate Left"
    Data.i #FLAG_N | #FLAG_Z | #FLAG_C
    Data.i $00,$26,$36,$00,$2E,$3E,$00,$00,$00,$00,$2A,$00,$00
    ; ROR shifts all bits right one position. The Carry is shifted into bit 7 
    ; and the original bit 0 is shifted into the Carry.
    Data.s "ROR","ROtate Right"
    Data.i #FLAG_N | #FLAG_Z | #FLAG_C
    Data.i $00,$66,$76,$00,$6E,$7E,$00,$00,$00,$00,$6A,$00,$00
    ; RTI retrieves the Processor Status Word (flags) and the Program Counter 
    ; from the stack in that order (interrupts push the PC first And then the PSW).
    ; 
    ; Note that unlike RTS, the Return address on the stack is the actual 
    ; address rather than the address-1.
    Data.s "RTI","ReTurn from Interrupt"
    Data.i #FLAG_N | #FLAG_V | #FLAG_B | #FLAG_D | #FLAG_I | #FLAG_Z | #FLAG_C
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00
    ; RTS pulls the top two bytes off the stack (low byte first) and transfers 
    ; program control To that address+1. 
    ; It is used, As expected, to exit a subroutine invoked via JSR which pushed the address-1.
    Data.s "RTS","ReTurn from Subroutine"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$60,$00
    ; -------------------------------------------------------------------------------
    ; RTS is frequently used to implement a jump table where addresses-1 are pushed onto the stack 
    ; and accessed via RTS eg. To access the second of four routines:
    ; 
    ;  LDX #1
    ;  JSR EXEC
    ;  JMP SOMEWHERE
    ; 
    ; LOBYTE
    ;  .BYTE <ROUTINE0-1,<ROUTINE1-1
    ;  .BYTE <ROUTINE2-1,<ROUTINE3-1
    ; 
    ; HIBYTE
    ;  .BYTE >ROUTINE0-1,>ROUTINE1-1
    ;  .BYTE >ROUTINE2-1,>ROUTINE3-1
    ; 
    ; EXEC
    ;  LDA HIBYTE,X
    ;  PHA
    ;  LDA LOBYTE,X
    ;  PHA
    ;  RTS
    ; ------------------------------------------------------------------------------- 
    ; SBC results are dependant on the setting of the decimal flag. In decimal mode, 
    ; subtraction is carried out on the assumption that the values involved 
    ; are packed BCD (Binary Coded Decimal).
    ; 
    ; There is no way to subtract without the carry which works As an inverse borrow. 
    ; i.e, To subtract you set the carry before the operation. 
    ; If the carry is cleared by the operation, it indicates a borrow occurred.
    Data.s "SBC","SuBtract with Carry"
    Data.i #FLAG_N | #FLAG_V | #FLAG_Z | #FLAG_C
    Data.i $E9,$E5,$F5,$00,$ED,$FD,$F9,$00,$E1,$F1,$00,$00,$00
    Data.s "STA","STore Accumulator"
    Data.i #FLAG_0
    Data.i $00,$85,$95,$00,$8D,$9D,$99,$00,$81,$91,$00,$00,$00
    ;Stack Instructions
    ;These instructions are implied mode, have a length of one byte and require machine 
    ;cycles as indicated. The "PuLl" operations are known As "POP" on most other microprocessors. 
    ;With the 6502, the stack is always on page one ($100-$1FF) And works top down.
    Data.s "TXS","Transfer X To Stack ptr"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$9A,$00
    Data.s "TSX","Transfer Stack ptr To X"
    Data.i #FLAG_N | #FLAG_Z
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$BA,$00
    Data.s "PHA","PusH Accumulator"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$48,$00
    Data.s "PLA","PuLl Accumulator"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$68,$00
    Data.s "PHP","PusH Processor status"
    Data.i #FLAG_0
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00
    Data.s "PLP","PuLl Processor status"
    Data.i #FLAG_N | #FLAG_V | #FLAG_B | #FLAG_D | #FLAG_I | #FLAG_Z | #FLAG_C
    Data.i $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$28,$00
    Data.s "STX","STore X register"
    Data.i #FLAG_0
    Data.i $00,$86,$00,$96,$8E,$00,$00,$00,$00,$00,$00,$00,$00
    Data.s "STY","STore Y register"
    Data.i #FLAG_0
    Data.i $00,$84,$94,$00,$8C,$00,$00,$00,$00,$00,$00,$00,$00

    Data.s "@@@"

  OPCODE_CYCLE_6502:

;          |Len|Cycle|Add Cycle (add 1 cycle if page boundary crossed)|
; for       Imm   ZP    ZPX   ZPY   ABS   ABSX  ABSY  IND   INDX  INDY  ACC   IMPL  REL
    Data.i 2,2,0,2,3,0,2,4,0,0,0,0,3,4,0,3,4,1,3,4,1,0,0,0,2,6,0,2,5,1,0,0,0,0,0,0,0,0,0   ; ADC
    Data.i 2,2,0,2,2,0,2,3,0,0,0,0,3,4,0,3,4,1,3,4,1,0,0,0,2,6,0,2,5,1,0,0,0,0,0,0,0,0,0   ; AND
    Data.i 0,0,0,2,5,0,2,6,0,0,0,0,3,6,0,3,7,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0   ; ASL
    Data.i 0,0,0,2,3,0,0,0,0,0,0,0,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; BIT
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2   ; BPL
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2   ; BMI
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,0   ; BVC
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2   ; BVS
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2   ; BCC
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2   ; BCS
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2   ; BNE
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2   ; BEQ
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,7,0,0,0,0   ; BRK
    Data.i 2,2,0,2,3,0,2,4,0,0,0,0,3,4,0,3,4,1,3,4,1,0,0,0,2,6,0,2,5,1,0,0,0,0,0,0,0,0,0   ; CMP
    Data.i 2,3,0,2,3,0,0,0,0,0,0,0,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; CPX
    Data.i 2,3,0,2,3,0,0,0,0,0,0,0,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; CPY
    Data.i 0,0,0,2,5,0,2,6,0,0,0,0,3,6,0,3,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; DEC
    Data.i 2,2,0,2,3,0,2,4,0,0,0,0,3,4,0,3,4,1,3,4,1,0,0,0,2,6,0,2,5,0,0,0,0,0,0,0,0,0,0   ; EOR

    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; CLC
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; SEC
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; CLI
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; SEI
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; CLV
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; CLD
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; SED

    Data.i 0,0,0,2,5,0,2,6,0,0,0,0,3,6,0,3,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; INC
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; JMP * INDIRECT ONLY
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,3,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; JSR
    Data.i 2,2,0,2,3,0,2,4,0,0,0,0,3,4,0,3,4,1,3,4,1,0,0,0,2,6,0,2,5,1,0,0,0,0,0,0,0,0,0   ; LDA
    Data.i 2,2,0,2,3,0,2,4,0,0,0,0,3,4,0,0,0,0,3,4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; LDX
    Data.i 2,2,0,2,3,0,2,4,0,0,0,0,3,4,0,3,4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; LDY
    Data.i 0,0,0,2,5,0,2,6,0,0,0,0,3,6,0,3,7,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0   ; LSR
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; NOP
    Data.i 2,2,0,2,2,0,2,3,0,0,0,0,3,4,0,3,4,1,3,4,1,0,0,0,2,6,0,2,5,1,0,0,0,0,0,0,0,0,0   ; ORA

    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; TAX
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; TXA
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; DEX
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; INX
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; TAY
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; TYA
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; DEY
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; INY

    Data.i 0,0,0,2,5,0,2,6,0,0,0,0,3,6,0,3,7,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0   ; ROL
    Data.i 0,0,0,2,5,0,2,6,0,0,0,0,3,6,0,3,7,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0,0,0,0   ; ROR

    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,6,0,0,0,0   ; RTI
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,6,0,0,0,0   ; RTS

    Data.i 2,2,0,2,3,0,2,4,0,0,0,0,3,4,0,3,4,1,3,4,1,0,0,0,2,6,0,2,5,1,0,0,0,0,0,0,0,0,0   ; SBC
    Data.i 0,0,0,2,3,0,2,4,0,0,0,0,3,4,0,3,5,0,3,5,0,0,0,0,2,6,0,2,6,0,0,0,0,0,0,0,0,0,0   ; STA
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; TXS
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,0   ; TSX
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,0,0,0,0   ; PHA
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,4,0,0,0,0   ; PLA
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,0,0,0,0   ; PHP
    Data.i 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,4,0,0,0,0   ; PLP
    Data.i 0,0,0,2,3,0,0,0,0,2,4,0,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; STX
    Data.i 0,0,0,2,3,0,2,4,0,0,0,0,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; STY

  LABEL_6502:
; HEXA Code
; Text LABEL
; 4 lines remarks

; Soft Switches And Status Indicators
; 
; KEYBOARD = $C000 ;keyboard data (latched) (Read)
;                  ;Bit 7 is set to indicate a keypress
;                  ;is waiting, with the ASCII
;                  ;code in bits 6-0.
; 

; 
    Data.i $C000
    Data.s "KBD"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""
; SET80STORE=$C001 ;80STORE On- enable 80-column memory mapping (WR-only)
    Data.i $C001
    Data.s "SET80STORE"
    Data.s "80STORE On- enable 80-column memory mapping (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRAUXRD = $C002 ;read from main 48K (WR-only)
    Data.i $C002
    Data.s "CLRAUXRD"
    Data.s "read from main 48K (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; SETAUXRD = $C003 ;read from aux/alt 48K (WR-only)
    Data.i $C003
    Data.s "SETAUXRD"
    Data.s "read from aux/alt 48K (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRAUXWR = $C004 ;write to main 48K (WR-only)
    Data.i $C004
    Data.s "CLRAUXWR"
    Data.s "write to main 48K (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; SETAUXWR = $C005 ;write to aux/alt 48K (WR-only)
    Data.i $C005
    Data.s "SETAUXWR"
    Data.s "write to aux/alt 48K (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRCXROM = $C006 ;use ROM on cards (WR-only)
    Data.i $C006
    Data.s "CLRCXROM"
    Data.s "use ROM on cards (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; SETCXROM = $C007 ;use internal ROM (WR-only)
    Data.i $C007
    Data.s "SETCXROM"
    Data.s "use internal ROM (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRAUXZP = $C008 ;use main zero page, stack, & LC (WR-only)
    Data.i $C008
    Data.s "CLRAUXZP"
    Data.s "use main zero page, stack, & LC (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; SETAUXZP = $C009 ;use alt zero page, stack, & LC (WR-only)
    Data.i $C009
    Data.s "SETAUXZP"
    Data.s "use alt zero page, stack, & LC (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRC3ROM = $C00A ;use internal Slot 3 ROM (WR-only)
    Data.i $C00A
    Data.s "CLRC3ROM"
    Data.s "use internal Slot 3 ROM (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; SETC3ROM = $C00B ;use external Slot 3 ROM (WR-only)
    Data.i $C00B
    Data.s "SETC3ROM"
    Data.s "use external Slot 3 ROM (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLR80VID = $C00C ;disable 80-column display mode (WR-only)
    Data.i $C00C
    Data.s "CLR80VID"
    Data.s "disable 80-column display mode (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; SET80VID = $C00D ;enable 80-column display mode (WR-only)
    Data.i $C00D
    Data.s "SET80VID"
    Data.s "enable 80-column display mode (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRALTCH = $C00E ;use main char set- norm LC, Flash UC (WR-only)
    Data.i $C00E
    Data.s "CLRALTCH"
    Data.s "use main char set- norm LC, Flash UC (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; SETALTCH = $C00F ;use alt char set- norm inverse, LC; no Flash (WR-only)
    Data.i $C00F
    Data.s "SETALTCH"
    Data.s "use alt char set- norm inverse, LC; no Flash (WR-only)"
    Data.s ""
    Data.s ""
    Data.s ""
; STROBE =   $C010 ;clear bit 7 of keyboard data ($C000)
; If Read, it also provides an "any key down" flag in bit 7, With
; the keycode in the remaining bits. (These features only apply to
; the IIe and later machines.)

    Data.i $C010
    Data.s "KBDSTROBE"
    Data.s "clear bit 7 of keyboard data ($C000)"
    Data.s "If Read, it also provides an 'any key down' flag in bit 7, with"
    Data.s "the keycode in the remaining bits. (These features only apply to"
    Data.s "the IIe and later machines.)"
; 
; 
; Bit seven of these Read Status locations is 1 If the condition is true
; 
; RDLCBNK2 = $C011 ;reading from LC bank $Dx 2
    Data.i $C011
    Data.s "RDLCBNK2"
    Data.s "reading from LC bank $Dx 2"
    Data.s ""
    Data.s ""
    Data.s ""
; RDLCRAM =  $C012 ;reading from LC RAM
    Data.i $C012
    Data.s "RDLCRAM"
    Data.s "reading from LC RAM"
    Data.s ""
    Data.s ""
    Data.s ""
; RDRAMRD =  $C013 ;reading from aux/alt 48K
    Data.i $C013
    Data.s "RDRAMRD"
    Data.s "reading from aux/alt 48K"
    Data.s ""
    Data.s ""
    Data.s ""
; RDRAMWR =  $C014 ;writing to aux/alt 48K
    Data.i $C014
    Data.s "RDRAMWR"
    Data.s "writing to aux/alt 48K"
    Data.s ""
    Data.s ""
    Data.s ""
; RDCXROM =  $C015 ;using internal Slot ROM
    Data.i $C015
    Data.s "RDCXROM"
    Data.s "using internal Slot ROM"
    Data.s ""
    Data.s ""
    Data.s ""
; RDAUXZP =  $C016 ;using Slot zero page, stack, & LC
    Data.i $C016
    Data.s "RDAUXZP"
    Data.s "using Slot zero page, stack, & LC"
    Data.s ""
    Data.s ""
    Data.s ""
; RDC3ROM =  $C017 ;using external (Slot) C3 ROM
    Data.i $C017
    Data.s "RDC3ROM"
    Data.s "using external (Slot) C3 ROM"
    Data.s ""
    Data.s ""
    Data.s ""
; RD80COL =  $C018 ;80STORE is On- using 80-column memory mapping
    Data.i $C018
    Data.s "RD80COL"
    Data.s "80STORE is On- using 80-column memory mapping"
    Data.s ""
    Data.s ""
    Data.s ""
; RDVBLBAR = $C019 ;not VBL (VBL signal low)
    Data.i $C019
    Data.s "RDVBLBAR"
    Data.s "not VBL (VBL signal low)"
    Data.s ""
    Data.s ""
    Data.s ""
; RDTEXT =   $C01A ;using text mode
    Data.i $C01A
    Data.s "RDTEXT"
    Data.s "using text mode"
    Data.s ""
    Data.s ""
    Data.s ""
; RDMIXED =  $C01B ;using mixed mode
    Data.i $C01B
    Data.s "RDMIXED"
    Data.s "using mixed mode"
    Data.s ""
    Data.s ""
    Data.s ""
; RDPAGE2 =  $C01C ;using text/graphics page2
    Data.i $C01C
    Data.s "RDPAGE2"
    Data.s "using text/graphics page2"
    Data.s ""
    Data.s ""
    Data.s ""
; RDHIRES =  $C01D ;using Hi-res graphics mode
    Data.i $C01D
    Data.s "RDHIRES"
    Data.s "using Hi-res graphics mode"
    Data.s ""
    Data.s ""
    Data.s ""
; RDALTCH =  $C01E ;using alternate character set
    Data.i $C01E
    Data.s "RDALTCH"
    Data.s "using alternate character set"
    Data.s ""
    Data.s ""
    Data.s ""
; RD80VID =  $C01F ;using 80-column display mode
    Data.i $C01F
    Data.s "RD80VID"
    Data.s "using 80-column display mode"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; TAPEOUT =  $C020 ;toggle the cassette output
    Data.i $C020
    Data.s "TAPEOUT"
    Data.s "toggle the cassette output"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; SPEAKER =  $C030 ;toggle speaker diaphragm
    Data.i $C030
    Data.s "SPKR"
    Data.s "toggle speaker diaphragm"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; STROBE =   $C040 ;generate .5 uS low pulse @ Game pin 5
; If Read, you get one half-microsecond low pulse on the Game I/O
; STROBE pin; if write, you get two pulses. (IIe and ][+ only, not
; available on the IIgs).
    Data.i $C040
    Data.s "STROBEGAMEIO"
    Data.s "generate .5 uS low pulse @ Game pin 5"
    Data.s "If Read, you get one half-microsecond low pulse on the Game I/O"
    Data.s "STROBE pin; if write, you get two pulses. (IIe and ][+ only, not"
    Data.s "available on the IIgs)."
; 
; CLRTEXT =  $C050 ;display graphics
    Data.i $C050
    Data.s "CLRTEXT"
    Data.s "display graphics"
    Data.s ""
    Data.s ""
    Data.s ""
; SETTEXT =  $C051 ;display text
    Data.i $C051
    Data.s "SETTEXT"
    Data.s "display text"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; CLRMIXED = $C052 ;clear mixed mode- enable full graphics
    Data.i $C052
    Data.s "CLRMIXED"
    Data.s "clear mixed mode- enable full graphics"
    Data.s ""
    Data.s ""
    Data.s ""
; SETMIXED = $C053 ;enable graphics/text mixed mode
    Data.i $C053
    Data.s "SETMIXED"
    Data.s "enable graphics/text mixed mode"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; PAGE1 =    $C054 ;select text/graphics page1
    Data.i $C054
    Data.s "PAGE1"
    Data.s "select text/graphics page1"
    Data.s ""
    Data.s ""
    Data.s ""
; PAGE2 =    $C055 ;select text/graphics page2
; See IIe, IIc, IIgs manual For details on how these switches
; affect 80-col bank selection.
    Data.i $C055
    Data.s "PAGE2"
    Data.s "select text/graphics page2"
    Data.s "See IIe, IIc, IIgs manual For details on how these switches"
    Data.s "affect 80-col bank selection."
    Data.s ""
; 
; CLRHIRES = $C056 ;select Lo-res
    Data.i $C056
    Data.s "CLRHIRES"
    Data.s "select Lo-res"
    Data.s ""
    Data.s ""
    Data.s ""
; SETHIRES = $C057 ;select Hi-res
    Data.i $C057
    Data.s "SETHIRES"
    Data.s "select Hi-res"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; SETAN0 =   $C058 ;Set annunciator-0 output to 0
    Data.i $C058
    Data.s "SETAN0"
    Data.s "Set annunciator-0 output to 0"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRAN0 =   $C059 ;Set annunciator-0 output to 1
    Data.i $C059
    Data.s "CLRAN0"
    Data.s "Set annunciator-0 output to 1"
    Data.s ""
    Data.s ""
    Data.s ""
; SETAN1 =   $C05A ;Set annunciator-1 output to 0
    Data.i $C05A
    Data.s "SETAN1"
    Data.s "Set annunciator-1 output to 0"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRAN1 =   $C05B ;Set annunciator-1 output to 1
    Data.i $C05B
    Data.s "CLRAN1"
    Data.s "Set annunciator-1 output to 1"
    Data.s ""
    Data.s ""
    Data.s ""
; SETAN2 =   $C05C ;Set annunciator-2 output to 0
    Data.i $C05C
    Data.s "SETAN2"
    Data.s "Set annunciator-2 output to 0"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRAN2 =   $C05D ;Set annunciator-2 output to 1
    Data.i $C05D
    Data.s "CLRAN2"
    Data.s "Set annunciator-2 output to 1"
    Data.s ""
    Data.s ""
    Data.s ""
; SETAN3 =   $C05E ;Set annunciator-3 output to 0
    Data.i $C05E
    Data.s "SETAN3"
    Data.s "Set annunciator-3 output to 0"
    Data.s ""
    Data.s ""
    Data.s ""
; SETDHIRES= $C05E ;if IOUDIS Set, turn on double-hires
    Data.i $C05E
    Data.s "SETDHIRES"
    Data.s "if IOUDIS Set, turn on double-hires"
    Data.s ""
    Data.s ""
    Data.s ""
; CLRAN3 =   $C05F ;Set annunciator-3 output to 1
    Data.i $C05F
    Data.s "CLRAN3"
    Data.s "Set annunciator-3 output to 1"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; TAPEIN =   $C060 ;bit 7 = data from cassette on Apple II,
; Or PB3           ;II+, IIe. On IIgs bit 7 reflects the
;                  ;status of Game Port Pushbutton 3--
;                  ;closed= 1. (read)
    Data.i $C060
    Data.s "TAPEIN"
    Data.s "bit 7 = data from cassette on Apple II,"
    Data.s "II+, IIe. On IIgs bit 7 reflects the"
    Data.s "status of Game Port Pushbutton 3--"
    Data.s "closed= 1. (read)"
; 
; OPNAPPLE = $C061 ;open apple (command) key data (read)
    Data.i $C061
    Data.s "OPNAPPLE"
    Data.s "open apple (command) key data (read)"
    Data.s ""
    Data.s ""
    Data.s ""
; CLSAPPLE = $C062 ;closed apple (option) key data (read)
; These are actually the first two game Pushbutton inputs (PB0
; And PB1) which are borrowed by the Open Apple And Closed Apple
; keys. Bit 7 is set (=1) in these locations If the game switch Or
; corresponding key is pressed.
    Data.i $C062
    Data.s "CLSAPPLE"
    Data.s "closed apple (option) key data (read)"
    Data.s "These are actually the first two game Pushbutton inputs (PB0 and PB11)"
    Data.s "hich are borrowed by the Open Apple And Closed Apple keys. Bit 7 is set (=1)"
    Data.s "in these locations if the game switch or corresponding key is pressed."
; 
; PB2 =      $C063 ;game Pushbutton 2 (read)
; This input has an option To be connected To the shift key on
; the keyboard. (See info on the 'shift key mod'.)
    Data.i $C063
    Data.s "PB2"
    Data.s "game Pushbutton 2 (read)"
    Data.s "This input has an option To be connected To the shift key on"
    Data.s "the keyboard. (See info on the 'shift key mod'.)"
    Data.s ""
; 
; PADDLE0 =  $C064 ;bit 7 = status of pdl-0 timer (read)
    Data.i $C064
    Data.s "PADDLE0"
    Data.s "bit 7 = status of pdl-0 timer (read)"
    Data.s ""
    Data.s ""
    Data.s ""
; PADDLE1 =  $C065 ;bit 7 = status of pdl-1 timer (read)
    Data.i $C065
    Data.s "PADDLE1"
    Data.s "bit 7 = status of pdl-1 timer (read)"
    Data.s ""
    Data.s ""
    Data.s ""
; PADDLE2 =  $C066 ;bit 7 = status of pdl-2 timer (read)
    Data.i $C066
    Data.s "PADDLE2"
    Data.s "bit 7 = status of pdl-2 timer (read)"
    Data.s ""
    Data.s ""
    Data.s ""
; PADDLE3 =  $C067 ;bit 7 = status of pdl-3 timer (read)
    Data.i $C067
    Data.s "PADDLE3"
    Data.s "bit 7 = status of pdl-3 timer (read)"
    Data.s ""
    Data.s ""
    Data.s ""
; PDLTRIG =  $C070 ;trigger paddles
; Read this To start paddle countdown, then time the period Until
; $C064-$C067 bit 7 becomes set To determine the paddle position.
; This takes up To three milliseconds If the paddle is at its maximum
; extreme (reading of 255 via the standard firmware routine).
    Data.i $C070
    Data.s "PDLTRIG"
    Data.s "trigger paddles"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; SETIOUDIS= $C07E ;enable DHIRES & disable $C058-5F (W)
; CLRIOUDIS= $C07E ;disable DHIRES & enable $C058-5F (W)
    Data.i $C07E
    Data.s "SETIOUDIS/CLRIOUDIS"
    Data.s "enable/disable DHIRES & disable $C058-5F (W)"
    Data.s ""
    Data.s ""
    Data.s ""
; 
; 
; "Language Card" area Switches
; Bank 1 And Bank 2 here are the 4K banks at $D000-$DFFF. The
; remaining area from $E000-$FFFF is the same For both
; sets of switches.
; 
;            $C080 ;LC RAM bank2, Read and WR-protect RAM
; ROMIN =    $C081 ;LC RAM bank2, Read ROM instead of RAM,
;                  ;two or more successive reads WR-enables RAM
;            $C082 ;LC RAM bank2, Read ROM instead of RAM,
;                  ;WR-protect RAM
; LCBANK2 =  $C083 ;LC RAM bank2, Read RAM
;                  ;two or more successive reads WR-enables RAM
;            $C088 ;LC RAM bank1, Read and WR-protect RAM
;            $C089 ;LC RAM bank1, Read ROM instead of RAM,
;                  ;two or more successive reads WR-enables RAM
;            $C08A ;LC RAM bank1, Read ROM instead of RAM,
;                  ;WR-protect RAM
; LCBANK1 =  $C08B ;LC RAM bank1, Read RAM
;                  ;two or more successive reads WR-enables RAM
;            $C084-$C087 are echoes of $C080-$C083
;            $C08C-$C08F are echoes of $C088-$C08B
; 
; 
; CLRC8ROM = $CFFF ;disable Slot card C8 ROM
; Reading any location from $Cn00-$CnFF (where n is the Slot) will
; enable the $C800-$CFFF area For that card, If the card supports
; this feature. Reading $CFFF disables this area For all cards.
; 
; 
; Example: To enable double Hi-res graphics, the following code will
; accomplish this:
; 
; STA SETHIRES
; STA SETAN3
; STA CLRMIXED
; STA CLRTEXT
; JSR $C300
; 
; 
; --kburtch@pts.mot.com, David Empson, Rubywand
; 
; ----------------------------
; 
; 
; The following is a List of PEEKs, POKEs And Pointers in the zero page area. Most of the information comes from the Beagle Bros chart (1982).
; 
; FP= "floating point"= Applesoft BASIC   INT= Integer BASIC
; Note: Text window And related settings refer To 40-column mode
; 
; Decimal | Hexadecimal |
; -----------------------------------------------------------------------------
; 32      | $20         | Text window left-edge (0-39)
    Data.i $20
    Data.s "TXTWIN-LEFT"
    Data.s "Text window left-edge (0-39)"
    Data.s ""
    Data.s ""
    Data.s ""

; 33      | $21         | Text window width (1-40)
    Data.i $21
    Data.s "TXTWIN-WIDTH"
    Data.s "Text window width (1-40)"
    Data.s ""
    Data.s ""
    Data.s ""
; 34      | $22         | Text window top-edge (0-23)
    Data.i $22
    Data.s "TXTWIN-TOP"
    Data.s "Text window top-edge (0-23)"
    Data.s ""
    Data.s ""
    Data.s ""
; 35      | $23         | Text window bottom (1-24)
    Data.i $23
    Data.s "TXTWIN-BOTTOM"
    Data.s "Text window bottom (1-24)"
    Data.s ""
    Data.s ""
    Data.s ""
; 36      | $24         | Horizontal cursor-position (0-39)
    Data.i $24
    Data.s "HCURSORPOS"
    Data.s "Horizontal cursor-position (0-39)"
    Data.s ""
    Data.s ""
    Data.s ""
; 37      | $25         | Vertical cursor-position (0-23)
    Data.i $25
    Data.s "VCURSORPOS"
    Data.s "Vertical cursor-position (0-23)"
    Data.s ""
    Data.s ""
    Data.s ""
; 43      | $2B         | Boot slot * 16 (after boot only)
    Data.i $2B
    Data.s "BOOTSLOT"
    Data.s "Boot slot * 16 (after boot only)"
    Data.s ""
    Data.s ""
    Data.s ""
; 44      | $2C         | Lo-res line End-point
    Data.i $2C
    Data.s "LORESLINE"
    Data.s "Lo-res line End-point"
    Data.s ""
    Data.s ""
    Data.s ""
; 48      | $30         | Lo-res COLOR * 17
    Data.i $30
    Data.s "LORESCOLOR"
    Data.s "Lo-res COLOR * 17"
    Data.s ""
    Data.s ""
    Data.s ""
; 50      | $32         | Text output format [63=INVERSE 255=NORMAL 127=FLASH]
    Data.i $32
    Data.s "TEXTOUTPUT-FORMAT"
    Data.s "Text output format [63=INVERSE 255=NORMAL 127=FLASH]"
    Data.s ""
    Data.s ""
    Data.s ""
; 51      | $33         | Prompt-character (NOTE: POKE 51,0:Goto LINE # will
;         |             | sometimes prevent a false Not DIRECT COMMAND 
;         |             | obtained With Goto # alone.)
    Data.i $33
    Data.s "PROMPTCHAR"
    Data.s "Prompt-character (NOTE: POKE 51,0:Goto LINE # will"
    Data.s "sometimes prevent a false Not DIRECT COMMAND"
    Data.s "obtained With Goto # alone.)"
    Data.s ""
; 74-75   | $4A-$4B     | LOMEM address (INT)
; 76-77   | $4C-$4D     | HIMEM address (INT)
; 78-79   | $4E-$4F     | Random-Number Field
; 103-104 | $67-$68     | Start of Applesoft program- normally set To $801
;         |             | (2049 decimal) And location $800 is set To $00. 
;         |             | NOTE: To load a program above hires page 1 (at
;         |             | $4001), POKE 103,1: POKE 104,64: POKE 16384,0  
;         |             | And LOAD the program.
; 105-106 | $69-$6A     | LOMEM Start of varible space & End of Applesoft prgm
; 107-108 | $6B-$6C     | Start of Array Space  (FP)
; 109-110 | $6D-$6E     | End of Array Space  (FP)
; 111-112 | $6F-$70     | Start of string-storage  (FP)
; 115-116 | $73-$74     | HIMEM- the highest available Applesoft address +1
; 117-118 | $75-$76     | Line# being executed.  (FP)
; 119-120 | $77-$78     | Line# where program stopped.  (FP)
; 121-122 | $79-$7A     | Address of line executing.  (FP)
; 123-124 | $7B-$7C     | Current Data line#
; 125-126 | $7D-$7E     | Next Data address
; 127-128 | $7F-$80     | INPUT Or Data address
; 129-130 | $81-$82     | Var.last used. VAR$=CHR$(PEEK(129))+CHR$(PEEK(130))
; 131-132 | $83-$84     | Last-Used-Varible Address  (FP)
; 175-176 | $AF-$B0     | End of Applesoft Program (Normally=LOMEM)
; 202-203 | $CA-$CB     | Start of Program Address (INT)
; 204-205 | $CC-CD      | End of Varible Storage (INT)
; 214     | $D6         | RUN Flag (POKE 214,255 sets Applesoft run-only.)
    Data.i $D6
    Data.s "RUN-FLAG"
    Data.s "RUN Flag (POKE 214,255 sets Applesoft run-only.)"
    Data.s ""
    Data.s ""
    Data.s ""
; 216     | $D8         | ONERR Flag (POKE 216,0 cancels ONERR; en norm errs)
    Data.i $DA
    Data.s "ONERR-FLAG"
    Data.s "ONERR Flag (POKE 216,0 cancels ONERR; en norm errs)"
    Data.s ""
    Data.s ""
    Data.s ""
; 218-219 | $DA-$DB     | Line# of ONERR Error
    Data.i $DA
    Data.s "HI-LINE-ERROR"
    Data.s "High Line# of ONERR Error"
    Data.s ""
    Data.s ""
    Data.s ""

    Data.i $DB
    Data.s "LO-LINE-ERROR"
    Data.s "Low Line# of ONERR Error"
    Data.s ""
    Data.s ""
    Data.s ""
; 222     | $DE         | Error Code  (FP)
    Data.i $DE
    Data.s "EOOROCODE"
    Data.s "Error Code  (FP)"
    Data.s ""
    Data.s ""
    Data.s ""
; 224-225 | $E0-$E1     | Horizontal Coordinate of HPLOT
; 226     | $E2         | Vertical Coordinate of HPLOT
; 232-233 | $E8-$E9     | Start address of Shape Table
; 241     | $F1         | 256 - SPEED value (SPEED=255 --> $F1: 01)  (FP)
    Data.i $F1
    Data.s "SPEEDVALUE"
    Data.s "256 - SPEED value (SPEED=255 --> $F1: 01)  (FP)"
    Data.s ""
    Data.s ""
    Data.s ""
; 250-254 | $FA-$FE     | Free Space (normally open To user)
; 
; --Jon Relay And Apple II Textfiles ( http://www.textfiles.com/apple/ ).
; 
; ----------------------------
; 
; 
; Useful CALLs
; 
; Example: from the BASIC prompt, CALL -151 enters the monitor.
; 
;  Hex   Dec
; $BEF8 48888  ProDOS- recovers from "NO BUFFERS AVAILABLE" error
; $D683 54915  Inits Applesoft stack- scraps false "OUT OF MEMORY" error.
; $F328 -3288  Repairs Applesoft stack after an ONERR Goto handles an error.
; $F3D4 -3116  HGR2
    Data.i $F3D4
    Data.s "HGR2"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""
; $F3DE -3106  HGR
    Data.i $F3DE
    Data.s "HGR"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""
; $F3F2 -3086  Clear HI-RES screen To Black
    Data.i $F3F2
    Data.s "CLEAR-HIRES-BLACK"
    Data.s "Clear HI-RES screen To Black"
    Data.s ""
    Data.s ""
    Data.s ""
; $F3F6 -3082  Clear HI-RES screen To recent HCOLOR
    Data.i $F3F6
    Data.s "CLEAR-HIRES-HCOLOR"
    Data.s "Clear HI-RES screen To recent HCOLOR"
    Data.s ""
    Data.s ""
    Data.s ""
; $F5CB -2613  Move HI-RES cursor coords To 224-226
; $F800 -2048  PLOT a LO-RES Point (AC:Y-COORD  Y:X-COORD)
; $F819 -2023  DRAW a HORIZONTAL LO-RES LINE.
; $F828 -2008  DRAW a VERTICAL LO-RES LINE.
; $F832 -1998  CLEAR LO-RES SCREEN 1 And set GRAPHICS mode.
; $F836 -1994  CLEAR top 20 lines of LO-RES Graphics
; $F847 -1977  CALCULATE LO-RES Graphics base ADDRESS.
; $F85F -1953  Change LO-RES COLOR To COLOR + 3
; $F940 -1728  PRINT contents of X & Y (REG 9 As 4 HEX digits)
; $F94C -1716  PRINT X BLANKS (X REG contains # To PRINT)
; $FA86 -1402  IRQ HANDLER
; $FA92 -1390  Break HANDLER
; $FAA6 -1370  RE-BOOTS DISK SYSTEM
; $FAD7 -1321  To display USER REGISTERS
; $FB2F -1233  TEXT- screen init
    Data.i $FB2F
    Data.s "INIT"
    Data.s "TEXT- screen init"
    Data.s ""
    Data.s ""
    Data.s ""
; $FB39 -1223  set SCREEN To TEXT mode
; $FB40 -1216  GR- set GRAPHICS mode
; $FB4B -1205  set NORMAL WINDOW
; $FB5B -1189  TABV (Set VTAB with Accumulator)
    Data.i $FB5B
    Data.s "TABV"
    Data.s "TABV (Set VTAB with Accumulator)"
    Data.s ""
    Data.s ""
    Data.s ""
; $FB60 -1184  Prints the 'Apple ][' at the top of your screen.
; $FBC1 -1087  CALCULATE TEXT BASE ADDRESS
; $FBE4 -1052  SOUND BELL
; $FBF4 -1036  To MOVE CURSOR RIGHT
; $FBFD -1027  OUTPUT A-REG As ASCII on TEXT SCREEN 1
; $FC10 -1008  To MOVE CURSOR LEFT
; $FC1A  -998  To MOVE CURSOR UP
; $FC22  -990  PERFORM a VERTICAL TAB To ROW in ACCUMULATOR
; $FC2C  -980  PREFORM ESCAPE FUNCTION
; $FC42  -958  CLEAR from CURSOR To End of PAGE (ESC -F)
; $FC58  -936  HOME & CLEAR SCREEN (Destroys ACCUMULATOR & Y-REG)
    Data.i $FC58
    Data.s "HOME"
    Data.s "HOME & CLEAR SCREEN (Destroys ACCUMULATOR & Y-REG)"
    Data.s ""
    Data.s ""
    Data.s ""
; $FC62  -926  PERFORM a CARRIAGE Return
; $FC66  -922  PERFORM a LINE FEED
; $FC70  -912  SCOLL UP 1 Line (Destroys ACCUMULATOR & Y-REG)
; $FC95  -875  Clear entire Text line.
; $FC9C  -868  CLEAR from CURSOR To End of Line (ESC-E)
    Data.i $FCA8
    Data.s "WAIT"
    Data.s "Delay"
    Data.s ""
    Data.s ""
    Data.s ""
; $FDOC  -756  GET KEY from KEYBOARD (Destroys A & Y-REG) WAIT For KEY PRESS.
    Data.i $FD0C
    Data.s "GETKEY"
    Data.s "GET KEY from KEYBOARD (Destroys A & Y-REG) WAIT For KEY PRESS."
    Data.s ""
    Data.s ""
    Data.s ""
; $FD5A  -678  Wait For Return
    Data.i $FD5A
    Data.s "WAITFORRETURN"
    Data.s "Wait For Return"
    Data.s ""
    Data.s ""
    Data.s ""
; $FD5C  -676  Sound Bell And wait For Return
    Data.i $FD5C
    Data.s "BELL-WAITRET"
    Data.s "Sound Bell And wait For Return"
    Data.s ""
    Data.s ""
    Data.s ""
; $FD67  -665  PREFORM CARRIAGE Return & GET LINE of TEXT.
    Data.i $FD67
    Data.s "CR-GETTEXTLINE"
    Data.s "PREFORM CARRIAGE Return & GET LINE of TEXT"
    Data.s ""
    Data.s ""
    Data.s ""
; $FD6A  -662  GET LINE of TEXT from KEYBOARD (X RETND With # of CHARACTERS)
    Data.i $FD6A
    Data.s "GETTEXTLINE"
    Data.s "GET LINE of TEXT from KEYBOARD (X RETND With # of CHARACTERS)"
    Data.s ""
    Data.s ""
    Data.s ""
; $FD6F  -657  INPUT which accepts commas & colons. Here is an example:
;              PRINT "NAME (LAST, FIRST): ";: CALL-657: N$="": FOR X= 512 TO 719
;              : IF PEEK (X) < > 141 THEN N$= N$ + CHR$ (PEEK (X) -128): NEXT X
    Data.i $FD6F
    Data.s "INPUT"
    Data.s "INPUT which accepts commas & colons"
    Data.s "Here is an example:"
    Data.s "PRINT "+#QUOTE+"NAME (LAST, FIRST): "+#QUOTE+";: CALL-657: N$="+#QUOTE+#QUOTE+": FOR X= 512 TO 719"
    Data.s ": IF PEEK (X) < > 141 THEN N$= N$ + CHR$ (PEEK (X) -128): NEXT X"
; 
; $FD8E  -626  PRINT CARRIAGE Return (Destroys ACCUMULATOR & Y-REG)
    Data.i $FD8E
    Data.s "PRINTCR"
    Data.s "PRINT CARRIAGE Return (Destroys ACCUMULATOR & Y-REG)"
    Data.s ""
    Data.s ""
    Data.s ""
; $FDDA  -550  PRINT CONTENTS of ACCUMULATOR As 2 HEX DIGETS.
    Data.i $FDDA
    Data.s "PRINTACC"
    Data.s "PRINT CONTENTS of ACCUMULATOR As 2 HEX DIGETS."
    Data.s ""
    Data.s ""
    Data.s ""
; $FDE3  -541  PRINT a HEX digit
    Data.i $FDE3
    Data.s "PRINTHEX"
    Data.s "PRINT a HEX digit"
    Data.s ""
    Data.s ""
    Data.s ""
; $FDED  -531  OUTPUT CHARACTER IN ACCUMULATOR. (Destroys A & Y-REG COUNT)
    Data.i $FDED
    Data.s "COUT"
    Data.s "OUTPUT CHARACTER IN ACCUMULATOR. (Destroys A & Y-REG COUNT)"
    Data.s ""
    Data.s ""
    Data.s ""
; $FDF0  -528  GET MONITOR CHARACTER OUTPUT
; $FE2C  -468  PERFORM MEMORY MOVE A1-A2 To A4. Here is an example:
;              10 POKE 60,Source Start address Lo
;              20 POKE 61,Source Start address Hi
;              30 POKE 62,Source End address Lo
;              40 POKE 63,Source End address Hi
;              50 POKE 66,Destination address Lo
;              60 POKE 67,Destination address Hi
;              70 CALL -468
; 
; $FE80  -384  set INVERSE mode
    Data.i $FE80
    Data.s "INVERSE"
    Data.s "Set INVERSE mode"
    Data.s ""
    Data.s ""
    Data.s ""
; $FE84  -380  set NORMAL mode
    Data.i $FE84
    Data.s "NORMAL"
    Data.s "Set NORMAL mode"
    Data.s ""
    Data.s ""
    Data.s ""
;
    Data.i $FE89
    Data.s "SETKBD"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""
;
    Data.i $FE93
    Data.s "SETVID"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""
;
    Data.i $FE95
    Data.s "OUTPORT"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""
; $FEBF  -321  DISPLAY A,S,Y,P,S REG. (CURRENT VALUES)
; $FF2D  -211  PRINT "ERR" & SOUNDS BELL (Destroys ACCUMULATOR & Y-REG)
; $FF3A  -198  PRINT BELL (Destroys ACCUMULATOR & Y-REG)
; $FF59  -167  ENTER MONITOR RESET, TEXT mode, "COLD START"
; $FF65  -155  ENTER MONITOR, ring BELL, "WARM START"
; $FF69  -151  Go To MONITOR
; $FF70  -144  SCAN INPUT BUFFER (ADDRESS $200...)
;
    Data.i $FFFC
    Data.s "RESETV"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""

; END = $FFFF
    Data.i $FFFF
    Data.s "END"
    Data.s ""
    Data.s ""
    Data.s ""
    Data.s ""
EndDataSection
; IDE Options = PureBasic 4.30 (Linux - x86)
; CursorPosition = 1019
; FirstLine = 1012
; Folding = -
; DisableDebugger
; CompileSourceDirectory