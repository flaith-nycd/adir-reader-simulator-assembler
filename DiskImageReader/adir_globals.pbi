; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***         GLOBALS           ***
; ***                           ***
; *********************************
Global _ADIR_DISK_FORMAT.i   = #True             ; Valid format
Global _ADIR_INVERSE_CHAR.i  = #False            ; If Chars used in CATALOG are inversed
Global _ADIR_VTOC.i          = #False            ; Show/Hide VTOC GUI
Global _ADIR_GUI_QUIT.i      = #False            ; quit GUI
Global _ADIR_FORMAT_EXE.s    = #ADIR_CONSOLE     ; Using GUI or CONSOLE mode (default : CONSOLE)
Global _ADIR_COLOR_CHAR.i    = #COLOR_BW         ; Set color Char
Global _ADIR_VERSION.s       = "?.?.?"+_ADIR_FORMAT_EXE
Global _ADIR_DEBUG.i         = #False
Global _ADIR_EXPORT_FILE.s   = ""                ; Filename of exported file

; DOS3 Globals
Global _DOS3_MAXSECTCATALOG  = 15

; Disk
Global *ImgDskBuffer, *buf_sector

Global *vtoc.TVTOC
Global *catalog.TCATALOG
Global *tslist.TTSLIST

Global *offset.Character                         ; Inside Procedure GetByte : Return one Byte

; Processor
Global *Reg.TREGISTER
Global *PS.c                                     ; Processor Status
Global *MAIN_RAM.CHARACTER, *AUX_RAM.CHARACTER
Global NewList OPCODE.TOPCODE()
Global NewList LABEL.TLABEL()

; LinkedList for files & cat
; Global NewList DumpFile.Character()
Global NewList DumpFile.CHARACTER()
Global NewList Catfile.TCATFILE()

; Array for Basic Tokens
Global Dim ADIR_BASIC_TOKEN.s(#BASIC_TOKEN)
Global Dim ADIR_BASIC_INTEGER_TOKEN.s(#BASIC_INT_TOKEN)

; Array for VTOC
Global Dim TAB_TS.b(#DOS_TRACK,#DOS_SECTOR)

; Variables
Global dump_counter.i        = -#NB_BYTE         ; Shared Value for continious buffer
                                                 ; need to start vith negative value (-16) 
Global SizeOfDisk.i          = 0
Global Tmp_DiskName.s        = ""
Global DiskName.s            = ""
Global DISK_DOS_Version.s    = ""
Global DISK_VOLUME_Number.s  = ""
Global DISK_FREE_DOS_SEC.i   = 0
Global DISK_FREE_DOS_BYTE.f  = 0.0

Global DUMP_VALUE.i          = #DUMP_DISPLAY_ALL
Global DISASM_VALUE.i        = #DUMP_DIS_NORMAL  ; or #DUMP_DIS_DISASM
Global BYTE_ORDERING.i       = #LITTLE_ENDIAN
; IDE Options = PureBasic 4.30 (Linux - x86)
; CursorPosition = 16
; Folding = -
; DisableDebugger
; CompileSourceDirectory