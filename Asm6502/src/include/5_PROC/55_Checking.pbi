;-Check MultiValue for a constant
Procedure.i CheckMultiValue(sTok.s, Size.i, CurrentLine.i)
Protected Result.i = #Tok_OTHER
Protected PosFindQuote = FindString(sTok, Chr(34), 1)
Protected PosFindLastQuote.i = 0

  If PosFindQuote = 0                     ; No Quote and no ',x' or ',Y'
    If FindString(LCase(sTok),",y",1) = 0 And FindString(LCase(sTok),",x",1) = 0
      If FindString(sTok,",",1) > 0
        Result = #Tok_MULTI
      EndIf
    EndIf
  Else
    PosFindLastQuote = FindString(sTok, Chr(34), PosFindQuote+1)
    If PosFindLastQuote > 0               ; Searching for a second quote
      If FindString(sTok,",",PosFindLastQuote+1) > 0
        Result = #Tok_MULTI
      EndIf
    EndIf
  EndIf

  ByteSize = #_NONE
  ProcedureReturn result
EndProcedure

;-Check Tokens, constants & labels
Procedure.i CheckToken(sTok.s, PosTok = 1)
Protected i.i, result.i = #Tok_OTHER
Protected PosX.i, PosY.i, LensTok.i

  TypeToken = #Typ_CONST
  Result = CheckMultiValue(sTok, ByteSize, CurrentLine)

  If Left(LCase(sTok),1) = "$" And TypeToken = #Typ_CONST And Result <> #Tok_MULTI
    Result = #Tok_VALUE
    LensTok = Len(sTok)-1                                 ; -1 for the '$'
    
    ; if sTok contains ,X or ,Y
    PosX = FindString(LCase(sTok),",x",1)
    PosY = FindString(LCase(sTok),",y",1)
    If PosX > 1 : LensTok = PosX-2 : EndIf                ; -2 for the comma ',' and the '$'
    If PosY > 1 : LensTok = PosY-2 : EndIf

    If LensTok >= 3 And LensTok < 5                       ; if sTok = $ABCD : Word
      ByteSize = #_WORD
    ElseIf LensTok >= 1 And LensTok < 3                   ; If sTok = $AB   : Byte
      ByteSize = #_BYTE
    Else                                                  ; if no "," : error too long value
      ByteSize = #_NONE
      Result = #Tok_ERROR
      AddError(#ERR_CONST_TOOLONG, CurrentLine)
    EndIf
  EndIf  
  
  If Left(LCase(sTok),2) = "#$" And TypeToken = #Typ_CONST
    Result = #Tok_VALUE
    If Len(sTok)-2 >= 1 And Len(sTok)-2 < 3
      ByteSize = #_BYTE
    Else
      ByteSize = #_NONE
      Result = #Tok_ERROR
      AddError(#ERR_IMM_TOOLONG, CurrentLine)
    EndIf
    
  EndIf
  
  If Left(LCase(sTok),1) = "%" And TypeToken = #Typ_CONST And Result <> #Tok_MULTI
    ByteSize = #_BIN
    Result = #Tok_VALUE
  EndIf

  ; Check if the second Token is known as a predefined keyword
  If PosTok = 2
    For i = 0 To #NB_TOK - 1
      If LCase(sTok) = tToken(i)
        TypeToken = #Typ_KEYWORD
        result = i
      EndIf
    Next i
  
    ForEach tOpcode()
      If UCase(sTok) = tOpcode()\opc_MNEMONIC
        TypeToken = #Typ_OPCODE
        result = ListIndex(tOpcode()) + #NB_TOK
        Break
      EndIf
    Next
  EndIf

  If TypeToken = #Typ_CONST And Result = #Tok_OTHER
    If FindString(sTok,"+",1) : TypeToken = #Typ_COMPUTE : EndIf
    If FindString(sTok,"-",1) : TypeToken = #Typ_COMPUTE : EndIf
    If FindString(sTok,"*",1) : TypeToken = #Typ_COMPUTE : EndIf
    If FindString(sTok,"/",1) : TypeToken = #Typ_COMPUTE : EndIf
    If IsDecimal(sTok)
      Result = #Tok_VALUE
      ByteSize = #_DECI
    EndIf
  EndIf 

  ProcedureReturn result
EndProcedure

Procedure.i CheckInvalidChar(text.s)
Protected result.i = #False
Protected i.i, a.s  

  For i = 0 To Len(text)-1
    a = Mid(text,i,1)
    If FindString(#INVALID_CHAR,a,1)
      result = #True
    EndIf
  Next
  ProcedureReturn result
EndProcedure

;Check double Labels & Constants definition...
Procedure CheckDoubleLC()
Protected NewMap tmplabel.sLABEL(), NewMap tmpConst.sCONST()
Protected tmp$, ll$, li$
  
  If ListSize(Label()) > 0
    ;Enlève tous les doublons en les mettant dans une liste temporaire
    ; les labels
    SortStructuredList(Label(),#PB_Sort_Ascending,OffsetOf(sLABEL\LABEL_Name), #PB_Sort_String)
    FirstElement(Label())
    AddMapElement(tmplabel(),Label()\LABEL_Name)
      tmplabel()\LABEL_Name = Label()\LABEL_Name
      tmplabel()\LABEL_Line = Label()\LABEL_Line
    tmp$ = Label()\LABEL_Name
  
    While NextElement(Label())
      If Label()\LABEL_Name <> tmp$
        AddMapElement(tmplabel(),Label()\LABEL_Name)
          tmplabel()\LABEL_Name = Label()\LABEL_Name
          tmplabel()\LABEL_Line = Label()\LABEL_Line
      EndIf
      tmp$ = Label()\LABEL_Name
    Wend

    ;Verifie les erreurs de doublons
    FirstElement(Label())
    tmp$ = Label()\LABEL_Name
  
    While NextElement(Label())
      If Label()\LABEL_Name = tmp$
        FindMapElement(tmplabel(), Label()\LABEL_Name)
        ll$ = tmplabel()\LABEL_Name
        li$ = Str(tmplabel()\LABEL_Line)
        AddError(#ERR_LABEL_DEFINED, Label()\LABEL_Line, ll$, li$)
      Else
        tmp$ = Label()\LABEL_Name
      EndIf
    Wend
  EndIf
  
  If ListSize(Const()) > 0
    ; les constantes
    SortStructuredList(Const(),#PB_Sort_Ascending,OffsetOf(sCONST\CONST_Name), #PB_Sort_String)
    FirstElement(Const())
    AddMapElement(tmpConst(),Const()\CONST_Name)
      tmpconst()\CONST_Name = Const()\CONST_Name
      tmpConst()\CONST_Line = Const()\CONST_Line
    tmp$ = Const()\CONST_Name
  
    While NextElement(Const())
      If Const()\CONST_Name <> tmp$
        AddMapElement(tmpConst(),Const()\CONST_Name)
          tmpconst()\CONST_Name = Const()\CONST_Name
          tmpConst()\CONST_Line = Const()\CONST_Line
      EndIf
      tmp$ = Const()\CONST_Name
    Wend

    ;Verifie les erreurs de doublons
    FirstElement(Const())
    tmp$ = Const()\CONST_Name
  
    While NextElement(Const())
      If Const()\CONST_Name = tmp$
        FindMapElement(tmpConst(), Const()\CONST_Name)
        ll$ = tmpconst()\CONST_Name
        li$ = Str(tmpConst()\CONST_Line)
        AddError(#ERR_CONST_DEFINED, Const()\CONST_Line, ll$, li$)
      Else
        tmp$ = Const()\CONST_Name
      EndIf
    Wend
  EndIf

EndProcedure

Procedure CheckORG(ORG.s)
Protected result.s = GetConstValue(ORG)
Protected tmp$

  If result = ""
    tmp$ = ORG
  Else
    tmp$ = result
  EndIf

  _ORG_ = Val(tmp$)
EndProcedure

Procedure.i CheckOpcode(ConstLabel.s)
Protected result.i = #False
Protected i.i

  For i = 0 To #NB_TOK-1
    If UCase(ConstLabel) = UCase(tToken(i))
      result = #True
      Break
    EndIf
  Next
    
  ForEach tOpcode()
    If UCase(ConstLabel) = tOpcode()\opc_MNEMONIC
      result = #True
      Break
    EndIf
  Next
  ProcedureReturn result
EndProcedure

Procedure.i CheckValidConst(Const.s)
Protected Result.i = 0
; du moins important au plus important

  If Len(Const) > #MAXCHARCONST
    result = #ERR_CL_TOOLOONG
  EndIf

  If IsDecimal(Left(Const,1))
    result = #ERR_CL_STARTWITHNUM
  EndIf

  If CheckOpcode(Const)
    result = #ERR_CONST_EQUAL_OPCODE
  EndIf

  If CheckInvalidChar(Const)
    result = #ERR_CL_INVALIDCHAR
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure.i CheckValidLabel(Label.s)
Protected Result.i = 0
; du moins important au plus important  

  If Len(Label) > #MAXCHARLABEL
    result = #ERR_CL_TOOLOONG
  EndIf

  If IsDecimal(Left(Label,1))
    result = #ERR_CL_STARTWITHNUM
  EndIf

  If CheckOpcode(Label)
    result = #ERR_LABEL_EQUAL_OPCODE
  EndIf

  If CheckInvalidChar(Label)
    result = #ERR_CL_INVALIDCHAR
  EndIf

  ProcedureReturn Result
EndProcedure

;Check if Labels or Constants
Procedure CheckIfLabelOrConst()
Protected TMP_CONST.s = ""
Protected Get_ORG.i = #False, TypeCONST.i = #False, tkValue.i = 0, Result.i = 0, found.i = 0

  DEBUG_LOG("ListSize(Token()) = "+Str(ListSize(Token())))

  ForEach Token()

    If Token()\TokB\Key = #Tok_ORG And Get_ORG = #False
      SET_ORG = Token()\TokC\Value
      Get_ORG = #True
      _EIP_ = 0
    EndIf

    If Token()\TokA\Type = #Typ_CONST
      TypeCONST = #False

      ;for adding const name & value where we find EQU or =
      TMP_CONST = Token()\TokA\Value

      ;Verifie si Constante est Ok :
      ; - Ne doit pas commencer par un chiffre
      ; - Ne doit pas comporter de caractères de séparations
      ; - Ne doit pas dépasser une longueur de X caractères
      Result = CheckValidConst(TMP_CONST)
      DEBUG_LOG("CheckValidConst("+TMP_CONST+") : Result = "+Str(Result))
      If Result = 0
        ; Check value where opcode = EPZ
        If Token()\TokB\Key = #Tok_EPZ
          If Left(Token()\TokC\Value,1) = "$"                     ; it must be a Zero Page Value
            If Len(Token()\TokC\Value) = 3                        ; So len = 3
              If CheckOpcode(Token()\TokC\Value) = 0
                DEBUG_LOG("CheckOpcode("+Token()\TokC\Value+")")
                AddElement(Const())
                  Const()\CONST_Name  = TMP_CONST
                  Const()\CONST_Value = Token()\TokC\Value
                  Const()\CONST_Line  = Token()\TokLine
                  TypeCONST = #True
                  DEBUG_LOG("---ADD CONST: ["+Const()\CONST_Name+"] ["+Const()\CONST_Value+"] ["+Str(Const()\CONST_Line)+"]")
              Else
                AddError(#ERR_VALUE_EQUAL_OPCODE, Token()\TokLine); Bad declaration : Value used is a protected keyword
              EndIf
            Else
              AddError(#ERR_BAD_ZP_CONSTANT,Token()\TokLine)      ; else it's an error
            EndIf
          EndIf
        EndIf
        
        ; Check value where opcode = EQU or '='
        If Token()\TokB\Key = #Tok_EQU Or Token()\TokB\Key = #Tok_EQUAL
          If Left(Token()\TokC\Value,1) = "*"                     ; If we have a '*' its a label, we need to set the adress after
            tkValue = 0 : TypeCONST = #False
          Else
            tkValue + 1
            If CheckOpcode(Token()\TokC\Value) = 0
              DEBUG_LOG("CheckOpcode("+Token()\TokC\Value+")")
              AddElement(Const())
                Const()\CONST_Name  = TMP_CONST
                Const()\CONST_Value = Token()\TokC\Value
                Const()\CONST_Line  = Token()\TokLine
                tkValue = 0
                TypeCONST = #True
                DEBUG_LOG("---ADD CONST: ["+Const()\CONST_Name+"] ["+Const()\CONST_Value+"] ["+Str(Const()\CONST_Line)+"]")
            Else
              AddError(#ERR_VALUE_EQUAL_OPCODE, Token()\TokLine)    ;Bad declaration : Value used is a protected keyword
            EndIf
            DEBUG_LOG("---------------")
          EndIf
        EndIf
      Else
        AddError(Result, Token()\TokLine)
        TypeCONST = #True                                           ; no double error (label/const)
      EndIf          

      If tkValue = 0 And TypeCONST = #False
        Token()\TokA\Type = #Typ_ERROR
        ;Verifie si Label est Ok :
        ; - Ne doit pas commencer par un chiffre
        ; - Ne doit pas comporter de caractères de séparations
        ; - Ne doit pas dépasser une longueur de X caractères
        Result = CheckValidLabel(Token()\TokA\Value)
        DEBUG_LOG("CheckValidLabel("+Token()\TokA\Value+") : Result = "+Str(Result))
        If Result = 0
          Token()\TokA\Type = #Typ_LABEL
          AddElement(Label())
            Label()\LABEL_Name   = Token()\TokA\Value
            Label()\LABEL_Line   = Token()\TokLine
            DEBUG_LOG("---ADD LABEL: ["+Label()\LABEL_Name+"] ["+Str(Label()\LABEL_Line)+"]")
        Else
          AddError(Result, Token()\TokLine)
        EndIf
        DEBUG_LOG("---------------")
      EndIf
      
    EndIf
    
    If Token()\TokB\Type = #Typ_CONST And Token()\TokB\Key = #Tok_OTHER
      found = 0
      ForEach tOpcode()
        If UCase(Token()\TokB\Value) = tOpcode()\opc_MNEMONIC
          found + 1
        EndIf
      Next
      If found = 0
        AddError(#ERR_BAD_OPCODE, Token()\TokLine, UCase(Token()\TokB\Value))
        Token()\TokB\Type = #Typ_KEYWORD
        Token()\TokB\Key  = #Tok_ERROR
      EndIf
    EndIf

  Next

  DEBUG_LOG("---- End proc CheckIfLabelOrConst()")
EndProcedure

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 44
; FirstLine = 16
; Folding = --
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant