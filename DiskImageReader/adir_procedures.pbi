; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***                           ***
; *********************************
; ******************
;-** Declarations **
; ******************
Declare Init_ADIR(Format_init.s)
Declare Init_6502(value.i)
Declare ADIR_Error(_error_.s, _num_error_.l)
Declare.l OpenDSK(TheFile.s = "")
Declare Add_Buffer(length.l,taille.l,continous.i = #False)
Declare ReadTS(track.l,sector.l,continous.i = #False)
Declare.s HEXA(value.i, size = #S_BYTE)
Declare Win_processing()
Declare Set_DUMP(what_to_dump.i = #DUMP_DISPLAY_ALL)
Declare.c Read8_MEM()
Declare.i Read16_MEM()
Declare.c GetByte(track.l, sector.l, offset.l)

Declare Set_BYTE_ORDERING(value.i)
Declare Init_OPCODE()
Declare Init_CPU()
Declare ZeroMemory(*memory.CHARACTER, size.l)
Declare Reset_Memory()
Declare Init_Register()
Declare Get_PROCESSOR_STATUS()
Declare Get_ROM_FILE()
Declare.c ABSRead8_MEM(*memory.CHARACTER,position)
Declare.i ABSRead16_MEM(*memory.CHARACTER,position)
Declare DUMP_MEMORY(Start_From.i, End_To.i, Byte_Per_Line.i = #NB_BYTE)
Declare.i GetElement(opcode.i,type.i = #GET_OPCODE)
Declare.i GetCycle(opcode.i)
Declare.i GET_LABEL(value.i)
Declare DISASM_MEMORY(Start_From.i, End_To.i)
Declare.i PUSH_STACK(value.c)
Declare.i POP_STACK()
Declare DUMP_REG()

;-***********************
;>***                 ***
;-***   INIT, ERROR   ***
;-***   DIVERS PROC   ***
;>***                 ***
;-***********************
Procedure Init_ADIR(Format_init.s)
Protected tmp.s, i.i

  Select Format_init

    Case #ADIR_CONSOLE
      _ADIR_FORMAT_EXE  = #ADIR_CONSOLE
      OpenConsole()
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ;EnableGraphicalConsole(1)
        ConsoleColor(7, 0)
      CompilerElse
        ;ADIR_Console_Normal()
      CompilerEndIf

    Case #ADIR_GUI
      _ADIR_FORMAT_EXE  = #ADIR_GUI
      _ADIR_GUI_QUIT    = #False

  EndSelect

  Restore basic_token
  i = 0
  While tmp <> "@@@@@"
    Read.s tmp
    ADIR_BASIC_TOKEN(i) = tmp
    i+1
  Wend

  Restore basic_integer_token
  i = 0
  While tmp <> "@@@@@"
    Read.s tmp
    ADIR_BASIC_INTEGER_TOKEN(i) = tmp
    i+1
  Wend

  _ADIR_VERSION     = #ADIR_PUBLIC_VER + "." + #ADIR_FONCTION_ADDED + "." + #ADIR_UPDATED + _ADIR_FORMAT_EXE

  If _ADIR_DEBUG = #True
    CreateFile(#DEBUG_FILENUM,#DEBUG_NAME)
      WriteStringN(#DEBUG_FILENUM,"DEBUG LOG--DATE:"+FormatDate(" %dd/%mm/%yyyy at %hh:%ii:%ss", Date()))
      WriteStringN(#DEBUG_FILENUM,"---------------")
    CloseFile(#DEBUG_FILENUM)
  EndIf

EndProcedure

; Init for 6502 stuff/Emulator
Procedure Init_6502(value.i)
  If value & #CPU_6502_OPCODE   : Init_OPCODE()                   : EndIf
  If value & #CPU_6502_CPU      : Init_CPU()                      : EndIf
  If value & #CPU_6502_ROM      : Reset_Memory() : Get_ROM_FILE() : EndIf
  If value & #CPU_6502_REGISTER : Init_Register()                 : EndIf
EndProcedure

Procedure DEBUG_LOG(value.s)
  If _ADIR_DEBUG = #True
    OpenFile(#DEBUG_FILENUM,#DEBUG_NAME)
      FileSeek(#DEBUG_FILENUM, Lof(#DEBUG_FILENUM))
      WriteStringN(#DEBUG_FILENUM,value)
    CloseFile(#DEBUG_FILENUM)
  EndIf
EndProcedure

Procedure ADIR_Error(_error_.s, _num_error_.l)
Protected msg.s, _BUF.s
Protected level.i = #MIN_LEVEL

  CloseWindow(#MAIN_WIN_PROCESSING)

  Select _num_error_
	  Case #ERR_ADD_LIST
	    msg = "Cannot add more line"
	    level = #MAX_LEVEL
	  Case #ERR_CREATE_IMG
      msg = "CreateImage: Creation error"
      level = #MAX_LEVEL
	  Case #ERR_GRAB_IMG
      msg = "GrabImage: Creation error"
      level = #MAX_LEVEL
	  Case #ERR_ALLOC_MEM
	    msg = "Memory allocation error for "+#QUOTE+_error_+#QUOTE
	    level = #MAX_LEVEL
    Case #ERR_FILE_NOT_FOUND
	    msg = "Disk image "+#QUOTE+_error_+#QUOTE+" not found"
	    level = #MAX_LEVEL

	  Case #ERR_INVALID_TS
	    msg = "Track/Sector ["+_error_+"] invalid"
    Case #ERR_INVALID_TSO
	    msg = "Track/Sector/Offset ["+_error_+"] invalid"
	  Case #ERR_DAMAGED_FILE
      msg = "File ["+_error_+"] is damaged"
	  Case #ERR_LENGTH_FILE
      msg = "File ["+_error_+"] is empty"

	  Default
	    msg = "Unknown Error "+_error_
      level = #MAX_LEVEL
  EndSelect

  _BUF = msg

  If _ADIR_FORMAT_EXE = #ADIR_CONSOLE
    PrintN("*** Err#"+RSet(Str(_num_error_),5,"0")+": "+_BUF+" !!! ***")
  Else
    MessageRequester("*** Err#"+RSet(Str(_num_error_),5,"0"),_BUF+" !!! ***")
  EndIf

  If level = #MAX_LEVEL
    End
  EndIf
EndProcedure

Procedure.l OpenDSK(TheFile.s = "")
  If Not TheFile
    Tmp_DiskName = OpenFileRequester("Choose a valid disk image","","Disk Image (*.dsk,*.do,*.nib)|*.dsk;*.DSK;*.do;*.DO;*.nib;*.NIB|All files (*.*)|*.*",0)
  Else
    Tmp_DiskName = TheFile
  EndIf

  DiskName = GetFilePart(Tmp_DiskName)

  If Tmp_DiskName
    SizeOfDisk = FileSize(Tmp_DiskName)
    If SizeOfDisk > 0
      *ImgDskBuffer = AllocateMemory(SizeOfDisk)
  
      If *ImgDskBuffer
        OpenFile(#FileDsk,Tmp_DiskName)
        ReadData(#FileDsk,*ImgDskBuffer,SizeOfDisk)
        CloseFile(#FileDsk)
      Else
        ADIR_Error(DiskName,#ERR_ALLOC_MEM)
      EndIf
    Else
      ADIR_Error("OPENDSK: "+DiskName,#ERR_FILE_NOT_FOUND)
    EndIf
  EndIf

  ProcedureReturn SizeOfDisk
EndProcedure

Procedure Add_Buffer(length.l,taille.l,continous.i = #False)
Protected i.i = 0, a.b
Shared dump_counter.i

  If continous = #False
    ClearList(DumpFile())
    dump_counter = 0
  EndIf

  a = PeekB(*buf_sector+i) & $FF              ;Get byte from buffer+i

  AddElement(DumpFile())
    DumpFile()\c = a
  i + 1
  dump_counter + 1
  
  While i < length
    a = PeekB(*buf_sector+i) & $FF            ;cf above

    AddElement(DumpFile())
      DumpFile()\c = a
    i + 1
    dump_counter + 1
  Wend
EndProcedure

Procedure ReadTS(track.l,sector.l,continous.i = #False)
Protected Position_TS.l

If *ImgDskBuffer
  *buf_sector = AllocateMemory(#SizeOfSector)
  Position_TS = (track * 256 * 16) + (sector * 256)     ;compute position inside Disk buffer

  If Position_TS < SizeOfDisk
    CopyMemory(*ImgDskBuffer+Position_TS,*buf_sector,#SizeOfSector)
  
    Add_Buffer(#SizeOfSector,#NB_BYTE,continous)
  Else
    ADIR_Error("READTS: $"+HEXA(track)+"/$"+HEXA(sector),#ERR_INVALID_TS)
  EndIf
EndIf

EndProcedure

Procedure.s HEXA(value.i, size = #S_BYTE)
  ProcedureReturn RSet(Hex(value),size,"0")
EndProcedure

Procedure Win_processing()
  If OpenWindow(#MAIN_WIN_PROCESSING,0,0,150,40,"",#PB_Window_WindowCentered,WindowID(#MAIN_WIN_ADIR))
    TextGadget(#WIN_LABEL_PROCESS,10,10,100,20,"Processing...")
    While WindowEvent():Wend
    Delay(250)
  EndIf
EndProcedure

Procedure Set_DUMP(what_to_dump.i = #DUMP_DISPLAY_ALL)
  DUMP_VALUE = what_to_dump
EndProcedure

Procedure Set_DISASM(what_to_disasm.i = #DUMP_DIS_NORMAL)
  DISASM_VALUE = what_to_disasm
EndProcedure

Procedure.c Read8_MEM()
Protected a.c = Dumpfile()\c

  NextElement(Dumpfile())
  ProcedureReturn a
EndProcedure

Procedure.i Read16_MEM()
Protected val.i

  Select BYTE_ORDERING
    Case #BIG____ENDIAN
      val = Read8_MEM() << 8
      val | Read8_MEM()
    Case #LITTLE_ENDIAN
      val = Read8_MEM()
      val | Read8_MEM() << 8
  EndSelect
  
  ProcedureReturn val
EndProcedure

Procedure.c GetByte(track.l, sector.l, offset.l)
Protected Position_TS.l

If *ImgDskBuffer
  Position_TS = (track * 256 * 16) + (sector * 256)

  If Position_TS < SizeOfDisk And offset >=0
    CopyMemory(*ImgDskBuffer+Position_TS+offset,*offset,SizeOf(Character))
    ProcedureReturn *offset\c
  Else
    ADIR_Error("GETBYTE: $"+HEXA(track)+"/$"+HEXA(sector)+"/$"+HEXA(offset),#ERR_INVALID_TSO)
    DEBUG_LOG(">>>>>> ERROR GETBYTE in (Track/Sector/Offset) : $"+HEXA(track)+"/$"+HEXA(sector)+"/$"+HEXA(offset))
  EndIf
EndIf

EndProcedure

;-**********************
;>***                ***
;-***   PROCESSOR    ***
;>***                ***
;-**********************

Procedure Set_BYTE_ORDERING(value.i)
  ;#LITTLE_ENDIAN
  ;#BIG____ENDIAN
  BYTE_ORDERING = value
EndProcedure

Procedure Init_OPCODE()
Protected tmp1.s,tmp2.s,tmp3.i, i.i
Protected tmp_len.i, tmp_cycle.i, tmp_extra_cycle.i

  Restore OPCODE_FLAG_6502
  Read.s tmp1

  While tmp1 <> "@@@"
    Read.s tmp2
    Read.i tmp3

    AddElement(OPCODE())
      OPCODE()\OPC_MNEMONIC    = tmp1
      OPCODE()\OPC_DESCRIPTION = tmp2
      OPCODE()\OPC_FLAGS       = tmp3

      For i = 0 To #NB_MODE_OPC-1
        Read.i tmp3
        OPCODE()\OPC_CODE[i]\_opc_CODE = tmp3
        
      Next i

    Read.s tmp1
  Wend

  Restore OPCODE_CYCLE_6502
  ResetList(OPCODE())
;   CreateFile(98,"adir_DEBUG_OPC_CYCLE.LOG")
  ForEach OPCODE()
    For i = 0 To #NB_MODE_OPC-1
      tmp3 = OPCODE()\OPC_CODE[i]\_opc_CODE
;       Select i
;         Case #IMM
;           mode$="Immediate"
;         Case #ZP
;           mode$="Zero Page"
;         Case #ZPX
;           mode$="Zero Page,X"
;         Case #ZPY
;           mode$="Zero Page,Y"
;         Case #ABS
;           mode$="Absolute"
;         Case #ABSX
;           mode$="Absolute,X"
;         Case #ABSY
;           mode$="Absolute,Y"
;         Case #IND
;           mode$="Indirect"
;         Case #INDX
;           mode$="Indirect,X"
;         Case #INDY
;           mode$="Indirect,Y"
;         Case #ACC
;           mode$="Accumulator"
;         Case #IMPL
;           mode$="Implied"
;         Case #REL
;           mode$="Relative"
;       EndSelect
; 
;       WriteString(98,"["+OPCODE()\OPC_MNEMONIC+"] --> $"+hexa(tmp3)+" - MODE: ["+mode$+"]")
;       If Len(mode$) < 8 : WriteString(98,Chr(9)) : EndIf
; 
;       WriteString(98,Chr(9))

      Read.i tmp_len.i
      Read.i tmp_cycle.i
      Read.i tmp_extra_cycle
      OPCODE()\OPC_CODE[i]\_opc_LEN          = tmp_len
      OPCODE()\OPC_CODE[i]\_opc_CYCLE        = tmp_cycle
      OPCODE()\OPC_CODE[i]\_opc_EXTRA_CYCLE  = tmp_extra_cycle
;       WriteString(98," - LEN:"+Str(tmp_len)+" - CYCLE:"+Str(tmp_cycle)+" - EXTRA:"+Str(tmp_extra_cycle))
;       
;       If OPCODE()\OPC_MNEMONIC <> "BRK" And tmp3 = 0 And tmp_len > 0 : WriteString(98," <-- ERROR ***") : EndIf
;       WriteStringN(98,"")
    Next i
;     WriteStringN(98,"--------------------------------------------------------------------")
  Next
;   CloseFile(98)
  
  Restore LABEL_6502
  Read.i tmp3
  
  While tmp3 <> $FFFF
    AddElement(LABEL())
      LABEL()\Code  = tmp3
      Read.s tmp1
      LABEL()\Text  = tmp1
      Read.s tmp1
      LABEL()\Line1 = tmp1
      Read.s tmp1
      LABEL()\Line2 = tmp1
      Read.s tmp1
      LABEL()\Line3 = tmp1
      Read.s tmp1
      LABEL()\Line4 = tmp1
    Read.i tmp3
  Wend

  SortList(LABEL(),#PB_Sort_Ascending)
EndProcedure

Procedure Init_CPU()
  *Reg      = AllocateMemory(SizeOf(TREGISTER))
  *MAIN_RAM = AllocateMemory(#RAM_64K)
  *AUX_RAM  = AllocateMemory(#RAM_64K)
EndProcedure

Procedure ZeroMemory(*memory.CHARACTER, size.l)
Protected iByte

  iByte = 0
  While iByte <= size
    PokeL(*memory + iByte, $00)
    iByte + 4
  Wend
EndProcedure

Procedure Reset_Memory()
Protected iByte

;*** Init RAM Image ***
	ZeroMemory(*MAIN_RAM, #RAM_64K)
	ZeroMemory(*AUX_RAM , #RAM_64K)

  iByte = 0
  While iByte < $C000
    PokeL(*MAIN_RAM + iByte, $FFFFFFFF)
    iByte + 4
  Wend
EndProcedure

Procedure Init_Register()
  *Reg\A    = $FF
  *Reg\X    = $FF
  *Reg\Y    = $FF

  *Reg\PS\N = 0
  *Reg\PS\V = 0
  *Reg\PS\R = 1
  *Reg\PS\B = 0
  *Reg\PS\D = 0
  *Reg\PS\I = 0
  *Reg\PS\Z = 0
  *Reg\PS\C = 0

  *Reg\SP   = #MAX_STACK                ; Stack Pointer : starting at $FF ($00 à $FF)
  *Reg\PC   = $0000                     ; Program Counter
EndProcedure

Procedure Get_PROCESSOR_STATUS()

  *PS = #FLAG_R                         ; Default value

  If *Reg\PS\N = 1                      ; Negative (sign)
    *PS | #FLAG_N
  EndIf

  If *Reg\PS\V = 1                      ; Overflow
    *PS | #FLAG_V
  EndIf

  If *Reg\PS\B = 1                      ; Break command
    *PS | #FLAG_B
  EndIf

  If *Reg\PS\D = 1                      ; Decimal mode
    *PS | #FLAG_D
  EndIf

  If *Reg\PS\I = 1                      ; Interrupt disable
    *PS | #FLAG_I
  EndIf

  If *Reg\PS\Z = 1                      ; Zero
    *PS | #FLAG_Z
  EndIf

  If *Reg\PS\C = 1                      ; Carry
    *PS | #FLAG_C
  EndIf
EndProcedure

Procedure Get_ROM_FILE()
Protected *MEM_ROM

  *MEM_ROM = AllocateMemory(#SIZE_ROM_2E)

  If *MEM_ROM
    OpenFile(#FILE_ROM,"data/"+#ROMFILE_2E)
    ReadData(#FILE_ROM,*MEM_ROM,#SIZE_ROM_2E)
    CloseFile(#FILE_ROM)
    ;CopyMemory(*MEM_ROM,*MAIN_RAM + $C000,#SIZE_ROM_2E)
    CopyMemory(*MEM_ROM,*MAIN_RAM + #RAM_64K - #SIZE_ROM_2E + 1, #SIZE_ROM_2E)
    FreeMemory(*MEM_ROM)
  Else
    PrintN("*** Error getting rom file "+Chr(34)+"data/"+#ROMFILE_2E+Chr(34)+" !")
    End
  EndIf
EndProcedure

; Procedure.s HEXA(value.i, size = #S_BYTE)
;   ProcedureReturn RSet(Hex(value),size,"0")
; EndProcedure
; 
Procedure.c ABSRead8_MEM(*memory.CHARACTER,position)
  If position > MemorySize(*memory) : position = $0000 : EndIf
  ProcedureReturn PeekC(*memory+position)
EndProcedure

Procedure.i ABSRead16_MEM(*memory.CHARACTER,position)
Protected val.i

  Select BYTE_ORDERING
    Case #BIG____ENDIAN
      val = ABSRead8_MEM(*memory,position) << 8
      val | ABSRead8_MEM(*memory,position+1)
    Case #LITTLE_ENDIAN
      val = ABSRead8_MEM(*memory,position)
      val | ABSRead8_MEM(*memory,position+1) << 8
  EndSelect
  
  ProcedureReturn val
EndProcedure

;-> DUMPING PROCEDURES
; Procedure Set_DUMP(what_to_dump.i = #DUMP_DISPLAY_ALL)
;   DUMP_VALUE = what_to_dump
; EndProcedure

Procedure DUMP_MEMORY(Start_From.i, End_To.i, Byte_Per_Line.i = #NB_BYTE)
Protected *ptrADR = *MAIN_RAM + Start_From
Protected ind.i = 0, counter.i = 0
Protected Length.i = End_to - Start_From, org.i = 0
Protected a.c, b.s, lineHEX.s = "", lineASC.s = ""
Protected z.i = 0, sp.s = ""

  If End_To < Start_From
    Print("*** DUMP ERROR : ")
    PrintN("End adress ($"+HEXA(End_To,#S_WORD)+") < Starting adress ($"+HEXA(Start_From,#S_WORD)+")")
    ProcedureReturn 
  EndIf

  org = Start_From

  a = PeekC(*ptrADR + ind)

  Select a
    Case $20 To $7E
      b = Chr(a)
    Case $A0 To $FE
      b = Chr(a - $80)
    Default
      b = "."
  EndSelect

  lineHEX = HEXA(a) + " "
  lineASC = b

  ind + 1
  
  While ind <= Length
    If ind % Byte_Per_Line = 0
      Select DUMP_VALUE
        Case #DUMP_DISPLAY_HEX
          PrintN(HEXA(org, #S_WORD)+":"+lineHEX)
        Case #DUMP_DISPLAY_ASC
          PrintN(HEXA(org, #S_WORD)+":"+lineASC)
        Case #DUMP_DISPLAY_ALL
          PrintN(HEXA(org, #S_WORD)+":"+lineHEX+"- "+lineASC)
      EndSelect

      lineHEX = "" : lineASC = "" : b = "" : org = Start_From + ind : counter = ind
    EndIf
    a = PeekC(*ptrADR + ind)
  
    Select a
      Case $20 To $7E
        b = Chr(a)
      Case $A0 To $FE
        b = Chr(a - $80)
      Default
        b = "."
    EndSelect
  
    lineHEX + HEXA(a) + " "
    lineASC + b
    ind + 1
  Wend

  z = Byte_Per_Line - (Length-counter)  ;compute space gap for align
  sp = Space((z+z*2)-3)
  Select DUMP_VALUE
    Case #DUMP_DISPLAY_HEX
      PrintN(HEXA(org, #S_WORD)+":"+lineHEX)
    Case #DUMP_DISPLAY_ASC
      PrintN(HEXA(org, #S_WORD)+":"+lineASC)
    Case #DUMP_DISPLAY_ALL
      PrintN(HEXA(org, #S_WORD)+":"+lineHEX+sp+"- "+lineASC)
  EndSelect

EndProcedure

;-> DISSASM PROCEDURES
Procedure.i GetElement(opcode.i,type.i = #GET_OPCODE)
Protected indx.i = -1, i.i = 0

  ResetList(OPCODE())
  While NextElement(OPCODE())
    For i = 0 To #NB_MODE_OPC-1
      If OPCODE()\OPC_CODE[i]\_opc_CODE = opcode
        Select type
          Case #GET_OPCODE
            ProcedureReturn indx+1
            Break
          Case #GET_MODE
            ProcedureReturn i
            Break
        EndSelect
      EndIf
    Next
    indx + 1
  Wend

  ProcedureReturn -1
EndProcedure

Procedure.i GetCycle(opcode.i)
Protected indx.i = 0

EndProcedure

Procedure.i GET_LABEL(value.i)
Protected indx.i = -1

  ResetList(LABEL())
  While NextElement(LABEL())
    If LABEL()\code = value
      ProcedureReturn indx+1
      Break
    EndIf
    indx + 1
  Wend

  ProcedureReturn -1
EndProcedure

Procedure DISASM_MEMORY(Start_From.i, End_To.i)
Protected *ptrADR = *MAIN_RAM + Start_From
Protected code_len.i = End_to - Start_From, code_org.i  = Start_From

Protected i.i = 0, indx.i, mode.i, jump.i = 0, adr_jmp.i = 0
Protected opcode.c

Protected val_tmp.i, val_tmp1.i, val_tmp2.i, the_label.i

  If End_To < Start_From
    Print("*** DISASM ERROR : ")
    PrintN("End adress ($"+HEXA(End_To,#S_WORD)+") < Starting adress ($"+HEXA(Start_From,#S_WORD)+")")
    ProcedureReturn 
  EndIf

  PrintN("ORG    $"+HEXA(code_org,#S_WORD))
  PrintN("LEN    $"+HEXA(code_len,#S_WORD))
;   PrintN("reg.PC $"+HEXA(*Reg\PC,#S_WORD))
  PrintN("")

  While i <= code_len
    opcode = PeekC(*ptrADR + i)
    Print(hexa(code_org + i,#S_WORD)+"-   ")
    Print(hexa(opcode)+" ")

    If opcode <> $00
      indx = GetElement(opcode)
      If indx <> -1                           ;Opcode found
        mode = GetElement(opcode,#GET_MODE)
        SelectElement(OPCODE(), indx)
        opc$ = OPCODE()\OPC_MNEMONIC
      EndIf
  
      tmp1$="":tmp2$="":tmp3$="";Chr(9)+"; "
  
      If indx <> -1
        Select OPCODE()\OPC_CODE[mode]\_opc_LEN
          Case 2
            i + 1
            val_tmp2 = PeekC(*ptrADR + i)
            tmp2$ = hexa(val_tmp2)

            the_label = GET_LABEL(val_tmp2)

            If the_label <> -1
              SelectElement(LABEL(),the_label)
              tmp3$ = Chr(9) + ";" + LABEL()\Line1
            EndIf

          Case 3
            i + 1
            val_tmp2 = PeekC(*ptrADR + i)
            tmp2$ = hexa(val_tmp2)

            i + 1
            val_tmp1 = PeekC(*ptrADR + i)
            tmp1$ = hexa(val_tmp1)
            
            val_tmp = val_tmp2 + val_tmp1 << 8
            the_label = GET_LABEL(val_tmp)

            If the_label <> -1
              SelectElement(LABEL(),the_label)
              tmp3$ = Chr(9) + ";" + LABEL()\text
            EndIf
         EndSelect
      Else
        opc$="???"
      EndIf

      ; Affiche opcode HEXA
      Print(tmp2$ + " " + tmp1$)
      Print("    ")
  
      ; Affiche MNEMONIC
      Print(Chr(9) + opc$ + Chr(9))
      If indx <> -1
        If mode = #Imm : Print("#") : EndIf
        If mode < #IMPL And mode <> #IND And mode <> #ACC And mode <> #INDX And mode <> #INDY: Print("$") : EndIf
        If mode = #REL
          jump = PeekC(*ptrADR + i)
          If jump > 127
            adr_jmp = (code_org + i) - ($FF-jump)
          Else
            adr_jmp = (code_org + i) + jump + 1
          EndIf
          tmp1$ = "$" + hexa(adr_jmp,#S_WORD) : tmp2$ = ""
        EndIf
        If mode = #IND
          tmp1$ = "($" + tmp1$
          tmp2$ = tmp2$ + ")"
        EndIf
        If mode = #INDX
          tmp2$ = "($" + tmp2$ + ",X)"
        EndIf
        If mode = #INDY
          tmp2$ = "($" + tmp2$ + ",Y)"
        EndIf
        If mode = #ZPX
          tmp2$ + ",X"
        EndIf
        If mode = #ZPY
          tmp2$ + ",Y"
        EndIf
        If mode = #ABSX
          tmp2$ + ",X"
        EndIf
        If mode = #ABSY
          tmp2$ + ",Y"
        EndIf
      EndIf
  
      Print(tmp1$+tmp2$+tmp3$)
    Else
      Print(Chr(9)+Chr(9)+"BRK")
    EndIf

    PrintN("")
    i + 1
  Wend
EndProcedure

Procedure.i PUSH_STACK(value.c)
Protected *ptrADR = *MAIN_RAM + #STACK

  PokeC(*ptrADR + *Reg\SP, value)
  *Reg\SP - 1
  If *Reg\SP < 0 : *Reg\SP = #MAX_STACK : EndIf
EndProcedure

Procedure.i POP_STACK()
Protected *ptrADR = *MAIN_RAM + #STACK
Protected value.c

  If *Reg\SP > #MAX_STACK : *Reg\SP = 0 : Else : *Reg\SP + 1 : EndIf
  value = PeekC(*ptrADR + *Reg\SP)
  ProcedureReturn value
EndProcedure

Procedure DUMP_REG()
  Get_PROCESSOR_STATUS()
  PrintN("")
  PrintN( " A="+HEXA(*Reg\A)+" X="+HEXA(*Reg\X)+" Y="+HEXA(*Reg\Y)+" P="+HEXA(*PS)+" S="+HEXA(*Reg\SP)+" PC="+HEXA(*Reg\PC,#S_WORD) )
EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 100
; FirstLine = 95
; Folding = ------
; DisableDebugger
; CompileSourceDirectory