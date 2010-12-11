;-Tokenizer
Procedure.s GetCurrentChar()
Protected car.s

  car = Chr(PeekC(@_line+CurrentPos))
  ProcedureReturn car
EndProcedure

Procedure.i SkipSpace()
Protected nbspace.i = 0
  
  While GetCurrentChar() = " " Or GetCurrentChar() = #TAB$
    CurrentPos + 1
    nbspace + 1
  Wend

  ProcedureReturn nbspace  
EndProcedure

; Procedure.s GetToken()
; Protected sTok.s = "", c.s
; 
;   Repeat
;     c = GetCurrentChar()
; 
;     ; Car = '"' and Not inside a string ?     //String definition
;     If c = #DBL_QUOTE And _QUOTE = 0
;       CurrentPos + 1
;       _QUOTE = 1
;       sTok + GetString()                      ; + au cas ou on aurait un '#' devant, sinon mettre '='
;       Break
;     EndIf
; 
;     ; Car = '"' and inside a string ?         //String definition
;     If c = #DBL_QUOTE And _QUOTE = 1
;       CurrentPos + 1
;       _QUOTE = 0
;       Break
;     EndIf
; 
;     ; Car = TAB and Not inside a string ?     //Tabulation
;     If c = #CHAR_TAB And _QUOTE = 0
;       CurrentPos + 1
;       Break
;     EndIf
; 
;     ; Car = ';' or Car = '*' in the beginning 
;     ; of the line and Not inside a string ?   //Remark
;     If c = ";" And _QUOTE = 0 : CurrentPos = LenLine : Break : EndIf
;     If c = "*" And _QUOTE = 0 And CurrentPos = 0
;       CurrentPos = LenLine : sTok = ""
;     EndIf
;     
;     ; Current car position >= current Line length ?
;     If CurrentPos >= LenLine : Break : EndIf
;     
;     ; if it's a space outside a quoted string
;     If c = " " And _QUOTE = 0 : Break : EndIf
; 
;     ; Make the Token
;     If (c >= "A" Or c <= "Z") And (c >= "a" Or c =< "z")
;       CurrentPos + 1
;       sTok + c
;     EndIf
; 
; ;     ; car = "=-+/*" outside a quoted string
; ;     If (c="=" Or c="-" Or c="+" Or c="/" Or c="*") And _QUOTE = 0
; ;       CurrentPos + 1
; ;       sTok = c
; ;       Break
; ;     EndIf
;   ForEver  
; 
;   ProcedureReturn sTok
; EndProcedure

;*****************************************************************************************

; Procedure.s GetString()
; Protected sText.s = "", c.s
;   
;   c = GetCurrentChar()
;   
;   While (c <> #DBL_QUOTE) And (CurrentPos < LenLine)
;     sText + c
;     CurrentPos + 1
;     c = GetCurrentChar()
;     TypeToken = #Typ_TEXT
;   Wend
;   
;   ProcedureReturn #DBL_QUOTE+sText+#DBL_QUOTE
; EndProcedure

Procedure.s GetString()
Protected sText.s = "", c.s
  
  c = GetCurrentChar()
  
  Repeat
    sText + c
    CurrentPos + 1
    c = GetCurrentChar()
  Until (c = #DBL_QUOTE) Or (CurrentPos >= LenLine)

  TypeToken = #Typ_TEXT

  ProcedureReturn sText
EndProcedure

Procedure.s GetToken()
Protected sTok.s = "", c.s

  Repeat
    c = GetCurrentChar()

    ; Car = '"' and Not inside a string ?     //String definition
    If c = #DBL_QUOTE And _QUOTE = #False
      sTok+c
      CurrentPos + 1
      _QUOTE = #True
      c = GetCurrentChar()
    EndIf

;     ; Car = '"' and Not inside a string ?     //String definition
;     If c = #DBL_QUOTE And _QUOTE = #False
;       sTok + GetString()
;       c = GetCurrentChar()
;       _QUOTE = #True
;     EndIf

    ; Car = '"' and inside a string ?         //String definition
    If c = #DBL_QUOTE And _QUOTE = 1
      _QUOTE = #False
    EndIf

    ; Car = TAB and Not inside a string ?     //Tabulation
    If c = #CHAR_TAB And _QUOTE = #False
      CurrentPos + 1
      Break
    EndIf

    ; Car = ';' or Car = '*' in the beginning 
    ; of the line and Not inside a string ?   //Remark
    If c = ";" And _QUOTE = #False : CurrentPos = LenLine : Break : EndIf
    If c = "*" And _QUOTE = #False And CurrentPos = 0
      CurrentPos = LenLine : sTok = ""
    EndIf
    
    ; Current car position >= current Line length ?
    If CurrentPos >= LenLine : Break : EndIf
    
    ; if it's a space outside a quoted string
    If c = " " And _QUOTE = #False
      CurrentPos + 1
      Break
    EndIf

    ; Make the Token
    CurrentPos + 1
    sTok + c

  ForEver  

  ProcedureReturn sTok
EndProcedure

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 3
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant