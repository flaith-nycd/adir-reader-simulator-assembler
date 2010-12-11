Procedure PrintOPC_MNEMONIC()
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

Procedure PrintSRC_TOKEN()
  PrintN("Tokens"):PrintN("")
  PrintN("--------+-----------+-------------+------+----------------------+-----")
  PrintN("  Line  | Type      | Key         | Size | Value                | Pos ")
  PrintN("--------+-----------+-------------+------+----------------------+-----")
  
  ForEach Token()
    With token()
      Select \TokType
        Case #Typ_KEYWORD
          t$ = "#_KEYWORD"
        Case #Typ_OPCODE
          t$ = "#_OPCODE "
        Case #Typ_LABEL
          t$ = "#_LABEL  "
        Case #Typ_TEXT
          t$ = "#_TEXT   "
        Case #Typ_CONST
          t$ = "#_CONST  "
        Case #Typ_COMPUTE
          t$ = "#_COMPUTE"
        Case #Typ_OTHER
          t$ = "#_OTHER  "
      EndSelect
      
      Select \TokKey
        Case #Tok_ERROR
          u$ = "#Tok_ERROR "
        Case #Tok_ORG
          u$ = "#Tok_ORG   "
        Case #Tok_EQU
          u$ = "#Tok_EQU   "
        Case #Tok_EQUAL
          u$ = "#Tok_=     "
;         Case #Tok_ASTERISK
;           u$ = "#Tok_*     "
        Case #Tok_LST
          u$ = "#Tok_LST   "
        Case #Tok_AST
          u$ = "#Tok_AST   "
        Case #Tok_ASC
          u$ = "#Tok_ASC   "
        Case #Tok_DA
          u$ = "#Tok_DA    "
        Case #Tok_DFB
          u$ = "#Tok_DFB   "
        Case #Tok_DS
          u$ = "#Tok_DS    "
        Case #Tok_HEX
          u$ = "#Tok_HEX   "

        ;Opcode  
        Case #Opc_ADC
          u$ = "#Opc_ADC   "
        Case #Opc_AND
          u$ = "#Opc_AND   "
        Case #Opc_ASL
          u$ = "#Tok_ASL   "
        Case #Opc_BCC
          u$ = "#Opc_BCC   "
        Case #Opc_BCS
          u$ = "#Opc_BCS   "
        Case #Opc_BEQ
          u$ = "#Opc_BEQ   "
        Case #Opc_BIT
          u$ = "#Opc_BIT   "
        Case #Opc_BMI
          u$ = "#Opc_BMI   "
        Case #Opc_BNE
          u$ = "#Opc_BNE   "
        Case #Opc_BPL
          u$ = "#Opc_BPL   "
        Case #Opc_BRA                         ;65C02
          u$ = "#Opc_BRA   "
        Case #Opc_BRK
          u$ = "#Opc_BRK   "
        Case #Opc_BVC
          u$ = "#Opc_BVC   "
        Case #Opc_BVS
          u$ = "#Opc_BVS   "
        Case #Opc_CLC
          u$ = "#Opc_CLC   "
        Case #Opc_CLD
          u$ = "#Opc_CLD   "
        Case #Opc_CLI
          u$ = "#Opc_CLI   "
        Case #Opc_CLV
          u$ = "#Opc_CLV   "
        Case #Opc_CMP
          u$ = "#Opc_CMP   "
        Case #Opc_CPX
          u$ = "#Opc_CPX   "
        Case #Opc_CPY
          u$ = "#Opc_CPY   "
        Case #Opc_DEC
          u$ = "#Opc_DEX   "
        Case #Opc_DEX
          u$ = "#Opc_DEX   "
        Case #Opc_DEY
          u$ = "#Opc_DEY   "
        Case #Opc_EOR
          u$ = "#Opc_EOR   "
        Case #Opc_INC
          u$ = "#Opc_INC   "
        Case #Opc_INX
          u$ = "#Opc_INX   "
        Case #Opc_INY
          u$ = "#Opc_INY   "
        Case #Opc_JMP
          u$ = "#Opc_JMP   "
        Case #Opc_JSR
          u$ = "#Opc_JSR   "
        Case #Opc_LDA
          u$ = "#Opc_LDA   "
        Case #Opc_LDX
          u$ = "#Opc_LDX   "
        Case #Opc_LDY
          u$ = "#Opc_LDY   "
        Case #Opc_LSR
          u$ = "#Opc_LSR   "
        Case #Opc_NOP
          u$ = "#Opc_NOP   "
        Case #Opc_ORA
          u$ = "#Opc_ORA   "
        Case #Opc_PHA
          u$ = "#Opc_PHA   "
        Case #Opc_PHP
          u$ = "#Opc_PHP   "
        Case #Opc_PHX                         ;65C02
          u$ = "#Opc_PHX   "
        Case #Opc_PHY                         ;65C02
          u$ = "#Opc_PHY   "
        Case #Opc_PLA
          u$ = "#Opc_PLA   "
        Case #Opc_PLP
          u$ = "#Opc_PLP   "
        Case #Opc_PLX                         ;65C02
          u$ = "#Opc_PLX   "
        Case #Opc_PLY                         ;65C02
          u$ = "#Opc_PLY   "
        Case #Opc_ROL
          u$ = "#Opc_ROL   "
        Case #Opc_ROR
          u$ = "#Opc_ROR   "
        Case #Opc_RTI
          u$ = "#Opc_RTI   "
        Case #Opc_RTS
          u$ = "#Opc_RTS   "
        Case #Opc_SBC
          u$ = "#Opc_SBC   "
        Case #Opc_SEC
          u$ = "#Opc_SEC   "
        Case #Opc_SED
          u$ = "#Opc_SED   "
        Case #Opc_SEI
          u$ = "#Opc_SEI   "
        Case #Opc_STA
          u$ = "#Opc_STA   "
        Case #Opc_STX
          u$ = "#Opc_STX   "
        Case #Opc_STY
          u$ = "#Opc_STY   "
        Case #Opc_STZ                         ;65C02
          u$ = "#Opc_STZ   "          
        Case #Opc_TAX
          u$ = "#Opc_TAX   "
        Case #Opc_TAY
          u$ = "#Opc_TAY   "
        Case #Opc_TRB                         ;65C02
          u$ = "#Opc_TRB   "
        Case #Opc_TSB                         ;65C02
          u$ = "#Opc_TSB   "          
        Case #Opc_TSX
          u$ = "#Opc_TSX   "
        Case #Opc_TXA
          u$ = "#Opc_TXA   "
        Case #Opc_TXS
          u$ = "#Opc_TXS   "
        Case #Opc_TYA
          u$ = "#Opc_TYA   "
        
        Case #Tok_VALUE
          u$ = "#Tok_VALUE "
        Case #Tok_LABEL
          u$ = "#Tok_LABEL "
        Case #Tok_OTHER
  ;         u$ = "#Tok_OTHER "
          u$ = "           "
      EndSelect
  
      Select \TokByteSize
        Case #_NONE : v$ = "    "
        Case #_BYTE : v$ = "BYTE"
        Case #_WORD : v$ = "WORD"
        Case #_DECI : v$ = "DECI"
        Case #_HEXA : v$ = "HEXA"
        Case #_BIN  : v$ = "BIN "
      EndSelect
  
      litok$ = "(" + RSet(Str(\TokLine),4,"0") + ")"
      lineTok = \TokLine
      If lineTok = oldlineTok
        litok$ = "      "
      EndIf
      
      pstok = \TokPos
      If pstok <= oldpstok
        PrintN("--------+-----------+-------------+------+----------------------+-----")
      EndIf
  
      l$ = litok$ + " | " + t$ + " | " + u$ + " | " + v$
      
  ;     If \TokType = #Typ_CONST And \TokPos = 3 And \TokByteSize = #_NONE
  ;       If Len(\TokValue) > 20
  ;         tk$ = #DBL_QUOTE + LSet(Left(\TokValue,18),18," ") + #DBL_QUOTE
  ;       Else
  ;         ll = 18 - Len(\TokValue)
  ;         tk$ = #DBL_QUOTE + \TokValue + #DBL_QUOTE + Space(ll)
  ;       EndIf
  ;     Else
  ;       tk$ = LSet(Left(\TokValue,20),20," ")
  ;     EndIf
  
      If Len(\TokValue) > 20
        tk$ = LSet(Left(\TokValue,17),20,".")
      Else
        tk$ = LSet(Left(\TokValue,20),20," ")
      EndIf
  
      l$ + " | " + tk$ + " | " + RSet(Str(\TokPos),3," ")
      PrintN(" "+l$)
      oldpstok = pstok
      oldlineTok = lineTok
    EndWith
  Next
  
  PrintN("--------+-----------+-------------+------+----------------------+-----")
EndProcedure

Procedure PrintSRC_LIST()
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
  PrintN("--------+-------------------------------------------------------------")
  PrintN("  Line  | Source")
  PrintN("--------+-------------------------------------------------------------")

  t$ = "" : curline = 1

  ForEach Token()
    lineTok = Token()\TokLine
    litok$ = "(" + RSet(Str(curline),4,"0") + ")"

    pstok = Token()\TokPos
    If pstok <= oldpstok
;     If lineTok <> oldlineTok
      t$ = Trim(t$)
      PrintN(" " + litok$ + " | " + t$) : t$ = ""
      curline + 1
      tt = #False
    EndIf

;     If Token()\TokType = #Typ_LABEL
;       t$ = LSet(Token()\TokValue,15," ") : ll = Len(Token()\TokValue)
;     Else
;       If Token()\TokType = #Typ_KEYWORD
;         t$ + Space(15-ll) + LSet(Token()\TokValue,5," ")
;       Else
;         t$ + Token()\TokValue
;       EndIf
;     EndIf
    If Token()\TokType = #Typ_CONST And pstok = 1
      t$ + "["+Token()\TokValue + "] "
    Else
      t$ + Token()\TokValue + " "
    EndIf

    oldpstok = pstok
    oldlineTok = lineTok
  Next
  
  t$ = Trim(t$)
  PrintN(" " + litok$ + " | " + t$)
  PrintN("--------+-------------------------------------------------------------")
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
; IDE Options = PureBasic 4.50 Beta 3 (Windows - x86)
; CursorPosition = 334
; FirstLine = 314
; Folding = --
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant