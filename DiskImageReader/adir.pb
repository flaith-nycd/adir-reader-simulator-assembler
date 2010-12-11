; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***                           ***
; ***      Console Version      ***
; ***                           ***
; *********************************
#COMPILER_CONSOLE   = #True

XIncludeFile "adir_constants.pbi"
XIncludeFile "adir_structures.pbi"
XIncludeFile "adir_globals.pbi"
XIncludeFile "adir_procedures.pbi"
XIncludeFile "adir_dos3.pbi"
XIncludeFile "adir_vtoc.pbi"
XIncludeFile "adir_datasection.pbi"

Structure TARGV
  type.i
  value.s
EndStructure

Global NewList ARGV.s()
Global ARGC.i

Global ADIR_CATALOG.i, ADIR_VTOC.i, ADIR_SHOW.i, ADIR_EXTRACT.i, ADIR_DISASM.i
Global the_dsk.s, the_file.s
Global FOUND.i = #False

;- Procedures
Procedure Usage()
  PrintN("[A]pple [D]isk [I]mage [R]eader ver#"+_ADIR_VERSION)
  PrintN("Usage: adir DISKIMAGE [OPTION] [FILE]")
  PrintN("  without OPTION          Display free space & free bytes")
  PrintN("  -h, --help              print this help and exit")
  PrintN("  -c, --catalog           show CATALOG")
  PrintN("  -v, --vtoc              show VTOC")
  PrintN("  -a, --all               show CATALOG & VTOC")
  PrintN("  -e, --extract           extract FILE")
  PrintN("  -d, --disasm            disassemble FILE")
;   PrintN("  -0, --raw-f0            extract FILE in raw format 0")
;   PrintN("  -1, --raw-f1            extract FILE in raw format 1")
;   PrintN("  -2, --raw-f2            extract FILE in raw format 2")
;   PrintN("")
;   PrintN("Format0: <ADRESS>:<16 x HEX> - <16 x ASC>")
;   PrintN("Format1: <ADRESS>:<16 x HEX>")
;   PrintN("Format2: <ADRESS>:<16 x ASC>")
  PrintN("")
  PrintN("If FILE contains spaces, you must add quotes :")
  PrintN("adir ../dsk/adir_nycd.dsk -e "+#QUOTE+"test sound"+#QUOTE)
  PrintN("")
  PrintN("Please send bugs at <flaith@gmail.com>.")
  End
EndProcedure

; ****************
; ***          ***
; ***   MAIN   ***
; ***          ***
; ****************
_ADIR_DEBUG = #True
Init_ADIR(#ADIR_CONSOLE)
Init_6502(#CPU_6502_OPCODE)

ADIR_HELP    = #False
ADIR_CATALOG = #False
ADIR_VTOC    = #False
ADIR_ALL     = #False
ADIR_EXTRACT = #False
ADIR_DISASM  = #False

ARGC = CountProgramParameters()
totproc = 0

If ARGC = 0 : usage() : EndIf

For i = 0 To ARGC - 1
  AddElement(argv())
    ARGV() = ProgramParameter(i)
Next i

ResetList(ARGV())
i = 0
ForEach ARGV()
  If Left(ARGV(),1) = "-"
    Select LCase(ARGV())
      Case "-h","--help"
        ADIR_HELP = #True
        Break
      Case "-c","--catalog"
        ADIR_CATALOG = #True
        Break
      Case "-v","--vtoc"
        ADIR_VTOC    = #True
        Break
      Case "-a","--all"
        ADIR_ALL     = #True
        Break
      Case "-e","--extract"
        ADIR_EXTRACT = #True
      Case "-d","--disasm"
        ADIR_DISASM = #True
      Default
        PrintN("Unknow option")
        Usage()
    EndSelect
  EndIf
  i+1
Next

If ADIR_HELP = #True
  Usage()
EndIf

ResetList(ARGV())
SelectElement(ARGV(),0)
the_dsk = ARGV()
OpenDSK(the_dsk)

  *offset = AllocateMemory(SizeOf(Character))
  PrintN("[A]pple [D]isk [I]mage [R]eader ver#"+_ADIR_VERSION)
  
  If GetByte($11,$00,$03) <> 3 
    PrintN(" => !!! Not a valid dos diskette !!!"):PrintN("")
    _ADIR_DISK_FORMAT = #False
    End
  Else
    _ADIR_DISK_FORMAT = #True
    PrintN("")
  EndIf
  
  ReadVTOC($11,$00):CATALOG(*vtoc\track,*vtoc\sector)

  If ADIR_VTOC = #True
    GUI_VTOC()
    PrintN("")
    Get_Free_space()
  EndIf

  If ADIR_CATALOG = #True
    DRAW_CATALOG()
    PrintN("")
    Get_Free_space()
  EndIf

  If ADIR_ALL = #True
    GUI_VTOC()
    DRAW_CATALOG()
    PrintN("")
    Get_Free_space()
  EndIf

  If ADIR_DISASM = #True
    ADIR_EXTRACT = #True
    Set_DISASM(#DUMP_DIS_DISASM)
  EndIf

  If ADIR_EXTRACT = #True
    i = 0 : FOUND = #False
    If SelectElement(ARGV(),2)
      the_file = UCase(ARGV())
      ForEach Catfile()
        a$ = Trim(catfile()\filename)
        If a$ = the_file
          FOUND = #True
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
          Get_Free_space()
          showfile(i)
          PrintN("")
          PrintN("-----------------------------------------------------------------------")
          
          If ReadFile(#NUM_READFILE,_ADIR_EXPORT_FILE)
            While Eof(#NUM_READFILE) = 0
              PrintN(ReadString(#NUM_READFILE))
            Wend
            CloseFile(#NUM_READFILE)
          EndIf

          PrintN("-----------------------------------------------------------------------")
          PrintN("File exported as : "+#QUOTE+_ADIR_EXPORT_FILE+#QUOTE)
;           Print("Type: "+typ$+" - ")
          PrintN("ORG: $"+HEXA(Catfile()\org,#S_WORD)+"("+Str(Catfile()\org)+") - LEN: $"+HEXA(Catfile()\length,#S_WORD)+"("+Str(Catfile()\length)+")")
          PrintN("-----------------------------------------------------------------------")
          Break
        EndIf
        i + 1
      Next
      If FOUND = #False
        PrintN("Err: *** File to extract: "+#QUOTE+the_file+#QUOTE+" Not Found !!!"):PrintN("")
        End
      EndIf
    Else
      PrintN("Err: *** Need a FILE to extract !!!"):PrintN("")
      End
    EndIf
  EndIf

  If ADIR_VTOC = #False And ADIR_CATALOG = #False And ADIR_ALL = #False And ADIR_EXTRACT = #False
    Get_Free_space()
  EndIf

CloseConsole()
; IDE Options = PureBasic 4.30 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 62
; FirstLine = 43
; Folding = -
; Executable = adir
; DisableDebugger
; CompileSourceDirectory