#COMPILER_CONSOLE = #True

XIncludeFile "adir_constants.pbi"
XIncludeFile "adir_structures.pbi"
XIncludeFile "adir_globals.pbi"
XIncludeFile "adir_procedures.pbi"
XIncludeFile "adir_dos3.pbi"
XIncludeFile "adir_datasection.pbi"

Global *PRG_BASIC.Character

Procedure InitCode()
Protected tmp_code1.c, tmp_code2.c
Protected PCL.i, PCH.i
Protected i.i = 0
Protected code_org.i, code_len.i
Protected *hex_code.CHARACTER

  Restore code_example
  
  Read.c tmp_code1
  Read.c tmp_code2
  code_org = tmp_code1 + (tmp_code2 << 8) ;* 256

  Read.c tmp_code1
  Read.c tmp_code2
  code_len = tmp_code1 + (tmp_code2 << 8) ;* 256

  ; -------- (PCL) = code_org - (code_org/256) * 256
  ; -------- (PCH) = code_org >> 8
  PCL = code_org - (code_org/256) * 256
  PCH = code_org >> 8
  *Reg\PC = PCH * 256 + PCL

  *hex_code = AllocateMemory(code_len)

  While i <= code_len
    Read.c tmp_code1
    PokeC(*hex_code + i,tmp_code1)
    i + 1
  Wend
  
  CopyMemory(*hex_code,*MAIN_RAM+*Reg\PC,code_len+1)
  FreeMemory(*hex_code)

  Restore basic_prg
  Read.c tmp_code1
  Read.c tmp_code2
  code_len = tmp_code1 + (tmp_code2 << 8) ;* 256
  
  *PRG_BASIC = AllocateMemory(code_len)
  i = 0

  While i <= code_len
    Read.c tmp_code1
    PokeC(*PRG_BASIC + i,tmp_code1)
    i + 1
  Wend

EndProcedure

; ********************
; ***              ***
; ***     MAIN     ***
; ***              ***
; ********************
OpenConsole()
Init_ADIR(#ADIR_CONSOLE)
Init_6502(#CPU_6502_ALL)
; Init_OPCODE()
; Init_CPU()
; Reset_Memory()
; Get_ROM_FILE()
; Init_Register()

DUMP_REG()

*Reg\X = 0                              ;   LDX #$00
                                        ;CONT:
While *Reg\X < 5                        ;   CPX #$05
                                        ;   BCS THE_END          ;Greater than or equal to #$05 => End
  *Reg\A = Random($FF)                  ;   LDA #Random
  PUSH_STACK(*Reg\A)                    ;   PHA
  *Reg\X + 1                            ;   INX
                                        ;   JMP CONT
Wend                                    ;THE_END:

DUMP_MEMORY($01F0,$01FF,1)

DUMP_REG():Print("----- POPSTACK : VALUE = $"+HEXA(POP_STACK()))
DUMP_REG():Print("----- POPSTACK : VALUE = $"+HEXA(POP_STACK()))
DUMP_REG():Print("----- POPSTACK : VALUE = $"+HEXA(POP_STACK()))
DUMP_REG():Print("----- POPSTACK : VALUE = $"+HEXA(POP_STACK()))
DUMP_REG():Print("----- POPSTACK : VALUE = $"+HEXA(POP_STACK()))
DUMP_REG():Print("----- POPSTACK : VALUE = $"+HEXA(POP_STACK()))
DUMP_REG():Print("----- POPSTACK : VALUE = $"+HEXA(POP_STACK()))
DUMP_REG():PrintN("")

Set_DUMP(#DUMP_DISPLAY_HEX):DUMP_MEMORY($FC58,$FC7F,8):PrintN("")
Set_DUMP(#DUMP_DISPLAY_ASC):DUMP_MEMORY($D0D0,$D364,48):DUMP_REG()
;Set_DUMP(#DUMP_DISPLAY_ALL):DUMP_MEMORY($C100,$C6FF,16):PrintN("")

; ResetList(OPCODE())
; ForEach OPCODE()
;   PrintN(OPCODE()\opc_MNEMONIC + " - Flag=%"+RSet(Bin(OPCODE()\opc_FLAGS),8,"0") + " - " + OPCODE()\opc_DESCRIPTION)
;   Print("$"+HEXA(OPCODE()\opc_CODE[#IMM]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#ZP]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#ZPX]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#ZPY]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#ABS]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#ABSX]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#ABSY]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#IND]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#INDX]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#INDY]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#ACC]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#IMPL]\_opc_CODE)+",")
;   Print("$"+HEXA(OPCODE()\opc_CODE[#REL]\_opc_CODE))
;   PrintN("")
; Next

InitCode()
DISASM_MEMORY($0300,$031F):PrintN("")
DISASM_MEMORY($FC58,$FC5C):PrintN("")
DISASM_MEMORY($FBB4,$FBFF):PrintN("")
;DISASM_MEMORY($C100,$C6FF):PrintN("")

*Reg\PS\N = 1
*Reg\PS\V = 0
*Reg\PS\B = 0
*Reg\PS\D = 1
*Reg\PS\I = 0
*Reg\PS\Z = 1
*Reg\PS\C = 1

Get_PROCESSOR_STATUS()
PrintN("Processor status = $"+HEXA(*PS)+" - %"+RSet(Bin(*PS),8,"0"))
DUMP_REG():PrintN("")

Set_DUMP(#DUMP_DISPLAY_ALL)
DUMP_MEMORY($FFF0,$FFFF)
DUMP_MEMORY($0000,$000F):PrintN("")
PrintN(HEXA(ABSRead8_MEM(*MAIN_RAM,$FC58)))
PrintN(HEXA(ABSRead16_MEM(*MAIN_RAM,$FC5A),#S_WORD))
PrintN(HEXA(ABSRead16_MEM(*MAIN_RAM,$FFFF),#S_WORD))

PrintN("Length of Basic program = "+Str(MemorySize(*PRG_BASIC)))
i=0
While i <= MemorySize(*PRG_BASIC)
  nextadr = ABSRead16_MEM(*PRG_BASIC,i) : i + 2
  If nextadr = 0 : Break : EndIf

  lineNum = ABSRead16_MEM(*PRG_BASIC,i) : i + 2
  line$ = Str(lineNum)+" "
  Repeat
    token = ABSRead8_MEM(*PRG_BASIC,i) : i + 1
    Select token
      Case $80 To $EA
        line$ + " " + ADIR_BASIC_TOKEN(token-$80) + " "
      Default
        line$ + Chr(token)
    EndSelect
  Until token = 0
  PrintN(line$)
Wend

Print("Frappez 'Entree'..."):Input()
CloseConsole()
End

DataSection

  code_example:
    Data.c $00,$03                              ; ORG
    
;     Data.c $0E,$00                              ; LEN
;     Data.c $A2,$77,$8A,$38,$E9,$01,$D0,$FB
;     Data.c $2C,$30,$C0,$CA,$D0,$F4,$60

    Data.c $1F,$00                              ; LEN
    Data.c $A9,$0B,$8D,$08,$03,$A9,$27,$E9
    Data.c $00,$85,$24,$A9,$0A,$20,$5B,$FB
    Data.c $20,$00,$80,$C8,$C5,$CC,$CC,$CF
    Data.c $A0,$D7,$CF,$D2,$CC,$C4,$00,$60

; 0300-   A9 0B     	LDA	  #$0B
; 0302-   8D 08 03    STA	  $0308
; 0305-   A9 27     	LDA	  #$27
; 0307-   E9 00     	SBC	  #$00
; 0309-   85 24     	STA	  $24
; 030B-   A9 0A     	LDA	  #$0A
; 030D-   20 5B FB    JSR	  $FB5B
; 0310-   20 00 80    JSR	  $8000
; 0313-   C8      	  INY	
; 0314-   C5 CC     	CMP	  $CC
; 0316-   CC CF A0    CPY	  $A0CF
; 0319-   D7      	  ???	
; 031A-   CF      	  ???	
; 031B-   D2      	  ???	
; 031C-   CC C4 00    CPY	  $00C4
; 031F-   60      	  RTS

  code_txt:
    Data.s " ORG $300"
    Data.s " LDX #$00"
    Data.s "CONT:"
    Data.s " CPX #$05"
    Data.s " BCS THE_END          ;Greater than or equal to #$05 => End"
    Data.s " LDA #$EA"
    Data.s " PHA"
    Data.s " INX"
    Data.s " JMP CONT"
    Data.s "THE_END:"
    Data.s " RTS"

  basic_prg:
;     Data.c $5F,$00,$07,$08,$0A,$00,$97,$00,$11,$08,$0B,$00,$96,$31,$3A,$A2
;     Data.c $31,$00,$23,$08,$14,$00,$BA,$22,$54,$4F,$55,$43,$48,$45,$20,$3A
;     Data.c $20,$22,$3B,$00,$2B,$08,$1E,$00,$BE,$41,$24,$00,$3E,$08,$28,$00
;     Data.c $96,$32,$30,$3A,$BA,$E6,$28,$41,$24,$29,$22,$20,$20,$22,$00,$4F
;     Data.c $08,$32,$00,$AD,$E6,$28,$41,$24,$29,$D0,$32,$37,$AB,$37,$30,$00
;     Data.c $57,$08,$3C,$00,$AB,$31,$31,$00,$5D,$08,$46,$00,$80,$00,$00,$00
;     Data.c $0A,$41,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;     Data.c $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

    Data.c $66,$03,$22,$08,$01,$00,$B2,$20,$44,$49,$4D,$20,$28,$4E,$42,$52
    Data.c $45,$20,$4C,$49,$47,$4E,$45,$2C,$20,$4E,$42,$52,$45,$20,$43,$4F
    Data.c $4C,$29,$00,$39,$08,$05,$00,$86,$5A,$45,$52,$4F,$28,$37,$2C,$37
    Data.c $29,$2C,$55,$4E,$28,$37,$2C,$37,$29,$00,$47,$08,$06,$00,$43,$31
    Data.c $D0,$30,$3A,$43,$32,$D0,$33,$00,$51,$08,$07,$00,$43,$41,$52,$D0
    Data.c $30,$00,$57,$08,$0A,$00,$91,$00,$61,$08,$14,$00,$B0,$32,$30,$30
    Data.c $30,$00,$67,$08,$4B,$00,$91,$00,$71,$08,$4C,$00,$AB,$35,$30,$30
    Data.c $30,$00,$94,$08,$50,$00,$B2,$20,$2A,$2A,$2A,$2A,$2A,$20,$53,$4F
    Data.c $55,$53,$20,$52,$4F,$55,$54,$49,$4E,$45,$20,$41,$46,$46,$49,$43
    Data.c $48,$41,$47,$45,$00,$9F,$08,$5A,$00,$81,$59,$D0,$30,$C1,$37,$00
    Data.c $AA,$08,$64,$00,$81,$58,$D0,$30,$C1,$37,$00,$CC,$08,$6F,$00,$AD
    Data.c $43,$41,$52,$D0,$30,$C4,$AD,$5A,$45,$52,$4F,$28,$59,$2C,$58,$29
    Data.c $D0,$30,$C4,$43,$D0,$43,$32,$3A,$AB,$31,$33,$30,$00,$EC,$08,$70
    Data.c $00,$AD,$43,$41,$52,$D0,$31,$C4,$AD,$55,$4E,$28,$59,$2C,$58,$29
    Data.c $D0,$30,$C4,$43,$D0,$43,$32,$3A,$AB,$31,$33,$30,$00,$F5,$08,$7D
    Data.c $00,$43,$D0,$43,$31,$00,$FC,$08,$82,$00,$92,$43,$00,$09,$09,$87
    Data.c $00,$93,$58,$C8,$48,$2C,$59,$C8,$56,$00,$10,$09,$8E,$00,$82,$58
    Data.c $00,$17,$09,$96,$00,$82,$59,$00,$21,$09,$A0,$00,$48,$D0,$48,$C8
    Data.c $38,$00,$27,$09,$AA,$00,$B1,$00,$3D,$09,$E8,$03,$83,$20,$30,$2C
    Data.c $31,$2C,$31,$2C,$31,$2C,$31,$2C,$31,$2C,$30,$2C,$30,$00,$53,$09
    Data.c $E9,$03,$83,$20,$31,$2C,$31,$2C,$30,$2C,$30,$2C,$30,$2C,$31,$2C
    Data.c $31,$2C,$30,$00,$6A,$09,$EA,$03,$83,$20,$31,$2C,$31,$2C,$30,$2C
    Data.c $30,$2C,$31,$2C,$31,$2C,$31,$2C,$30,$20,$00,$80,$09,$EB,$03,$83
    Data.c $20,$31,$2C,$31,$2C,$30,$2C,$31,$2C,$30,$2C,$31,$2C,$31,$2C,$30
    Data.c $00,$96,$09,$EC,$03,$83,$20,$31,$2C,$31,$2C,$31,$2C,$30,$2C,$30
    Data.c $2C,$31,$2C,$31,$2C,$30,$00,$AC,$09,$ED,$03,$83,$20,$31,$2C,$31
    Data.c $2C,$30,$2C,$30,$2C,$30,$2C,$31,$2C,$31,$2C,$30,$00,$C2,$09,$EE
    Data.c $03,$83,$20,$30,$2C,$31,$2C,$31,$2C,$31,$2C,$31,$2C,$31,$2C,$30
    Data.c $2C,$30,$00,$D8,$09,$EF,$03,$83,$20,$30,$2C,$30,$2C,$30,$2C,$30
    Data.c $2C,$30,$2C,$30,$2C,$30,$2C,$30,$00,$EE,$09,$F2,$03,$83,$20,$30
    Data.c $2C,$30,$2C,$30,$2C,$31,$2C,$31,$2C,$30,$2C,$30,$2C,$30,$00,$04
    Data.c $0A,$F3,$03,$83,$20,$30,$2C,$30,$2C,$31,$2C,$31,$2C,$31,$2C,$30
    Data.c $2C,$30,$2C,$30,$00,$1A,$0A,$F4,$03,$83,$20,$30,$2C,$30,$2C,$30
    Data.c $2C,$31,$2C,$31,$2C,$30,$2C,$30,$2C,$30,$00,$30,$0A,$F5,$03,$83
    Data.c $20,$30,$2C,$30,$2C,$30,$2C,$31,$2C,$31,$2C,$30,$2C,$30,$2C,$30
    Data.c $00,$46,$0A,$F6,$03,$83,$20,$30,$2C,$30,$2C,$30,$2C,$31,$2C,$31
    Data.c $2C,$30,$2C,$30,$2C,$30,$00,$5C,$0A,$F7,$03,$83,$20,$30,$2C,$30
    Data.c $2C,$30,$2C,$31,$2C,$31,$2C,$30,$2C,$30,$2C,$30,$00,$72,$0A,$F8
    Data.c $03,$83,$20,$30,$2C,$30,$2C,$31,$2C,$31,$2C,$31,$2C,$31,$2C,$30
    Data.c $2C,$30,$00,$88,$0A,$F9,$03,$83,$20,$30,$2C,$30,$2C,$30,$2C,$30
    Data.c $2C,$30,$2C,$30,$2C,$30,$2C,$30,$00,$93,$0A,$D0,$07,$81,$59,$D0
    Data.c $30,$C1,$37,$00,$9E,$0A,$DA,$07,$81,$58,$D0,$30,$C1,$37,$00,$AD
    Data.c $0A,$E4,$07,$87,$5A,$45,$52,$4F,$28,$59,$2C,$58,$29,$00,$B7,$0A
    Data.c $EE,$07,$82,$58,$3A,$82,$59,$00,$C2,$0A,$F8,$07,$81,$59,$D0,$30
    Data.c $C1,$37,$00,$CD,$0A,$02,$08,$81,$58,$D0,$30,$C1,$37,$00,$DA,$0A
    Data.c $0C,$08,$87,$55,$4E,$28,$59,$2C,$58,$29,$00,$E4,$0A,$16,$08,$82
    Data.c $58,$3A,$82,$59,$00,$EA,$0A,$20,$08,$B1,$00,$01,$0B,$87,$13,$B2
    Data.c $20,$33,$35,$20,$43,$4F,$4C,$4F,$4E,$4E,$45,$53,$20,$4D,$41,$58
    Data.c $49,$00,$0D,$0B,$88,$13,$48,$D0,$30,$3A,$56,$D0,$30,$00,$19,$0B
    Data.c $8D,$13,$81,$4A,$D0,$31,$C1,$32,$30,$00,$25,$0B,$92,$13,$81,$49
    Data.c $D0,$31,$C1,$33,$35,$00,$40,$0B,$9C,$13,$43,$41,$52,$D0,$D3,$28
    Data.c $28,$DB,$28,$31,$30,$30,$29,$29,$C8,$28,$DB,$28,$31,$29,$29,$29
    Data.c $00,$48,$0B,$A6,$13,$B0,$38,$30,$00,$4F,$0B,$B0,$13,$82,$49,$00
    Data.c $5D,$0B,$BA,$13,$56,$D0,$56,$C8,$38,$3A,$48,$D0,$30,$00,$64,$0B
    Data.c $C4,$13,$82,$4A,$00,$00,$00,$0A,$43,$08,$4C,$00,$AB,$35,$30,$30
    Data.c $30,$00,$94,$08,$50,$00,$B2,$20,$2A,$2A,$2A,$2A,$2A,$20,$53,$4F
    Data.c $55,$53,$20,$52,$4F,$55,$54,$49,$4E,$45,$20,$41,$46,$46,$49,$43
EndDataSection
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 68
; FirstLine = 12
; Folding = -
; Executable = adir_cpu.exe
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 3
; EnableBuildCount = 2
; EnableExeConstant