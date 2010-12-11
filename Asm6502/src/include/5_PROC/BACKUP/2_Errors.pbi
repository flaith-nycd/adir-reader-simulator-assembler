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
	  Case #ERR_LABEL_STARTWITHNUM
	    msg = "Bad Declaration : Label starts With a number"
	  Case #ERR_LABEL_INVALIDCHAR
	    msg = "Bad declaration : Label contains an invalid character"
	  Case #ERR_LABEL_TOOLOONG
	    msg = "Bad declaration : Maximum chars for Labels = "+Str(#MAXCHARLABEL)
	  Case #ERR_LABEL_EQUAL_OPCODE
	    msg = "Bad declaration : Label name used is a protected keyword"

	  Case #ERR_CONST_DEFINED
	    msg = "Duplicate constant '"+private_value1+"' : already defined in line "+private_value2
	  Case #ERR_CONST_STARTWITHNUM
	    msg = "Bad declaration : Constant starts With a number"
	  Case #ERR_CONST_INVALIDCHAR
	    msg = "Bad declaration : Constant contains an invalid character"
	  Case #ERR_CONST_TOOLOONG
	    msg = "Bad declaration : Maximum chars for constants = "+Str(#MAXCHARCONST)
	  Case #ERR_CONST_EQUAL_OPCODE
	    msg = "Bad declaration : Constant name used is a protected keyword"
	  Case #ERR_VALUE_EQUAL_OPCODE
	    msg = "Bad declaration : Value used is a protected keyword"

	  Case #ERR_CONST_TOOLONG
	    msg = "Constant value has not a valid length"
	  Case #ERR_IMM_TOOLONG
	    msg = "Immediate value has not a valid length"

	  Case #ERR_BIN_TOOLONG
	    msg = "Binary value too long (> 8 bits)"
	  Case #ERR_BYTE_TOOLONG
	    msg = "Current byte has not a valid length"
	  Case #ERR_WORD_TOOLONG
	    msg = "Current Value is not a valid word"
	    
	  Case #ERR_BAD_OPCODE
	    msg = "Unknown opcode '"+private_value1+"'"

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

; IDE Options = PureBasic 4.50 Beta 3 (Windows - x86)
; CursorPosition = 4
; FirstLine = 4
; Folding = -
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant