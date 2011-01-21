Procedure EnterASM(__Org.u, __Opcodes.s)
  Protected.i _iIndex
  Protected.a _aValue
  
  If Len(__Opcodes) % 2 <> 0
    PrintN_OEM("Problème dans la saisie des opcodes !!!")
    End
  EndIf

  For _iIndex = 0 To Len(__Opcodes) Step 2
    tmp$ = Mid(__Opcodes,_iIndex+1,2)
    _aValue = Val("$"+tmp$)
    PutMemory_6502(__Org, _aValue)
    __Org + 1
  Next
EndProcedure

Procedure.s Dump_OpcodeLine(__Opcode.s)
  Protected.s _sDisOpcode   = DISSASM_OPCODE
  Protected.s _sDisasm      = DISSASM_START+DISSASM_MIDDLE+DISSASM_END
  Protected.s _sAllRegister = " A=$"+Hexa(Registers\A)+" X=$"+Hexa(Registers\X)+" Y=$"+Hexa(Registers\Y)+" PC=$"+Hexa(Registers\PC,#S_WORD)+" S=$"+Hexa(#STACK+Registers\S,#S_WORD)+" | "
  Protected.i _iSpaceA      = 15 - Len(_sDisOpcode)
  Protected.i _iSpaceB      = 11 - Len(_sDisasm)
  ProcedureReturn _sDisOpcode+Space(_iSpaceA)+__Opcode+" "+_sDisasm+Space(_iSpaceB)+_sAllRegister
EndProcedure

Procedure Dump_MEMORY(__From.i, __To.i, __BytePerLine.i = #NB_BYTE_PER_LINE)
  Protected.s _sLineHEX = "", _sLineASC = "", _sCHR, _sSpace = ""
  Protected.a _aValue
  Protected.i _iFromTMP, _iIndex, _iCounter, _iLength, _iGAP

  _iFromTMP = __From
  _iLength  = __To - __From

  _aValue = GetMemory_6502(_iFromTMP + _iIndex)

  Select _aValue
    Case $20 To $7E
      _sCHR = Chr(_aValue)
    Case $A0 To $FE
      _sCHR = Chr(_aValue - $80)
    Default
      _sCHR = "."
  EndSelect

  _sLineHEX + Hexa(_aValue) + " "
  _sLineASC + _sCHR
  _iIndex + 1

  While _iIndex <= _iLength
    If _iIndex % __BytePerLine = 0
      PrintN(HEXA(__From, #S_WORD)+":"+_sLineHEX+"- "+_sLineASC)
      _sLineHEX = "" : _sLineASC = "" : _iCounter = _iIndex
      __From + __BytePerLine
    EndIf
    _aValue = GetMemory_6502(_iFromTMP + _iIndex)
    Select _aValue
      Case $20 To $7E
        _sCHR = Chr(_aValue)
      Case $A0 To $FE
        _sCHR = Chr(_aValue - $80)
      Default
        _sCHR = "."
    EndSelect
    _sLineHEX + Hexa(_aValue) + " "
    _sLineASC + _sCHR
    _iIndex + 1
  Wend

  _iGAP   = __BytePerLine - (_iLength - _iCounter)        ;compute space gap for align
  _sSpace = Space((_iGAP+_iGAP*2)-3)
  PrintN(HEXA(__From, #S_WORD)+":"+_sLineHEX+_sSpace+"- "+_sLineASC)
EndProcedure

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 73
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant