Procedure PrintOPC_MNEMONIC()
Protected i.i

  PrintN("Opcodes & Mnemonics")
  
  ; Address Modes and Object Sizes
  ; ------------------------------
  ;A	        the accumulator (a literal character 'A')		
  ;
  ;val8	      an 8-bit value		
  ;
  ;addr8	    an 8-bit zero-page address (a direct address). 
  ;           The full 16-bit address of the operand is $00addr8		
  ;
  ;(addr8i)   two consecutive zero-page addresses, addr8i and addr8i+1
  ;           which together contain the 16-bit address of the operand byte 
  ;           in low byte/high byte form (an indirect address)		
  ;
  ;addr16     a 16-bit address anywhere in memory (a direct address)		
  ;
  ;(addr16i)	two consecutive addresses anywhere in memory, addr16i and addr16i+1
  ;           which together contain a 16-bit address in low byte/high byte form 
  ;           to be loaded into the program counter (an indirect address)		
				
  ; Mode						            Source Form				    Object Form				      #Bytes	16-Bit Effective Address
  
  ; Accumulator					        mnemonic 'A'			    opcode					        1		    n/a
  ; Immediate					          mnemonic #val8			  opcode val8				      2   		n/a
  ; Zero Page					          mnemonic addr8			  opcode addr8			      2		    $00addr8
  ; Zero Page X-Indexed			    mnemonic addr8,X		  opcode addr8			      2		    $00addr8+X
  ; Zero Page Y-Indexed			    mnemonic addr8,Y		  opcode addr8			      2		    $00addr8+Y
  ; Absolute					          mnemonic addr16			  opcode <addr16>addr16	  3		    addr16
  ; Absolute X-Indexed			    mnemonic addr16,X		  opcode <addr16>addr16	  3		    addr16+X
  ; Absolute Y-Indexed			    mnemonic addr16,Y		  opcode <addr16>addr16	  3		    addr16+Y
  ; Implied						          mnemonic				      opcode					        1		    n/a
  ; Relative					          mnemonic val8			    opcode val8				      2		    PC+val8 (sign extended)
  ; Zero Page Indexed Indirect	mnemonic (addr8i,X)		opcode addr8i			      2		    $00addr8i+X -> addr16
  ; Zero Page Indirect Indexed	mnemonic (addr8i),Y		opcode addr8i			      2		    $00addr8i -> addr16 + Y
  ; Absolute Indirect			      mnemonic (addr16i)		opcode <addr16i>addr16i	3		    addr16i -> addr16
  ; Absolute Indexed Indirect*	mnemonic (addr16i,X)	opcode <addr16i>addr16i	3		    addr16i+X -> addr16
  ; Zero Page Indirect*			    mnemonic (addr8i)		  opcode addr8i			      2		    $00addr8i -> addr16

  PrintN("Acc Imm ZP ZP,X ZP,Y Abs Abs,X Abs,Y Imp Rel (ZP,X) (ZP),Y (Abs) (Abs,X) (ZP)")
  PrintN("")
  ForEach tOpcode()
    With tOpcode()
      PrintN("Opcode      : "+\opc_MNEMONIC)
      PrintN("Description : "+\opc_DESCRIPTION)
      For i = 0 To #NB_MODE_OPC-1
        Print("$"+HEXA(\opc_CODE[i])+" ")
      Next i
      PrintN(""):PrintN("-----------------------------------------------------------")
    EndWith
  Next
  PrintN("")
EndProcedure

Procedure.s CheckTokenType(tokType.i = #Typ_OTHER)
Protected result.s = ""

  Select TokType
    Case #Typ_KEYWORD   : result = "#_KEYWORD"
    Case #Typ_OPCODE    : result = "#_OPCODE "
    Case #Typ_LABEL     : result = "#_LABEL  "
    Case #Typ_TEXT      : result = "#_TEXT   "
    Case #Typ_CONST     : result = "#_CONST  "
    Case #Typ_COMPUTE   : result = "#_COMPUTE"
    Case #Typ_ERROR     : result = "#_ERROR  "
    Case #Typ_OTHER     : result = "#_OTHER  "
  EndSelect

  ProcedureReturn result
EndProcedure

Procedure.s CheckTokenOpcode(tokOpcode.i = #Tok_OTHER)
Protected result.s = ""

  Select tokOpcode
    Case #Tok_ERROR     : result = "#Tok_ERROR "
    Case #Tok_ORG       : result = "#Tok_ORG   "
    Case #Tok_EQU       : result = "#Tok_EQU   "
    Case #Tok_EPZ       : result = "#Tok_EPZ   "
    Case #Tok_EQUAL     : result = "#Tok_=     "
;     Case #Tok_ASTERISK  : result = "#Tok_*     "
    Case #Tok_LST       : result = "#Tok_LST   "
    Case #Tok_AST       : result = "#Tok_AST   "
    Case #Tok_ASC       : result = "#Tok_ASC   "
    Case #Tok_DA        : result = "#Tok_DA    "
    Case #Tok_DFB       : result = "#Tok_DFB   "
    Case #Tok_DS        : result = "#Tok_DS    "
    Case #Tok_HEX       : result = "#Tok_HEX   "

    Case #Tok_VALUE     : result = "#Tok_VALUE "
    Case #Tok_MULTI     : result = "#Tok_MULTI "
    Case #Tok_LABEL     : result = "#Tok_LABEL "
    Case #Tok_OTHER     : result = "           "        ; result = "#Tok_OTHER "

    ;Opcode  
    Case #Opc_ADC       : result = "#Opc_ADC   "
    Case #Opc_AND       : result = "#Opc_AND   "
    Case #Opc_ASL       : result = "#Tok_ASL   "
    Case #Opc_BCC       : result = "#Opc_BCC   "
    Case #Opc_BCS       : result = "#Opc_BCS   "
    Case #Opc_BEQ       : result = "#Opc_BEQ   "
    Case #Opc_BIT       : result = "#Opc_BIT   "
    Case #Opc_BMI       : result = "#Opc_BMI   "
    Case #Opc_BNE       : result = "#Opc_BNE   "
    Case #Opc_BPL       : result = "#Opc_BPL   "
    Case #Opc_BRA       : result = "#Opc_BRA   "        ;65C02
    Case #Opc_BRK       : result = "#Opc_BRK   "
    Case #Opc_BVC       : result = "#Opc_BVC   "
    Case #Opc_BVS       : result = "#Opc_BVS   "
    Case #Opc_CLC       : result = "#Opc_CLC   "
    Case #Opc_CLD       : result = "#Opc_CLD   "
    Case #Opc_CLI       : result = "#Opc_CLI   "
    Case #Opc_CLV       : result = "#Opc_CLV   "
    Case #Opc_CMP       : result = "#Opc_CMP   "
    Case #Opc_CPX       : result = "#Opc_CPX   "
    Case #Opc_CPY       : result = "#Opc_CPY   "
    Case #Opc_DEC       : result = "#Opc_DEX   "
    Case #Opc_DEX       : result = "#Opc_DEX   "
    Case #Opc_DEY       : result = "#Opc_DEY   "
    Case #Opc_EOR       : result = "#Opc_EOR   "
    Case #Opc_INC       : result = "#Opc_INC   "
    Case #Opc_INX       : result = "#Opc_INX   "
    Case #Opc_INY       : result = "#Opc_INY   "
    Case #Opc_JMP       : result = "#Opc_JMP   "
    Case #Opc_JSR       : result = "#Opc_JSR   "
    Case #Opc_LDA       : result = "#Opc_LDA   "
    Case #Opc_LDX       : result = "#Opc_LDX   "
    Case #Opc_LDY       : result = "#Opc_LDY   "
    Case #Opc_LSR       : result = "#Opc_LSR   "
    Case #Opc_NOP       : result = "#Opc_NOP   "
    Case #Opc_ORA       : result = "#Opc_ORA   "
    Case #Opc_PHA       : result = "#Opc_PHA   "
    Case #Opc_PHP       : result = "#Opc_PHP   "
    Case #Opc_PHX       : result = "#Opc_PHX   "        ;65C02
    Case #Opc_PHY       : result = "#Opc_PHY   "        ;65C02
    Case #Opc_PLA       : result = "#Opc_PLA   "
    Case #Opc_PLP       : result = "#Opc_PLP   "
    Case #Opc_PLX       : result = "#Opc_PLX   "        ;65C02
    Case #Opc_PLY       : result = "#Opc_PLY   "        ;65C02
    Case #Opc_ROL       : result = "#Opc_ROL   "
    Case #Opc_ROR       : result = "#Opc_ROR   "
    Case #Opc_RTI       : result = "#Opc_RTI   "
    Case #Opc_RTS       : result = "#Opc_RTS   "
    Case #Opc_SBC       : result = "#Opc_SBC   "
    Case #Opc_SEC       : result = "#Opc_SEC   "
    Case #Opc_SED       : result = "#Opc_SED   "
    Case #Opc_SEI       : result = "#Opc_SEI   "
    Case #Opc_STA       : result = "#Opc_STA   "
    Case #Opc_STX       : result = "#Opc_STX   "
    Case #Opc_STY       : result = "#Opc_STY   "
    Case #Opc_STZ       : result = "#Opc_STZ   "        ;65C02
    Case #Opc_TAX       : result = "#Opc_TAX   "
    Case #Opc_TAY       : result = "#Opc_TAY   "
    Case #Opc_TRB       : result = "#Opc_TRB   "        ;65C02
    Case #Opc_TSB       : result = "#Opc_TSB   "        ;65C02
    Case #Opc_TSX       : result = "#Opc_TSX   "
    Case #Opc_TXA       : result = "#Opc_TXA   "
    Case #Opc_TXS       : result = "#Opc_TXS   "
    Case #Opc_TYA       : result = "#Opc_TYA   "
  EndSelect

  ProcedureReturn result
EndProcedure

Procedure.s CheckTokenSize(tokSize.i = #_NONE)
Protected result.s = ""

  Select tokSize
    Case #_NONE         : result = "    "
    Case #_BYTE         : result = "BYTE"
    Case #_WORD         : result = "WORD"
    Case #_DECI         : result = "DECI"
    Case #_HEXA         : result = "HEXA"
    Case #_BIN          : result = "BIN "
  EndSelect

  ProcedureReturn result
EndProcedure

Procedure PrintSRC_TOKEN()
Protected Dim tblToken.SClassToken(2)
Protected i.i, linetok.i, oldlineTok.i
Protected l$, t$, u$, v$, litok$, tk$

  PrintN("Tokens"):PrintN("")
  PrintN("--------+-----------+-------------+------+----------------------+-----")
  PrintN("  Line  | Type      | Key         | Size | Value                | Pos ")
  PrintN("--------+-----------+-------------+------+----------------------+-----")
  
  ForEach Token()
    tblToken(0)\Pos       = Token()\TokA\pos
    tblToken(0)\Type      = Token()\TokA\type
    tblToken(0)\Key       = Token()\TokA\key
    tblToken(0)\Value     = Token()\TokA\value
    tblToken(0)\ByteSize  = Token()\TokA\ByteSize

    tblToken(1)\Pos       = Token()\TokB\pos
    tblToken(1)\Type      = Token()\TokB\type
    tblToken(1)\Key       = Token()\TokB\key
    tblToken(1)\Value     = Token()\TokB\value
    tblToken(1)\ByteSize  = Token()\TokB\ByteSize

    tblToken(2)\Pos       = Token()\TokC\pos
    tblToken(2)\Type      = Token()\TokC\type
    tblToken(2)\Key       = Token()\TokC\key
    tblToken(2)\Value     = Token()\TokC\value
    tblToken(2)\ByteSize  = Token()\TokC\ByteSize

    lineTok               = Token()\TokLine

    For i = 0 To 2
      If tblToken(i)\Type <> #NA
        t$ = CheckTokenType(tblToken(i)\Type)
        u$ = CheckTokenOpcode(tblToken(i)\Key)
        v$ = CheckTokenSize(tblToken(i)\ByteSize)
        litok$ = "(" + RSet(Str(lineTok),4,"0") + ")"
        If lineTok = oldlineTok
          litok$ = "      "
        EndIf
        l$ = litok$ + " | " + t$ + " | " + u$ + " | " + v$

        If Len(tblToken(i)\Value) > 20
          tk$ = LSet(Left(tblToken(i)\Value,17),20,".")
        Else
          tk$ = LSet(Left(tblToken(i)\Value,20),20," ")
        EndIf

        l$ + " | " + tk$ + " | " + RSet(Str(tblToken(i)\Pos),3," ")
        PrintN(" "+l$)
        oldlineTok = lineTok
      EndIf
    Next
    PrintN("--------+-----------+-------------+------+----------------------+-----")
  Next
  
EndProcedure

Procedure PrintSRC_LIST()
Protected t$, litok$
Protected curline.i, lineTok.i

  PrintN("--------+-------------------------------------------------------------")
  PrintN("  Line  | Source")
  PrintN("--------+-------------------------------------------------------------")

  t$ = "" : curline = 1

  ForEach src()
    lineTok = src()\line
    t$ = src()\text
    litok$ = "(" + RSet(Str(curline),4,"0") + ")"
    
    PrintN(" " + litok$ + " | " + t$)
    curline + 1
  Next
  
  PrintN("--------+-------------------------------------------------------------")
EndProcedure

Procedure PrintSRC_CleanLIST()
Protected lig$, litok$, a$, b$, c$, e$
Protected curline.i

  PrintN("--------+--------+----------------------------------------------------")
  PrintN("  Line  |  Real  | Source")
  PrintN("        |  Line  |")
  PrintN("--------+--------+----------------------------------------------------")

  lig$ = "" : curline = 1

  ForEach CleanSRC()
    litok$ = "(" + RSet(Str(curline),4,"0") + ")"
    a$=CleanSRC()\Label\Value
    b$=CleanSRC()\Opcode\Value
    c$=CleanSRC()\Operand\Value
    e$="(" + RSet(Str(CleanSRC()\RealLine),4,"0") + ")"
    lig$ = " " + litok$ + " | " + e$ + " | " + a$ + " " + b$ + " " + c$

;     With CleanSRC()
;       DEBUG_LOG("CleanSRC: "+Str(\IsConst)+" | "+\Label\Value+" "+\Opcode\Value+" "+\Operand\Value)
;     EndWith

    If CleanSRC()\IsConst = 0
      PrintN(lig$)
      curline + 1
    EndIf
  Next

  PrintN("--------+--------------------------------------------------------------")
EndProcedure

Procedure PrintSYMBOL_TABLE()
  ;Symbol table - alphabetical order:
  ;
  ;   A2L     =$3E     ?  CHRIN   =$8021      COUT    =$FDEF      CROUT   =$FD8E
  ;   GETLN   =$FD6A      GETNUM  =$FFA7      KEY     =$8024      KEYBRD  =$C000
  ;   LOOP    =$8008   ?  MSGIN   =$8033   ?  MSGOUT  =$8000      MSGRTS  =$801A
  ;   PROMPT  =$33        SKIPADD =$800E      STROBE  =$C010      TEMP    =$00
  ;   ZMODE   =$FFC7
  ;
  ;
  ;Symbol table - numerical order:
  ;
  ;   TEMP    =$00        PROMPT  =$33        A2L     =$3E     ?  MSGOUT  =$8000
  ;   LOOP    =$8008      SKIPADD =$800E      MSGRTS  =$801A   ?  CHRIN   =$8021
  ;   KEY     =$8024   ?  MSGIN   =8033       KEYBRD  =$C000      STROBE  =$C010
  ;   GETLN   =$FD6A      CROUT   =$FD8E      COUT    =$FDED      GETNUM  =$FFA7
  ;   ZMODE   =$FFC7
  ;
  PrintN("Symbol table - alphabetical order:")
  PrintN("")

  ForEach Label()
    Print(LSet(Label()\LABEL_Name,19," ") + " " + RSet(Str(Label()\LABEL_Line),5," "))
;     If Label()\LABEL_Error <> -1
;       PrintN(#TAB$+#TAB$+#TAB$+"<ERR #"+str(Label()\LABEL_Error)+">")
;     Else
      PrintN("")
;     EndIf
  Next
  
  PrintN("")
  
  PrintN("--- CONST " + Space(10) + "LINE" + #CHAR_TAB + "VALUE"):PrintN("")
  ForEach Const()
    Print(LSet(Const()\CONST_Name,19," ") + " " + RSet(Str(Const()\CONST_Line),5," ") + #CHAR_TAB + Const()\CONST_Value)
;     If Const()\CONST_Error <> -1
;       PrintN(#TAB$+#TAB$+"<ERR #"+str(Const()\CONST_Error)+">")
;     Else
      PrintN("")
;     EndIf
  Next

  PrintN("")
EndProcedure

Procedure PrintLABEL_CONST()
;   PrintN("Labels & constants")
;   PrintN("")
;   PrintN("Program '"+the_file+"' starting at adress : "+SET_ORG):PrintN("")

  If ListSize(label()) > 0
    PrintN("--- LABEL " + Space(10) + "LINE"):PrintN("")
    ForEach Label()
      Print(LSet(Label()\LABEL_Name,19," ") + " " + RSet(Str(Label()\LABEL_Line),5," "))
  ;     If Label()\LABEL_Error <> -1
  ;       PrintN(#TAB$+#TAB$+#TAB$+"<ERR #"+str(Label()\LABEL_Error)+">")
  ;     Else
        PrintN("")
  ;     EndIf
    Next
    
    PrintN("")
  EndIf
  
  If ListSize(Const()) > 0
    PrintN("--- CONST " + Space(10) + "LINE" + #CHAR_TAB + "VALUE"):PrintN("")
    ForEach Const()
      Print(LSet(Const()\CONST_Name,19," ") + " " + RSet(Str(Const()\CONST_Line),5," ") + #CHAR_TAB + Const()\CONST_Value)
    ;     If Const()\CONST_Error <> -1
    ;       PrintN(#TAB$+#TAB$+"<ERR #"+str(Const()\CONST_Error)+">")
    ;     Else
        PrintN("")
    ;     EndIf
    Next
  EndIf

  PrintN("")
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 242
; FirstLine = 231
; Folding = --
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant