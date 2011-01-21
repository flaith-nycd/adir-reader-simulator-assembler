;- Procedures Affichages
Procedure INVERSE()
  ConsoleColor(4,6)
EndProcedure

Procedure NORMAL()
  ConsoleColor(7,0)
EndProcedure
  
Procedure PrintRegister()
  Protected.s _sRegisters = Binary(Registers\P\Flag), _sTMP = ""
  Protected.i i

  For i = 1 To Len(_sRegisters)
    _sTMP = Mid(_sRegisters, i, 1)
    Select i
      Case 1 : If _sTMP = "1" : INVERSE() : Print("N") : NORMAL() : Else : Print("N") : EndIf 
      Case 2 : If _sTMP = "1" : INVERSE() : Print("V") : NORMAL() : Else : Print("V") : EndIf 
      Case 3 : If _sTMP = "1" : INVERSE() : Print("-") : NORMAL() : Else : Print("-") : EndIf 
      Case 4 : If _sTMP = "1" : INVERSE() : Print("B") : NORMAL() : Else : Print("B") : EndIf 
      Case 5 : If _sTMP = "1" : INVERSE() : Print("D") : NORMAL() : Else : Print("D") : EndIf 
      Case 6 : If _sTMP = "1" : INVERSE() : Print("I") : NORMAL() : Else : Print("I") : EndIf 
      Case 7 : If _sTMP = "1" : INVERSE() : Print("Z") : NORMAL() : Else : Print("Z") : EndIf 
      Case 8 : If _sTMP = "1" : INVERSE() : Print("C") : NORMAL() : Else : Print("C") : EndIf 
    EndSelect
  Next
  PrintN("")
EndProcedure

Procedure Print_OEM(__Message.s)
  Protected _sMessage.s = __Message
  CharToOem_(@__Message, @_sMessage)
  Print(_sMessage)
EndProcedure

Procedure PrintN_OEM(__Message.s)
  Protected _sMessage.s = __Message
  CharToOem_(@__Message, @_sMessage)
  PrintN(_sMessage)
EndProcedure

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 40
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant