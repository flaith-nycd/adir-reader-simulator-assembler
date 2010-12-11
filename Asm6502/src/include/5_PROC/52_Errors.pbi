;-Error handling
Procedure.s GetError(_num_error_.i, private_value1.s = "", private_value2.s = "")
Protected msg.s = ""

  Select _num_error_
	  Case #ERR_TOKEN_BINARY
	    msg = "Bad binary value"
	  Case #ERR_TOKEN_ASCII
      msg = "Bad ascii text"
	  Case #ERR_TOKEN_HEXA
	    msg = "Bad haxadecimal value"
	    
	  Case #ERR_LABEL_DEFINED
	    msg = "Duplicate label '"+private_value1+"' : already defined in line "+private_value2

	  Case #ERR_LABEL_EQUAL_OPCODE
	    msg = "Bad declaration : Label name used is a protected keyword"

	  Case #ERR_CONST_DEFINED
	    msg = "Duplicate constant '"+private_value1+"' : already defined in line "+private_value2

	  Case #ERR_CL_STARTWITHNUM
	    msg = "Bad declaration : Constant or label starts With a number"
	  Case #ERR_CL_INVALIDCHAR
	    msg = "Bad declaration : Constant or label contains an invalid character"
	  Case #ERR_CL_TOOLOONG
	    msg = "Bad declaration : Maximum chars for constants or label = "+Str(#MAXCHARCONST)
	    
	  Case #ERR_CONST_EQUAL_OPCODE
	    msg = "Bad declaration : Constant name used is a protected keyword"
	  Case #ERR_VALUE_EQUAL_OPCODE
	    msg = "Bad declaration : Value used is a protected keyword"

	  Case #ERR_CONST_TOOLONG
	    msg = "Constant value has not a valid length"
	  Case #ERR_IMM_TOOLONG
	    msg = "Immediate value has not a valid length"
	  Case #ERR_MISSING_QUOTE
	    msg = "Missing quote in constant definition"

	  Case #ERR_BIN_TOOLONG
	    msg = "Binary value too long (> 8 bits)"
	  Case #ERR_BYTE_TOOLONG
	    msg = "Current byte has not a valid length"
	  Case #ERR_WORD_TOOLONG
	    msg = "Current Value is not a valid word"
	    
	  Case #ERR_BAD_ZP_CONSTANT
	    msg = "Bad zero page value declared"

	  Case #ERR_TOO_MUCH_TOKEN
	    msg = "Unexpected Error : too much tokens (missing ';' for remarks ?)"
	  Case #ERR_BAD_OPCODE
	    msg = "Unknown opcode '"+private_value1+"'"
	    
	  Case #ERR_OPENED_PARENT_MISS
	    msg = "Opened Parenthesis missing for '"+private_value1+"'"
	  Case #ERR_CLOSED_PARENT_MISS
	    msg = "Closed Parenthesis missing for '"+private_value1+"'"
	    
	  Case #ERR_BAD_VALUE_DFB
	    msg = "Bad value defined for DFB (Binary only)"

	  Case #ERR_UNKNOWN_MODE
	    msg = "Invalid adressing mode used : "+private_value1
  
	  Default
	    msg = "Unknown Error "+Str(_num_error_)
  EndSelect
  
  ProcedureReturn msg
EndProcedure

Procedure AddError(_num_error_.i, _num_line_.i, private_value1.s = "", private_value2.s = "")
  AddElement(ListError())
    ListError()\num       = _num_error_
    ListError()\line      = _num_line_
    ListError()\value1    = private_value1
    ListError()\value2    = private_value2
EndProcedure

Procedure ShowError()
Protected src$

  SortStructuredList(ListError(), #PB_Sort_Ascending, OffsetOf(sListError\line), #PB_Sort_Integer)
  
  ForEach ListError()
    ;DEBUG_LOG("ERR Line : "+Str(ListError()\line)+" - "+GetError(ListError()\num,ListError()\value1,ListError()\value2))
    ;PrintN("Error in line "+RSet(str(ListError()\line),5," ")+" : "+GetError(ListError()\num,ListError()\value1,ListError()\value2))
    ConsoleColor(12,0) : Print("Error in line "+RSet(Str(ListError()\line),6,"0")+": ")
    ConsoleColor(6,0) : PrintN(GetError(ListError()\num,ListError()\value1,ListError()\value2))
    ConsoleColor(7,0)
    If Val(ListError()\value2) > 0
      SelectElement(src(),Val(ListError()\value2)-1)
      Src$ = ReplaceString(src()\text,#TAB$," ")
      ConsoleColor(2,0)
      PrintN(RSet(Str(src()\line),8,"0")+" "+Trim(src$))
      ConsoleColor(7,0)
    EndIf
    SelectElement(src(),ListError()\line-1)
    Src$ = ReplaceString(src()\text,#TAB$," ")
    PrintN(RSet(Str(src()\line),8,"0")+" "+Trim(src$)):PrintN("")
  Next
  PrintN("")
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 83
; FirstLine = 49
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant