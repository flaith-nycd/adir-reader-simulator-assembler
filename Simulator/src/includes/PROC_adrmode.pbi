;-------------------------------------------------------------------------
;-Memory Addressing Modes
;* Implied *
Procedure ADRMODE_implied()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    DISSASM_START = "" : DISSASM_MIDDLE = "" : DISSASM_END = ""
  CompilerEndIf
EndProcedure
;* #Immediate *
Procedure ADRMODE_immediate()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC)
    DISSASM_OPCODE + " " + Hexa(H)
    DISSASM_START = "#$" : DISSASM_MIDDLE = Hexa(H) : DISSASM_END = ""
  CompilerEndIf
  Memory = Registers\PC
  Registers\PC + 1
EndProcedure
;* ABS *
Procedure ADRMODE_abs()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC) : L = Memory_6502(Registers\PC + 1)
    DISSASM_OPCODE + " " + Hexa(H) + " " + Hexa(L)
    DISSASM_START = "$" : DISSASM_MIDDLE = Hexa(L) + Hexa(H) : DISSASM_END = ""
  CompilerEndIf
  Memory = Memory_6502(Registers\PC) + (Memory_6502(Registers\PC + 1) << 8)
  Registers\PC + 2
EndProcedure
;* Branch *
Procedure ADRMODE_relative()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    DISSASM_START = "$" : DISSASM_END = ""
    H = Memory_6502(Registers\PC)
    DISSASM_OPCODE + " " + Hexa(H)
  CompilerEndIf
  Memory = Memory_6502(Registers\PC)
  ; Si Memory > $7F : on va vers le haut (pour les sauts)
  If (Memory & $80) : Memory - $100
    CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
      DISSASM_MIDDLE = Hexa((Registers\PC) - ($FF - H),#S_WORD)
  Else
      DISSASM_MIDDLE = Hexa((Registers\PC) + H + 1,#S_WORD)
    CompilerEndIf
  EndIf
  Registers\PC + 1
EndProcedure
;* (ABS) *
Procedure ADRMODE_indirect()
  Protected.u _uTmp
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC) : L = Memory_6502(Registers\PC + 1)
    DISSASM_OPCODE + " " + Hexa(H) + " " + Hexa(L)
    DISSASM_START = "($" : DISSASM_MIDDLE = Hexa(L) + Hexa(H) : DISSASM_END = ")"
  CompilerEndIf
  _uTmp = Memory_6502(Registers\PC) + (Memory_6502(Registers\PC + 1) << 8)
  Memory= Memory_6502(_uTmp) + (Memory_6502(_uTmp + 1) << 8)
  Registers\PC + 2
EndProcedure
;* ABS,X *
Procedure ADRMODE_absx()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC) : L = Memory_6502(Registers\PC + 1)
    DISSASM_OPCODE + " " + Hexa(H) + " " + Hexa(L)
    DISSASM_START = "$" : DISSASM_MIDDLE = Hexa(L) + Hexa(H) : DISSASM_END = ",X"
  CompilerEndIf
  Memory = Memory_6502(Registers\PC) + (Memory_6502(Registers\PC + 1) << 8)
  Memory + Registers\X
  Registers\PC + 2
EndProcedure
;* ABS,Y *
Procedure ADRMODE_absy()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC) : L = Memory_6502(Registers\PC + 1)
    DISSASM_OPCODE + " " + Hexa(H) + " " + Hexa(L)
    DISSASM_START = "$" : DISSASM_MIDDLE = Hexa(L) + Hexa(H) : DISSASM_END = ",Y"
  CompilerEndIf
  Memory = Memory_6502(Registers\PC) + (Memory_6502(Registers\PC + 1) << 8)
  Memory + Registers\Y
  Registers\PC + 2
EndProcedure
;* ZP *
Procedure ADRMODE_zp()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC)
    DISSASM_OPCODE + " " + Hexa(H)
    DISSASM_START = "$" : DISSASM_MIDDLE = Hexa(H) : DISSASM_END = ""
  CompilerEndIf
  Memory = Memory_6502(Registers\PC)
  Registers\PC + 1
EndProcedure
;* ZP,X *
Procedure ADRMODE_zpx()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    L = Memory_6502(Registers\PC + 1)
    DISSASM_OPCODE + " " + Hexa(L)
    DISSASM_START = "$" : DISSASM_MIDDLE = Hexa(L) : DISSASM_END = ",X"
  CompilerEndIf
  Memory = Memory_6502(Registers\PC + 1) + Registers\X
  Memory & $00FF
  Registers\PC + 1
EndProcedure
;* ZP,Y *
Procedure ADRMODE_zpy()
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    L = Memory_6502(Registers\PC + 1)
    DISSASM_OPCODE + " " + Hexa(L)
    DISSASM_START = "$" : DISSASM_MIDDLE = Hexa(L) : DISSASM_END = ",Y"
  CompilerEndIf
  Memory = Memory_6502(Registers\PC + 1) + Registers\Y
  Memory & $00FF
  Registers\PC + 1
EndProcedure
;* (ZP,X) *
Procedure ADRMODE_indx()
  Protected.u _uTmp = Memory_6502(Registers\PC + 1) + Registers\X
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC)
    DISSASM_OPCODE + " " + Hexa(H)
    DISSASM_START = "($" : DISSASM_MIDDLE = Hexa(H) : DISSASM_END = ",X)"
  CompilerEndIf
  Memory = Memory_6502(_uTmp) + (Memory_6502(_uTmp + 1) << 8)
  Registers\PC + 1
EndProcedure
;* (ZP),Y *
Procedure ADRMODE_indy()
  Protected.u _uTmp = Memory_6502(Registers\PC + 1)
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC)
    DISSASM_OPCODE + " " + Hexa(H)
    DISSASM_START = "($" : DISSASM_MIDDLE = Hexa(H) : DISSASM_END = "),Y"
  CompilerEndIf
  Memory = Memory_6502(_uTmp) + (Memory_6502(_uTmp + 1) << 8) + Registers\Y
  Registers\PC + 1
EndProcedure
;* (ABS,X) *
Procedure ADRMODE_indabsx()
  Protected.u _uTmp
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC) : L = Memory_6502(Registers\PC + 1)
    DISSASM_OPCODE + " " + Hexa(H) + " " + Hexa(L)
    DISSASM_START = "($" : DISSASM_MIDDLE = Hexa(L) + Hexa(H) : DISSASM_END = ",X)"
  CompilerEndIf
  _uTmp = Memory_6502(Registers\PC) + (Memory_6502(Registers\PC + 1) << 8) + Registers\X
  Memory= Memory_6502(_uTmp) + (Memory_6502(_uTmp + 1) << 8)
  Registers\PC + 1
EndProcedure
;* (ZP) *
Procedure ADRMODE_indzp()
  Protected.u _uTmp
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    DISSASM_OPCODE = Hexa(Opcode)
    H = Memory_6502(Registers\PC)
    DISSASM_OPCODE + " " + Hexa(H)
    DISSASM_START = "($" : DISSASM_MIDDLE = Hexa(H) : DISSASM_END = ")"
  CompilerEndIf
  _uTmp = Memory_6502(Registers\PC + 1)
  Memory= Memory_6502(_uTmp) + (Memory_6502(_uTmp + 1) << 8)
  Registers\PC + 1
EndProcedure

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 42
; FirstLine = 29
; Folding = ---
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant