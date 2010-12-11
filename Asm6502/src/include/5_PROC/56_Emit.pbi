;Explode value from multiple values like : ASC "HELLO WORLD!",8D,"HOW ARE YOU?",8D,8D,00
;and Emit code for output
Procedure.i PopEIP()
Protected Value.i

  Value = EIP()\DS_VALUE
  _EIP_ = EIP()\EIP
  PreviousElement(EIP())

  ProcedureReturn Value
EndProcedure

Procedure PushEIP(Value.i=0)
  AddElement(EIP())
    EIP()\EIP       = _EIP_
    EIP()\DS_VALUE  = Value
EndProcedure

Procedure AddOpcode(value.i)
;   AddElement(lstSrc()\Opcode())
;     lstSrc()\Opcode() = value
;   _EIP_ + 1
;   WriteByte(#BINARY_FILE, value)
EndProcedure

Procedure CheckDSValue(nbword.i, valasc.i)
Protected i.i

  If nbword = 0                                           ; No value so it's $00 by default
    For i = 1 To valasc
      AddOpcode(0)
    Next
  Else
    PushEIP(valasc) : _DS_ = #True                        ; so we keep it for the next emit
  EndIf
EndProcedure

Procedure.i CheckCompute(Value.s)
Protected posCompute.i, i.i, a$

  For i = 1 To Len(Value)
    a$ = Mid(Value,i,1)
    If FindString("+-*/",a$,1)
      posCompute = i
    EndIf
  Next
  
  ProcedureReturn posCompute
EndProcedure

Procedure.i Emit(string.s, NumLineSCR.i, nbword.i, typeToken.i=-1)
Protected i.i, valasc.i, lcar.s, asc$
Protected Diff_EIP.a, BaseEIP.a
Protected OLD_EIP.i

  lcar    = Left(string,1)
  OLD_EIP = _EIP_

  If _DS_ = #True                                         ; We're inside a 'DS' definition
    Diff_EIP = PopEIP()                                   ; Retrieve the Value we previously pushed
                                                          ; for the number of value to emit
    If Diff_EIP = 0
      BaseEIP = Val("$"+Right(HEXA(_EIP_, #S_WORD),2))
      Diff_EIP = $FF - BaseEIP
    EndIf

    If lcar <> #DBL_QUOTE And lcar <> #SIM_QUOTE          ; If it's not a String
      For i = 0 To Diff_EIP                               ; we do add the values
        valasc = Val(string)
        AddOpcode(valasc)
      Next
    Else
      _DS_ = #False                                       ; DO NOT FORGET
      For i = 0 To Diff_EIP                               ; we add several strings
        Emit(String, NumLineSCR, 0, #Tok_ASC)             ; thanks to recursivity :)
      Next
    EndIf

    _DS_ = #False
  Else

    Select typeToken
;       Case #Tok_HEX
;       Case #Tok_DA
;       Case #Tok_DB
;       Case #Tok_DW

      Case #Tok_ASC
        Select lcar

          Case #DBL_QUOTE                                 ;ASCII APPLE is Bit 7 Enable
            asc$ = Mid(string,2,Len(string)-2)
            For i =  1 To Len(asc$)
              valasc = Asc(Mid(asc$,i,1))
              valasc = valasc | %10000000
              AddOpcode(valasc)
            Next i

          Case #SIM_QUOTE                                 ;ASCII APPLE is Bit 7 Disable
            asc$ = Mid(string,2,Len(string)-2)
            For i =  1 To Len(asc$)
              valasc = Asc(Mid(asc$,i,1))
              AddOpcode(valasc)
            Next i

          Case "%","$"
            valasc = Val(string)
            AddOpcode(valasc)

          Default
            If IsDecimal(String)
              valasc = Val(string)
            Else
              valasc = Val("$"+String)
            EndIf
            AddOpcode(valasc)

        EndSelect

      Case #Tok_DS
        Select lcar

          Case "\"                                        ; Not a value so making opcodes 'til next boundary
            If nbword = 0                                 ; No value so it's $00 by default
              BaseEIP.a = Val("$"+Right(HEXA(_EIP_, #S_WORD),2))
              Diff_EIP.a = $FF - BaseEIP
              For i = 0 To Diff_EIP
                AddOpcode(0)
              Next
            Else
              PushEIP() : _DS_ = #True                    ; Keep current EIP
            EndIf

          Case "%","$"                                    ; If there is a value
            valasc = Val(string)  
            CheckDSValue(nbword, valasc)

          Default
            If IsDecimal(String)
              valasc = Val(string)
            ElseIf IsHexadecimal(String)
              valasc = Val("$"+String)
            EndIf
            CheckDSValue(nbword, valasc)

        EndSelect

      Case #Tok_DFB
        Select lcar

          Case "%","$"
            valasc = Val(string)
            AddOpcode(valasc)

          Default
            valasc = Val(string)
            AddOpcode(valasc)

        EndSelect
        
    EndSelect
  EndIf
  
  ProcedureReturn _EIP_ - OLD_EIP                         ; gives the number of bytes written
EndProcedure

Procedure.i Explode(string.s, separator.s = ",")
Protected tblIndex.i, indice.i, start.i
Protected QUOTE.i = #False
Protected car.s = ""
Protected Dim position.i(30)
Protected PosCompute.i, typeCompute.i
Protected LeftValue$, RightValue$

  tblIndex = 0 : indice = 1
  
  While indice <= Len(string)
    car = Mid(string, indice, 1)
    If car = #DBL_QUOTE And QUOTE = #False : QUOTE = #True  : indice + 1 : car = Mid(string, indice, 1) : EndIf
    If car = #DBL_QUOTE And QUOTE = #True  : QUOTE = #False : EndIf
    If car = separator And QUOTE = #False
      position(tblIndex) = indice
      tblIndex + 1
    EndIf
    indice + 1
  Wend

  position(tblIndex) = Len(String)+1

  start = 1
  For indice = 0 To tblIndex
    typeCompute = #COMPUTE_NONE
    tblExplode(indice) = Mid(string, start, position(indice)-start)
    start = position(indice)+1

    PosCompute = CheckCompute(tblExplode(indice))
    If PosCompute > 1
      LeftValue$=Left(tblExplode(indice), posCompute-1)
      RightValue$=Mid(tblExplode(indice), posCompute+1)
      Select Mid(tblExplode(indice), posCompute, 1)
        Case "+"
          typeCompute = #COMPUTE_ADD
          DEBUG_LOG("ADD "+RightValue$+" TO "+LeftValue$)
        Case "-"
          typeCompute = #COMPUTE_SUB
          DEBUG_LOG("SUB "+RightValue$+" TO "+LeftValue$)
        Case "*"
          typeCompute = #COMPUTE_MUL
          DEBUG_LOG("MUL "+RightValue$+" TO "+LeftValue$)
        Case "/"
          typeCompute = #COMPUTE_DIV
          DEBUG_LOG("DIV "+RightValue$+" TO "+LeftValue$)
      EndSelect
    EndIf

  Next

  ProcedureReturn tblIndex
EndProcedure

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 211
; FirstLine = 44
; Folding = --
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant