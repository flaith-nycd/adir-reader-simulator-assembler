; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***        STRUCTURES         ***
; ***                           ***
; *********************************
;-Structure TPROCESSOR
Structure TPROCESSOR
  N.c                                   ; Bit 7 - Negative (sign)
  V.c                                   ; Bit 6 - Overflow
  R.c                                   ; Bit 5 - Not used (Reserved always 1)
  B.c                                   ; Bit 4 - Break command
  D.c                                   ; Bit 3 - Decimal mode
  I.c                                   ; Bit 2 - Interrupt disable
  Z.c                                   ; Bit 1 - Zero
  C.c                                   ; Bit 0 - Carry
EndStructure

;-Structure TREGISTER
Structure TREGISTER
  A.c                                   ; 8Bits  - Accumulator
  X.c                                   ; Index register X
  Y.c                                   ; Index register Y
  PC.i                                  ; 16bits - Program Counter (PCH - PCL)
  SP.c                                  ; Stack pointer
  PS.TPROCESSOR                         ; Processor Status
EndStructure

;-Structure TCYCLE
Structure TCYCLE
  _opc_CODE.i                           ; Opcode (same in Structure TOPCODE : opc_CODE[])
  _opc_MODE.i                           ; #IMM,#ZP,#ZPX,#ABS,#ABSX,#ABSY,#INDX,#INDY,#ACC or #BRA
  _opc_LEN.i                            ; Length
  _opc_CYCLE.i                          ; Nb cycle
  _opc_EXTRA_CYCLE.i                    ; Extra Cycle (add 1 cycle if page boundary crossed)
EndStructure

