;-----------------------------------------------------------------------
;- Macros
Macro quote
  "
EndMacro
Macro InitializeCPU(__opcode__, __procedure__, __ADR__)
  Instruction(__opcode__) = @__procedure__() : AdrMode(__opcode__) = @ADRMODE_#__ADR__()
  ; Pour le désassemblage on met que les 3 caractères (sinon il met ASL_A, par exemple)
  Tbl_Opcode(__opcode__)        = Left(quote#__procedure__#quote,3)
  Tbl_ModeAdressage(__opcode__) = @ADRMODEDIS_#__ADR__()
EndMacro
Macro CallDisasmADRMODE(__registerPC__, __opcode__)
  __registerPC__ + CallFunctionFast(Tbl_ModeAdressage(__opcode__))
EndMacro
Macro CycleCPU(__opcode__, __time__, __boundary__)
  Cycle(__opcode__)\Time = __time__ : Cycle(__opcode__)\Boundary = __boundary__
EndMacro
Macro CallInstruction(__opcode__)
  ;Debug "CallFunctionFast(Instruction($"+hexa(__opcode__)+")) ==> ADR:$"+Hex(Instruction(__opcode__))
  CallFunctionFast(Instruction(__opcode__))
EndMacro
Macro CallAdrMode(__opcode__)
  ;Debug "CallFunctionFast(AdrMode($"+hexa(__opcode__)+")) ==> ADR:$"+Hex(AdrMode(__opcode__))
  CallFunctionFast(AdrMode(__opcode__))
EndMacro
Macro AddCallBack(__adress__, __function__)
  AddMapElement(MapCallBack(), __adress__) : MapCallBack() = @__function__()
EndMacro
Macro RemoveCallBack(__adress__)
  DeleteMapElement(MapCallBack(), __adress__)
EndMacro
Macro CallBack(__adress__)
  CallFunctionFast(MapCallback(__adress__))
EndMacro
Macro ShowStatus(__opcode__)
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    Print(Dump_OpcodeLine(__opcode__)) : PrintRegister()
  CompilerEndIf
EndMacro
Macro ShowAdress(__PC__)
  CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant)
    Print("$"+hexa(__PC__,#S_WORD)+":")
  CompilerEndIf
EndMacro
; Clear Sign Flag
Macro ClearSign_N()
  Registers\P\Flag & #Mask_Sign         ;force bit Sign à 0
EndMacro
; Clear Overflow Flag
Macro ClearOverflow_V()
  Registers\P\Flag & #Mask_Overflow     ;force bit Overflow à 0
EndMacro
; Clear Break Flag
Macro ClearBreak_B()
  Registers\P\Flag & #Mask_Break        ;force bit Break à 0
EndMacro
; Clear Decimal Flag
Macro ClearDecimal_D()
  Registers\P\Flag & #Mask_Decimal      ;force bit Decimal à 0
EndMacro
; Clear Interrupt disable Flag
Macro ClearInterrupt_I()
  Registers\P\Flag & #Mask_Interrupt    ;force bit Interrupt à 0
EndMacro
; Clear Zero Flag
Macro ClearZero_Z()
  Registers\P\Flag & #Mask_Zero         ;force bit Zero à 0
EndMacro
; Clear Carry Flag
Macro ClearCarry_C()
  Registers\P\Flag & #Mask_Carry        ;force bit Carry à 0
EndMacro
;-----------------------------------------------------------------------
; Set Sign Flag
Macro SetSign_N()
  Registers\P\Flag | #Flag_Sign         ;force bit Sign à 1
EndMacro
; Set Overflow Flag               - http://www.6502.org/tutorials/vflag.html
Macro SetOverflow_V()
  Registers\P\Flag | #Flag_Overflow     ;force bit Overflow à 1
EndMacro
; Set Break Flag
Macro SetBreak_B()
  Registers\P\Flag | #Flag_Break        ;force bit Break à 1
EndMacro
; Set Decimal Flag                - http://6502.org/tutorials/decimal_mode.html
Macro SetDecimal_D()
  Registers\P\Flag | #Flag_Decimal      ;force bit Decimal à 1
EndMacro
; Set Interrupt disable Flag
Macro SetInterrupt_I()
  Registers\P\Flag | #Flag_Interrupt    ;force bit Interrupt à 1
EndMacro
; Set Zero Flag
Macro SetZero_Z()
  Registers\P\Flag | #Flag_Zero         ;force bit Zero à 1
EndMacro
; Set Carry Flag
Macro SetCarry_C()
  Registers\P\Flag | #Flag_Carry        ;force bit Carry à 1
EndMacro
;-----------------------------------------------------------------------
Macro DoIf
  If
EndMacro

Macro EndDo
  : EndIf
EndMacro

Macro Do
  :
EndMacro

Macro DoElse
  : Else :
EndMacro
;-----------------------------------------------------------------------
Macro CheckSign(__VALUE__)
  DoIf __VALUE__ & #Flag_Sign = #Flag_Sign Do SetSign_N() DoElse ClearSign_N() EndDo
EndMacro

Macro CheckZero(__VALUE__)
  Doif __VALUE__ = 0 Do SetZero_Z() DoElse ClearZero_Z() EndDo
EndMacro

Macro CheckOverflow(__VALUE__)
  ;Le flag V est posé quand le résultat est > 127 ($7F) ou < - 128 ($80) 
  ;et effacé si l'accumulateur est compris entre -128 ou 127 ($80 ou $7F)
  DoIf __VALUE__ > $7F Or __VALUE__ < -$80 Do SetOverflow_V() DoElse ClearOverflow_V() EndDo
EndMacro

Macro CheckCarryLeft(__VALUE__)    ;ROL, ASL
  DoIf __VALUE__ & %10000000 = %10000000 Do SetCarry_C() DoElse ClearCarry_C() EndDo
EndMacro

Macro CheckCarryRight(__VALUE__)   ;ROR, LSR
  DoIf __VALUE__ & %00000001 = %00000001 Do SetCarry_C() DoElse ClearCarry_C() EndDo
EndMacro

Macro CMPREG(__Register__, __value__)
  If Registers\__Register__ - __value__ & #Flag_Sign : SetSign_N() : EndIf
  If Registers\__Register__ = __value__ : ClearSign_N() : SetZero_Z() : SetCarry_C() : EndIf 
  If Registers\__Register__ < __value__ : ClearZero_Z() : ClearCarry_C() : EndIf 
  If Registers\__Register__ > __value__ : ClearZero_Z() : SetCarry_C() : EndIf 
EndMacro

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 12
; Folding = ------
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant