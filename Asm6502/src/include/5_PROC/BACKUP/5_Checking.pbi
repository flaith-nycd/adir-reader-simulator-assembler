;-Check Tokens, constants & labels
Procedure.i CheckToken(sTok.s, PosTok = 1)
Protected i.i, result.i = #Tok_OTHER

  TypeToken = #Typ_CONST

  If Left(LCase(sTok),1) = "$" And TypeToken = #Typ_CONST
    Result = #Tok_VALUE
    If Len(sTok)-1 >= 3 And Len(sTok)-1 < 5
      ByteSize = #_WORD
    ElseIf Len(sTok)-1 >= 1 And Len(sTok)-1 < 3
      ByteSize = #_BYTE
    ElseIf FindString(LCase(sTok),",y",1) > 0 Or FindString(LCase(sTok),",x",1) > 0
      ByteSize = #_WORD
    Else
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
  
  If Left(LCase(sTok),1) = "%" And TypeToken = #Typ_CONST
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

  For i = 0 To Len(text)-1
    a.s = Mid(text,i,1)
    If FindString(#INVALID_CHAR,a,1)
      result = #True
    EndIf
  Next
  ProcedureReturn result
EndProcedure

;Check double Labels & Constants definition...
Procedure CheckDoubleLC()
Protected NewMap tmplabel.sLABEL(), NewMap tmpConst.sCONST()
  SortStructuredList(Label(),#PB_Sort_Ascending,OffsetOf(sLABEL\LABEL_Name), #PB_Sort_String)
  SortStructuredList(Const(),#PB_Sort_Ascending,OffsetOf(sCONST\CONST_Name), #PB_Sort_String)
  
  ;Enlève tous les doublons en les mettant dans une liste temporaire
  ; les labels
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
  
  ; les constantes
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
  
  ;Verifie les erreurs de doublons avec 
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
  
  ; et constantes
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
EndProcedure

Procedure CheckORG(ORG.s)
  Protected result.s = FindConstant(ORG)

  If result = ""
    tmp$ = ORG
  Else
    tmp$ = result
  EndIf

  _ORG_ = Val(tmp$)
    
EndProcedure

Procedure.i CheckOpcode(ConstLabel.s)
Protected result.i = #False

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
    result = #ERR_CONST_TOOLOONG
  EndIf

  If IsDecimal(Left(Const,1))
    result = #ERR_CONST_STARTWITHNUM
  EndIf

  If CheckOpcode(Const)
    result = #ERR_CONST_EQUAL_OPCODE
  EndIf

  If CheckInvalidChar(Const)
    result = #ERR_CONST_INVALIDCHAR
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure.i CheckValidLabel(Label.s)
Protected Result.i = 0
; du moins important au plus important  

  If Len(Label) > #MAXCHARLABEL
    result = #ERR_LABEL_TOOLOONG
  EndIf

  If IsDecimal(Left(Label,1))
    result = #ERR_LABEL_STARTWITHNUM
  EndIf

  If CheckOpcode(Label)
    result = #ERR_LABEL_EQUAL_OPCODE
  EndIf

  If CheckInvalidChar(Label)
    result = #ERR_LABEL_INVALIDCHAR
  EndIf

  ProcedureReturn Result
EndProcedure

;Check Labels & Constants
Procedure CheckLabelConst()
Protected CurrElement.i = 0
Protected CurrLine.i, oldCurLine.i
Protected tkvalue.i = 0, TMP_CONST.s = ""
Protected changeElement.i = #False, Get_ORG.i = #False, TypeCONST.i = #False

  DEBUG_LOG("ListSize(Token()) = "+Str(ListSize(Token())))

  FirstElement(Token())
  While CurrElement <= ListSize(Token())

    If Token()\TokKey = #Tok_ORG And Get_ORG = #False
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

      While oldCurLine = CurrLine And CurrElement <= ListSize(Token())
        If tkvalue > 0 And Token()\TokPos = 3
          ;Verifie si Constante est Ok :
          ; - Ne doit pas commencer par un chiffre
          ; - Ne doit pas comporter de caractères de séparations
          ; - Ne doit pas dépasser une longueur de X caractères
          Result = CheckValidConst(TMP_CONST)
          DEBUG_LOG("CheckValidConst("+TMP_CONST+") : Result = "+Str(Result))
          If Result = 0
            If CheckOpcode(Token()\TokValue) = 0
              DEBUG_LOG("CheckOpcode("+Token()\TokValue+")")
              AddElement(Const())
                Const()\CONST_Name  = TMP_CONST
                Const()\CONST_Value = Token()\TokValue
                Const()\CONST_Line  = Token()\TokLine
                DEBUG_LOG("---ADD CONST: ["+Const()\CONST_Name+"] ["+Const()\CONST_Value+"] ["+Str(Const()\CONST_Line)+"]")
            Else
              AddError(#ERR_VALUE_EQUAL_OPCODE, Token()\TokLine)
            EndIf
          Else
            AddError(Result, Token()\TokLine)
          EndIf          
;           AddElement(Const())
;             Const()\CONST_Name  = TMP_CONST
;             Const()\CONST_Value = Token()\TokValue 
;             Const()\CONST_Line  = Token()\TokLine
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
        DEBUG_LOG("ThisElement = "+Str(ThisElement))
        SelectElement(Token(),ThisElement)
        Token()\TokType = #Typ_LABEL
        
        ;Verifie si Label est Ok :
        ; - Ne doit pas commencer par un chiffre
        ; - Ne doit pas comporter de caractères de séparations
        ; - Ne doit pas dépasser une longueur de X caractères
        Result = CheckValidLabel(Token()\TokValue)
        DEBUG_LOG("CheckValidLabel("+Token()\TokValue+") : Result = "+Str(Result))
        If Result = 0
          AddElement(Label())
            Label()\LABEL_Name = Token()\TokValue
            Label()\LABEL_Line = Token()\TokLine
            DEBUG_LOG("---ADD LABEL: ["+Label()\LABEL_Name+"] ["+Str(Label()\LABEL_Line)+"]")
        Else
          AddError(Result, Token()\TokLine)
        EndIf

        CurrElement - 1
        DEBUG_LOG("CurrElement = "+Str(CurrElement))
        If SelectElement(Token(),CurrElement)
        Else
          DEBUG_LOG("ERROR SelectElement(Token(),CurrElement)")
          DEBUG_LOG("Taking LastElement(Token())")
          LastElement(Token())
        EndIf
        DEBUG_LOG("---------------")
        
        tkvalue = 0
        changeElement = #True
      EndIf
      
    EndIf
    
    If Token()\TokPos = 2 And Token()\TokType = #Typ_CONST And Token()\TokKey = #Tok_OTHER
      found = 0
      ForEach tOpcode()
        If UCase(Token()\TokValue) = tOpcode()\opc_MNEMONIC
          found + 1
        EndIf
      Next
      If found = 0
        AddError(#ERR_BAD_OPCODE, Token()\TokLine, UCase(Token()\TokValue))
        Token()\TokType = #Typ_KEYWORD
        Token()\TokKey  = #Tok_ERROR
      EndIf
    EndIf

    oldCurLine = CurLine
    CurrElement + 1
    tkvalue = 0

    NextElement(Token())
  Wend
  
  DEBUG_LOG("---- End proc CheckLabelConst()")
EndProcedure

; IDE Options = PureBasic 4.50 Beta 3 (Windows - x86)
; CursorPosition = 304
; FirstLine = 297
; Folding = --
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant