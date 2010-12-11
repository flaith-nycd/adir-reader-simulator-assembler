;-Constants
#FILE_SRC       = 0

#DEBUG_FILENUM  = 99
#DEBUG_NAME     = "ADIR_ASMLOG.TXT"

#DBL_QUOTE      = Chr(34)
#SIM_QUOTE      = Chr(39)
#CHAR_TAB       = Chr(9)

Enumeration 
  #Typ_KEYWORD
  #Typ_INT
  #Typ_STRING
  #Typ_LABEL
  #Typ_TEXT
  #Typ_CONST
  #Typ_COMPUTE
  #Typ_OTHER    = 99
EndEnumeration

Enumeration 
;-Enum Assembler
  #Tok_ORG
  #Tok_EQU
  #Tok_EQUAL              ;= like EQU
  #Tok_ASTERISK           ;* When you don't know the adress, calculate when assembling

  #Tok_LST                ;keep compatibility with all assemblers
  #Tok_AST

  #Tok_ASC
  #Tok_DA
  #Tok_DFB
  #Tok_DS
  #Tok_HEX
  
;-Enum 6502 Opcode
  #Tok_ADC
  #Tok_AND
  #Tok_ASL
  #Tok_BCC
  #Tok_BCS
  #Tok_BEQ
  #Tok_BIT
  #Tok_BMI
  #Tok_BNE
  #Tok_BPL
  #Tok_BRK
  #Tok_BVC
  #Tok_BVS
  #Tok_CLC
  #Tok_CLD
  #Tok_CLI
  #Tok_CLV
  #Tok_CMP
  #Tok_CPX
  #Tok_CPY
  #Tok_DEC
  #Tok_DEX
  #Tok_DEY
  #Tok_EOR
  #Tok_INC
  #Tok_INX
  #Tok_INY
  #Tok_JMP
  #Tok_JSR
  #Tok_LDA
  #Tok_LDX
  #Tok_LDY
  #Tok_LSR
  #Tok_NOP
  #Tok_ORA
  #Tok_PHA
  #Tok_PHP
  #Tok_PLA
  #Tok_PLP
  #Tok_ROL
  #Tok_ROR
  #Tok_RTI
  #Tok_RTS
  #Tok_SBC
  #Tok_SEC
  #Tok_SED
  #Tok_SEI
  #Tok_STA
  #Tok_STX
  #Tok_STY
  #Tok_TAX
  #Tok_TAY
  #Tok_TSX
  #Tok_TXA
  #Tok_TXS
  #Tok_TYA
EndEnumeration

#NB_TOK = #PB_Compiler_EnumerationValue

Enumeration #PB_Compiler_EnumerationValue + 1
  #Tok_VALUE 
  #Tok_LABEL
  #Tok_OTHER
EndEnumeration

Enumeration 
  #_NONE
  #_BYTE
  #_WORD
  #_DECI
  #_HEXA
  #_BIN
EndEnumeration

;-Structures
Structure sTOKEN
  TokType.i                           ;KEYWORD or STRING or INT or LABEL
  TokKey.i                            ;If it's a KeyWord
  TokValue.s                          ;Value (for a label it's the line number)
  TokByteSize.i
  TokLine.i                           ;Line of the current token
  TokPos.i                            ;Pos of the Token (1:Label or Const - 2:Keyword or EQU - 3:Value)
EndStructure

Structure sLABEL
  LABEL_Name.s
  LABEL_Line.i
EndStructure

Structure sCONST
  CONST_Name.s
  CONST_Value.s
  CONST_Line.i
EndStructure

Structure sSOURCE
  line.i
  text.s
EndStructure

;-Global
Global _line.s = ""
Global CurrentPos.i = 0, CurrentLine.i = 0, LenLine.i = 0, TypeToken.i = #Typ_OTHER, ByteSize.i = #_NONE
Global Dim tToken.s(#NB_TOK)

Global _QUOTE.i = 0, _PARENT.i = 0

Global SET_ORG.s = ""

Global NewList src.sSOURCE()
Global NewList Token.sTOKEN()
Global NewList Label.sLABEL()
Global NewList Const.sCONST()

Global NewList ARGV.s()
Global ARGC.i, the_file.s, ASM_HELP.i

;-Macro & Proc by DRI 
;-(http://www.purebasic.fr/french/viewtopic.php?t=4667)
Macro IsUpper(c)
  ((c >= 'A') And (c <= 'Z'))
EndMacro

Macro IsLower(c)
  ((c >= 'a') And (c <= 'z'))
EndMacro

Macro IsAlpha(c)
  (IsUpper(c) Or IsLower(c))
EndMacro

Macro IsAlnum(c)
  (IsAlpha(c) Or IsDigit(c))
EndMacro

Macro IsBinDigit(c)
  ((c >= '0') And (c <= '1'))
EndMacro

Macro IsDeciDigit(c)
  ((c >= '0') And (c <= '9'))
EndMacro

Macro IsHexaDigit(c)
  (IsDeciDigit(c) Or ((c >= 'a') And (c <= 'f')) Or ((c >= 'A') And (c <= 'F')))
EndMacro

Macro IsPunct(c)
  ((c = '"') Or FindString("!#%&'();<=>?[\]*+,-./:^_{|}~", Chr(c), 1))
EndMacro

Macro IsGraph(c)
  (IsAlnum(c) Or IsPunct(c))
EndMacro

Macro IsPrint(c)
  ((c = ' ') Or IsGraph(c))
EndMacro

Macro IsSpace(c)
  ((c = ' ') Or (c = #FF) Or (c = #LF) Or (c = #CR) Or (c = #HT) Or (c = #VT))
EndMacro

Macro IsBlank(c)
  ((c = ' ') Or (c = #TAB))
EndMacro

Macro IsCntrl(c)
  ((c = #BEL) Or (c = #BS))
EndMacro

;-DRI Proc
Procedure.i IsBinary(sTok.s)
  Protected Binary.i, *String.Character
 
  If sTok
    Binary = #True
    *String = @sTok
   
    While Binary And *String\c
      Decimal = IsBinDigit(*String\c)
      *String + SizeOf(Character)
    Wend
  EndIf
 
  ProcedureReturn Binary
EndProcedure

Procedure.i IsDecimal(sTok.s)
  Protected Decimal.i, *String.Character
 
  If sTok
    Decimal = #True
    *String = @sTok
   
    While Decimal And *String\c
      Decimal = IsDeciDigit(*String\c)
      *String + SizeOf(Character)
    Wend
  EndIf
 
  ProcedureReturn Decimal
EndProcedure

Procedure.i IsHexadecimal(sTok.s)
  Protected HexaDecimal.i, *String.Character
 
  If sTok
    HexaDecimal = #True
    *String = @sTok
   
    While HexaDecimal And *String\c
      HexaDecimal = IsHexaDigit(*String\c)
      *String + SizeOf(Character)
    Wend
  EndIf
 
  ProcedureReturn HexaDecimal
EndProcedure

;-******************
;-*** Procedures ***
;-******************
Procedure DEBUG_LOG(value.s)
  OpenFile(#DEBUG_FILENUM,#DEBUG_NAME)
    FileSeek(#DEBUG_FILENUM, Lof(#DEBUG_FILENUM))
    WriteStringN(#DEBUG_FILENUM,value)
  CloseFile(#DEBUG_FILENUM)
EndProcedure

Procedure Usage()
  PrintN("[ADIR]-6502 Assembler")
  PrintN("Usage: adir_assembler file")
  PrintN("  -h, --help              print this help and exit")
  PrintN("")
  PrintN("Please send bugs at <flaith@gmail.com>.")
  End
EndProcedure

Procedure Init()
Protected tok.i=0 : i.i = 1

  Restore dToken
  Read.s token$

  While token$ <> "@@@"
    tToken(tok) = LCase(token$)
;     PrintN("tToken("+Str(tok)+")="+tToken(tok))
    tok + 1
    Read.s token$
  Wend

;   Restore dToken
;   Read.s tokens$
;   While d$ <> "@"
;     d$ = Mid(tokens$,i,1)
;     If (Asc(d$) & %00100000) = %00100000       ;verifie si bit 5 à 1
;       tok$ + d$
;       tToken(tok) = tok$
;       tok + 1
;       tok$ = ""
;     Else
;       tok$ + LCase(d$)
;     EndIf
; 
;     i+1
;   Wend

  CreateFile(#DEBUG_FILENUM,#DEBUG_NAME)
    WriteStringN(#DEBUG_FILENUM,"DEBUG LOG--DATE:"+FormatDate(" %dd/%mm/%yyyy at %hh:%ii:%ss", Date()))
    WriteStringN(#DEBUG_FILENUM,"---------------")
  CloseFile(#DEBUG_FILENUM)
EndProcedure

Procedure.i OpenSRC(file.s)
Protected fd.i, curtext.s, curline.i

  fd = ReadFile(#FILE_SRC,file)
  If fd
    curline = 1
    While Eof(#FILE_SRC) = 0
      curtext = Trim(ReadString(#FILE_SRC))
      If Len(curtext) > 1
        AddElement(src())
          src()\line = curline
          src()\text = curtext
        curline + 1
      EndIf
    Wend
  Else
    ProcedureReturn -1
  EndIf
	
	CloseFile(#FILE_SRC)
EndProcedure

Procedure PrintSRC()
  ForEach src()
    PrintN(RSet(Str(src()\line),3,"0") + " - " + src()\text)
  Next
EndProcedure

;-
Procedure.s GetCurrentChar()
  car.s = Chr(PeekC(@_line+CurrentPos))
  ProcedureReturn car
EndProcedure

Procedure SkipSpace()
  While GetCurrentChar() = " "
    CurrentPos + 1
  Wend
EndProcedure

Procedure.s GetString()
Protected sText.s = "", c.s
  
  c = GetCurrentChar()
  
  While (c <> #DBL_QUOTE) And (CurrentPos < LenLine)
    sText + c
    CurrentPos + 1
    c = GetCurrentChar()
    TypeToken = #Typ_TEXT
  Wend
  
  ProcedureReturn #DBL_QUOTE+sText+#DBL_QUOTE
EndProcedure

Procedure.s GetToken()
Protected sTok.s = "", c.s

  Repeat
    c = GetCurrentChar()

    ; Car = '"' and Not inside a string ?     //String definition
    If c = #DBL_QUOTE And _QUOTE = 0
      CurrentPos + 1
      _QUOTE = 1
      sTok = GetString()
      Break
    EndIf

    ; Car = '"' and inside a string ?         //String definition
    If c = #DBL_QUOTE And _QUOTE = 1
      CurrentPos + 1
      _QUOTE = 0
      Break
    EndIf

    ; Car = TAB and Not inside a string ?     //Tabulation
    If c = #CHAR_TAB And _QUOTE = 0
      CurrentPos + 1
      Break
    EndIf

    ; Car = ';' or Car = '*' in the beginning 
    ; of the line and Not inside a string ?   //Remark
    If c = ";" And _QUOTE = 0 : CurrentPos = LenLine : Break : EndIf
    If c = "*" And _QUOTE = 0 And CurrentPos = 0
      CurrentPos = LenLine : sTok = ""
    EndIf
    
    ; Current car position >= current Line length ?
    If CurrentPos >= LenLine : Break : EndIf
    
    ; if it's a space outside a quoted string
    If c = " " And _QUOTE = 0 : Break : EndIf

    ; Make the Token
    If (c >= "A" Or c <= "Z") And (c >= "a" Or c =< "z")
      CurrentPos + 1
      sTok + c
    EndIf

;     ; car = "=-+/*" outside a quoted string
;     If (c="=" Or c="-" Or c="+" Or c="/" Or c="*") And _QUOTE = 0
;       CurrentPos + 1
;       sTok = c
;       Break
;     EndIf
  ForEver  

  ProcedureReturn sTok
EndProcedure

Procedure.i CheckToken(sTok.s)
Protected i.i, result.i = #Tok_OTHER

  TypeToken = #Typ_CONST

;   If IsDecimal(sTok) And TypeToken = #Typ_CONST
;     ByteSize = #_DECI
;     Result = #Tok_VALUE
;   EndIf
  
;   If IsHexadecimal(sTok) And TypeToken = #Typ_CONST
;     ByteSize = #_HEXA
;     Result = #Tok_VALUE
;   EndIf
  
  ;Else other
;   If Left(LCase(sTok),1) = "%" And TypeToken = #Typ_CONST
;     If IsBinary(sTok)
;       ByteSize = #_BIN
;       Result = #Tok_VALUE
;     EndIf
;   EndIf

  If Left(LCase(sTok),1) = "$" And TypeToken = #Typ_CONST
    If Len(sTok)-1 > 2
      ByteSize = #_WORD
    Else
      ByteSize = #_BYTE
    EndIf
    Result = #Tok_VALUE
  EndIf

;   If Left(LCase(sTok),1) = "#" And TypeToken = #Typ_CONST
;     If Mid(LCase(sTok),2,1) = "$"
;       ByteSize = #_HEXA
;       Result = #Tok_VALUE
;       ElseIf Mid(LCase(sTok),2,1) = "%"
;         ByteSize = #_BIN
;         Result = #Tok_VALUE
;     Else
;       ByteSize = #_DECI
;       Result = #Tok_VALUE
;     EndIf
;   EndIf

  If Left(LCase(sTok),2) = "#$" And TypeToken = #Typ_CONST
    If Len(sTok)-2 > 2
      ByteSize = #_WORD
    Else
      ByteSize = #_BYTE
    EndIf
    Result = #Tok_VALUE
  EndIf

  ; Check if the Token is known as a predefined keyword
  For i = 0 To #NB_TOK - 1
    If LCase(sTok) = tToken(i)
      TypeToken = #Typ_KEYWORD
      result = i
    EndIf
  Next i

  If TypeToken = #Typ_CONST And Result = #Tok_OTHER
    If FindString(sTok,"+",1) : TypeToken = #Typ_COMPUTE : EndIf
    If FindString(sTok,"-",1) : TypeToken = #Typ_COMPUTE : EndIf
    If FindString(sTok,"*",1) : TypeToken = #Typ_COMPUTE : EndIf
    If FindString(sTok,"/",1) : TypeToken = #Typ_COMPUTE : EndIf
  EndIf 

  ProcedureReturn result
EndProcedure


;-
Procedure CheckLabelConst()
Protected CurrElement.i = 0
Protected CurrLine.i, oldCurLine.i
Protected tkvalue.i = 0, TMP_CONST.s = ""
Protected changeElement.i = #False, Get_ORG.i = #False, TypeCONST.i = #False

  FirstElement(Token())
  While CurrElement <= ListSize(Token())

    If Token()\TokKey = #Tok_ORG And Get_ORG = #False
      DEBUG_LOG("ORG : "+Str(Token()\TokLine))
      NextElement(Token())
      SET_ORG = Token()\TokValue
      Get_ORG = #True
      PreviousElement(Token())
      _EIP_ = 0
    EndIf

    If Token()\TokPos = 1 And Token()\TokType = #Typ_CONST
      ThisElement = CurrElement
      
      ;for adding const name & value where we find EQU or =
      TMP_CONST = Token()\TokValue

      tkvalue = 0

      changeElement = #False
      TypeCONST = #False

      CurrLine = Token()\TokLine
      oldCurLine = CurrLine
      DEBUG_LOG("ThisElement : "+Str(ThisElement))

      While oldCurLine = CurrLine And CurrElement <= ListSize(Token())
        If tkvalue > 0 And Token()\TokPos = 3
          DEBUG_LOG("--- CONST in line " + Str(Token()\TokLine) + " for element " + Str(ThisElement))
          AddElement(Const())
            Const()\CONST_Name  = TMP_CONST
            Const()\CONST_Value = Token()\TokValue 
            Const()\CONST_Line  = Token()\TokLine
          tkvalue = 0
          TypeCONST = #True
          Break
        EndIf

        If Token()\TokKey = #Tok_EQU Or Token()\TokKey = #Tok_EQUAL
          tkvalue + 1
        EndIf

        NextElement(Token())
        CurrLine = Token()\TokLine
        CurrElement + 1
      Wend

      If tkvalue = 0 And TypeCONST = #False
        DEBUG_LOG("--- LABEL in line " + Str(Token()\TokLine) + " for element " + Str(ThisElement))
        SelectElement(Token(),ThisElement)
        Token()\TokType = #Typ_LABEL
        AddElement(Label())
          Label()\LABEL_Name = Token()\TokValue
          Label()\LABEL_Line = Token()\TokLine
        CurrElement - 1
        SelectElement(Token(),CurrElement)
        tkvalue = 0
        changeElement = #True
      EndIf
      
;       If tkvalue > 0 ;And Token()\TokPos = 3
;         PreviousElement(Token())
;         AddElement(Const())
;           Const()\CONST_Name  = TMP_CONST
;           Const()\CONST_Value = Token()\TokValue 
;           Const()\CONST_Line  = Token()\TokLine
;         NextElement(Token())
;       EndIf

    EndIf

    oldCurLine = CurLine
    CurrElement + 1
    tkvalue = 0

    NextElement(Token())
  Wend
  
EndProcedure

Procedure PreProcess()
Protected PosTok.i

  ForEach Src()
    CurrentLine = src()\line
    _line = src()\text
  
    CurrentPos = 0 : PosTok = 1

    LenLine = Len(_Line)
  
    While CurrentPos < LenLine
      SkipSpace()
      a$=GetToken()
        If a$ <> ""
          If TypeToken <> #Typ_TEXT
            TypeToken = #Typ_OTHER              ;force type of token
          EndIf
          ByteSize = #_NONE
          type = CheckToken(a$)
          AddElement(Token())
            Token()\TokPos = PosTok
            Token()\TokType = TypeToken
            Token()\TokKey = type
            Token()\TokValue = a$
            Token()\TokByteSize = ByteSize
            Token()\TokLine = CurrentLine
            PosTok + 1
        EndIf
      SkipSpace()
    Wend
  Next
  
  CheckLabelConst()
EndProcedure

;-
Procedure PrintLABEL_CONST()
  PrintN("ORG : "+SET_ORG):PrintN("")

  PrintN("--- LABEL " + Space(10) + "LINE"):PrintN("")
  ForEach Label()
    PrintN(LSet(Label()\LABEL_Name,19," ") + " " + RSet(Str(Label()\LABEL_Line),5," "))
  Next
  
  PrintN("")
  
  PrintN("--- CONST " + Space(10) + "LINE" + #CHAR_TAB + "VALUE"):PrintN("")
  ForEach Const()
    PrintN(LSet(Const()\CONST_Name,19," ") + " " + RSet(Str(Const()\CONST_Line),5," ") + #CHAR_TAB + Const()\CONST_Value)
  Next

  PrintN("")

EndProcedure

Procedure PrintSRC_TOKEN()
  PrintN("--------+-----------+-------------+------+----------------------+-----")
  PrintN("  Line  | Type      | Key         | Size | Value                | Pos ")
  PrintN("--------+-----------+-------------+------+----------------------+-----")
  
  ForEach Token()
    With token()
      Select \TokType
        Case #Typ_KEYWORD
          t$ = "#_KEYWORD"
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
        Case #Tok_ORG
          u$ = "#Tok_ORG   "
        Case #Tok_EQU
          u$ = "#Tok_EQU   "
        Case #Tok_EQUAL
          u$ = "#Tok_=     "
        Case #Tok_ASTERISK
          u$ = "#Tok_*     "
  
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
  
        Case #Tok_ADC
          u$ = "#Tok_ADC   "
        Case #Tok_AND
          u$ = "#Tok_AND   "
        Case #Tok_ASL
          u$ = "#Tok_ASL   "
        Case #Tok_BCC
          u$ = "#Tok_BCC   "
        Case #Tok_BCS
          u$ = "#Tok_BCS   "
        Case #Tok_BEQ
          u$ = "#Tok_BEQ   "
        Case #Tok_BIT
          u$ = "#Tok_BIT   "
        Case #Tok_BMI
          u$ = "#Tok_BMI   "
        Case #Tok_BNE
          u$ = "#Tok_BNE   "
        Case #Tok_BPL
          u$ = "#Tok_BPL   "
        Case #Tok_BRK
          u$ = "#Tok_BRK   "
        Case #Tok_BVC
          u$ = "#Tok_BVC   "
        Case #Tok_BVS
          u$ = "#Tok_BVS   "
        Case #Tok_CLC
          u$ = "#Tok_CLC   "
        Case #Tok_CLD
          u$ = "#Tok_CLD   "
        Case #Tok_CLI
          u$ = "#Tok_CLI   "
        Case #Tok_CLV
          u$ = "#Tok_CLV   "
        Case #Tok_CMP
          u$ = "#Tok_CMP   "
        Case #Tok_CPX
          u$ = "#Tok_CPX   "
        Case #Tok_CPY
          u$ = "#Tok_CPY   "
        Case #Tok_DEC
          u$ = "#Tok_DEX   "
        Case #Tok_DEX
          u$ = "#Tok_DEX   "
        Case #Tok_DEY
          u$ = "#Tok_DEY   "
        Case #Tok_EOR
          u$ = "#Tok_EOR   "
        Case #Tok_INC
          u$ = "#Tok_INC   "
        Case #Tok_INX
          u$ = "#Tok_INX   "
        Case #Tok_INY
          u$ = "#Tok_INY   "
        Case #Tok_JMP
          u$ = "#Tok_JMP   "
        Case #Tok_JSR
          u$ = "#Tok_JSR   "
        Case #Tok_LDA
          u$ = "#Tok_LDA   "
        Case #Tok_LDX
          u$ = "#Tok_LDX   "
        Case #Tok_LDY
          u$ = "#Tok_LDY   "
        Case #Tok_LSR
          u$ = "#Tok_LSR   "
        Case #Tok_NOP
          u$ = "#Tok_NOP   "
        Case #Tok_ORA
          u$ = "#Tok_ORA   "
        Case #Tok_PHA
          u$ = "#Tok_PHA   "
        Case #Tok_PHP
          u$ = "#Tok_PHP   "
        Case #Tok_PLA
          u$ = "#Tok_PLA   "
        Case #Tok_PLP
          u$ = "#Tok_PLP   "
        Case #Tok_ROL
          u$ = "#Tok_ROL   "
        Case #Tok_ROR
          u$ = "#Tok_ROR   "
        Case #Tok_RTI
          u$ = "#Tok_RTI   "
        Case #Tok_RTS
          u$ = "#Tok_RTS   "
        Case #Tok_SBC
          u$ = "#Tok_SBC   "
        Case #Tok_SEC
          u$ = "#Tok_SEC   "
        Case #Tok_SED
          u$ = "#Tok_SED   "
        Case #Tok_SEI
          u$ = "#Tok_SEI   "
        Case #Tok_STA
          u$ = "#Tok_STA   "
        Case #Tok_STX
          u$ = "#Tok_STX   "
        Case #Tok_STY
          u$ = "#Tok_STY   "
        Case #Tok_TAX
          u$ = "#Tok_TAX   "
        Case #Tok_TAY
          u$ = "#Tok_TAY   "
        Case #Tok_TSX
          u$ = "#Tok_TSX   "
        Case #Tok_TXA
          u$ = "#Tok_TXA   "
        Case #Tok_TXS
          u$ = "#Tok_TXS   "
        Case #Tok_TYA
          u$ = "#Tok_TYA   "
        
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
  Next
  
  PrintN("--------+-----------+-------------+------+----------------------+-----")
EndProcedure

Procedure PrintSRC_LIST()
  PrintN("--------+-------------------------------------------------------------")
  PrintN("  Line  | Source")
  PrintN("--------+-------------------------------------------------------------")

  t$ = "" : curline = 0

  ForEach Token()
    lineTok = Token()\TokLine
    litok$ = "(" + RSet(Str(curline),4,"0") + ")"

    pstok = Token()\TokPos
    If pstok <= oldpstok

;     If lineTok <> oldlineTok
      PrintN(" " + litok$ + " | " + t$) : t$ = ""
      curline + 1
      tt = #False
    EndIf

    If Token()\TokType = #Typ_LABEL
      t$ = LSet(Token()\TokValue,15," ") : ll = Len(Token()\TokValue)
    Else
      If Token()\TokType = #Typ_KEYWORD
        t$ + Space(15-ll) + LSet(Token()\TokValue,5," ")
      Else
        t$ + Token()\TokValue
      EndIf
    EndIf

;     If Token()\TokType = #Typ_KEYWORD Or Token()\TokType = #Typ_CONST Or Token()\TokType = #Typ_LABEL
;       If Token()\TokKey = #Tok_OTHER And Token()\TokPos = 1
;         t$ + #CHAR_TAB + Token()\TokValue 
;       Else
;         t$ + Token()\TokValue + #CHAR_TAB
;       EndIf
;     Else
;       t$ + Token()\TokValue
;     EndIf
;    t$ + Token()\TokValue + #CHAR_TAB

    oldpstok = pstok
    oldlineTok = lineTok
  Next
  
  PrintN(" " + litok$ + " | " + t$)
  PrintN("--------+-------------------------------------------------------------")
EndProcedure

;- Main
OpenConsole()
Init()
ASM_HELP = #False

ARGC = CountProgramParameters()

If ARGC = 0 : usage() : EndIf

For i = 0 To ARGC - 1
  AddElement(argv())
    ARGV() = ProgramParameter(i)
Next i

ResetList(ARGV())
ForEach ARGV()
  If Left(ARGV(),1) = "-"
    Select LCase(ARGV())
      Case "-h","--help"
        ASM_HELP = #True
        Break
      Default
        PrintN("Unknow option")
        Usage()
    EndSelect
  EndIf
Next

If ASM_HELP = #True
  Usage()
EndIf

ResetList(ARGV())
SelectElement(ARGV(),0)
the_file = ARGV()

If OpenSRC(the_file) = -1
  PrintN("File "+the_file+" not found") : End
EndIf

PreProcess()

PrintSRC_TOKEN()
;PrintSRC_LIST()

PrintLABEL_CONST()

;Print("Frappez 'Entree'..."):Input()
CloseConsole()
End

DataSection
  dToken:
;    Data.s "ORgEQuLDaLDxLDySTaSTxSTyINcINxINyDEcDExDEyCMpCPxCPyBEqBPlBNeBCcBCsJSrJMpRTsAScDaDFb@"
    Data.s "ORG","EQU","=","*","LST","AST","ASC","DA","DFB","DS","HEX"

    Data.s "ADC","AND","ASL","BCC","BCS","BEQ","BIT","BMI","BNE","BPL","BRK","BVC","BVS"
    Data.s "CLC","CLD","CLI","CLV","CMP","CPX","CPY","DEC","DEX","DEY","EOR","INC","INX"
    Data.s "INY","JMP","JSR","LDA","LDX","LDY","LSR","NOP","ORA","PHA","PHP","PLA","PLP"
    Data.s "ROL","ROR","RTI","RTS","SBC","SEC","SED","SEI","STA","STX","STY","TAX","TAY"
    Data.s "TSX","TXA","TXS","TYA"
    Data.s "@@@"

EndDataSection
; IDE Options = PureBasic 4.40 Beta 7 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 956
; FirstLine = 640
; Folding = ------
; Executable = adir_assembler.exe
; CompileSourceDirectory
; EnableCompileCount = 1
; EnableBuildCount = 0