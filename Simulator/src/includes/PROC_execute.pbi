;-Execution des codes
Procedure CALL(__Org.u = $0300)
  Registers\PC = __Org

  StartRun = ElapsedMilliseconds()
  Repeat
    ShowAdress(Registers\PC)
    ;Opcode = Memory_6502(Registers\PC)
    Opcode = GetMemory_6502(Registers\PC)
    ; On ajoute 1 avant de faire le Call
    ; pour être ok avec les Modes d'Adressage de la mémoire
    Registers\PC + 1
    CallInstruction(Opcode)
    If FindMapElement(MapCallBack(), Hexa(Memory, #S_WORD)) : CallBack(Hexa(Memory, #S_WORD)) : EndIf
  Until Opcode = $00
  EndRun = ElapsedMilliseconds()
EndProcedure

Procedure BLOAD(__FileName.s, __Org.u = $0300)
  ;Protected.c _cOpcode
  Protected.a _aOpcode

  Registers\PC = __Org
  
  If FileSize(__FileName) > 0
    If ReadFile(#BINARY_FILE, __FileName)
      While Eof(#BINARY_FILE) = 0
        ;_cOpcode = ReadCharacter(#BINARY_FILE)
        _aOpcode = ReadAsciiCharacter(#BINARY_FILE)
        ;Memory_6502(__Org) = _cOpcode
        PutMemory_6502(__Org, _aOpcode)
        __Org + 1
      Wend
      CloseFile(#BINARY_FILE)
    Else
      PrintN("*** Couldn't open the file "+__FileName+" !")
      Print("Frappez 'Entree'"):Input()
      End
    EndIf
  Else
    PrintN("*** File "+__FileName+" not found !!!")
    Print("Frappez 'Entree'"):Input()
    End
  EndIf
EndProcedure

Procedure BRUN(__FileName.s, __Org.u = $0300)
  BLOAD(__FileName, __Org)
  CALL(__Org)
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 11
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant