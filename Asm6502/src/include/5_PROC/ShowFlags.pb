Enumeration 
;-Enum Assembler
  #Tok_ORG
  #Tok_EQU
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

;Mode
Enumeration 
  #Mode_Acc                 ;0  Accumulator
  #Mode_Imm                 ;1  Immediate
  #Mode_ZP                  ;2  Zero Page
  #Mode_ZPX                 ;3  Zero Page X-Indexed 
  #Mode_ZPY                 ;4  Zero Page Y-Indexed
  #Mode_Abs                 ;5  Absolute
  #Mode_AbsX                ;6  Absolute X-Indexed
  #Mode_AbsY                ;7  Absolute Y-Indexed
  #Mode_Imp                 ;8  Implied
  #Mode_Rel                 ;9  Relative
  #Mode_IZPX                ;10 Zero Page Indexed Indirect
  #Mode_IZPY                ;11 Zero Page Indirect Indexed
  #Mode_IAbs                ;12 Absolute Indirect
  #Mode_IAbsX               ;13 Absolute Indexed Indirect (65C02)
  #Mode_IZP                 ;14 Zero Page Indirect (65C02)
EndEnumeration

DataSection
  dataMode:
    Data.s "Accumulator"
    Data.s "Immediate"
    Data.s "Zero Page"
    Data.s "Zero Page X-Indexed"
    Data.s "Zero Page Y-Indexed"
    Data.s "Absolute"
    Data.s "Absolute X-Indexed"
    Data.s "Absolute Y-Indexed"
    Data.s "Implied"
    Data.s "Relative"
    Data.s "Zero Page Indexed Indirect"
    Data.s "Zero Page Indirect Indexed"
    Data.s "Absolute Indirect"
    Data.s "Absolute Indexed Indirect (65C02)"
    Data.s "Zero Page Indirect (65C02)"
EndDataSection

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

#NA                   = -1

;-Label
Structure sLABEL
  LABEL_Name.s
  LABEL_Line.i
  LABEL_Adress.i                      ; Hex value of the adress
EndStructure

;-Constant
Structure sCONST
  CONST_Name.s
  CONST_Value.s
  CONST_Line.i
EndStructure

Global NewList Label.sLABEL()
Global NewList Const.sCONST()
Global Dim tblMode.s(14)
;                        --USED--
Global GFlag.a       = %00000000
Global MaskGF.a      = %11111111

;                        |-----USED------
Global LFlag.u       = %1000000000000000
Global MaskLF.u      = %0111111111111111

;
Global _Value.s           = ""
Global CurrentPosValue.i  = 0

Macro IsDeciDigit(c)
  ((c >= '0') And (c <= '9'))
EndMacro

Macro IsHexaDigit(c)
  (IsDeciDigit(c) Or ((c >= 'a') And (c <= 'f')) Or ((c >= 'A') And (c <= 'F')))
EndMacro

Procedure.s FindConstant(Const.s)
Protected result.s = ""

  ForEach Const()
    If Const = Const()\CONST_Name
      result = Const()\CONST_Value
      Break
    EndIf
  Next

  ProcedureReturn result
EndProcedure

Procedure.i FindLabel(Label.s)
Protected result.i = 0

  ForEach Label()
    If Label = Label()\LABEL_Name
      result = Label()\LABEL_Line
      Break
    EndIf
  Next

  ProcedureReturn result
EndProcedure

Procedure.i IsHexadecimal(sTok.s)
  Protected HexaDecimal.i, *String.Character
 
  If sTok
    HexaDecimal = #True
    *String = @sTok
   
    While HexaDecimal And *String\c
      HexaDecimal = IsHexaDigit(*String\c)
      *String + SizeOf(Character)
    Wend
  EndIf
 
  ProcedureReturn HexaDecimal
EndProcedure

Procedure SetLF(flag.i)
  LFlag = LFlag | flag
EndProcedure

Procedure.i IsSetLF(flag.i)
  ProcedureReturn LFlag & flag
EndProcedure

Procedure.i IsNotSetLF(flag.i)
  If LFlag & flag = #False
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure ResetLFlag()
  LFlag = LFlag & ~MaskLF
EndProcedure

Procedure SetGF(flag.i)
  GFlag = GFlag | flag
EndProcedure

Procedure.i IsSetGF(flag.i)
  ProcedureReturn GFlag & flag
EndProcedure

Procedure.i IsNotSetGF(flag.i)
  If GFlag & flag = #False
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure ResetGFlag()
  GFlag = GFlag & ~MaskGF
EndProcedure

Procedure ShowNotFlag()
  If IsNotSetLF(#LF_OUTSIDE)
    Debug "Outside Parenthesis = False"
  EndIf
  If IsNotSetGF(#GF_16BIT)
    Debug "Is16Bits     = False"
  EndIf
  If IsNotSetGF(#GF_INDEXED)
    Debug "IsIndexed    = False"
  EndIf
EndProcedure

Procedure ShowGFlag()
  If IsSetGF(#GF_16BIT)
    Debug "Is16Bits     = True"
  EndIf
  If IsSetGF(#GF_PARENT)
    Debug "IsParent     = True"
  EndIf
  If IsSetGF(#GF_INDEXEDX)
    Debug "IsIndexed_X  = True"
  EndIf
  If IsSetGF(#GF_INDEXEDY)
    Debug "IsIndexed_Y  = True"
  EndIf
  If IsSetGF(#GF_ISLABEL)
    Debug "IsLabel      = True"
  EndIf
  If IsSetGF(#GF_ISVALUE)
    Debug "IsValue      = True"
  EndIf
  If IsSetGF(#GF_IsSTRING)
    Debug "IsString     = True"
  EndIf
EndProcedure

Procedure ShowLFlag()
  If IsSetLF(#LF_INDEX_X)
    Debug "Indexed With X      = true"
  EndIf
  If IsSetLF(#LF_INDEX_Y)
    Debug "Indexed with Y      = true"
  EndIf
  If IsSetLF(#LF_OPARENT)
    Debug "Opened Parenthesis  = true"
  EndIf
  If IsSetLF(#LF_CPARENT)
    Debug "closed Parenthesis  = true"
  EndIf
  If IsSetLF(#LF_OUTSIDE)
    Debug "Outside Parenthesis = true"
  EndIf
  If IsSetLF(#LF_COMMA)
    Debug "Comma               = true"
  EndIf
  If IsSetLF(#LF_MINUS)
    Debug "Minus               = true"
  EndIf
  If IsSetLF(#LF_PLUS)
    Debug "Plus                = true"
  EndIf
  If IsSetLF(#LF_MULTIPLY)
    Debug "Multiply            = true"
  EndIf
  If IsSetLF(#LF_DIVIDE)
    Debug "Divide              = true"
  EndIf
  If IsSetLF(#LF_SUPP)
    Debug "Greater than        = true"
  EndIf
  If IsSetLF(#LF_INF)
    Debug "lesser than         = true"
  EndIf
  If IsSetLF(#LF_DIESE)
    Debug "Diese               = true"
  EndIf
  If IsSetLF(#LF_DOLLAR)
    Debug "Dollar              = true"
  EndIf
  If IsSetLF(#LF_QUOTE)
    Debug "Quote               = true"
  EndIf
EndProcedure

; Generate Hexa value
Procedure.s GetValueChar()
  car.s = Chr(PeekC(@_value+CurrentPosValue))
  ProcedureReturn car
EndProcedure

; Example:
; --------
; ADC (ADd With Carry)
; 
; Affects Flags: S V Z C
; 
; MODE           SYNTAX       HEX LEN TIM
; Immediate     ADC #$44      $69  2   2
; Zero Page     ADC $44       $65  2   3
; Zero Page,X   ADC $44,X     $75  2   4
; Absolute      ADC $4400     $6D  3   4
; Absolute,X    ADC $4400,X   $7D  3   4+
; Absolute,Y    ADC $4400,Y   $79  3   4+
; Indirect,X    ADC ($44,X)   $61  2   6
; Indirect,Y    ADC ($44),Y   $71  2   5+
;
; 65C02 Absolute Indexed Indirect
; OP LEN CYC MODE    FLAGS    SYNTAX
; -- --- --- ----    -----    ------
; 7C 3   6   (abs,X) ........ JMP ($1234,X)

Procedure.i CheckMode(Instruction.i, Value.s)
Protected mode.i = #NA
Protected car.s = "", lencar.i = Len(Value)
Protected PosOP.i = 0, PosCP.i = 0                ;Variable pour recup valeur entre les parenthères, ou avant virgule et après $

  ;Check Type of value (Acc Imm ZP ZP,X ...)
  ResetLFlag():ResetGFlag()
  
  If value <> ""
    CurrentPosValue = 0
    _Value = Value
    While CurrentPosValue <= lencar
      car = GetValueChar()
      
      Select LCase(car)
        Case "("
          If Not IsSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_OPARENT)
            PosOP = CurrentPosValue + 1
          EndIf
  
        Case ")"
          If Not IsSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_CPARENT)
            If PosCP = 0
              PosCP = CurrentPosValue
            EndIf
          EndIf
  
        Case ","
          If Not IsSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_COMMA)
            If PosCP = 0
              PosCP = CurrentPosValue
            EndIf
            If IsSetLF(#LF_CPARENT)                         ; close parent already defined ?
              SetLF(#LF_OUTSIDE)                            ; so it's outside parenthesis
            EndIf
          EndIf
  
        Case "#"
          If Not IsSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_DIESE)
            PosOP = CurrentPosValue + 1
          EndIf
  
        Case "$"
          If Not IsSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_DOLLAR)
            ;SetGF(#GF_ISVALUE)
            ;PosOP = CurrentPosValue + 1
            PosOP = CurrentPosValue
          EndIf
  
  ;       Case "a"
  ;         mode = #Mode_Acc
  
        Case "x"
          If Not IsSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_INDEX_X) : SetGF(#GF_INDEXEDX)
            SetGF(#GF_INDEXED)
          EndIf
  
        Case "y"
          If Not IsSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_INDEX_Y) : SetGF(#GF_INDEXEDY)
            SetGF(#GF_INDEXED)
          EndIf
  
        Case Chr(34)
          If IsSetLF(#LF_QUOTE)
            SetGF(#GF_IsSTRING)
          Else
            SetLF(#LF_QUOTE)
          EndIf
  
      EndSelect
  
      CurrentPosValue + 1
    Wend
    
    ; in case we have a LDA #HOME, for example, so we have PosCO and now the PosCP
    If PosCP = 0
      PosCP = CurrentPosValue
    EndIf
  
;     Debug "Value: "+Value
    tmp_value$ = Mid(value,PosOP+1,PosCP-PosOP)
    If IsHexadecimal(tmp_value$) And IsSetLF(#LF_DOLLAR)
      SetGF(#GF_ISVALUE)
      ValueConst$ = tmp_value$
    EndIf

    If ValueConst$ = ""
      ValueConst$ = FindConstant(tmp_value$)
      If ValueConst$ = ""
        ValueLabel = FindLabel(tmp_value$)
        If ValueLabel = 0
          ValueConst$ = tmp_value$
        Else
          Debug "Label '"+tmp_value$+"' is in line: "+Str(ValueLabel)
          SetGF(#GF_ISLABEL)
        EndIf
      EndIf
    EndIf
  
    If Len(ValueConst$) >= 4 : SetGF(#GF_16BIT) : EndIf
  EndIf

  ;Checking parenthesis
  If IsSetLF(#LF_OPARENT) And IsSetLF(#LF_CPARENT) : SetGF(#GF_PARENT) : EndIf

  If IsSetLF(#LF_OPARENT) And Not isSetGF(#GF_PARENT)
    Debug "*** Error: Closed Parenthesis missing for "+value
    mode = #NA
  EndIf
  
  If IsSetLF(#LF_CPARENT) And Not isSetGF(#GF_PARENT)
    Debug "*** Error: Opened Parenthesis missing for "+value
    mode = #NA
  EndIf
  
  ;   #Mode_Acc                 ;0  Accumulator
  ;   ASL
  If value = "" Or LCase(Value) = "a"
    Select Instruction
      Case #Opc_ASL, #Opc_DEC, #Opc_INC, #Opc_LSR, #Opc_ROL, #Opc_ROR
        mode = #Mode_Acc
    EndSelect
  EndIf

  ;   #Mode_Imm                 ;1  Immediate
  ;   ORA #$44
  If IsNotSetGF(#GF_PARENT) And IsSetLF(#LF_DIESE) And IsNotSetGF(#GF_16BIT)
    mode = #Mode_Imm
  EndIf

  ;   #Mode_ZP                  ;2  Zero Page
  ;   AND $44
  If IsNotSetGF(#GF_PARENT) And IsNotSetLF(#LF_DIESE) And IsNotSetGF(#GF_16BIT) And mode = #NA And IsNotSetGF(#GF_ISLABEL)
    mode = #Mode_ZP
  EndIf

  ;   #Mode_ZPX                 ;3  Zero Page X-Indexed 
  If IsSetGF(#GF_INDEXEDX) And IsNotSetGF(#GF_PARENT) And IsNotSetLF(#LF_DIESE) And IsNotSetGF(#GF_16BIT)
    mode = #Mode_ZPX
  EndIf

  ;   #Mode_ZPY                 ;4  Zero Page Y-Indexed
  ;   LDX $44,Y or STX $44,Y
  If IsSetGF(#GF_INDEXEDY) And IsNotSetGF(#GF_PARENT) And IsNotSetLF(#LF_DIESE) And IsNotSetGF(#GF_16BIT)
    mode = #Mode_ZPY
  EndIf
  
  ;   #Mode_Abs                 ;5  Absolute
  ;   ADC $4400
  If IsNotSetGF(#GF_PARENT) And IsNotSetGF(#GF_INDEXEDY) And IsNotSetGF(#GF_INDEXEDX) And IsSetGF(#GF_16BIT)
    mode = #Mode_Abs
  EndIf

  ;   #Mode_AbsX                ;6  Absolute X-Indexed
  ;   ADC $4400,X
  If IsNotSetGF(#GF_PARENT) And isnotsetlf(#LF_OPARENT) And IsNotSetLF(#LF_CPARENT) And IsSetGF(#GF_INDEXEDX) And IsSetGF(#GF_16BIT)
    mode = #Mode_AbsX
  EndIf

  ;   #Mode_AbsY                ;7  Absolute Y-Indexed
  ;   ADC $4400,Y
  If IsNotSetGF(#GF_PARENT) And IsSetGF(#GF_INDEXEDY) And IsSetGF(#GF_16BIT)
    mode = #Mode_AbsY
  EndIf

  ;   #Mode_Imp                 ;8  Implied
  If value = ""
    Select Instruction
      Case #Opc_BRK
        mode = #Mode_Imp
      Case #Opc_CLC, #Opc_CLD, #Opc_CLI, #Opc_CLV
        mode = #Mode_Imp
      Case #Opc_DEX, #Opc_DEY
        mode = #Mode_Imp
      Case #Opc_INX, #Opc_INY
        mode = #Mode_Imp
      Case #Opc_NOP
        mode = #Mode_Imp
      Case #Opc_PHA, #Opc_PHP, #Opc_PHX, #Opc_PHY, #Opc_PLA, #Opc_PLP, #Opc_PLX, #Opc_PLY
        mode = #Mode_Imp
      Case #Opc_RTI, #Opc_RTS
        mode = #Mode_Imp
      Case #Opc_SEC, #Opc_SED, #Opc_SEI
        mode = #Mode_Imp
      Case #Opc_TAX, #Opc_TAY, #Opc_TSX, #Opc_TXA, #Opc_TXS, #Opc_TYA
        mode = #Mode_Imp
    EndSelect
  EndIf
  
  ;   #Mode_Rel                 ;9  Relative
  If IsSetGF(#GF_16BIT) Or IsSetGF(#GF_ISLABEL)
    Select Instruction
      Case #Opc_BCC, #Opc_BCS, #Opc_BEQ, #Opc_BMI, #Opc_BNE, #Opc_BPL, #Opc_BRA, #Opc_BVC, #Opc_BVS
        mode = #Mode_Rel
    EndSelect
  EndIf

  ;   #Mode_IZPX                ;10 Zero Page Indexed Indirect
  ;   ADC ($22,X)
  If IsSetGF(#GF_PARENT) And IsSetGF(#GF_INDEXEDX) And IsNotSetLF(#LF_OUTSIDE) And IsNotSetGF(#GF_16BIT)
    mode = #Mode_IZPX
  EndIf
  
  ;   #Mode_IZPY                ;11 Zero Page Indirect Indexed
  ;   ADC ($22),Y
  If IsSetGF(#GF_PARENT) And IsSetGF(#GF_INDEXEDY) And IsSetLF(#LF_OUTSIDE) And ~IsSetGF(#GF_16BIT)
    mode = #Mode_IZPY
  EndIf

  ;   #Mode_IAbs                ;12 Absolute Indirect
  ;   JMP ($FFFF)
  If IsSetGF(#GF_PARENT) And IsSetGF(#GF_16BIT) And IsNotSetGF(#GF_INDEXED)
    mode = #Mode_IAbs
  EndIf
  
  ;   #Mode_IAbsX               ;13 Absolute Indexed Indirect (65C02)
  ;   JMP ($1234,X)  
  If IsSetGF(#GF_PARENT) And IsSetGF(#GF_INDEXEDX) And IsSetGF(#GF_16BIT) And IsNotSetLF(#LF_OUTSIDE)
    If Instruction = #Opc_JMP
      mode = #Mode_IAbsX
    EndIf
  EndIf
  
  ;   #Mode_IZP                 ;14 Zero Page Indirect (65C02)
  ;   ADC ($22)
  If IsSetGF(#GF_PARENT) And IsNotSetGF(#GF_INDEXEDX) And IsNotSetGF(#GF_INDEXEDY) And IsNotSetGF(#GF_16BIT)
    mode = #Mode_IZP
  EndIf
  
;   Debug "Value for '"+value+"' = %"+Bin(LFlag)
;   If IsSetGF(#GF_PARENT)
;     Debug "Value between parenthesis = ["+ValueConst$+"]";tmp_value$+"]"
;   EndIf
; 
;   If (IsSetGF(#GF_INDEXEDX) Or IsSetGF(#GF_INDEXEDY)) And IsSetLF(#LF_DOLLAR)
;     Debug "Value between '$' and ',' = ["+ValueConst$+"]";tmp_value$+"]"
;   EndIf
;   
;   If IsSetLF(#LF_DIESE)
;     Debug "Value after '#' = ["+ValueConst$+"]";tmp_value$+"]"
;   EndIf

  ProcedureReturn mode
EndProcedure  

; IMMEDIAT  =   $F0
; ZP        =   $05
; ABS       =   $10
; GenerateHEXA(#Opc_ADC, "#IMMEDIAT+1")
; GenerateHEXA(#Opc_ADC, "ZP+1")
; GenerateHEXA(#Opc_ADC, "ZP,X")
; GenerateHEXA(#Opc_ADC, "ABS")
; GenerateHEXA(#Opc_ADC, "ABS,X")
; GenerateHEXA(#Opc_ADC, "$00,Y")
; GenerateHEXA(#Opc_ADC, "(ZP,X)")
; GenerateHEXA(#Opc_ADC, "(ZP),Y")
; GenerateHEXA(#Opc_ADC, "(ZP)")
Procedure.i GenerateOpcode(Instruction.i, Value.s, PosElement.i)
Protected result.i = #NA

  result = CheckMode(Instruction, Value)

  ProcedureReturn result
EndProcedure

Procedure PrintMODE(mode.i)
  If mode <> -1
    Debug "mode="+Str(mode)+"-"+tblMode(mode)
  Else
    Debug "*** ERROR *** : no mode"
  EndIf
  
  Debug ""
EndProcedure

Restore dataMode
For i = 0 To 14
  Read.s tmp$
  tblMode.s(i) = tmp$
Next i

AddElement(Label())
Label()\LABEL_Name  = "MON"
Label()\LABEL_Line  = 1081

AddElement(Const())
Const()\CONST_Name  = "HELLO"
Const()\CONST_Value = "$C098"

AddElement(Const())
Const()\CONST_Name  = "SAUT"
Const()\CONST_Value = "$1023"

AddElement(Const())
Const()\CONST_Name  = "ZEROP"
Const()\CONST_Value = "$22"

AddElement(Const())
Const()\CONST_Name  = "IMMEDIAT"
Const()\CONST_Value = "$44"

; ;ShowFlags()
; Debug "ADC (HELLO,X"
; mode=GenerateOpcode(#Opc_ADC, "(HELLO,X", 0)
; ;ShowLFlag()
; ShowGFlag()
; PrintMODE(mode)
; 
; Debug "ADC HELLO),X"
; mode=GenerateOpcode(#Opc_ADC, "HELLO),X", 0)
; ;ShowLFlag()
; ShowGFlag()
; PrintMODE(mode)
; 
; Debug "ADC (HELLO),X"
; mode=GenerateOpcode(#Opc_ADC, "(HELLO),X", 0)
; ;ShowLFlag()
; ShowGFlag()
; PrintMODE(mode)
; 
; Debug "JMP (SAUT,X)"
; mode=GenerateOpcode(#Opc_JMP, "(SAUT,X)", 0)
; ;ShowLFlag()
; ShowGFlag():ShowNotFlag()
; PrintMODE(mode)
; 
; Debug "ADC (HELLO,Y)"
; mode=GenerateOpcode(#Opc_ADC, "(HELLO,Y)", 0)
; ;ShowLFlag()
; ShowGFlag()
; PrintMODE(mode)
; 
; Debug "ADC $FFF0,Y"
; mode=GenerateOpcode(#Opc_ADC, "$FFF0,Y", 0)
; ;ShowLFlag()
; ShowGFlag()
; PrintMODE(mode)
; 
; Debug "ADC (ZEROP),Y"
; mode=GenerateOpcode(#Opc_ADC, "(ZEROP),Y", 0)
; ;ShowLFlag()
; ShowGFlag()
; PrintMODE(mode)
; 
; Debug "LDA #IMMEDIAT"
; mode=GenerateOpcode(#Opc_LDA, "#IMMEDIAT", 0)
; ;ShowLFlag()
; ShowGFlag()
; PrintMODE(mode)

; Accumulator   ASL A
; Immediate     ADC #$44
; Zero Page     ADC $44
; Zero Page,X   ADC $44,X
; Absolute      ADC $4400
; Absolute,X    ADC $4400,X
; Absolute,Y    ADC $4400,Y
; Indirect,X    ADC ($44,X)
; Indirect,Y    ADC ($44),Y

;   #Mode_Acc                 ;0  Accumulator
Debug "ASL A"
mode=GenerateOpcode(#Opc_ASL, "A", 0)
PrintMODE(mode)

;   #Mode_Imm                 ;1  Immediate
Debug "ADC #$44"
mode=GenerateOpcode(#Opc_ADC, "#$44", 0)
PrintMODE(mode)

;   #Mode_ZP                  ;2  Zero Page
Debug "ADC $44"
mode=GenerateOpcode(#Opc_ADC, "$44", 0)
PrintMODE(mode)

;   #Mode_ZPX                 ;3  Zero Page X-Indexed 
Debug "ADC $44,X"
mode=GenerateOpcode(#Opc_ADC, "$44,X", 0)
PrintMODE(mode)

;   #Mode_ZPY                 ;4  Zero Page Y-Indexed
Debug "LDX $44,Y"
mode=GenerateOpcode(#Opc_LDX, "$44,Y", 0)
PrintMODE(mode)

;   #Mode_Abs                 ;5  Absolute
Debug "ADC $4400"
mode=GenerateOpcode(#Opc_ADC, "$4400", 0)
PrintMODE(mode)

;   #Mode_AbsX                ;6  Absolute X-Indexed
Debug "ADC $4400,X"
mode=GenerateOpcode(#Opc_ADC, "$4400,X", 0)
PrintMODE(mode)

;   #Mode_AbsY                ;7  Absolute Y-Indexed
Debug "ADC $4400,Y"
mode=GenerateOpcode(#Opc_ADC, "$4400,Y", 0)
PrintMODE(mode)

;   #Mode_Imp                 ;8  Implied
Debug "TAX"
mode=GenerateOpcode(#Opc_TAX, "", 0)
PrintMODE(mode)

;   #Mode_Rel                 ;9  Relative
Debug "BCC $030F"
mode=GenerateOpcode(#Opc_BCC, "$030F", 0)
PrintMODE(mode)

Debug "BMI MON"
mode=GenerateOpcode(#Opc_BMI, "MON", 0)
PrintMODE(mode)

;   #Mode_IZPX                ;10 Zero Page Indexed Indirect
Debug "ADC ($44,X)"
mode=GenerateOpcode(#Opc_ADC, "($44,X)", 0)
PrintMODE(mode)

;   #Mode_IZPY                ;11 Zero Page Indirect Indexed
Debug "ADC ($44),Y"
mode=GenerateOpcode(#Opc_ADC, "($44),Y", 0)
PrintMODE(mode)

;   #Mode_IAbs                ;12 Absolute Indirect
Debug "JMP ($5597)"
mode=GenerateOpcode(#Opc_JMP, "($5597)", 0)
PrintMODE(mode)
Debug "STA ($5597)"
mode=GenerateOpcode(#Opc_STA, "($5597)", 0)
PrintMODE(mode)

;   #Mode_IAbsX               ;13 Absolute Indexed Indirect (65C02)
Debug "JMP ($1234,X)"
mode=GenerateOpcode(#Opc_JMP, "($1234,X)", 0)
PrintMODE(mode)
  
;   #Mode_IZP                 ;14 Zero Page Indirect (65C02)
Debug "ADC ($22)"
mode=GenerateOpcode(#Opc_ADC, "($22)", 0)
PrintMODE(mode)
; IDE Options = PureBasic 4.50 Beta 4 (Windows - x86)
; CursorPosition = 606
; FirstLine = 575
; Folding = ----
; CompileSourceDirectory
; EnableCompileCount = 256
; EnableBuildCount = 0
; EnableExeConstant