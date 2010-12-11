Procedure.s GetConstValue(Const.s)
Protected result.s = ""

  ForEach Const()
    If LCase(Const) = LCase(Const()\CONST_Name)
      result = Const()\CONST_Value
      Break
    EndIf
  Next

  ProcedureReturn result
EndProcedure

Procedure.i GetLabelLine(Label.s)
Protected result.i = 0

  ForEach Label()
    If LCase(Label) = LCase(Label()\LABEL_Name)
      result = Label()\LABEL_Line
      Break
    EndIf
  Next

  ProcedureReturn result
EndProcedure

Procedure.i GetLabelAdress(Label.s)
Protected result.i = 0

  ForEach Label()
    If LCase(Label) = LCase(Label()\LABEL_Name)
      result = Label()\LABEL_Adress
      Break
    EndIf
  Next

  ProcedureReturn result
EndProcedure

Procedure.i SetLabelAdress(Line.i, Adress.i)
Protected result.i = #False

  ForEach Label()
    If Line = Label()\LABEL_Line
      Label()\LABEL_Adress = Adress
      result = #True
      Break
    EndIf
  Next

  ProcedureReturn result
EndProcedure

; IDE Options = PureBasic 4.50 RC 2 (Windows - x86)
; CursorPosition = 32
; FirstLine = 5
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant