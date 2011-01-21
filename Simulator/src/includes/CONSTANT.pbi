;-Constantes
#Flag_Sign        = 1 << 7                        ; 128
#Flag_Overflow    = 1 << 6                        ; 64
#Flag_Undefined   = 1 << 5                        ; 32
#Flag_Break       = 1 << 4                        ; 16
#Flag_Decimal     = 1 << 3                        ; 8
#Flag_Interrupt   = 1 << 2                        ; 4
#Flag_Zero        = 1 << 1                        ; 2
#Flag_Carry       = 1 << 0                        ; 1

#Mask_Sign        = ~#Flag_Sign
#Mask_Overflow    = ~#Flag_Overflow
#Mask_Undefined   = ~#Flag_Undefined
#Mask_Break       = ~#Flag_Break
#Mask_Decimal     = ~#Flag_Decimal
#Mask_Interrupt   = ~#Flag_Interrupt
#Mask_Zero        = ~#Flag_Zero
#Mask_Carry       = ~#Flag_Carry

#_6502MaxInst     = $FF
#_6502MaxMemory   = $FFFF
#_MaxCallBack     = 128

#PATH_TO_DOS      = "DOS33\"
#DOS_33           = "Dos33.mem"

#PATH_TO_ROM      = "ROM\"
#ROM_II           = "Apple2.rom"
#ROM_II_PLUS      = "Apple2_Plus.rom"
#ROM_IIE          = "Apple2e.rom"
#ROM_IIE_ENHANCED = "Apple2e_Enhanced.rom"

#S_BYTE           = 1
#S_WORD           = 2
#S_LONG           = 4
#NB_BYTE_PER_LINE = 8

#STACK            = $0100
#RAM_48K          = $BFFF
#RAM_64K          = $FFFF
#DOS_START        = $9D00

Enumeration
  #CPU_6502
  #CPU_65C02
  #BINARY_FILE
  #ROM_FILENUM
  #DOS_FILENUM
EndEnumeration

Enumeration
  #MODEL_II
  #MODEL_II_PLUS
  #MODEL_IIE
  #MODEL_IIE_ENHANCED
EndEnumeration

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 47
; FirstLine = 5
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant