;-Global

; Src tokenizer
Global _line.s = ""
Global CurrentPos.i = 0, CurrentLine.i = 0, CurrentSRCLine.i = 0, LenLine.i = 0, TypeToken.i = #Typ_OTHER, ByteSize.i = #_NONE

; Value checking
Global _value.s = "", _ConstValue.s = "", _LabelValue.s = "", _Difference.i = 0
Global CurrentPosValue.i = 0

Global Dim tToken.s(#NB_TOK)
Global NewList tOpcode.sOPCODE()
Global _QUOTE.i = 0, _PARENT.i = 0

Global SET_ORG.s = "", _ORG_.i = 0, _EIP_.i = 0

Global NewList src.sSOURCE()
Global NewList CleanSRC.SCLEANSOURCE()

;-Missing Label for Pass2
Global NewList MissingLabel.sMISSING()
Global NewList ComputeLabel.sCOMPUTE()

;Token/label/etc...
Global NewList Token.sTOKEN()

Global NewList Label.sLABEL()
Global NewList Const.sCONST()
Global NewList ListError.sListError()

Global Dim tblMode.s(#NB_MODE_OPC-1)
Global Dim tblByteLen.i(#NB_MODE_OPC-1)
Global Dim tblExplode.S(50)                               ;50 should be enough

Global NewList EIP.sEIPDS()
Global _DS_.i = #False

Global NewList ARGV.s()
Global ARGC.i, input_file.s, output_file.s, pos1.i, pos2.i, input_file_tmp$
Global ASM_HELP.i, SHOW_TOKEN.i = #False, SHOW_CLEAN_LIST.i = #False, SHOW_OPCODE = #False, SHOW_NO_ERROR.i = #True
Global TotalAssemblyBytes.i = 0
Global StartTimeAssembly.i, EndTimeAssembly.i, DiffTimeAssembly.f
;Flags
;                        --USED--
Global GFlag.a       = %00000000
Global MaskGF.a      = %11111111

;                        |-----USED------
Global LFlag.u       = %1000000000000000
Global MaskLF.u      = %0111111111111111
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 35
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant