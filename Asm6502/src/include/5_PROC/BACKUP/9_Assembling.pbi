;-Pre-Process Assembly
Procedure PreProcess()
Protected PosTok.i

  ;PrintN("Pre-processing...")

  ForEach Src()
    CurrentLine = src()\line
    _line = src()\text
  
    CurrentPos = 0 : PosTok = 1

    LenLine = Len(_Line)
  
    While CurrentPos < LenLine
      nbspace = SkipSpace()
      If nbspace > 0
        PosTok + 1
        ;DEBUG_LOG("Postok="+Str(PosTok)+" nbspace = "+Str(nbspace)+" - Line:"+_line)
      EndIf

      a$=GetToken()
        If a$ <> ""
          If TypeToken <> #Typ_TEXT
            TypeToken = #Typ_OTHER              ;force type of token
          EndIf
          ByteSize = #_NONE
          type = CheckToken(a$,PosTok)

          AddElement(Token())
            Token()\TokPos = PosTok
            Token()\TokType = TypeToken
            Token()\TokKey = type
            Token()\TokValue = a$
            Token()\TokByteSize = ByteSize
            Token()\TokLine = CurrentLine
            PosTok + 1
        EndIf
      SkipSpace()
    Wend
  Next
  
  DEBUG_LOG("---Call procedure CheckLabelConst()")
  CheckLabelConst()
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
Protected result.i = 0
  ;result = pass1()
  ;result + pass2()
  ProcedureReturn Result
EndProcedure

Procedure.i Assembly()
Protected result.i = ListSize(ListError())

  PrintN("Program '"+the_file+"' starting at adress : $"+HEXA(_ORG_, #S_WORD)+" ("+Str(_ORG_)+")"):PrintN("")

  ;--End assembly, 70 bytes, Errors: 0
  Print("End assembly, ")
  Print(Str(TotalAssemblyBytes)+" Bytes, ")
  PrintN("Errors: "+Str(result))
  PrintN("")
  
  If result > 0

    If SHOW_NO_ERROR
      SortStructuredList(ListError(), #PB_Sort_Ascending, OffsetOf(sListError\line), #PB_Sort_Integer)
  
      ForEach ListError()
        ;PrintN("Error in line "+RSet(str(ListError()\line),5," ")+" : "+GetError(ListError()\num,ListError()\value1,ListError()\value2))
        ConsoleColor(12,0) : Print("Error in line "+RSet(Str(ListError()\line),6,"0")+": ")
        ConsoleColor(6,0) : PrintN(GetError(ListError()\num,ListError()\value1,ListError()\value2))
        ConsoleColor(7,0)
        If Val(ListError()\value2) > 0
          SelectElement(src(),Val(ListError()\value2)-1)
          Src$ = ReplaceString(src()\text,#TAB$," ")
          ConsoleColor(2,0)
          PrintN(RSet(Str(src()\line),8,"0")+" "+Trim(src$))
          ConsoleColor(7,0)
        EndIf
        SelectElement(src(),ListError()\line-1)
        Src$ = ReplaceString(src()\text,#TAB$," ")
        PrintN(RSet(Str(src()\line),8,"0")+" "+Trim(src$)):PrintN("")
      Next
      PrintN("")
      ;PrintSRC_LIST()
    EndIf
  Else
    result = Asm(#WD6502)
  EndIf

  ProcedureReturn result
EndProcedure

; IDE Options = PureBasic 4.50 Beta 3 (Windows - x86)
; CursorPosition = 52
; FirstLine = 12
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant