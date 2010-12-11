; *********************************
; ***                           ***
;-***  APPLE DISK IMAGE READER  ***
; ***        Constants          ***
; ***                           ***
; *********************************
;- Version
#ADIR_PUBLIC_VER      = "0"
#ADIR_FONCTION_ADDED  = "18"
#ADIR_UPDATED         = "1"

#ADIR_CONSOLE         = "C"
#ADIR_GUI             = "G"

;- Divers
#TB                   = Chr(9)
#SEP_LIST             = Chr(10)
#QUOTE                = Chr(34)
#NUM_READFILE         = 98

; For Debug
#DEBUG_FILENUM        = 99
#DEBUG_NAME           = "$ADIR_DEBUG.LOG$"

; *********************************
; ***                           ***
; ***      CPU + APPLESOFT      ***
; ***          Include          ***
; ***                           ***
; *********************************
;----CPU & APPLESOFT Include
#BIG____ENDIAN      = 0
#LITTLE_ENDIAN      = 1

;-> Kind of 6502 CPU stuff to init
#CPU_6502_OPCODE    = %00000001
#CPU_6502_CPU       = %00000010
#CPU_6502_ROM       = %00000100
#CPU_6502_REGISTER  = %00001000
#CPU_6502_ALL       = #CPU_6502_OPCODE | #CPU_6502_CPU | #CPU_6502_ROM | #CPU_6502_REGISTER

;-> Type of dumping
#DUMP_DISPLAY_HEX   = %00000001
#DUMP_DISPLAY_ASC   = %00000010
#DUMP_DISPLAY_ALL   = #DUMP_DISPLAY_HEX | #DUMP_DISPLAY_ASC

#DUMP_DIS_NORMAL    = %00000100
#DUMP_DIS_DISASM    = %00001000

;
#FLAG_0             = %00000000                  ; No flags
#FLAG_N             = %10000000                  ; Negative (sign)
#FLAG_V             = %01000000                  ; Overflow
#FLAG_R             = %00100000                  ; Not used (Reserved)
#FLAG_B             = %00010000                  ; Break command
#FLAG_D             = %00001000                  ; Decimal mode
#FLAG_I             = %00000100                  ; Interrupt disable
#FLAG_Z             = %00000010                  ; Zero
#FLAG_C             = %00000001                  ; Carry

#S_BYTE             = 2
#S_WORD             = 4
#S_LONG             = 8

#RAM_64K            = $FFFF

#STACK              = $0100
#MAX_STACK          = $FF

; Num of mode for each opcode
#NB_MODE_OPC        = 13

#BASIC_TOKEN        = 107                        ; NB TOKEN BASIC APPLESOFT
#BASIC_INT_TOKEN    = 127                        ; NB TOKEN INEGER BASIC APPLESOFT
#FILE_ROM           = 80
#SIZE_ROM_2E        = $4000                      ; 16384
#ROMFILE_2E         = "Apple2e_Enhanced.rom"

Enumeration
; See #NB_MODE_OPC
  #IMM                                           ; Immediate
  #ZP                                            ; Zero Page
  #ZPX                                           ; Zero Page X
  #ZPY                                           ; Zero Page Y
  #ABS                                           ; Absolute
  #ABSX                                          ; Absolute X
  #ABSY                                          ; Absolute Y
  #IND                                           ; Indirect
  #INDX                                          ; Indirect X
  #INDY                                          ; Indirect Y
  #ACC                                           ; Accumulator
  #IMPL                                          ; Implied Mode
  #REL                                           ; Relative Mode
EndEnumeration

Enumeration 
  #GET_OPCODE
  #GET_MODE
EndEnumeration

; *********************************
; ***                           ***
; ***   CATALOG FILES Include   ***
; ***                           ***
; *********************************
;----CATALOG FILES Include
#FileDsk              = 9
#SizeOfSector         = $100                     ; Size of one DOS sector
#LINE_8               = 8                        ; Line numbers length print   (Dump)
#NB_BYTE              = 16                       ; #Num bytes per line         (Dump)

;-> DOS Version
#DOS32                = 2
#DOS33                = 3

;-> TRACK-SECTOR SIZE
#DOS_TRACK            = 35
#DOS_SECTOR           = 16

;-> CATALOG
#NB_FDE               = 6                        ; Nb File Description Entry by sector

;-> Different File type
#FILE_TEXT            = $00
#FILE_INTEGER         = $01
#FILE_BASIC           = $02
#FILE_BINARY          = $04
#FILE_TYPE_S          = $08
#FILE_RELOC           = $10
#FILE_TYPE_A          = $20
#FILE_TYPE_B          = $40

#FILE_DELETED         = $FF
#FILE_LOCKED          = $80

; *********************************
; ***                           ***
; ***          GADGETS          ***
; ***                           ***
; *********************************
;---- Win & Button GADGET
;-> VTOC Button
#Enable               = 0
#Disable              = 1
#Pressed              = 1

Enumeration
  #MAIN_WIN_ADIR
  #VIEWFILE_WIN_ADIR
  #MAIN_WIN_PROCESSING
EndEnumeration

; Main Window
Enumeration
  #CATALOG
  #TEXT_DISK
  #Button_OPEN
  #Button_VTOC
  #Button_QUIT
  #IMG_GADGET

; Open file Window
  #Editor_FILE
  #Button_SAVE
  #Button_CLOSE
  #Container_VIEWFILE
  #Option_ASCII
  #Option_HEX
  #Option_BASIC
  #Option_DISASM

  #WIN_LABEL_PROCESS
EndEnumeration

;-> ERRORS
#MIN_LEVEL            = 0
#MAX_LEVEL            = 1

Enumeration 101
  #ERR_ADD_LIST                                  ; Cannot add more lines in list gadget
  #ERR_CREATE_IMG
  #ERR_GRAB_IMG
EndEnumeration

Enumeration 501
  #ERR_ALLOC_MEM                                 ; Memory Allocation Error
  #ERR_FILE_NOT_FOUND                            ; File Not Found
  #ERR_INVALID_TS                                ; Invalid Track or Sector
  #ERR_INVALID_TSO                               ; Invalid Track or Sector or Offset
  #ERR_DAMAGED_FILE                              ; Damaged File
  #ERR_LENGTH_FILE                               ; Empty File
EndEnumeration

;-> VTOC & CHAR IMAGE
Enumeration
  #IMG_VTOC
  #IMG_VTOC_USED
  #IMG_VTOC_NOT_USED
  #IMG_VTOC_TS_LIST
  #IMG_LABEL_TRACK
  #IMG_LABEL_SECTOR

;-> CHAR CATALOG IMAGE
  #IMG_CHAR_40
  #IMG_CHAR_80
  #IMG_CHAR_TMP

;-> ICON BUTTON IMAGE
  #IMG_BUTTON_DISK
  #IMG_BUTTON_VTOC
  #IMG_BUTTON_QUIT
EndEnumeration

;-> VTOC
#IMG_VTOC_W           = 14
#IMG_VTOC_H           = 16
#IMG_VTOC_WIDTH       = (2+35)*#IMG_VTOC_W       ; Add Height & Width for display of 
#IMG_VTOC_HEIGHT      = (2+16)*#IMG_VTOC_H       ; text tracks & sectors

;-> CHAR
#COL_4080             = 1                        ; (1:40 col - 2:80 col)

#COLOR_BW             = 1                        ; (1:B&W - 2:GREEN)
#COLOR_GREEN          = 2
#COLOR_REAL_GREEN     = 3
#COLOR_AMBRE          = 4

#CHAR_WIDTH           = 14
#CHAR_HEIGHT          = 16

#CHAR_W               = #CHAR_WIDTH/#COL_4080
#CHAR_H               = #CHAR_HEIGHT

#SCR_W                = 40*#COL_4080

#CHAR_NORMAL          = $00
#CHAR_INVERSE         = $01
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 39
; FirstLine = 33
; Folding = -
; DisableDebugger
; CompileSourceDirectory