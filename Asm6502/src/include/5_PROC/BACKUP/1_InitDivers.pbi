;-Divers
Procedure DEBUG_LOG(value.s)
  If _DEBUG_VAL = #DEBUGON
    OpenFile(#DEBUG_FILENUM,#DEBUG_NAME)
      FileSeek(#DEBUG_FILENUM, Lof(#DEBUG_FILENUM))
      WriteStringN(#DEBUG_FILENUM,value)
    CloseFile(#DEBUG_FILENUM)
  EndIf

EndProcedure

Procedure Usage()
  PrintN("[ADIR]-6502 Assembler")
  PrintN("Usage: "+#EXEC_NAME+" <OPTION> <file>")
  PrintN("  -h, --help              print this help and exit")
  PrintN("  -c  --opcode            print the mnemonics")
  PrintN("  -t  --token             print the tokens")
  PrintN("  -l  --cleanlist         print a clean list of the source")
  PrintN("  -n  --noerror           Don't show errors")
  PrintN("")
  PrintN("Please send bugs at <flaithotw@gmail.com>.")
  End
EndProcedure

Procedure.s HEXA(value.i, size = #S_BYTE)
  ProcedureReturn RSet(Hex(value),size,"0")
EndProcedure

Procedure GetARGV()
  ASM_HELP = #False

  ARGC = CountProgramParameters()

  If ARGC = 0 : usage() : EndIf
  
  For i = 0 To ARGC - 1
    AddElement(argv())
      ARGV() = ProgramParameter(i)
  Next i
  
  ResetList(ARGV())
  ForEach ARGV()
    If Left(ARGV(),1) = "-"
      Select LCase(ARGV())
        Case "-h","--help"
          ASM_HELP = #True
          Break
        Case "-c","--opcode"
          SHOW_OPCODE = #True
        Case "-t","--token"
          SHOW_TOKEN = #True
        Case "-l","--cleanlist"
          SHOW_CLEAN_LIST = #True
        Case "-n","--noerror"
          SHOW_NO_ERROR = #False
        Default
          PrintN("******")
          PrintN("****** Unknow option '"+ARGV()+"'")
          PrintN("******")
          Usage()
          Break
      EndSelect
    EndIf
  Next

  If ASM_HELP = #True
    Usage()
  EndIf

; i=0
; ForEach ARGV()
;   PrintN("ARGV("+str(i)+") = "+ARGV())
;   i+1
; Next

; ResetList(ARGV())
; SelectElement(ARGV(),0)
  LastElement(ARGV())
  the_file = ARGV()
EndProcedure

Procedure.i OpenSRC(file.s)
Protected fd.i, curtext.s, curline.i

  fd = ReadFile(#FILE_SRC,file)
  If fd
    curline = 1
    While Eof(#FILE_SRC) = 0
      ;curtext = Trim(ReadString(#FILE_SRC))
      curtext = ReadString(#FILE_SRC)
      AddElement(src())
        src()\line = curline
        src()\text = curtext
      curline + 1
    Wend
  Else
    ProcedureReturn -1
  EndIf
	
	CloseFile(#FILE_SRC)
EndProcedure

;-Init
Procedure Init(Mode.i = #DEBUGOFF)
Protected tok.i=0, opc.i = 0

  _DEBUG_VAL = Mode

  Restore dToken
  Read.s token$

  While token$ <> "@@@"
    tToken(tok) = LCase(token$)
    tok + 1
    Read.s token$
  Wend

  Restore dOpcode
  Read.s tmp1$

  While tmp1$ <> "@@@"
    Read.s tmp2$

    AddElement(tOpcode())
      tOpcode()\opc_MNEMONIC    = tmp1$
      tOpcode()\opc_DESCRIPTION = tmp2$

      For i = 0 To #NB_MODE_OPC-1
        Read.i tmp3
        tOpcode()\opc_CODE[i] = tmp3
      Next i

    Read.s tmp1$
  Wend
  
  If _DEBUG_VAL = #DEBUGON
    CreateFile(#DEBUG_FILENUM,#DEBUG_NAME)
      WriteStringN(#DEBUG_FILENUM,"DEBUG LOG--DATE:"+FormatDate(" %dd/%mm/%yyyy at %hh:%ii:%ss", Date()))
      WriteStringN(#DEBUG_FILENUM,"---------------")
      CloseFile(#DEBUG_FILENUM)
  EndIf  
EndProcedure

; IDE Options = PureBasic 4.50 Beta 2 (Windows - x86)
; CursorPosition = 1
; Folding = --
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant