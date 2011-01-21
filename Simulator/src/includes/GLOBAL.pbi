;-Globals
Global.CS_Register Registers
Global             *MAIN_RAM
Global.s           DISSASM_OPCODE = "", DISSASM_START = "", DISSASM_MIDDLE = "", DISSASM_END = ""
Global.a           H, L, Opcode
Global.u           Memory
Global.i           StartRun, EndRun
Global Dim         Memory_6502.a(#_6502MaxMemory)     ;On créé une mémoire de 65536 Octets max
; On défini les tableaux des adresses des instructions et Modes d'adressage
; qui seront appelés par le CallFunctionFast
Global Dim         Instruction.i(#_6502MaxInst)       ;Max 256 Instructions
Global Dim         Cycle.CS_Cycle(#_6502MaxInst)
Global Dim         AdrMode.i(#_6502MaxInst)           ;Mode d'adressage de la mémoire pour chaque instruction
; Pour le desassemblage
Global Dim         Tbl_Opcode.s(#_6502MaxMemory), Dim Tbl_ModeAdressage.i(#_6502MaxMemory)
Global.s           LINE_ASM = "", LINE_DISASM = ""
; CallBack
; Si on a l'appel à une valeur comme $FDED (COUT)
; on la gère par le programme directement
Global NewMap      MapCallBack.i(#_MaxCallBack)       ;Conserve les adresses des fonctions

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 7
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant