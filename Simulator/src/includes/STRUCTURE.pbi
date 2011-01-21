;-Structures
Structure CS_FlagRegister
  Flag.a
EndStructure

Structure CS_Register
  A.a
  X.a
  Y.a
  S.a
  P.CS_FlagRegister
  PC.u
  PCDisasm.i
EndStructure

Structure CS_Cycle
  Time.b
  Boundary.b
EndStructure

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 12
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant