;-Declarations
Declare   ZeroMemory(*memory.Character, __size.i)
Declare   Reset_Memory()
Declare   Get_ROM_FILE(__Model.i = #MODEL_IIE)
Declare   Get_DOS()
Declare   ClearFlagRegister()
Declare   ClearRegisters()
Declare   ClearAllRegisters()
Declare.s Binary(__Value.a)
Declare.s Hexa(__Value.u, __Len.b = #S_BYTE)
Declare.s Dump_OpcodeLine(__Opcode.s)
Declare   Dump_MEMORY(__From.i, __To.i, __BytePerLine.i = #NB_BYTE_PER_LINE)
Declare   Disasm_MEMORY(__From.i, __To.i)

Declare   INVERSE()
Declare   NORMAL()
Declare   PrintRegister()
Declare   Print_OEM(__Message.s)
Declare   PrintN_OEM(__Message.s)
;
Declare   PushStack(__Value.a)
Declare.a PopStack()
Declare.a GetMemory_6502(__Memory.i = -1)
Declare   PutMemory_6502(__Adress.u, __Value.a)

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 12
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant