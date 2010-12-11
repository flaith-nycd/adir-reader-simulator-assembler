;-DRI Proc
Procedure.i IsBinary(sTok.s)
  Protected Binary.i, *String.Character
 
  If sTok
    Binary = #True
    *String = @sTok
   
    While Binary And *String\c
      Binary = IsBinDigit(*String\c)
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

; IDE Options = PureBasic 4.50 Beta 2 (Windows - x86)
; CursorPosition = 48
; FirstLine = 2
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant