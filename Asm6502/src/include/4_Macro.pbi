;-Macro & Proc by DRI 
;-(http://www.purebasic.fr/french/viewtopic.php?t=4667)
Macro IsUpper(c)
  ((c >= 'A') And (c <= 'Z'))
EndMacro

Macro IsLower(c)
  ((c >= 'a') And (c <= 'z'))
EndMacro

Macro IsAlpha(c)
  (IsUpper(c) Or IsLower(c))
EndMacro

Macro IsAlnum(c)
  (IsAlpha(c) Or IsDigit(c))
EndMacro

Macro IsBinDigit(c)
  ((c >= '0') And (c <= '1'))
EndMacro

Macro IsDeciDigit(c)
  ((c >= '0') And (c <= '9'))
EndMacro

Macro IsHexaDigit(c)
  (IsDeciDigit(c) Or ((c >= 'a') And (c <= 'f')) Or ((c >= 'A') And (c <= 'F')))
EndMacro

Macro IsPunct(c)
  ((c = '"') Or FindString("!#%&'();<=>?[\]*+,-./:^_{|}~", Chr(c), 1))
EndMacro

Macro IsGraph(c)
  (IsAlnum(c) Or IsPunct(c))
EndMacro

Macro IsPrint(c)
  ((c = ' ') Or IsGraph(c))
EndMacro

Macro IsSpace(c)
  ((c = ' ') Or (c = #FF) Or (c = #LF) Or (c = #CR) Or (c = #HT) Or (c = #VT))
EndMacro

Macro IsBlank(c)
  ((c = ' ') Or (c = #TAB))
EndMacro

Macro IsCntrl(c)
  ((c = #BEL) Or (c = #BS))
EndMacro
; IDE Options = PureBasic 4.41 (Windows - x86)
; CursorPosition = 52
; FirstLine = 6
; Folding = ---
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant