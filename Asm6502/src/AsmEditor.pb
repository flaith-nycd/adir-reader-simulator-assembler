IncludePath "include"
XIncludeFile "GoScintilla.pbi"

Global BACK_COLOR.i = RGB(64,64,64)
Global BACK_COLOR_FOLD.i = RGB(104,104,104)
Global BACK_COLOR_LINENUM.i = RGB(144,144,144)
Global FORE_COLOR_LINENUM.i = RGB(10,10,144)

;Initialise the Scintilla library for Windows.
InitScintilla()

If OpenWindow(0, 100, 200, 600, 600, "Asm6502 Editor", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  RemoveKeyboardShortcut(0, #PB_Shortcut_Tab) ;Required for the tab key to function correctly when the Scintilla control has the focus.
  ;Create our Scintilla control. Note that we do not specify a callback; this is optional for GoScintilla.
  GOSCI_Create(1, 10, 10, 580, 580, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)

  ;Set the padding added to the width of the line-number margin.
  GOSCI_SetAttribute(1, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)

  ;Set folding symbols margin width.
  ;GOSCI_SetMarginWidth(1, #GOSCI_MARGINFOLDINGSYMBOLS, 12);24)

  ;Set the back color of the line containing the caret.
  GOSCI_SetColor(1, #GOSCI_CARETLINEBACKCOLOR, $000000)

  ;Set font.
  GOSCI_SetFont(1, "Lucida Console", 10)

  ;Set tabs. Here we use a 'hard' tab in which a tab character is physically inserted. Set the 3rd (optional) parameter to 1 to use soft-tabs.
  GOSCI_SetTabs(1, 6)

  ;Set styles for our syntax highlighting.
  ;=======================================
  ;First define some constants to identify our various styles.
  ;You can name these as we wish.
  Enumeration
    #STYLES_COMMANDS = 1
    #STYLES_COMMENTS
    #STYLES_LITERALSTRINGS
    #STYLES_NUMBERS
    #STYLES_CONSTANTS
    #STYLES_FUNCTIONS
  EndEnumeration

  GOSCI_SetColor(1, #GOSCI_BACKCOLOR, BACK_COLOR)
  GOSCI_SetColor(1, #GOSCI_FORECOLOR, RGB(75,150,150));$7f7f7f)
  GOSCI_SetColor(1, #GOSCI_CARETFORECOLOR, $00FF00)
  GOSCI_SetColor(1, #GOSCI_LINENUMBERBACKCOLOR, BACK_COLOR_LINENUM)
  GOSCI_SetColor(1, #GOSCI_LINENUMBERFORECOLOR, FORE_COLOR_LINENUM)
  GOSCI_SetColor(1, #GOSCI_FOLDMARGINHIBACKCOLOR, BACK_COLOR_FOLD)
  GOSCI_SetColor(1, #GOSCI_FOLDMARGINLOBACKCOLOR, BACK_COLOR_FOLD)
  
  ;Set individual styles for commands.
  GOSCI_SetStyleFont(1, #STYLES_COMMANDS, "", -1, #PB_Font_Bold)
  GOSCI_SetStyleColors(1, #STYLES_COMMANDS, $FFFFFF);$800000)  ;We have omitted the optional back color.

  ;Set individual styles for comments.
  GOSCI_SetStyleFont(1, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
  GOSCI_SetStyleColors(1, #STYLES_COMMENTS, $00FF00)  ;We have omitted the optional back color.

  ;Set individual styles for literal strings.
  GOSCI_SetStyleColors(1, #STYLES_LITERALSTRINGS, RGB(177,100,255));#Gray)  ;We have omitted the optional back color.

  ;Set individual styles for numbers.
  GOSCI_SetStyleColors(1, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.

  ;Set individual styles for constants.
  GOSCI_SetStyleColors(1, #STYLES_CONSTANTS, $2193DE)  ;We have omitted the optional back color.

  ;Set individual styles for functions.
  GOSCI_SetStyleFont(1, #STYLES_FUNCTIONS, "", -1, #PB_Font_Bold)
  GOSCI_SetStyleColors(1, #STYLES_FUNCTIONS, $CFFFCF);#Blue)  ;We have omitted the optional back color.

  ;Set delimiters and keywords for our syntax highlighting.
  ;========================================================
  ;Note the use of #GOSCI_ADDTOCODECOMPLETION (new for GoScintilla 2.0).
  ;First some commands.
  GOSCI_AddKeywords(1, "bne cpx inx jsr lda ldx rts sta", #STYLES_COMMANDS, #GOSCI_ADDTOCODECOMPLETION)
  ;Now set up a ; symbol to denote a comment. Note the use of #GOSCI_DELIMITTOENDOFLINE.
  ;Note also that this symbol will act as an additional separator.
  GOSCI_AddDelimiter(1, ";", "", #GOSCI_DELIMITTOENDOFLINE, #STYLES_COMMENTS)
  
  ;Now set up quotes to denote literal strings.
  GOSCI_AddDelimiter(1, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
  ;Now set up a # symbol to denote a constant. Note the use of #GOSCI_LEFTDELIMITWITHOUTWHITESPACE.
;  GOSCI_AddDelimiter(1, "#", "", #GOSCI_LEFTDELIMITWITHOUTWHITESPACE, #STYLES_CONSTANTS)
  ;Now set up a ( symbol to denote a function. Note the use of #GOSCI_RIGHTDELIMITWITHWHITESPACE.
;  GOSCI_AddDelimiter(1, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
  ;We arrange for a ) symbol to match the coloring of the ( symbol.
;  GOSCI_AddDelimiter(1, ")", "", 0, #STYLES_FUNCTIONS)

  ;Add some folding keywords. Again note the use of #GOSCI_ADDTOCODECOMPLETION.
  GOSCI_AddKeywords(1, "MAC MAC", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD)
  ;Note the final parameter (optional) which we set to #True in order to have the keywords sorted into alphabetic order.
  ;We do this for code-completion and the fact that we have not added the keywords ourselves in alphabetic order etc.
  GOSCI_AddKeywords(1, "EOM <<<", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD, #True)

  ;Additional lexer options.
  ;=========================
  GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
  GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)

  ;Set call-completion.
  ;====================
  ;This lexer state is not set by default.
  GOSCI_SetLexerState(1, #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING|#GOSCI_LEXERSTATE_ENABLECODEFOLDING|#GOSCI_LEXERSTATE_ENABLECODECOMPLETION)

  ;Set some initial text.
  ;======================
  text$ = "; Test ASM 6502" + #CRLF$
  text$ + "; -------------" + #CRLF$
  text$ + "; " + #CRLF$
  text$ + "; " + #CRLF$ + #CRLF$
  text$ + "HOME" + #TAB$ + "=" + #TAB$ + "$FC58" + #CRLF$ + #CRLF$
  text$ + #CRLF$
  text$ + #TAB$ + #TAB$ + "jsr" + #TAB$ + "home" + #CRLF$ + #CRLF$
  text$ + #TAB$ + #TAB$ + "ldx" + #TAB$ + "#$00" + #CRLF$
  text$ + "boucle" + #TAB$ + "lda" + #TAB$ + "($00),X" + #CRLF$
  text$ + #TAB$ + #TAB$ + "sta" + #TAB$ + "($22),X" + #CRLF$
  text$ + #TAB$ + #TAB$ + "inx" + #CRLF$
  text$ + #TAB$ + #TAB$ + "cpx" + #TAB$ + "#$20" + #CRLF$
  text$ + #TAB$ + #TAB$ + "bne" + #TAB$ + "boucle" + #CRLF$
  text$ + #TAB$ + #TAB$ + "rts" + #CRLF$
  
  GOSCI_SetText(1, text$)
  GOSCI_SetState(1, #GOSCI_CURRENTLINE, GOSCI_GetNumberOfLines(1))
  SetActiveGadget(1)

  Repeat
    eventID = WaitWindowEvent()
    Select eventID
      Case #PB_Event_Gadget
        Select EventGadget()
        EndSelect
    EndSelect
  Until eventID = #PB_Event_CloseWindow 

  ;Free the Scintilla gadget.
  ;This needs explicitly calling in order to free resources used by GoScintilla.
  GOSCI_Free(1)
EndIf
; IDE Options = PureBasic 4.51 (Windows - x86)
; EnableUnicode
; EnableThread
; EnableXP
; Executable = t.exe
; CompileSourceDirectory
; EnableCompileCount = 50
; EnableBuildCount = 0
; EnableExeConstant