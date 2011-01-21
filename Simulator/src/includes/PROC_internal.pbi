;- Procedures Internes
Procedure InitCPU(__Model.i = #MODEL_IIE)
  Protected i.i

;   If __Model < #MODEL_IIE
;     *MAIN_RAM = AllocateMemory(#RAM_48K)
;   Else
;     *MAIN_RAM = AllocateMemory(#RAM_64K)
;   EndIf

  *MAIN_RAM = AllocateMemory(#RAM_64K)
  For i = 0 To #_6502MaxInst
    Instruction(i)       = @NOP()
    AdrMode(i)           = @ADRMODE_implied()
    Tbl_ModeAdressage(i) = @ADRMODE_implied()
    Tbl_Opcode(i)        = "???"
    CycleCPU(i, 0, 0)
  Next
  For i = 0 To #_6502MaxMemory
    Memory_6502(i) = $00
  Next

  ; ADC - Affects Flags: S V Z C
  InitializeCPU($61, ADC,   indx)
  InitializeCPU($65, ADC,   zp)
  InitializeCPU($69, ADC,   immediate)
  InitializeCPU($6D, ADC,   abs)
  InitializeCPU($71, ADC,   indy)
  InitializeCPU($75, ADC,   zpx)
  InitializeCPU($79, ADC,   absy)
  InitializeCPU($7D, ADC,   absx)
  ; AND - Affects Flags: S Z
  InitializeCPU($21, AND_,  indx)
  InitializeCPU($25, AND_,  zp)
  InitializeCPU($29, AND_,  immediate)
  InitializeCPU($2D, AND_,  abs)
  InitializeCPU($31, AND_,  indy)
  InitializeCPU($35, AND_,  zpx)
  InitializeCPU($39, AND_,  absy)
  InitializeCPU($3D, AND_,  absx)
  ; ASL - Affects Flags: S Z C
  InitializeCPU($06, ASL,   zp)         : CycleCPU($06,5,0)
  InitializeCPU($0A, ASL_A, implied)    : CycleCPU($0A,2,0)
  InitializeCPU($0E, ASL,   abs)        : CycleCPU($0E,6,0)
  InitializeCPU($16, ASL,   zpx)        : CycleCPU($16,6,0)
  InitializeCPU($1E, ASL,   absx)       : CycleCPU($1E,7,0)
  ; BCC - Branch on Carry Clear
  InitializeCPU($90, BCC,   relative)
  ; BCS - Branch on Carry Set
  InitializeCPU($B0, BCS,   relative)
  ; BEQ - Branch on EQual
  InitializeCPU($F0, BEQ,   relative)
  ; BIT - Affects Flags: S V Z 
  InitializeCPU($24, BIT,   zp)
  InitializeCPU($2C, BIT,   abs)
  ; BMI - Branch on MInus
  InitializeCPU($30, BMI,   relative)
  ; BNE - (Branch on Not Equal)
  InitializeCPU($D0, BNE,   relative)
  ; BPL - Branch on PLus
  InitializeCPU($10, BPL,   relative)
  ; BRK - Affects Flags: B
  InitializeCPU($00, BRK,   implied)
  ; BVC - Branch on oVerflow Clear
  InitializeCPU($50, BVC,   relative)
  ; BVS - Branch on oVerflow Set
  InitializeCPU($70, BVS,   relative)
  ; Flag (Processor Status) Instructions
  ; Affect Flags: As noted
  InitializeCPU($18, CLC,   implied)
  InitializeCPU($D8, CLD,   implied)
  InitializeCPU($58, CLI,   implied)
  InitializeCPU($B8, CLV,   implied)
  ; CMP - Affects Flags: S Z C 
  InitializeCPU($C1, CMP,   indx)
  InitializeCPU($C5, CMP,   zp)
  InitializeCPU($C9, CMP,   immediate)
  InitializeCPU($CD, CMP,   abs)
  InitializeCPU($D1, CMP,   indy)
  InitializeCPU($D5, CMP,   zpx)
  InitializeCPU($D9, CMP,   absy)
  InitializeCPU($DD, CMP,   absx)
  ; CPX - Affects Flags: S Z C
  InitializeCPU($E0, CPX,   immediate)
  InitializeCPU($E4, CPX,   zp)
  InitializeCPU($EC, CPX,   abs)
  ; CPY - Affects Flags: S Z C
  InitializeCPU($C0, CPY,   Immediate)
  InitializeCPU($C4, CPY,   zp)
  InitializeCPU($CC, CPY,   abs)
  ; DEC - Affects Flags: S Z
  InitializeCPU($C6, DEC,   zp)
  InitializeCPU($CE, DEC,   abs)
  InitializeCPU($D6, DEC,   zpx)
  InitializeCPU($DE, DEC,   absx)
  ; DEX - Affects Flags: S Z 
  InitializeCPU($CA, DEX,   implied)
  ; DEY - Affects Flags: S Z 
  InitializeCPU($88, DEY,   implied)
  ; EOR - Affects Flags: S Z
  InitializeCPU($41, EOR,   indx)
  InitializeCPU($45, EOR,   zp)
  InitializeCPU($49, EOR,   immediate)
  InitializeCPU($4D, EOR,   abs)
  InitializeCPU($51, EOR,   indy)
  InitializeCPU($55, EOR,   zpx)
  InitializeCPU($59, EOR,   absy)
  InitializeCPU($5D, EOR,   absx)
  ; INC - Affects Flags: S Z
  InitializeCPU($E6, INC,   zp)
  InitializeCPU($EE, INC,   abs)
  InitializeCPU($F6, INC,   zpx)
  InitializeCPU($FE, INC,   absx)
  ; INX - Affects Flags: S Z
  InitializeCPU($E8, INX,   implied)
  ; INY - Affects Flags: S Z
  InitializeCPU($C8, INY,   implied)
  ; JMP - Affects Flags: none
  InitializeCPU($4C, JMP,   abs)
  InitializeCPU($6C, JMP,   indirect)
  ; JSR - Affects Flags: none
  InitializeCPU($20, JSR,   abs)
  ; LDA - Affects Flags: S Z
  InitializeCPU($A1, LDA,   indx)
  InitializeCPU($A5, LDA,   zp)
  InitializeCPU($A9, LDA,   immediate)
  InitializeCPU($AD, LDA,   abs)
  InitializeCPU($B1, LDA,   indy)
  InitializeCPU($B5, LDA,   zpx)
  InitializeCPU($B9, LDA,   absy)
  InitializeCPU($BD, LDA,   absx)
  ; LDX - Affects Flags: S Z
  InitializeCPU($A2, LDX,   immediate)
  InitializeCPU($A6, LDX,   zp)
  InitializeCPU($AE, LDX,   abs)
  InitializeCPU($B6, LDX,   zpy)
  InitializeCPU($BE, LDX,   absy)
  ; LDY - Affects Flags: S Z
  InitializeCPU($A0, LDY,   immediate)
  InitializeCPU($A4, LDY,   zp)
  InitializeCPU($AC, LDY,   abs)
  InitializeCPU($B4, LDY,   zpx)
  InitializeCPU($BC, LDY,   absx)
  ; LSR - Affects Flags: S Z C
  InitializeCPU($4A, LSR_A, implied)
  InitializeCPU($46, LSR,   zp)
  InitializeCPU($4E, LSR,   abs)
  InitializeCPU($56, LSR,   zpx)
  InitializeCPU($5E, LSR,   absx)
  ; NOP - Affects Flags: none
  InitializeCPU($EA, NOP,   implied)
  ; ORA - Affects Flags: S Z
  InitializeCPU($01, ORA,   indx)
  InitializeCPU($05, ORA,   zp)
  InitializeCPU($09, ORA,   immediate)
  InitializeCPU($0D, ORA,   abs)
  InitializeCPU($11, ORA,   indy)
  InitializeCPU($15, ORA,   zpx)
  InitializeCPU($19, ORA,   absy)
  InitializeCPU($1D, ORA,   absx)
  ; Stack Instructions
  InitializeCPU($48, PHA,   implied)
  InitializeCPU($08, PHP,   implied)
  InitializeCPU($68, PLA,   implied)
  InitializeCPU($28, PLP,   implied)
  ; ROL - Affects Flags: S Z C
  InitializeCPU($26, ROL,   zp)
  InitializeCPU($2A, ROL_A, implied)
  InitializeCPU($2E, ROL,   abs)
  InitializeCPU($36, ROL,   zpx)
  InitializeCPU($3E, ROL,   absx)
  ; ROR - Affects Flags: S Z C
  InitializeCPU($66, ROR,   zp)
  InitializeCPU($6A, ROR_A, implied)
  InitializeCPU($6E, ROR,   abs)
  InitializeCPU($76, ROR,   zpx)
  InitializeCPU($7E, ROR,   absx)
  ; RTS - Affects Flags: none
  InitializeCPU($60, RTS,   implied)
  ; SBC - Affects Flags: S V Z C
  InitializeCPU($E1, SBC,   indx)
  InitializeCPU($E5, SBC,   zp)
  InitializeCPU($E9, SBC,   immediate)
  InitializeCPU($ED, SBC,   abs)
  InitializeCPU($F1, SBC,   indy)
  InitializeCPU($F5, SBC,   zpx)
  InitializeCPU($F9, SBC,   absy)
  InitializeCPU($FD, SBC,   absx)
  ; Flag (Processor Status) Instructions
  ; Affect Flags: As noted
  InitializeCPU($38, SEC,   implied)
  InitializeCPU($F8, SED,   implied)
  InitializeCPU($78, SEI,   implied)
  ; STA - Affects Flags: none
  InitializeCPU($81, STA,   indx)
  InitializeCPU($85, STA,   zp)
  InitializeCPU($8D, STA,   abs)
  InitializeCPU($91, STA,   indy)
  InitializeCPU($95, STA,   zpx)
  InitializeCPU($99, STA,   absy)
  InitializeCPU($9D, STA,   absx)
  ; STX - Affects Flags: none
  InitializeCPU($86, STX,   zp)
  InitializeCPU($8E, STX,   abs)
  InitializeCPU($96, STX,   zpy)
  ; STY - Affects Flags: none
  InitializeCPU($84, STY,   zp)
  InitializeCPU($8C, STY,   abs)
  InitializeCPU($94, STY,   zpx)
  ; Transfert - Affect Flags: S Z
  InitializeCPU($AA, TAX,   implied)
  InitializeCPU($A8, TAY,   implied)
  InitializeCPU($BA, TSX,   implied)
  InitializeCPU($8A, TXA,   implied)
  InitializeCPU($98, TYA,   implied)
  InitializeCPU($9A, TXS,   implied)

  ; 65C02
  If __Model >= #MODEL_IIE_ENHANCED
    InitializeCPU($72, ADC,   indzp)
    InitializeCPU($32, AND_,  indzp)
    InitializeCPU($80, BRA,   relative)
    InitializeCPU($34, BIT,   zpx)
    InitializeCPU($3C, BIT,   absx)
    InitializeCPU($89, BIT_A, immediate)
    InitializeCPU($D2, CMP,   indzp)
    InitializeCPU($3A, DEC_A, implied)
    InitializeCPU($52, EOR,   indzp)
    InitializeCPU($1A, INC_A, implied)
    InitializeCPU($7C, JMP,   indabsx)
    InitializeCPU($B2, LDA,   indzp)
    InitializeCPU($12, ORA,   indzp)
    InitializeCPU($DA, PHX,   implied)
    InitializeCPU($5A, PHY,   implied)
    InitializeCPU($FA, PLX,   implied)
    InitializeCPU($7A, PLY,   implied)
    InitializeCPU($F2, SBC,   indzp)
    InitializeCPU($92, STA,   indzp)
    InitializeCPU($64, STZ,   zp)
    InitializeCPU($74, STZ,   zpx)
    InitializeCPU($9C, STZ,   abs)
    InitializeCPU($9E, STZ,   absx)
    InitializeCPU($14, TRB,   zp)
    InitializeCPU($1C, TRB,   abs)
    InitializeCPU($04, TSB,   zp)
    InitializeCPU($0C, TSB,   abs)
    ;Instructions with different cycle counts for 65C02
    ;CycleCPU(Opcode, Times, Adding time if page boundary)
    CycleCPU($1E,6,1)    ; ASL
    CycleCPU($5E,6,1)    ; LSR
    CycleCPU($3E,6,1)    ; ROL
    CycleCPU($7E,6,1)    ; ROR
  EndIf

  Reset_Memory()
  Get_ROM_FILE(__Model)
  Get_DOS()
  ClearAllRegisters()
EndProcedure

Procedure ZeroMemory(*memory.Character, __size.i)
Protected.i _iByte

  _iByte = 0
  While _iByte <= __size
    PokeI(*memory + _iByte, $00)
    _iByte + SizeOf(Integer)
  Wend
EndProcedure

Procedure Reset_Memory()
Protected.i _iByte

  ;*** Init RAM Image ***
	ZeroMemory(*MAIN_RAM, #RAM_64K)

  _iByte = 0
  While _iByte < $C000
    PokeI(*MAIN_RAM + _iByte, $FFFFFFFF)
    _iByte + SizeOf(Integer)
  Wend
EndProcedure

Procedure Get_ROM_FILE(__Model.i = #MODEL_IIE)
  Protected *MEM_ROM
  Protected.i _iRomSize = -1
  Protected.s _sRomFile
  
  Select __Model
    Case #MODEL_II
      _sRomFile = #ROM_II
    Case #MODEL_II_PLUS
      _sRomFile = #ROM_II_PLUS
    Case #MODEL_IIE
      _sRomFile = #ROM_IIE
    Case #MODEL_IIE_ENHANCED
      _sRomFile = #ROM_IIE_ENHANCED
    Default
      _sRomFile = #ROM_IIE
  EndSelect

  _sRomFile = #PATH_TO_ROM + _sRomFile

  _iRomSize = FileSize(_sRomFile)
  If _iRomSize > 0
    *MEM_ROM  = AllocateMemory(_iRomSize)
    If *MEM_ROM
      OpenFile(#ROM_FILENUM,_sRomFile)
      ReadData(#ROM_FILENUM,*MEM_ROM,_iRomSize)
      CloseFile(#ROM_FILENUM)
      CopyMemory(*MEM_ROM, @Memory_6502(0) + #RAM_64K - _iRomSize + 1, _iRomSize); $C000 pour IIe + Enhanced
      FreeMemory(*MEM_ROM)
    Else
      Print("*** Error Memory Allocation for rom file "+Chr(34)+_sRomFile+Chr(34)+" !")
      Input()
      End
    EndIf
  Else
    Print("*** Error getting rom file "+Chr(34)+_sRomFile+Chr(34)+" !")
    Input()
    End
  EndIf
EndProcedure

Procedure Get_DOS()
  Protected *MEM_DOS
  Protected.i _iDOSSize = -1
  Protected.s _sDOSFile
  
  _sDOSFile = #PATH_TO_DOS + #DOS_33

  _iDOSSize = FileSize(_sDOSFile)
  If _iDOSSize > 0
    *MEM_DOS  = AllocateMemory(_iDOSSize)
    If *MEM_DOS
      OpenFile(#DOS_FILENUM,_sDOSFile)
      ReadData(#DOS_FILENUM,*MEM_DOS,_iDOSSize)
      CloseFile(#DOS_FILENUM)
      CopyMemory(*MEM_DOS, @Memory_6502(0) + #DOS_START, _iDOSSize); $C000 pour IIe + Enhanced
      FreeMemory(*MEM_DOS)
    Else
      Print("*** Error Memory Allocation for DOS file "+Chr(34)+_sDOSFile+Chr(34)+" !")
      End
    EndIf
  Else
    Print("*** Error getting DOS file "+Chr(34)+_sDOSFile+Chr(34)+" !")
    End
  EndIf
EndProcedure

Procedure ClearFlagRegister()
  Registers\P\Flag = #Flag_Undefined
EndProcedure

Procedure ClearRegisters()
  With Registers
    \A  = $00
    \X  = $00
    \Y  = $00
  ; Initialise position de la pile
    \S  = $FF
  ; Initialise position du Program Counter
    \PC = GetMemory_6502($FFFC) | GetMemory_6502($FFFD) << 8
  EndWith
EndProcedure

Procedure ClearAllRegisters()
  ClearFlagRegister()
  ClearRegisters()
EndProcedure

Procedure.s Binary(__Value.a)
  ProcedureReturn RSet(Bin(__Value,#PB_Ascii),8,"0")
EndProcedure

Procedure.s Hexa(__Value.u, __Len.b = #S_BYTE)
  Protected.i _iTypeLen = #PB_Ascii
  If __Len = #S_WORD : _iTypeLen = #PB_Unicode : EndIf
  ProcedureReturn RSet(Hex(__Value,_iTypeLen),__Len * 2,"0")
EndProcedure

Procedure PushStack(__Value.a)
  PutMemory_6502(#STACK+Registers\S, __Value)
  Registers\S - 1
EndProcedure

Procedure.a PopStack()
  Protected.a _aResult = 0

  Registers\S + 1
  _aResult = GetMemory_6502(#STACK+Registers\S)

  ProcedureReturn _aResult
EndProcedure

Procedure.a GetMemory_6502(__Adress.i = -1)
  Protected.a _aResult = 0

  If __Adress = -1
    _aResult = Memory_6502(Registers\PC)
  Else
    _aResult = Memory_6502(__Adress)
  EndIf
  
  ProcedureReturn _aResult
EndProcedure

Procedure PutMemory_6502(__Adress.u, __Value.a)
  Memory_6502(__Adress) = __Value
EndProcedure

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 21
; Folding = ---
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant