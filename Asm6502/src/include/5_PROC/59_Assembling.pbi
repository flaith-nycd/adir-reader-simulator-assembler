Procedure MakeCleanSrc()
Protected IsConst.i = 0
Protected ptypeA.i, ptypeB.i, ptypeC.i
  DEBUG_LOG("---Call procedure MakeCleanSrc()")
  
  ForEach Token()
    ptypeA = Token()\TokA\Type
    ptypeB = Token()\TokB\Type
    ptypeC = Token()\TokC\Type
;     DEBUG_LOG("ptypeA:("+Str(ptypeA)+")-ptypeB:("+Str(ptypeB)+")-ptypeC:("+Str(ptypeC)+")")
    If ptypeA = #Typ_KEYWORD Or ptypeB = #Typ_KEYWORD Or ptypeC = #Typ_KEYWORD
      ;IsConst = #Typ_KEYWORD
      IsConst = Token()\TokB\Key
    Else
      IsConst = 0
    EndIf
    AddElement(CleanSRC())
;       DEBUG_LOG("      AddElement(CleanSRC())")
      CleanSRC()\IsConst       = IsConst
      CleanSRC()\Label\Value   = Token()\TokA\Value
      CleanSRC()\Opcode\Value  = Token()\TokB\Value
      CleanSRC()\Opcode\Key    = Token()\TokB\Key
      CleanSRC()\Operand\Value = Token()\TokC\Value
      CleanSRC()\Operand\Key   = Token()\TokC\Key                 ; for having #Tok_MULTI
      CleanSRC()\Operand\Type  = Token()\TokC\Type                ; for having type like #Typ_Compute
      CleanSRC()\RealLine      = Token()\TokLine
;       DEBUG_LOG("      clean: "+Str(CleanSRC()\IsConst)+" | "+CleanSRC()\Label\Value+" "+CleanSRC()\Opcode\Value+" "+CleanSRC()\Operand\Value+" ;Line:"+Str(CleanSRC()\RealLine))
;       DEBUG_LOG("      ----------")
  Next   
EndProcedure

;-Pre-Process Assembly
Procedure PreProcess()
Protected PosTok.i
  
; Structure SClassTokenInterne
;   pos.i
;   type.i
;   key.i
;   value.s
;   byte.i
; EndStructure
; 
Protected Dim tblToken.SClassToken(39)      ;40 elements max
Protected i.i, nbspace.i, type.i
Protected a$

  DEBUG_LOG("Pre-processing...")

  ForEach Src()
    CurrentLine = src()\line
    _line = src()\text
    _QUOTE = #False                           ;must be 0
  
    CurrentPos = 0 : PosTok = 1

    LenLine = Len(_Line)

    For i = 0 To 39
      tblToken(i)\Pos       = #NA
      tblToken(i)\Type      = #NA
      tblToken(i)\Key       = #NA
      tblToken(i)\Value     = ""
      tblToken(i)\ByteSize  = #NA
    Next i

    While CurrentPos < LenLine
      nbspace = SkipSpace()
      If nbspace > 0                          ;going to the next token
        PosTok + 1
      EndIf

      a$=GetToken()
      If a$ <> ""
        If TypeToken <> #Typ_TEXT
          TypeToken = #Typ_OTHER              ;force type of token
        EndIf
        ByteSize = #_NONE
        type = CheckToken(a$,PosTok)

        tblToken(PosTok-1)\pos      = PosTok
        tblToken(PosTok-1)\type     = TypeToken
        tblToken(PosTok-1)\key      = type
        tblToken(PosTok-1)\value    = a$
        tblToken(PosTok-1)\ByteSize = ByteSize
        
        PosTok + 1
      EndIf
      SkipSpace()
    Wend
    
    ;If quote is defined but not closed, it's a mistake
    If _QUOTE = #True : AddError(#ERR_MISSING_QUOTE, CurrentLine) : EndIf

    If postok-2 > 2
      DEBUG_LOG("Unexpected Error in line "+Str(CurrentLine)+" : too much tokens")
      AddError(#ERR_TOO_MUCH_TOKEN, CurrentLine)
      Break
    EndIf

;     If tblToken(0)\Value = "" And tblToken(1)\Value = "" And tblToken(2)\Value = ""
;     Else
    If tblToken(0)\Value <> "" Or tblToken(1)\Value <> "" Or tblToken(2)\Value <> ""
      AddElement(Token())
        Token()\TokA\pos       = tblToken(0)\Pos
        Token()\TokA\type      = tblToken(0)\Type
        Token()\TokA\key       = tblToken(0)\Key
        Token()\TokA\value     = tblToken(0)\Value
        Token()\TokA\ByteSize  = tblToken(0)\ByteSize

        Token()\TokB\pos       = tblToken(1)\Pos
        Token()\TokB\type      = tblToken(1)\Type
        Token()\TokB\key       = tblToken(1)\Key
        Token()\TokB\value     = tblToken(1)\Value
        Token()\TokB\ByteSize  = tblToken(1)\ByteSize

        Token()\TokC\pos       = tblToken(2)\Pos
        Token()\TokC\type      = tblToken(2)\Type
        Token()\TokC\key       = tblToken(2)\Key
        Token()\TokC\value     = tblToken(2)\Value
        Token()\TokC\ByteSize  = tblToken(2)\ByteSize

        Token()\TokLine        = CurrentLine

      With Token()
        DEBUG_LOG("A:"+\TokA\Value+"("+Str(\TokA\Type)+")"+"-B:"+\TokB\Value+"("+Str(\TokB\Type)+")"+"-C:"+\TokC\Value+"("+Str(\TokC\Type)+")"+"-Line:"+Str(\TokLine))
        DEBUG_LOG("--------A:Key="+Str(\TokA\Key)+" B:Key="+Str(\TokB\Key)+" C:Key"+Str(\TokC\Key))
      EndWith

    EndIf

    For i = 0 To 39
      tblToken(i)\Pos       = #NA
      tblToken(i)\Type      = #NA
      tblToken(i)\Key       = #NA
      tblToken(i)\Value     = ""
      tblToken(i)\ByteSize  = #NA
    Next i
  Next

  DEBUG_LOG("---Call procedure CheckIfLabelOrConst()")
  CheckIfLabelOrConst()
  DEBUG_LOG("---Call procedure CheckDoubleLC()")
  CheckDoubleLC()
  If SET_ORG <> ""
    CheckORG(SET_ORG)
  Else
    CheckORG(#DEFAULT_ORG)
  EndIf
  
  MakeCleanSrc()
EndProcedure

;-Assembly
Procedure.i Asm(typeProc.i)
  DEBUG_LOG("---Call pass1()")
  pass1()
  DEBUG_LOG("---Call pass2()")
  pass2()

  ProcedureReturn ListSize(ListError())
EndProcedure

Procedure.i Assembly()
Protected NBErrorAsm.i = 0

  PrintN("Program '"+input_file+"' starting at adress : $"+HEXA(_ORG_, #S_WORD)+" ("+Str(_ORG_)+")"):PrintN("")
  NBErrorAsm = Asm(#PROC_6502)
  TotalAssemblyBytes = _EIP_ - _ORG_
  EndTimeAssembly = ElapsedMilliseconds()

  ;--End assembly, 70 bytes, Errors: 0
  Print("End assembly, ")
  Print(Str(TotalAssemblyBytes)+" Bytes, ")
  PrintN("Errors: "+Str(NBErrorAsm))
  PrintN("")

  ProcedureReturn NBErrorAsm
EndProcedure

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 157
; FirstLine = 125
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant