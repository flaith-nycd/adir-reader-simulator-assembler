;-----------------------------------------------------------------------
;-6502 VLE (Very Light Emulator)
;-Started.....: 21.12.2010
;-Last update.: 21.01.2011
;-Author......: Nicolas Djurovic (Flaith)
;-TODO........: A lot!
;***********************************************************************
; Enlever cette constante pour ne plus afficher le désassemblage pendant l'execution
;#DISASM_DURING_EXEC         = 0
;-----------------------------------------------------------------------
IncludePath "includes"
IncludeFile "CONSTANT.pbi"
IncludeFile "STRUCTURE.pbi"
IncludeFile "GLOBAL.pbi"
IncludeFile "DECLARE.pbi"
IncludeFile "MACRO.pbi"
IncludeFile "PROC_adrmode.pbi"
IncludeFile "PROC_mnemonic.pbi"
IncludeFile "PROC_callback.pbi"
IncludeFile "PROC_dumpasm.pbi"
IncludeFile "PROC_disasm.pbi"
IncludeFile "PROC_internal.pbi"
IncludeFile "PROC_output.pbi"
IncludeFile "PROC_execute.pbi"
;-<<< MAIN >>>
OpenConsole():EnableGraphicalConsole(#True):NORMAL()
InitCPU(#MODEL_IIE_ENHANCED)
PrintN_OEM("--> A="+Hexa(Registers\A)+" X="+Hexa(Registers\X)+" Y="+Hexa(Registers\Y)+" P="+Hexa(Registers\P\Flag)+" S="+Hexa(Registers\S)+" PC="+hexa(Registers\PC,2))
;BRUN("TESTASM_01.BIN")

;EnterASM($0300,"2058fc60") ;efface ecran

; EnterASM($0300,"A9718536A9A98537A9C120EDFD60") ;FDED affiche le caractère dans l'accumulateur
; EnterASM($0300,"A9C120EDFD60") ;FDED affiche le caractère dans l'accumulateur

EnterASM($03D0,"4CBF9D4C849D")
EnterASM($03F2,"BF9D384C58FF")
EnterASM($03F8,"4C65FF4C65FF65FF")
EnterASM($0300,"A9718536A9A98537A200BD170320EDFDE8E006D0F56000C3CfD5C3CfD5") ; affiche un texte
AddCallBack("FDED",COUT)
PrintN_OEM("Résultat du COUT : ")
CALL($0300)
NORMAL():PrintN(""):PrintN_OEM("Temps écoulé : "+StrF((EndRun - StartRun) / 1000, 2)+" secondes")
RemoveCallBack("FDED")
PrintN("")
CompilerIf Defined(DISASM_DURING_EXEC, #PB_Constant) = #False
  Print_OEM("--> A="+Hexa(Registers\A)+" X="+Hexa(Registers\X)+" Y="+Hexa(Registers\Y)+" P="+Hexa(Registers\P\Flag)+" S="+Hexa(Registers\S)+" PC="+hexa(Registers\PC,2)+" | ") : PrintRegister()
  PrintN("")  
CompilerEndIf
PrintN_OEM("Dump de $0300 à $031C")
Dump_MEMORY($0300, $031C)
PrintN("")
PrintN_OEM("Désassemblage de $0300 à $031C")
Disasm_MEMORY($0300, $031C)
PrintN_OEM("Désassemblage de $FC58 à $FCEB")
Dump_MEMORY($FC58, $FCEB, 16)
Disasm_MEMORY($FC58, $FCEB)

EnterASM($0300,"a2778a38e901d0fb2c30c0cad0f460")
AddCallBack("C030",SPKR)
PrintN_OEM("Résultat du $C030 : ")
CALL($0300)
NORMAL():PrintN(""):PrintN_OEM("Temps écoulé : "+StrF((EndRun - StartRun) / 1000, 2)+" secondes")
RemoveCallBack("C030")
Dump_MEMORY($0300, $030E)
Disasm_MEMORY($0300, $030E)

PrintN("")

EnterASM($0300,"2060fb60") ;$FB60 affiche 'Apple //e' en haut de l'écran. (avec Modèle IIE_ENHANCED)
PrintN_OEM("Résultat du $FB60 affiche 'Apple //e' en haut de l'écran. (avec Modèle IIE_ENHANCED) : ")
Disasm_MEMORY($0300, $0303)
CALL($0300)
NORMAL():PrintN(""):PrintN_OEM("Temps écoulé : "+StrF((EndRun - StartRun) / 1000, 2)+" secondes")

Dump_MEMORY($0400, $41F, 16)
PrintN("")


Print_OEM("Frappez 'Entrée'"):Input()
CloseConsole()

; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 70
; FirstLine = 17
; Executable = ..\6502_Exe_#0.18.exe
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 681
; EnableBuildCount = 8
; EnableExeConstant