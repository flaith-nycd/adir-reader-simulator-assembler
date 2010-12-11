; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***         GUI VTOC          ***
; ***                           ***
; *********************************
Procedure GUI_VTOC()
Static ADIR_VTOC

  If _ADIR_FORMAT_EXE = #ADIR_GUI
    Select ADIR_VTOC
      Case #False
        ResizeWindow(#MAIN_WIN_ADIR, 420, 190, 600, 700)
        SetGadgetText(#Button_VTOC,"Hide VTOC")
      Case #True
        ResizeWindow(#MAIN_WIN_ADIR, 420, 190, 600, 400)
        SetGadgetText(#Button_VTOC,"Show VTOC")
    EndSelect
    ADIR_VTOC = 1 - ADIR_VTOC
    StartDrawing(ImageOutput(#IMG_VTOC))
      ;1 char = 14 x 16
      DrawImage(ImageID(#IMG_LABEL_TRACK),#IMG_VTOC_W*2,0)
      DrawImage(ImageID(#IMG_LABEL_SECTOR),0,#IMG_VTOC_H*2)
      For sector = 0 To #DOS_SECTOR-1
        For track = 0 To #DOS_TRACK-1
          If TAB_TS(track,sector) = 1
            used + 1
            DrawImage(ImageID(#IMG_VTOC_USED),(#IMG_VTOC_W*2)+track*#IMG_VTOC_W,(#IMG_VTOC_H*2)+sector*#IMG_VTOC_H)
          Else
            DrawImage(ImageID(#IMG_VTOC_NOT_USED),(#IMG_VTOC_W*2)+track*#IMG_VTOC_W,(#IMG_VTOC_H*2)+sector*#IMG_VTOC_H)  
            free + 1
          EndIf
        Next track
      Next sector

      ForEach Catfile()
        track  = catfile()\llist\track
        sector = catfile()\llist\sector
        DrawImage(ImageID(#IMG_VTOC_TS_LIST),(#IMG_VTOC_W*2)+track*#IMG_VTOC_W,(#IMG_VTOC_H*2)+sector*#IMG_VTOC_H)
      Next

    StopDrawing()
  Else
    used = 0 : free = 0
    PrintN("")
    PrintN("  00000000000000001111111111111111222")
    PrintN("  0123456789ABCDEF0123456789ABCDEF012")
    For sector = 0 To #DOS_SECTOR-1
      Print(RSet(Hex(sector),2,"0"))
      For track = 0 To #DOS_TRACK-1
        If TAB_TS(track,sector) = 1
          used + 1
  
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              ConsoleColor(0, 7)
            CompilerCase #PB_OS_Linux
              ADIR_Console_Inverse()
            CompilerCase #PB_OS_MacOS
          CompilerEndSelect

          Print("_")

          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              ConsoleColor(7, 0)
            CompilerCase #PB_OS_Linux
              ADIR_Console_Normal()
            CompilerCase #PB_OS_MacOS
          CompilerEndSelect

          Else
            free + 1
            Print(" ")
          EndIf
      Next track
      PrintN("")
    Next sector
    PrintN("# Sector used = "+Str(used)+" - # Sector free = "+Str(free))
    PrintN("")
  EndIf
EndProcedure

; Reading Volume Table Of Contents
Procedure ReadVTOC(track.l,sector.l)
Protected Position_TS.l

If *ImgDskBuffer
  *vtoc = AllocateMemory(#SizeOfSector)
  Position_TS = (track * 256 * 16) + (sector * 256)

  If Position_TS < SizeOfDisk
    CopyMemory(*ImgDskBuffer+Position_TS,*vtoc,#SizeOfSector)
  
;     PrintN("VTOC Structure size................................: $"+Hex(SizeOf(TVTOC)))
;     PrintN("")
;     PrintN("Track Number of First Catalog sector...............: $"+RSet(Hex(*vtoc\track),2,"0"))
;     PrintN("Sector Number of First Catalog sector..............: $"+RSet(Hex(*vtoc\sector),2,"0"))
; 
;     If *vtoc\dos = #DOS32 And *vtoc\num_sector_t = 13 : DOS_Version = "DOS 3.2" : EndIf
;     If *vtoc\dos = #DOS33 And *vtoc\num_sector_t = 16 : DOS_Version = "DOS 3.3" : EndIf
; 
;     PrintN("Release number of DOS used to init this diskette...: "+DOS_Version)
;     PrintN("Diskette volume number (1-254).....................: "+RSet(Str(*vtoc\volume),3,"0"))
;     PrintN("")

;     For i = 0 To 31
;       PrintN("              "+RSet(Hex(07+i),2,"0")+"-"+RSet(Hex($08+i),2,"0")+" - Not used.....................: $"+RSet(Hex(*vtoc\N2\NOT_USED[i]),2,"0"))
;     Next i

;     PrintN("Number of tracks per diskette (normally 35)........: "+RSet(Str(*vtoc\num_track_d),2,"0"))
;     PrintN("Number of sectors per track (13 or 16).............: "+RSet(Str(*vtoc\num_sector_t),2,"0"))
;     PrintN("")
;     PrintN("Number of bytes per sector (LO/HI format)..........: "+Str(*vtoc\num_byte_sec))
;     PrintN("Maximum number of track/sector pairs which")
;     PrintN("will fit in one file track/sector list sector")
;     PrintN("(122 for 256 byte sectors).........................: "+Str(*vtoc\maxnumts))
;     PrintN("")
;     PrintN("Last track where sectors were allocated............: $"+RSet(Hex(*vtoc\last_track),2,"0"))
;     dir$ = "+1"
;     If *vtoc\dir_track = $FF : dir$ = "-1" : EndIf
;     PrintN("Direction of track allocation (+1 or -1)...........: "+dir$)

; *******************************
; * Calc number of free sectors *
; *******************************
;
;BYTE   SECTORS
;       (BIT)
;       7654 3210
;
;+0     FDEC BA98
;+1     7654 3210
;+2     .... ....   (not used)
;+3     .... ....   (not used)
;
;exemple:
;Si les secteurs E et 8 sont libres et tous les autres alloués,
;le BITMAP sera donc :
;   41 00 .. ..
;
;Si tous les secteurs sont libres,
;le BITMAP sera donc :
;   FF FF .. ..

    DEBUG_LOG("---[ PROC ReadVTOC() - Disk: "+#QUOTE+DiskName+#QUOTE+" - Size : "+Str(SizeOfDisk))

    DEBUG_LOG("> Reading VTOC($"+HEXA(track)+",$"+HEXA(sector)+")")
    DEBUG_LOG("> 1st CATALOG TS                              : $"+HEXA(*vtoc\track)+",$"+HEXA(*vtoc\sector))

    DEBUG_LOG("> Last track where sectors were allocated     : $"+HEXA(*vtoc\last_track))
    DEBUG_LOG("> Direction of track allocation (+1 or -1)    : $"+HEXA(*vtoc\dir_track))
    DEBUG_LOG("> Number of tracks per diskette (normally 35) : "+Str(*vtoc\num_track_d))
    DEBUG_LOG("> Number of sectors per track (13 or 16)      : "+Str(*vtoc\num_sector_t))
    DEBUG_LOG("> Number of bytes per sector (LO/HI format)   : $"+HEXA(*vtoc\num_byte_sec,#S_WORD))

    If *vtoc\dos = #DOS32 And *vtoc\num_sector_t = 13 : DISK_DOS_Version = "DOS 3.2" : EndIf
    If *vtoc\dos = #DOS33 And *vtoc\num_sector_t = 16 : DISK_DOS_Version = "DOS 3.3" : EndIf

    DISK_VOLUME_Number = RSet(Str(*vtoc\volume),3,"0")

    DEBUG_LOG("> DISK VOLUME                                 : "+DISK_VOLUME_Number)

    free_byte.l = 0 : nb_sec.l = 0 : taille_sector = *vtoc\num_byte_sec
    
    For bmt = 0 To #DOS_TRACK-1                  ; 35 tracks
      B0_TRK = *vtoc\BMT[bmt]\Byte0
      B1_TRK = *vtoc\BMT[bmt]\Byte1
      ;B2_TRK = *vtoc\BMT[bmt]\Byte2                 ; not used
      ;B3_TRK = *vtoc\BMT[bmt]\Byte3                 ; not used

;       If bmt % 4 = 0 : PrintN("") : EndIf           ; Saut de ligne tous les "4"

      ;Affiche le BITMAP utilisé
;       Print(RSet(Hex(B0_TRK),2,"0")+" "+RSet(Hex(B1_TRK),2,"0")+" .. .. ")

      For i = 0 To 7                             ; 8Bits
        bit_byte_0 = (B0_TRK >> i) & 1
        bit_byte_1 = (B1_TRK >> i) & 1

        TAB_TS(bmt,8+i) = 1
        TAB_TS(bmt,i) = 1

        If bit_byte_0 = 1 : free_byte + taille_sector : TAB_TS(bmt,8+i) = 0 : nb_free_sec + 1 : EndIf
        If bit_byte_1 = 1 : free_byte + taille_sector : TAB_TS(bmt,i) = 0 : nb_free_sec + 1 : EndIf
      Next i

    Next bmt

    DISK_FREE_DOS_SEC  = nb_free_sec
    DISK_FREE_DOS_BYTE = free_byte/1024

    DEBUG_LOG("---] ENDPROC ReadVTOC()")

  Else
    ADIR_Error("READVTOC: $"+HEXA(track)+"/$"+HEXA(sector),#ERR_INVALID_TS)
  EndIf
EndIf

EndProcedure

Procedure Get_Free_space()
  If _ADIR_FORMAT_EXE = #ADIR_CONSOLE

    DEBUG_LOG("---[ PROC Get_Free_space()")

    PrintN("Disk: "+#QUOTE+DiskName+#QUOTE+" - Size: "+Str(SizeOfDisk)+" Bytes")
    PrintN("")
    PrintN("Free space.........................................: "+Str(DISK_FREE_DOS_SEC)+" sectors")
    PrintN("Free bytes.........................................: "+StrF(DISK_FREE_DOS_BYTE,2)+" Kb")

    DEBUG_LOG("---] ENDPROC Get_Free_space()")

  EndIf
EndProcedure
; IDE Options = PureBasic 4.30 (MacOS X - x86)
; CursorPosition = 69
; FirstLine = 51
; Folding = -
; DisableDebugger
; CompileSourceDirectory