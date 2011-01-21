;-------------------------------------------------------------------------
;-Memory Addressing Modes For Disassembling
;* #Implied *
Procedure ADRMODEDIS_implied()
  ProcedureReturn 0
EndProcedure
;* #Immediate *
Procedure ADRMODEDIS_immediate()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))
  LINE_ASM + _sVAL1
  LINE_DISASM + "#$" + _sVAL1
  ProcedureReturn 1
EndProcedure
;* ABS *
Procedure ADRMODEDIS_abs()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))
  Protected.s _sVAL2 = Hexa(Memory_6502(Registers\PCDisasm + 1))

  LINE_ASM + _sVAL1 + " " + _sVAL2
  LINE_DISASM + "$" + _sVAL2 + _sVAL1
  ProcedureReturn 2
EndProcedure
;* Branch *
Procedure ADRMODEDIS_relative()
  Protected.a _aSaut = Memory_6502(Registers\PCDisasm)
  Protected.s _sVAL1 = Hexa(_aSaut)

  LINE_ASM + _sVAL1
  ; Si _uSaut > $7F : on va vers le haut (pour les sauts)
  If (_aSaut & $80)
    _sVAL1 = Hexa((Registers\PCDisasm) - ($FF - _aSaut),#S_WORD)
  Else
    _sVAL1 = Hexa((Registers\PCDisasm) + _aSaut + 1,#S_WORD)
  EndIf

  LINE_DISASM + "$" + _sVAL1
  ProcedureReturn 1
EndProcedure
;* (ABS) *
Procedure ADRMODEDIS_indirect()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))
  Protected.s _sVAL2 = Hexa(Memory_6502(Registers\PCDisasm + 1))

  LINE_ASM + _sVAL1 + " " + _sVAL2
  LINE_DISASM + "($" + _sVAL2 + _sVAL1 + ")"
  ProcedureReturn 2
EndProcedure
;* ABS,X *
Procedure ADRMODEDIS_absx()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))
  Protected.s _sVAL2 = Hexa(Memory_6502(Registers\PCDisasm + 1))

  LINE_ASM + _sVAL1 + " " + _sVAL2
  LINE_DISASM + "$" + _sVAL2 + _sVAL1 + ",X"
  ProcedureReturn 2
EndProcedure
;* ABS,Y *
Procedure ADRMODEDIS_absy()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))
  Protected.s _sVAL2 = Hexa(Memory_6502(Registers\PCDisasm + 1))

  LINE_ASM + _sVAL1 + " " + _sVAL2
  LINE_DISASM + "$" + _sVAL2 + _sVAL1 + ",Y"
  ProcedureReturn 2
EndProcedure
;* ZP *
Procedure ADRMODEDIS_zp()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))

  LINE_ASM + _sVAL1
  LINE_DISASM + "$" + _sVAL1
  ProcedureReturn 1
EndProcedure
;* ZP,X *
Procedure ADRMODEDIS_zpx()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))

  LINE_ASM + _sVAL1
  LINE_DISASM + "$" + _sVAL1 + ",X"
  ProcedureReturn 1
EndProcedure
;* ZP,Y *
Procedure ADRMODEDIS_zpy()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))

  LINE_ASM + _sVAL1
  LINE_DISASM + "$" + _sVAL1 + ",Y"
  ProcedureReturn 1
EndProcedure
;* (ZP,X) *
Procedure ADRMODEDIS_indx()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))

  LINE_ASM + _sVAL1
  LINE_DISASM + "($" + _sVAL1 + ",X)"
  ProcedureReturn 1
EndProcedure
;* (ZP),Y *
Procedure ADRMODEDIS_indy()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))

  LINE_ASM + _sVAL1
  LINE_DISASM + "($" + _sVAL1 + "),Y"
  ProcedureReturn 1
EndProcedure
;* (ABS,X) *
Procedure ADRMODEDIS_indabsx()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))
  Protected.s _sVAL2 = Hexa(Memory_6502(Registers\PCDisasm + 1))

  LINE_ASM + _sVAL1 + " " + _sVAL2
  LINE_DISASM + "($" + _sVAL2 + _sVAL1 + ",X)"
  ProcedureReturn 2
EndProcedure
;* (ZP) *
Procedure ADRMODEDIS_indzp()
  Protected.s _sVAL1 = Hexa(Memory_6502(Registers\PCDisasm))

  LINE_ASM + _sVAL1
  LINE_DISASM + "($" + _sVAL1 + ")"
  ProcedureReturn 1
EndProcedure

;-Disassembling
Procedure Disasm_MEMORY(__From.i, __To.i)
  Protected.a _aOpcode
  Protected.i _iORG = __From
  Protected.s _sSpace
  
  Registers\PCDisasm = __From

  Repeat  
    _aOpcode     = GetMemory_6502(Registers\PCDisasm)
    LINE_ASM     = Hexa(_aOpcode) + " "
    LINE_DISASM  = Tbl_Opcode(_aOpcode)+ "   "
    ; On ajoute 1 avant de faire le Call
    ; pour être ok avec les Modes d'Adressage de la mémoire
    Registers\PCDisasm + 1
    ; Appel le mode d'adressage correspondant à l'opcode
    CallDisasmADRMODE(Registers\PCDisasm, _aOpcode)
    _sSpace      = Space(12-Len(LINE_ASM))
    PrintN(Hexa(_iORG,#S_WORD) + "-   "+LINE_ASM+_sSpace+LINE_DISASM)
    _iORG = Registers\PCDisasm
  Until Registers\PCDisasm > __To
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 139
; FirstLine = 94
; Folding = ---
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant