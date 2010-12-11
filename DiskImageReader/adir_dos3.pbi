; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***                           ***
; *********************************
; *****************
;-**   DOS 3.3   **
; *****************
; ******************
;-** Declarations **
; ******************
Declare EXPORT_File(element.i,lines.s)
Declare.s ViewFile(filename.s,element.i,type.i,org.i,length.i)
Declare.s ShowFile(element)
Declare CheckCatFiles()
Declare CATALOG(track.l, sector.l)

; ******************
;-**  Procedures  **
; ******************
Procedure EXPORT_File(element.i,lines.s)
Protected file_ts.i, filename.s, type_file.i, file_locked.i, org.i, typ$

SelectElement(Catfile(),element)
  filename    = Trim(Catfile()\filename)
  type_file   = Catfile()\type
  file_locked = Catfile()\locked
  org         = Catfile()\org

  Select type_file
    Case #FILE_TEXT     : typ$="TXT"
    Case #FILE_INTEGER  : typ$="INT"
    Case #FILE_BASIC    : typ$="BAS"
    Case #FILE_BINARY   : typ$="BIN"
    Case #FILE_TYPE_S   : typ$="S"
    Case #FILE_RELOC    : typ$="REL"
    Case #FILE_TYPE_A   : typ$="A"
    Case #FILE_TYPE_B   : typ$="B"
  EndSelect

  filename = ReplaceString(filename, "*", "_")

  _ADIR_EXPORT_FILE = filename+"$"+HEXA(file_locked)+HEXA(org,#S_WORD)+"#"+typ$+".ADIR"

  file_ts = CreateFile(#PB_Any,_ADIR_EXPORT_FILE)
  WriteString(file_ts,lines)
  CloseFile(file_ts)
EndProcedure

Procedure Set_ORG(type_file.i)

ResetList(DumpFile())
  Select type_file
    Case #FILE_BINARY, #FILE_TYPE_S, #FILE_RELOC, #FILE_TYPE_A, #FILE_TYPE_B:
      SelectElement(DumpFile(),4)    ; 0 & 1 = org - 2 & 3 = len
    Case #FILE_BASIC:
      SelectElement(DumpFile(),2)    ; 0 & 1 = len
    Case #FILE_TEXT:
      FirstElement(DumpFile())
  EndSelect

EndProcedure

;Procedure ViewFile(filename.s, type.i)
Procedure.s ViewFile(filename.s,element.i,type.i,org.i,length.i)
Protected lines.s, token.c, ind.i, Start_From.i, nextadr.i, lineNum.i

Protected b.s = "", lineHEX.s = "", lineASC.s = "", counter.i = 0
Protected z.i = 0, sp.s = "", Byte_Per_Line.i = #NB_BYTE

Protected indx.i, mode.i, jump.i = 0, adr_jmp.i = 0

  DEBUG_LOG("---[ PROC ViewFile("+filename+")")

  If DISASM_VALUE = #DUMP_DIS_DISASM

    DEBUG_LOG("{ -- #DUMP_DIS_DISASM")

    lines = "" : ind = 0
    Start_From = org 
  
    While ind < length

      opcode = Read8_MEM()
      lines + HEXA(org + ind,#S_WORD)+"-   "
      lines + HEXA(opcode)+" "

      If opcode <> $00
        indx = GetElement(opcode)
        If indx <> -1                           ;Opcode found
          mode = GetElement(opcode,#GET_MODE)
          SelectElement(OPCODE(), indx)
          opc$ = OPCODE()\OPC_MNEMONIC
        EndIf
    
        tmp1$="":tmp2$="":tmp3$=""
    
        If indx <> -1
          Select OPCODE()\OPC_CODE[mode]\_opc_LEN
            Case 2
              ind + 1
              val_tmp2 = Read8_MEM()
              tmp2$ = hexa(val_tmp2)
  
              the_label = GET_LABEL(val_tmp2)
  
              If the_label <> -1
                SelectElement(LABEL(),the_label)
                tmp3$ = Chr(9) + ";" + LABEL()\text   ;Line1
              EndIf
  
            Case 3
              ind + 1
              val_tmp2 = Read8_MEM()
              tmp2$ = hexa(val_tmp2)
  
              ind + 1
              val_tmp1 = Read8_MEM()
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
        lines + tmp2$ + " " + tmp1$ + "    "
    
        ; Affiche MNEMONIC
        lines + Chr(9) + opc$ + Chr(9)
        If indx <> -1
          If mode = #Imm : lines + "#" : tmp3$ = "" : EndIf     ;tmp3$ = "" cause it's a immedaite value
          If mode < #IMPL And mode <> #IND And mode <> #ACC And mode <> #INDX And mode <> #INDY: lines + "$" : EndIf
          If mode = #REL
            PreviousElement(Dumpfile())
            jump = Read8_MEM()
            If jump > 127
              adr_jmp = (org + ind) - ($FF-jump)
            Else
              adr_jmp = (org + ind) + jump + 1
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
    
        lines + tmp1$ + tmp2$ + tmp3$
      Else
        lines + Chr(9) + Chr(9) + "BRK"
      EndIf
  
      lines + #CRLF$
      ind + 1
    Wend

    DEBUG_LOG("}")

    If _ADIR_FORMAT_EXE = #ADIR_CONSOLE
      EXPORT_File(element,lines)
    EndIf

    ProcedureReturn

;       CloseWindow(#MAIN_WIN_PROCESSING)
;       SetGadgetText(#Editor_FILE, lines)
;       SetGadgetState(#Option_DISASM, 1)
;     EndIf
  EndIf

  Select type
    Case #FILE_TEXT

      DEBUG_LOG("{ -- #FILE_TEXT")

      lines = "" : ind = 0
      While ind <= length
        token = Read8_MEM() : ind + 1
          Select token
            Case $20 To $7E
              lines + Chr(token)
            Case $8D
              lines + #CRLF$
            Case $A0 To $FE
              lines + Chr(token - $80)
            Default
              lines + ""
          EndSelect
      Wend

      DEBUG_LOG("}")

      If _ADIR_FORMAT_EXE = #ADIR_CONSOLE
        EXPORT_File(element,lines)
      Else
        CloseWindow(#MAIN_WIN_PROCESSING)
        SetGadgetText(#Editor_FILE, lines)
        SetGadgetState(#Option_ASCII, 1)
      EndIf

    Case #FILE_BINARY, #FILE_TYPE_S, #FILE_RELOC, #FILE_TYPE_A, #FILE_TYPE_B

      DEBUG_LOG("{ -- #FILE_BINARY, #FILE_TYPE_S, #FILE_RELOC, #FILE_TYPE_A, #FILE_TYPE_B")

      lines = "" : ind = 0 : b = ""
      Start_From = org 
    
      token = Read8_MEM()
    
      Select token
        Case $20 To $7E
          b = Chr(token)
        Case $A0 To $FE
          b = Chr(token - $80)
        Default
          b = "."
      EndSelect
    
      lineHEX = HEXA(token) + " "
      lineASC = b

      ind + 1
      
      While ind <= Length
        If ind % Byte_Per_Line = 0
          Select DUMP_VALUE
            Case #DUMP_DISPLAY_HEX
              lines + HEXA(org, #S_WORD)+":"+lineHEX
            Case #DUMP_DISPLAY_ASC
              lines + HEXA(org, #S_WORD)+":"+lineASC
            Case #DUMP_DISPLAY_ALL
              lines+ HEXA(org, #S_WORD)+":"+lineHEX+"- "+lineASC
          EndSelect
          lines + #CRLF$
          lineHEX = "" : lineASC = "" : b = "" : org = Start_From + ind : counter = ind
        EndIf
        
        token = Read8_MEM()
      
        Select token
          Case $20 To $7E
            b = Chr(token)
          Case $A0 To $FE
            b = Chr(token - $80)
          Default
            b = "."
        EndSelect
      
        lineHEX + HEXA(token) + " "
        lineASC + b

        b = ""
        ind + 1
      Wend
    
      z = Byte_Per_Line - (Length-counter)  ;compute space gap for align
      sp = Space((z+z*2)-3)
      Select DUMP_VALUE
        Case #DUMP_DISPLAY_HEX
          lines + HEXA(org, #S_WORD)+":"+lineHEX
        Case #DUMP_DISPLAY_ASC
          lines + HEXA(org, #S_WORD)+":"+lineASC
        Case #DUMP_DISPLAY_ALL
          lines + HEXA(org, #S_WORD)+":"+lineHEX+sp+"- "+lineASC
      EndSelect
      lines + #CRLF$

      DEBUG_LOG("}")

      If _ADIR_FORMAT_EXE = #ADIR_CONSOLE
        EXPORT_File(element,lines)
      Else
        CloseWindow(#MAIN_WIN_PROCESSING)
        SetGadgetText(#Editor_FILE, lines)
        SetGadgetState(#Option_HEX, 1)
      EndIf

    Case #FILE_BASIC

      DEBUG_LOG("{ -- #FILE_BASIC")

      lines = "" : ind = 0
      While ind <= length
        nextadr = Read16_MEM() : ind + 2
        If nextadr = 0 : Break : EndIf
      
        lineNum = Read16_MEM() : ind + 2
        lines + Str(lineNum)+" "
        Repeat
          token = Read8_MEM() : ind + 1
          Select token
            Case $80 To $EA
              lines + " " + ADIR_BASIC_TOKEN(token-$80) + " "
            Default
              lines + Chr(token)
          EndSelect
        Until token = 0
        lines + #CRLF$
      Wend

      DEBUG_LOG("{ -- #FILE_BASIC")

      If _ADIR_FORMAT_EXE = #ADIR_CONSOLE
        EXPORT_File(element,lines)
      Else
        CloseWindow(#MAIN_WIN_PROCESSING)
        SetGadgetText(#Editor_FILE, lines)
        SetGadgetState(#Option_BASIC, 1)
      EndIf

  EndSelect

  DEBUG_LOG("---] ENDPROC ViewFile()")

EndProcedure

Procedure.s ShowFile(element)
Protected filename.s
Protected type_file.i, block_used.i
Protected track_file.i, sector_file.i

Protected track_l_next.i, sector_l_next.i
Protected cur_track_list.i, cur_sector_list.i

Protected org.i, length.i, tts.i

  If _ADIR_FORMAT_EXE = #ADIR_GUI
    Win_processing()
  EndIf

  ClearList(DumpFile())
  dump_counter = -#NB_BYTE

  SelectElement(Catfile(), element)
    filename    = Trim(Catfile()\filename)
    type_file   = Catfile()\type
    block_used  = catfile()\block_used
    track_file  = catfile()\llist\track
    sector_file = catfile()\llist\sector

    If Catfile()\damaged = #True
      ADIR_Error(filename,#ERR_DAMAGED_FILE)
      SetGadgetText(#Editor_FILE, "File is damaged !!!")
      CloseWindow(#MAIN_WIN_PROCESSING)
      ProcedureReturn ""
    EndIf

    If Catfile()\deleted = #True
      SetGadgetText(#Editor_FILE, "File is deleted !!!")
      CloseWindow(#MAIN_WIN_PROCESSING)
      ProcedureReturn ""
    EndIf
  ; Get TS List of selected file
  ;
  ;   Structure TTSLIST
  ;     N0.TNOTUSED           ;00             - Not used
  ;     next_t_list.c         ;01             - Track number of next T/S List sector if one was
  ;                           ;                 needed or zero if no more T/S List sectors.
  ;     next_s_list.c         ;02             - Sector number of next T/S List sector (if present).
  ;     N1.TNOTUSED_2         ;03-04          - Not used
  ;     sector_offset.w       ;05-06          - Sector offset in file of the first sector described
  ;                           ;                 by this list.
  ;     N2.TNOTUSED_5         ;07-0B          - not used
  ;     ts_data.TTS[122]      ;0C-0D          - Track and sector of first data sector or zeros
  ;                           ;0E-0F          - Track and sector of second data sector or zeros
  ;                           ;10-FF          - Up to 120 more Track/Sector pairs
  ;   EndStructure

  *tslist = AllocateMemory(SizeOf(TTSLIST))
  Position_TS = (track_file * 256 * 16) + (sector_file * 256)

  DEBUG_LOG("---[ PROC ShowFile()")
  DEBUG_LOG("> FILENAME: "+filename)
  DEBUG_LOG("> First TS: $"+HEXA(track_file)+"/$"+HEXA(sector_file))

  If Position_TS < SizeOfDisk
    CopyMemory(*ImgDskBuffer+Position_TS,*tslist,SizeOf(TTSLIST))
    
    ; Repeat until there are no additional T/S List sectors for this file
    DEBUG_LOG("{ -- Repeat until there are no additional T/S List sectors for this file")

    Repeat
      track_l_next    = *tslist\next_t_list
      sector_l_next   = *tslist\next_s_list

      DEBUG_LOG("  Next TS : $"+HEXA(track_l_next)+"/$"+HEXA(sector_l_next))

      tts = 0
      cur_track_list = *tslist\ts_data[tts]\track
      cur_sector_list = *tslist\ts_data[tts]\sector

      DEBUG_LOG("  Current TS : $"+HEXA(cur_track_list)+"/$"+HEXA(cur_sector_list)+" - TTS: "+Str(tts))
      DEBUG_LOG("  {")

      While cur_track_list <> 0
        ReadTS(cur_track_list,cur_sector_list,#True)
        tts + 1

        If tts > 121 : Break : EndIf
        cur_track_list = *tslist\ts_data[tts]\track
        cur_sector_list = *tslist\ts_data[tts]\sector

        DEBUG_LOG("    Current TS : $"+HEXA(cur_track_list)+"/$"+HEXA(cur_sector_list)+" - TTS: "+Str(tts))

      Wend

      DEBUG_LOG("  }")

      If track_l_next > 0
        ;ZeroMemory(*tslist,SizeOf(TTSLIST))
        Position_TS = (track_l_next * 256 * 16) + (sector_l_next * 256)
        DEBUG_LOG("  track_l_next > 0")
        DEBUG_LOG("  Position_TS: $"+HEXA(Position_TS,#S_WORD))
        CopyMemory(*ImgDskBuffer+Position_TS,*tslist,SizeOf(TTSLIST))
      EndIf
    Until track_l_next = 0 And sector_l_next = 0

    DEBUG_LOG("}")

  EndIf

  DEBUG_LOG("---] ENDPROC ShowFile()")

  ; Transfert List Dumpf() to *Buf_File
  org    = catfile()\org
  length = catfile()\length

  If length > 0
    Set_ORG(type_file)
    ViewFile(filename,element,type_file,org,length)
  Else
    ADIR_Error("SHOWFILE :"+filename,#ERR_LENGTH_FILE)
  EndIf
  
;   ; We clear linkedlist or it add everytime
;   ClearList(DumpFile())
  dump_counter = 0
EndProcedure

Procedure CheckCatFiles()
Protected TS_List_Track.i, TS_List_Sector.i
Protected First_Track_File.i, First_Sector_File.i
Protected org.i, length.i, tmp.i, tmp1.i, tmp2.i
Protected tmp_TS_List_Track.i, tmp_TS_List_Sector.i

; only for text file
Protected offset.i, block.i, nbcar.i

  DEBUG_LOG("---[ PROC CheckCatFiles()")

  ResetList(Catfile())
  ForEach Catfile()
    If catfile()\deleted = #False

      DEBUG_LOG("> FILENAME: "+catfile()\filename+" ---")

      TS_List_Track = catfile()\llist\track
      TS_List_Sector= catfile()\llist\sector

      First_Track_File  = GetByte(TS_List_Track,TS_List_Sector,$0C)
      First_Sector_File = GetByte(TS_List_Track,TS_List_Sector,$0D)

      DEBUG_LOG("> First TS (Offset) of TSL ($"+HEXA(TS_List_Track)+"/$"+HEXA(TS_List_Sector)+"): $"+HEXA(First_Track_File)+"($0C)/$"+HEXA(First_Sector_File)+"($0D)")

      If First_Track_File <= #DOS_TRACK And First_Sector_File <= #DOS_SECTOR  ;Anciennement 35,15
        catfile()\damaged = #False

        Select Catfile()\type
          Case #FILE_INTEGER
            tmp1 = GetByte(First_Track_File,First_Sector_File,$00)
            tmp2 = GetByte(First_Track_File,First_Sector_File,$01)
            length = tmp2 * 256 + tmp1
            catfile()\org     = $0000
            catfile()\length  = length

          Case #FILE_BASIC
            tmp1 = GetByte(First_Track_File,First_Sector_File,$00)
            tmp2 = GetByte(First_Track_File,First_Sector_File,$01)
            length = tmp2 * 256 + tmp1
            catfile()\org     = $0801
            catfile()\length  = length

          Case #FILE_BINARY, #FILE_TYPE_S, #FILE_RELOC, #FILE_TYPE_A, #FILE_TYPE_B
            tmp1 = GetByte(First_Track_File,First_Sector_File,$00)
            tmp2 = GetByte(First_Track_File,First_Sector_File,$01)
            org = tmp2 * 256 + tmp1
            tmp1 = GetByte(First_Track_File,First_Sector_File,$02)
            tmp2 = GetByte(First_Track_File,First_Sector_File,$03)
            length = tmp2 * 256 + tmp1
            catfile()\org     = org
            catfile()\length  = length

          Case #FILE_TEXT
            block = catfile()\block_used - 2        ;minus one TS List Sector and minus last block

            DEBUG_LOG("> TYPE  : #FILE_TEXT")
            DEBUG_LOG("> BLOCK : $"+HexA(block))

            ; check if there are no additional TS List
            DEBUG_LOG("> Check if there are no additional TS List")
            tmp1 = GetByte(TS_List_Track,TS_List_Sector,$01)
            tmp2 = GetByte(TS_List_Track,TS_List_Sector,$02)
            tmp_TS_List_Track = TS_List_Track
            tmp_TS_List_Sector= TS_List_Sector

            DEBUG_LOG("> tmp1 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$01)=$"+HexA(tmp1))
            DEBUG_LOG("> tmp2 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$02)=$"+HexA(tmp2))

            If tmp1 <> 0
              DEBUG_LOG("")
              DEBUG_LOG("{ -- More TSL")
              tmp_TS_List_Track = TS_List_Track
              tmp_TS_List_Sector= TS_List_Sector

              While tmp1 <> 0                         ;yes there are more TS List
                block - 1                             ;minus one TS List Sector
                TS_List_Track = tmp1
                TS_List_Sector = tmp2
                tmp_TS_List_Track = TS_List_Track
                tmp_TS_List_Sector= TS_List_Sector

                tmp1 = GetByte(TS_List_Track,TS_List_Sector,$01)
                tmp2 = GetByte(TS_List_Track,TS_List_Sector,$02)
                DEBUG_LOG("  tmp1 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$01)=$"+HexA(tmp1))
                DEBUG_LOG("  tmp2 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$02)=$"+HexA(tmp2))
              Wend

              DEBUG_LOG("}")
            EndIf

            TS_List_Track = tmp_TS_List_Track
            TS_List_Sector= tmp_TS_List_Sector

            ; get last sector to calculate the number of car to add in last TSL
            DEBUG_LOG("")
            DEBUG_LOG("{ -- Get last sector to calculate the number of car to add in last TSL")

            offset = $0C
            tmp1 = GetByte(TS_List_Track,TS_List_Sector,offset)
            tmp2 = GetByte(TS_List_Track,TS_List_Sector,offset+1)

            DEBUG_LOG("  tmp1 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$"+HEXA(offset)+")=$"+HexA(tmp1))
            DEBUG_LOG("  tmp2 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$"+HEXA(offset+1)+")=$"+HexA(tmp2))
            DEBUG_LOG("  ...")

            While tmp1 <> 0 Or tmp2 <> 0; Or offset <= (121*2)
              offset + 2
              tmp1 = GetByte(TS_List_Track,TS_List_Sector,offset)
              tmp2 = GetByte(TS_List_Track,TS_List_Sector,offset+1)
            Wend

            DEBUG_LOG("  tmp1 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$"+HEXA(offset)+")=$"+HexA(tmp1))
            DEBUG_LOG("  tmp2 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$"+HEXA(offset+1)+")=$"+HexA(tmp2))
            DEBUG_LOG("}")

            ;compute num of car with the last sector
            offset - 2                              ;Back to last TS
            tmp1 = GetByte(TS_List_Track,TS_List_Sector,offset)
            tmp2 = GetByte(TS_List_Track,TS_List_Sector,offset+1)

            DEBUG_LOG("")
            DEBUG_LOG("{ -- Compute num of car with the last sector")
            DEBUG_LOG("  tmp1 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$"+HEXA(offset)+")=$"+HexA(tmp1))
            DEBUG_LOG("  tmp2 = GetByte($"+HEXA(TS_List_Track)+",$"+HEXA(TS_List_Sector)+",$"+HEXA(offset+1)+")=$"+HexA(tmp2))

            offset = 0 : nbcar = 0
            tmp = GetByte(tmp1,tmp2,offset)

            DEBUG_LOG("  tmp = GetByte(tmp1,tmp2,offset)")
            DEBUG_LOG("  tmp = GetByte($"+HEXA(tmp1)+",$"+HEXA(tmp2)+",$"+HEXA(offset)+")=$"+HexA(tmp))
            DEBUG_LOG("  ...")

            While tmp <> 0
              nbcar + 1
              offset + 1
              tmp = GetByte(tmp1,tmp2,offset)
            Wend

            DEBUG_LOG("  tmp = GetByte($"+HEXA(tmp1)+",$"+HEXA(tmp2)+",$"+HEXA(offset)+")=$"+HexA(tmp))
            DEBUG_LOG("}")

            catfile()\org     = $0000
            catfile()\length  = block * #SizeOfSector + nbcar

        EndSelect
      Else
        catfile()\damaged = #True
      EndIf

    EndIf
  Next

DEBUG_LOG("---] ENDPROC CheckCatFiles()")

EndProcedure

Procedure CATALOG(track.l, sector.l)
Protected Position_TS.l, nb_sector_catalog.i = 0
Protected track_next.l = track, sector_next.l = sector
Protected track_file.l = -1, sector_file.l = -1, type_file.l
Protected filename.s = ""
Protected file_length.l, lenght_of_files.l
Protected hFile.l = 0, nb_file.l = 0
Protected file_deleted.l = #False, file_locked.l = #False
Protected ascii.l

ClearList(Catfile())

If *ImgDskBuffer And _ADIR_DISK_FORMAT = #True
  *catalog = AllocateMemory(SizeOf(TCATALOG))
  Position_TS = (track * 256 * 16) + (sector * 256)

  If Position_TS < SizeOfDisk
    CopyMemory(*ImgDskBuffer+Position_TS,*catalog,SizeOf(TCATALOG))

    DEBUG_LOG("---[ PROC CATALOG("+HEXA(track)+",$"+HEXA(sector)+")")

    DEBUG_LOG("> Position_TS : $"+HEXA(Position_TS,#S_LONG))

    DEBUG_LOG("{ While track_next <> 0 And sector_next <> 0")

    nb_sector_catalog = 0

    While track_next = track And sector_next > 0 ;while (catTrack != 0 && catSect != 0 &&	iterations < DiskFSDOS33::kMaxCatalogSectors)

    ;While track_next <> 0 And sector_next <> 0 And nb_sector_catalog < _DOS3_MAXSECTCATALOG

      track_next    = *catalog\next_track
      sector_next   = *catalog\next_sector
      
      DEBUG_LOG("  track_next/sector_next: $"+HEXA(track_next)+"/$"+HEXA(sector_next))
      
      hFile = 0

      DEBUG_LOG("    { Repeat")

      Repeat
        track_file    = *catalog\fde[hFile]\track_file
        sector_file   = *catalog\fde[hFile]\sector_file
        type_file     = *catalog\fde[hFile]\type_file
        file_length   = *catalog\fde[hFile]\file_len
  
        If track_file = 0 And sector_file = 0 : Break : EndIf
;         If track_file = 0 And sector_file = 0 And nb_sector_catalog = _DOS3_MAXSECTCATALOG - 1 : Break : EndIf
  
        If track_file = #FILE_DELETED            ; $FF
          file_deleted  = #True
          track_file    = *catalog\fde[hFile]\filename[29]
          *catalog\fde[hFile]\filename[29] = 128+32
        EndIf

        If type_file & #FILE_LOCKED = #FILE_LOCKED
;           ATTR$ = "*"
          file_locked = #True
          type_file - #FILE_LOCKED
        EndIf

;         Select type_file
;           Case #FILE_TEXT     : typ$="TXT"
;           Case #FILE_INTEGER  : typ$="INT"
;           Case #FILE_BASIC    : typ$="BAS"
;           Case #FILE_BINARY   : typ$="BIN"
;           Case #FILE_TYPE_S   : typ$="S"
;           Case #FILE_RELOC    : typ$="REL"
;           Case #FILE_TYPE_A   : typ$="A"
;           Case #FILE_TYPE_B   : typ$="B"
;         EndSelect

        filename = ""
        _ADIR_INVERSE_CHAR = #False

        For i = 0 To 29
          ascii = *catalog\fde[hFile]\filename[i]
          Select ascii
            Case $88                              ; CTRL-H (to hide filename in the catalog)
              filename + "("
            Case $00 To $1A                       ; Chars are inversed
              _ADIR_INVERSE_CHAR = #True
              filename + Chr(ascii + $40)
            Case $20 To $7E
              filename + Chr(ascii)
            Case $A0 To $FE
              filename + Chr(ascii - $80)
            Default
              filename + "."
          EndSelect
        Next i

        AddElement(Catfile())
          Catfile()\filename      = filename                ;Trim(filename)
          Catfile()\type          = type_file
          catfile()\block_used    = file_length
          catfile()\llist\track   = track_file
          catfile()\llist\sector  = sector_file
          catfile()\locked        = file_locked
          catfile()\deleted       = file_deleted
          catfile()\org           = $0
          catfile()\length        = $0
          catfile()\damaged       = #False
          catfile()\inversed      = _ADIR_INVERSE_CHAR

        nb_file+1 : hFile+1

        DEBUG_LOG("      Add Filename: "+filename+" TSL : $"+HEXA(track_file)+"/$"+HEXA(sector_file))

        file_deleted  = #False
        file_locked   = #False
        nb_sector_catalog + 1

      Until hfile > #NB_FDE

      DEBUG_LOG("    } Until hfile > #NB_FDE("+Str(#NB_FDE)+")")

      Position_TS = (track_next * 256 * 16) + (sector_next * 256)
      CopyMemory(*ImgDskBuffer+Position_TS,*catalog,SizeOf(TCATALOG))
    Wend    

    DEBUG_LOG("}")

; *** Added 24.12.08
; need to adjust :
;           catfile()\org
;           catfile()\length
;           catfile()\damaged
; for each files in the catalog
; DONE (26.12.08)

    FreeMemory(*catalog)

    DEBUG_LOG("---] ENDPROC CATALOG()")

    CheckCatFiles()
  Else
    ADIR_Error("CATALOG $"+HEXA(track)+"/$"+HEXA(sector),#ERR_INVALID_TS)
  EndIf
EndIf

EndProcedure

Procedure DRAW_CATALOG()
;   SortStructuredList(Catfile(), #PB_Sort_Ascending, OffsetOf(TCATFILE\filename), #PB_Sort_String)
;
  If _ADIR_FORMAT_EXE = #ADIR_CONSOLE
    PrintN("DOS #"+DISK_DOS_Version+" - VOLUME #"+DISK_VOLUME_Number)
    PrintN("")
    PrintN("Filename              "+#TB+#TB+"Type"+#TB+"Block"+#TB+" TSL "+#TB+"ORG"+#TB+"LEN"+#TB+"LOCK"+#TB+"DEL"):PrintN("")
    ForEach Catfile()
      ;With Catfile()
      a$ = Catfile()\filename
      Select Catfile()\type
        Case #FILE_TEXT     : typ$="TXT"
        Case #FILE_INTEGER  : typ$="INT"
        Case #FILE_BASIC    : typ$="BAS"
        Case #FILE_BINARY   : typ$="BIN"
        Case #FILE_TYPE_S   : typ$="S"
        Case #FILE_RELOC    : typ$="REL"
        Case #FILE_TYPE_A   : typ$="A"
        Case #FILE_TYPE_B   : typ$="B"
      EndSelect
;        b$ = RSet(Str(\type),3," ")
      b$ = typ$
      c$ = RSet(Str(Catfile()\block_used),3," ")
      d$ = RSet(Str(Catfile()\llist\track),2," ")+"/"+LSet(Str(Catfile()\llist\sector),2," ")
      e$ = "$"+RSet(Hex(Catfile()\org),4,"0")
      f$ = RSet(Str(Catfile()\length),5," ")
      g$ = "---" : h$ = "---"
      If Catfile()\locked : g$ = "lck" : EndIf
      If Catfile()\deleted : h$ = "del" : EndIf

      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          If Catfile()\inversed : ConsoleColor(0, 7) : EndIf
        CompilerCase #PB_OS_Linux
          If Catfile()\inversed : ADIR_Console_Inverse() : EndIf
        CompilerCase #PB_OS_MacOS
          If Catfile()\inversed : : EndIf
      CompilerEndSelect
  
      Print(a$)
  
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          If Catfile()\inversed : ConsoleColor(7, 0) : EndIf
        CompilerCase #PB_OS_Linux
          If Catfile()\inversed : ADIR_Console_Normal() : EndIf
        CompilerCase #PB_OS_MacOS
          If Catfile()\inversed : : EndIf
      CompilerEndSelect
  
      PrintN(#TB+b$+#TB+c$+#TB+d$+#TB+e$+#TB+f$+#TB+g$+#TB+h$)
    Next
  EndIf
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 774
; FirstLine = 761
; Folding = --
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant