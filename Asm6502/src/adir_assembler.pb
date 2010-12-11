EnableExplicit
; Si on veut avoir un debug log on créé cette constante
; sinon il faut la mettre en remarque pour la version release
#__DEBUG__      = 0

IncludePath "include"
XIncludeFile "0_Constant.pbi"
XIncludeFile "1_Data.pbi"
XIncludeFile "2_Structure.pbi"
XIncludeFile "3_Global.pbi"
XIncludeFile "4_Macro.pbi"
XIncludeFile "5_Procedures.pbi"

;- Main
OpenConsole()
ConsoleColor(7,0)

Init()
GetARGV()

;the_file = "..\prg.gs"

pos1 = FindString(input_file,"\",1)
pos2 = FindString(input_file,"/",1)

If pos1 > 0 : input_file_tmp$=Mid(input_file,pos1+1,Len(input_file)-pos1) : EndIf
If pos2 > 0 : input_file_tmp$=Mid(input_file,pos2+1,Len(input_file)-pos2) : EndIf

If OpenSRC(input_file) = -1
  PrintN("File "+#DBL_QUOTE+input_file_tmp$+#DBL_QUOTE+" not found") : End
EndIf

input_file = input_file_tmp$

StartTimeAssembly = ElapsedMilliseconds()

DEBUG_LOG("---Filename to assemble : "+input_file)

DEBUG_LOG("---Call procedure PreProcess()...")
PreProcess()

;check ARGV
DEBUG_LOG("---Check ARGV...")
If SHOW_OPCODE      : PrintOPC_MNEMONIC()   : EndIf
If SHOW_TOKEN       : PrintSRC_TOKEN()      : EndIf
If SHOW_CLEAN_LIST  : PrintSRC_CleanLIST()  : EndIf

;Normal
DEBUG_LOG("---Call procedure Assembly()...")
If Assembly() = 0
  ;No assembly error, so print Symbol Table
  ;   PrintLABEL_CONST()
Else
  If SHOW_NO_ERROR
    ShowError()
  EndIf
EndIf

PrintLABEL_CONST()

DiffTimeAssembly = (EndTimeAssembly-StartTimeAssembly)/1000
Print("Assembling "+Str(ListSize(CleanSRC()))+" lines in "+StrF(DiffTimeAssembly,2))
If DiffTimeAssembly > 1
  PrintN(" seconds")
Else
  PrintN(" second")
EndIf

;Print("Frappez 'Entree'..."):Input()
CloseConsole()
End
; IDE Options = PureBasic 4.50 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 3
; Executable = adir_assembler.exe
; CompileSourceDirectory
; EnableCompileCount = 41
; EnableBuildCount = 41
; EnableExeConstant