;-Structure TOPCODE
Structure TOPCODE
  opc_MNEMONIC.s                        ; Mnemonic
  opc_DESCRIPTION.s                     ; Description of the Mnemonic
  opc_FLAGS.i                           ; Flags affected
  opc_CODE.TCYCLE[#NB_MODE_OPC]         ; List of different OpCode
EndStructure

;-Structure TLABEL
Structure TLABEL
  code.i
  text.s
  line1.s
  line2.s
  line3.s
  line4.s
EndStructure

Structure TNOTUSED
  NOT_USED.c
EndStructure

Structure TNOTUSED_2
  NOT_USED.c[2]
EndStructure

Structure TNOTUSED_5
  NOT_USED.c[5]
EndStructure

Structure TNOTUSED_8
  NOT_USED.c[8]
EndStructure

Structure TNOTUSED_32
  NOT_USED.c[32]
EndStructure

Structure TBITMAP
  Byte0.c
  Byte1.c
  Byte2.c               ;not used
  Byte3.c               ;not used
EndStructure

;-Volume Table Of Content (VTOC) format
Structure TVTOC
                        ;BYTE
  N0.TNOTUSED           ;00             - Not used
  track.c               ;01             - Track Number of First Catalog sector
  sector.c              ;02             - Sector Number of First Catalog sector
  dos.c                 ;03             - Release number of DOS used to init this diskette
  N1.TNOTUSED_2         ;04-05          - Not used
  volume.c              ;06             - Diskette volume number (1-254)
  N2.TNOTUSED_32        ;07-26          - Not used
  maxnumts.c            ;27             - Maximum number of track/sector pairs which will fit
                        ;                 in one file track/sector list sector (122 for 256
                        ;                 byte sectors)
  N3.TNOTUSED_8         ;28-2F          - Not used
  last_track.c          ;30             - Last track where sectors were allocated
  dir_track.c           ;31             - Direction of track allocation (+1 or -1)
  N4.TNOTUSED_2         ;32-33          - Not used
  num_track_d.c         ;34             - Number of tracks per diskette (normally 35)
  num_sector_t.c        ;35             - Number of sectors per track (13 or 16)
  num_byte_sec.w        ;36-37          - Number of bytes per sector (LO/HI format)

  BMT.TBITMAP[35]       ;38-3B          - Bit Map of free sectors in track 0
                        ;3C-3F          - Bit Map of free sectors in track 1
                        ;40-43          - Bit Map of free sectors in track 2
                        ;44-47          - Bit Map of free sectors in track 3
                        ;48-4B          - Bit Map of free sectors in track 4
                        ;4C-4F          - Bit Map of free sectors in track 5
                        ;50-53          - Bit Map of free sectors in track 6
                        ;54-57          - Bit Map of free sectors in track 7
                        ;58-5B          - Bit Map of free sectors in track 8
                        ;5C-5F          - Bit Map of free sectors in track 9
                        ;60-63          - Bit Map of free sectors in track 10
                        ;64-67          - Bit Map of free sectors in track 11
                        ;68-6B          - Bit Map of free sectors in track 12
                        ;6C-6F          - Bit Map of free sectors in track 13
                        ;70-73          - Bit Map of free sectors in track 14
                        ;74-77          - Bit Map of free sectors in track 15
                        ;78-7B          - Bit Map of free sectors in track 16
                        ;7C-7F          - Bit Map of free sectors in track 17
                        ;80-83          - Bit Map of free sectors in track 18
                        ;84-87          - Bit Map of free sectors in track 19
                        ;88-8B          - Bit Map of free sectors in track 20
                        ;8C-8F          - Bit Map of free sectors in track 21
                        ;90-93          - Bit Map of free sectors in track 22
                        ;94-97          - Bit Map of free sectors in track 23
                        ;98-9B          - Bit Map of free sectors in track 24
                        ;9C-9F          - Bit Map of free sectors in track 25
                        ;A0-A3          - Bit Map of free sectors in track 26
                        ;A4-A7          - Bit Map of free sectors in track 27
                        ;A8-AB          - Bit Map of free sectors in track 28
                        ;AC-AF          - Bit Map of free sectors in track 29
                        ;B0-B3          - Bit Map of free sectors in track 30
                        ;B4-B7          - Bit Map of free sectors in track 31
                        ;B8-BB          - Bit Map of free sectors in track 32
                        ;BC-BF          - Bit Map of free sectors in track 33
                        ;C0-C3          - Bit Map of free sectors in track 34
  BMT35.TBITMAP[15]     ;C4-FF          - Bit Map for additionnal tracks if there are more
                        ;                 than 35 tracks per diskette
EndStructure

;-File Descriptive Entry format
Structure TFDE
                        ;BYTE
  track_file.c          ;00             - Track of first track/sector list sector
                        ;                 if this is a deleted file, the byte contains a hex
                        ;                 $FF and the original track number is copied to the
                        ;                 last byte of the file name field (Byte $20)
                        ;                 If this byte contains a hex $00, the entry is assumed
                        ;                 to never have been used and is available for use.
                        ;                 (This means track $00 can never be used for data even
                        ;                 if the DOS image is "wiped" from the diskette.)
  sector_file.c         ;01             - Sector of first track/sector list sector
  type_file.c           ;02             - File Type and Flag :
                        ;                     hex 80 + file type  -> file is locked
                        ;                         00 + file type  -> file is not locked
                        ;                         00 -> TEXT file
                        ;                         01 -> INTEGER BASIC file
                        ;                         02 -> APPLESOFT BASIC file
                        ;                         04 -> BINARY file
                        ;                         08 -> S type file
                        ;                         10 -> RELOCATABLE object module file
                        ;                         20 -> A type file
                        ;                         40 -> B type file
                        ;                     (thus, 84 is a locked BINARY file , and 90 is a
                        ;                     locked R type file)
  filename.c[30]        ;03-20          - File name (30 characters)
  file_len.w            ;21-22          - Length of file in sectors (LO/HI format).
                        ;                 The CATALOG command will only format the LO byte of
                        ;                 this length giving 1-255 but a full 65535 may be
                        ;                 stored here.
EndStructure

;-Catalog Sector Format
Structure TCATALOG
  N0.TNOTUSED           ;00             - Not used
  next_track.c          ;01             - Track number of next catalog sector (usually $11)
  next_sector.c         ;02             - Sector number of next catalog sector
  N1.TNOTUSED_8         ;03-0A          - Not used
  fde.TFDE[7]           ;0B-2D          - First File Description Entry
                        ;2E-50          - Second File Description Entry
                        ;51-73          - Third File Description Entry
                        ;74-96          - Fourth File Description Entry
                        ;97-B9          - Fifth File Description Entry
                        ;BA-DC          - Sixth File Description Entry
                        ;DD-FF          - Seventh File Description Entry
EndStructure

;-Track/Sector List
Structure TTS
  track.c
  sector.c
EndStructure

Structure TTSLIST
  N0.TNOTUSED           ;00             - Not used
  next_t_list.c         ;01             - Track number of next T/S List sector if one was
                        ;                 needed or zero if no more T/S List sectors.
  next_s_list.c         ;02             - Sector number of next T/S List sector (if present).
  N1.TNOTUSED_2         ;03-04          - Not used
  sector_offset.w       ;05-06          - Sector offset in file of the first sector described
                        ;                 by this list.
  N2.TNOTUSED_5         ;07-0B          - not used
  ts_data.TTS[122]      ;0C-0D          - Track and sector of first data sector or zeros
                        ;0E-0F          - Track and sector of second data sector or zeros
                        ;10-FF          - Up to 120 more Track/Sector pairs
EndStructure

;-Structure TCATFILE
Structure TCATFILE
  filename.s
  type.i
  block_used.i
  LList.TTS
  locked.i
  deleted.i
  org.i                 ; for Binary Files only (Applesoft = $0801)
  length.i              ; for Integer, AppleSoft and Binary Files
  damaged.i             ; #true is file damaged (show example in Disk AZTEC)
  inversed.i
EndStructure
; IDE Options = PureBasic 4.30 (Linux - x86)
; CursorPosition = 6
; Folding = -
; CompileSourceDirectory