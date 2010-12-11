;-Constants
#FILE_SRC       = 0
#S_BYTE         = 2
#S_WORD         = 4
#S_LONG         = 8

; Num of mode for each opcode
#NB_MODE_OPC    = 15        ;for 65C02 - 13 = 6502
#NA             = -1        ;for Not Attributed Opcode ($BB initialy)

#DEBUG_FILENUM  = 99
#DEBUG_NAME     = "ASM_DEBUG.LOG"
#EXEC_NAME      = "asm6502"       
#DEFAULT_ORG    = "$8000"

#DBL_QUOTE      = Chr(34)
#SIM_QUOTE      = Chr(39)
#CHAR_TAB       = Chr(9)
#INVALID_CHAR   = ",;&ι"+Chr(34)+"'(-θηΰ)=^$ω*<>:!~#{[|`\@]}+¨£%µ?./§" ;For Labels and Constants

#MAXCHARLABEL   = 8
#MAXCHARCONST   = 8

Enumeration 
  #PROC_6502
  #PROC_65C02
  #PROC_65C816
EndEnumeration

Enumeration
  #COMPUTE_NONE
  #COMPUTE_ADD
  #COMPUTE_SUB
  #COMPUTE_MUL
  #COMPUTE_DIV
EndEnumeration

Enumeration 110
  #Typ_KEYWORD
  #Typ_OPCODE
  #Typ_INT
  #Typ_STRING
  #Typ_LABEL
  #Typ_TEXT
  #Typ_CONST
  #Typ_COMPUTE              ;If we have : STA IN+5,X
  #Typ_ERROR
  #Typ_OTHER    = 199
EndEnumeration

Enumeration 
;-Enum Assembler
  #Tok_ORG
  #Tok_EQU
  #Tok_EPZ
  #Tok_EQUAL                ;= like EQU
;  #Tok_ASTERISK              ;* When you don't know the adress, calculate when assembling

  #Tok_LST                  ;keep compatibility with all assemblers
  #Tok_AST

  #Tok_ASC                  ;ascii text
  #Tok_DFB                  ;define binary
  #Tok_HEX                  ;define hex value
  #Tok_DA                   ;define adress
  #Tok_DB                   ;define binary
  #Tok_DW                   ;define word
  #Tok_DS                   ;define whatever
EndEnumeration

#NB_TOK = #PB_Compiler_EnumerationValue

Enumeration #NB_TOK
;-Enum 6502C Opcode
  #Opc_ADC
  #Opc_AND
  #Opc_ASL
  #Opc_BCC
  #Opc_BCS
  #Opc_BEQ
  #Opc_BIT
  #Opc_BMI
  #Opc_BNE
  #Opc_BPL
  #Opc_BRA                  ;65C02
  #Opc_BRK
  #Opc_BVC
  #Opc_BVS
  #Opc_CLC
  #Opc_CLD
  #Opc_CLI
  #Opc_CLV
  #Opc_CMP
  #Opc_CPX
  #Opc_CPY
  #Opc_DEC
  #Opc_DEX
  #Opc_DEY
  #Opc_EOR
  #Opc_INC
  #Opc_INX
  #Opc_INY
  #Opc_JMP
  #Opc_JSR
  #Opc_LDA
  #Opc_LDX
  #Opc_LDY
  #Opc_LSR
  #Opc_NOP
  #Opc_ORA
  #Opc_PHA
  #Opc_PHP
  #Opc_PHX                  ;65C02
  #Opc_PHY                  ;65C02
  #Opc_PLA
  #Opc_PLP
  #Opc_PLX                  ;65C02
  #Opc_PLY                  ;65C02
  #Opc_ROL
  #Opc_ROR
  #Opc_RTI
  #Opc_RTS
  #Opc_SBC
  #Opc_SEC
  #Opc_SED
  #Opc_SEI
  #Opc_STA
  #Opc_STX
  #Opc_STY
  #Opc_STZ                  ;65C02
  #Opc_TAX
  #Opc_TAY
  #Opc_TRB                  ;65C02
  #Opc_TSB                  ;65C02
  #Opc_TSX
  #Opc_TXA
  #Opc_TXS
  #Opc_TYA
EndEnumeration

#NB_OPC = #PB_Compiler_EnumerationValue

Enumeration #PB_Compiler_EnumerationValue + 1
  #Tok_VALUE 
  #Tok_LABEL
  #Tok_MULTI                ;Like DFB %01011010,%10010110,%10011001 or HEX 00112233454... or ASC "hello",8D,00
  #Tok_ERROR
  #Tok_OTHER
EndEnumeration

Enumeration 0
                            ;#Mode                                #ByteLen
  #Mode_Acc                 ;Accumulator                          1
  #Mode_Imm                 ;Immediate                            2
  #Mode_ZP                  ;Zero Page                            2
  #Mode_ZPX                 ;Zero Page X-Indexed                  2
  #Mode_ZPY                 ;Zero Page Y-Indexed                  2
  #Mode_Abs                 ;Absolute                             3
  #Mode_AbsX                ;Absolute X-Indexed                   3
  #Mode_AbsY                ;Absolute Y-Indexed                   3
  #Mode_Imp                 ;Implied                              1
  #Mode_Rel                 ;Relative                             2
  #Mode_IZPX                ;Zero Page Indexed Indirect           2
  #Mode_IZPY                ;Zero Page Indirect Indexed           2
  #Mode_IAbs                ;Absolute Indirect                    3
  #Mode_IAbsX               ;Absolute Indexed Indirect (65C02)    3
  #Mode_IZP                 ;Zero Page Indirect (65C02)           2
EndEnumeration

Enumeration 
  #_NONE
  #_BYTE
  #_WORD
  #_DECI
  #_HEXA
  #_BIN
EndEnumeration

Enumeration 500
  #ERR_TOKEN_BINARY         ;Not a good binary token
  #ERR_TOKEN_ASCII
  #ERR_TOKEN_HEXA
  #ERR_LABEL_DEFINED        ;Label already defined
  #ERR_CONST_DEFINED        ;Constant already defined
  #ERR_CONST_TOOLONG        ;Constant value has not a valid length
  #ERR_IMM_TOOLONG          ;Immediate value has not a valid length
  #ERR_MISSING_QUOTE        ;Missing quote in constant definition
  
  #ERR_BIN_TOOLONG          ;Binary value too long (> 8 bits)
  #ERR_BYTE_TOOLONG         ;Current byte has not a valid length
  #ERR_WORD_TOOLONG         ;Current word has not a valid length
  #ERR_BAD_ZP_CONSTANT      ;Bad zero page value declared
  
  #ERR_TOO_MUCH_TOKEN       ;Too much token in the line
  #ERR_BAD_OPCODE           ;Bad opcode
  
  #ERR_LABEL_EQUAL_OPCODE   ;Bad label declaration, same name of an opcode
  
  #ERR_CL_STARTWITHNUM      ;Bad constant or label declaration, starting with a number
  #ERR_CL_INVALIDCHAR       ;Bad constant or label declaration, contains an invalid character
  #ERR_CL_TOOLOONG          ;Bad constant or label declaration, longer than X chars

  #ERR_CONST_EQUAL_OPCODE   ;Bad constant declaration, same name of an opcode
  #ERR_VALUE_EQUAL_OPCODE   ;Bad constant value, same name of an opcode
  
  #ERR_OPENED_PARENT_MISS   ;Opened parenthesis missing
  #ERR_CLOSED_PARENT_MISS   ;Closed parenthesis missing
  
  #ERR_BAD_VALUE_DFB        ;Bad value defined for DFB (Binary only)
  #ERR_UNKNOWN_MODE         ;Bad mode Immediate, accumulator, or ...
EndEnumeration

;Flags
; Bit 0 to 14 used
; 14 : Indexed with X      = true
; 13 : Indexed with Y      = true
; 12 : Opened Parenthesis  = true
; 11 : closed Parenthesis  = true
; 10 : Outside Parenthesis = true
;  9 : Comma               = true
;  8 : Minus               = true
;  7 : Plus                = true
;  6 : Multiply            = true
;  5 : Divide              = true
;  4 : Greater than        = true
;  3 : lesser than         = true
;  2 : Diese               = true
;  1 : Dollar              = true
;  0 : Quote               = true
#LF_INDEX_X           = %0100000000000000
#LF_INDEX_Y           = %0010000000000000
#LF_OPARENT           = %0001000000000000
#LF_CPARENT           = %0000100000000000
#LF_OUTSIDE           = %0000010000000000
#LF_COMMA             = %0000001000000000
#LF_MINUS             = %0000000100000000
#LF_PLUS              = %0000000010000000
#LF_MULTIPLY          = %0000000001000000
#LF_DIVIDE            = %0000000000100000
#LF_SUPP              = %0000000000010000
#LF_INF               = %0000000000001000
#LF_DIESE             = %0000000000000100
#LF_DOLLAR            = %0000000000000010
#LF_QUOTE             = %0000000000000001

; Bit 0 to 6 used
;  7 : IsIndexed    = True
;  6 : Is16Bits     = True
;  5 : IsParent     = True
;  4 : IsIndexed_X  = True
;  3 : IsIndexed_Y  = True
;  2 : IsLabel      = True
;  1 : IsValue      = True
;  0 : IsString     = True
#GF_INDEXED           = %10000000
#GF_16BIT             = %01000000
#GF_PARENT            = %00100000
#GF_INDEXEDX          = %00010000
#GF_INDEXEDY          = %00001000
#GF_ISLABEL           = %00000100
#GF_ISVALUE           = %00000010
#GF_IsSTRING          = %00000001
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 26
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant