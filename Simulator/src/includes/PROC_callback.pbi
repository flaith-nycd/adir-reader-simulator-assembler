;- Procedures CallBack
Procedure COUT()
  Protected.s _sCHR

  If Opcode = $20 Or Opcode = $4C
    Select registers\A
      Case $20 To $7E
        _sCHR = Chr(registers\A)
      Case $A0 To $FE
        _sCHR = Chr(registers\A - $80)
      Default
        _sCHR = "."
    EndSelect
    Print(_sCHR)
    ; Obligatoire, sinon il lance tout le reste
    CallInstruction($60)  
  EndIf
EndProcedure

Procedure SPKR()
  If Opcode = $2C Or Opcode = $AD
    ;INVERSE():PrintN("---SPKR"):NORMAL()
    If Random(1) = 1 : Beep_(8000,1) : EndIf
  EndIf
EndProcedure

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 21
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant