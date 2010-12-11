Procedure.s FindConstant(Const.s)
Protected result.s = ""

  ForEach Const()
    If Const = Const()\CONST_Name
      result = Const()\CONST_Value
      Break
    EndIf
  Next

  ProcedureReturn result
EndProcedure

; IDE Options = PureBasic 4.50 Beta 2 (Windows - x86)
; CursorPosition = 12
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant