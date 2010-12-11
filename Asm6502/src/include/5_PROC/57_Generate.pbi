;Get Value Char
Procedure.s GetValueChar()
Protected car.s

  car = Chr(PeekC(@_value+CurrentPosValue))
  ProcedureReturn car
EndProcedure

;Local Flags
Procedure SetLF(flag.i)
  LFlag = LFlag | flag
EndProcedure

Procedure UnSetLF(flag.i)
  LFlag = LFlag ! flag
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

; Global Flags
Procedure SetGF(flag.i)
  GFlag = GFlag | flag
EndProcedure

Procedure UnSetGF(flag.i)
  GFlag = GFlag ! flag
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

Procedure ShowGFlag()
  If IsSetGF(#GF_INDEXED)
    DEBUG_LOG("IsIndexed    = True")
  EndIf
  If IsSetGF(#GF_16BIT)
    DEBUG_LOG("Is16Bits     = True")
  EndIf
  If IsSetGF(#GF_PARENT)
    DEBUG_LOG("IsParent     = True")
  EndIf
  If IsSetGF(#GF_INDEXEDX)
    DEBUG_LOG("IsIndexed_X  = True")
  EndIf
  If IsSetGF(#GF_INDEXEDY)
    DEBUG_LOG("IsIndexed_Y  = True")
  EndIf
  If IsSetGF(#GF_ISLABEL)
    DEBUG_LOG("IsLabel      = True")
  EndIf
  If IsSetGF(#GF_ISVALUE)
    DEBUG_LOG("IsValue      = True")
  EndIf
  If IsSetGF(#GF_IsSTRING)
    DEBUG_LOG("IsString     = True")
  EndIf
EndProcedure

Procedure ShowLFlag()
  If IsSetLF(#LF_INDEX_X)
    DEBUG_LOG("Indexed With X      = true")
  EndIf
  If IsSetLF(#LF_INDEX_Y)
    DEBUG_LOG("Indexed with Y      = true")
  EndIf
  If IsSetLF(#LF_OPARENT)
    DEBUG_LOG("Opened Parenthesis  = true")
  EndIf
  If IsSetLF(#LF_CPARENT)
    DEBUG_LOG("closed Parenthesis  = true")
  EndIf
  If IsSetLF(#LF_OUTSIDE)
    DEBUG_LOG("Outside Parenthesis = true")
  EndIf
  If IsSetLF(#LF_COMMA)
    DEBUG_LOG("Comma               = true")
  EndIf
  If IsSetLF(#LF_MINUS)
    DEBUG_LOG("Minus               = true")
  EndIf
  If IsSetLF(#LF_PLUS)
    DEBUG_LOG("Plus                = true")
  EndIf
  If IsSetLF(#LF_MULTIPLY)
    DEBUG_LOG("Multiply            = true")
  EndIf
  If IsSetLF(#LF_DIVIDE)
    DEBUG_LOG("Divide              = true")
  EndIf
  If IsSetLF(#LF_SUPP)
    DEBUG_LOG("Greater than        = true")
  EndIf
  If IsSetLF(#LF_INF)
    DEBUG_LOG("lesser than         = true")
  EndIf
  If IsSetLF(#LF_DIESE)
    DEBUG_LOG("Diese               = true")
  EndIf
  If IsSetLF(#LF_DOLLAR)
    DEBUG_LOG("Dollar              = true")
  EndIf
  If IsSetLF(#LF_QUOTE)
    DEBUG_LOG("Quote               = true")
  EndIf
EndProcedure

;Check Type of value (Acc Imm ZP ZP,X ...)
Procedure.i CheckMode(Instruction.i, Value.s, LineOfInstruction.i, ValueCompute.s)
Protected mode.i = #NA
Protected car.s = "", lencar.i = Len(Value)
Protected PosOP.i = 0, PosCP.i = 0                        ; defined vars to get value between parenthesis or before comma et after a '$'
Protected tmpvalue.s = "", ConstValue.s = "", LabelLine.i = 0, Difference.i = 0

  ResetLFlag():ResetGFlag()
  _Difference = Difference
  _ConstValue = ""

  If value <> ""
    CurrentPosValue = 0
    _Value = Value                                         ; for procedure GetValueChar()
    PosOP = CurrentPosValue

    While CurrentPosValue <= lencar
      car = GetValueChar()

      Select LCase(car)
;**** NO MORE USE OF THIS
;         Case "*"
;           If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
;             If CurrentPosValue = 0 
;               SetLF(#LF_MULTIPLY)
;             EndIf
;           EndIf
;**** NO MORE USE OF THIS

        Case "("
          If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_OPARENT)
            PosOP = CurrentPosValue + 1
          EndIf
  
        Case ")"
          If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_CPARENT)
            If PosCP = 0
              PosCP = CurrentPosValue
            EndIf
          EndIf
  
        Case ","
          If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_COMMA)
            If PosCP = 0
              PosCP = CurrentPosValue
            EndIf
            If IsSetLF(#LF_CPARENT)                        ; close parent already defined ?
              SetLF(#LF_OUTSIDE)                           ; so it's outside parenthesis
            EndIf
          EndIf
  
        Case "#"
          If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_DIESE)
            PosOP = CurrentPosValue + 1
          EndIf

        Case "$"
          If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
            SetLF(#LF_DOLLAR)
            ;SetGF(#GF_ISVALUE)
            ;PosOP = CurrentPosValue + 1
            PosOP = CurrentPosValue
          EndIf

        Case "x"
          If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
            If IsSetLF(#LF_COMMA)                          ; and ',' defined
              SetLF(#LF_INDEX_X) : SetGF(#GF_INDEXEDX)
              SetGF(#GF_INDEXED)
            EndIf
          EndIf

        Case "y"
          If IsNotSetLF(#LF_QUOTE)                         ; not inside Quote
            If IsSetLF(#LF_COMMA)                          ; and ',' defined
              SetLF(#LF_INDEX_Y) : SetGF(#GF_INDEXEDY)
              SetGF(#GF_INDEXED)
            EndIf
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

    tmpvalue = Mid(value,PosOP+1,PosCP-PosOP)

    ;If there is a value to compute, we change the value to check
    If ValueCompute <> Value
      If IsNotSetGF(#GF_INDEXED)
        tmpvalue = Mid(ValueCompute,PosOP+1,Len(ValueCompute))
      Else
        tmpvalue = ValueCompute
      EndIf
    EndIf

    If IsHexadecimal(tmpvalue) And IsSetLF(#LF_DOLLAR)
      SetGF(#GF_ISVALUE)
      ConstValue = tmpvalue
    EndIf

    If ConstValue = ""
      ; value is empty so check if a constant exist
      ConstValue = GetConstValue(tmpvalue)
      
      ; if not maybe it's a label
      If ConstValue = ""
        LabelLine = GetLabelLine(tmpvalue)
        ConstValue = tmpvalue
        ; definitively not a constant or a label already defined so it's a jump to an address
        If LabelLine <> 0
          Difference = LabelLine - LineOfInstruction
          _Difference = Difference
          SetGF(#GF_ISLABEL)
        EndIf
      Else
        ; particular case where it's indexed with Y or instruction = JMP with a zero page value
        ; if lda or sta $32,Y or jmp $32 => lda $0032,y or sta $0032,Y or jmp $0032
        If (issetLF(#LF_INDEX_Y) And isSetGF(#GF_INDEXED)) Or Instruction = #Opc_JMP
          If Left(ConstValue,1) = "$" And Len(ConstValue) = 3
            ConstValue = "$00"+Right(ConstValue,2)
          EndIf
        EndIf

      EndIf
    EndIf

    If IsSetGF(#GF_ISLABEL)  : SetGF(#GF_16BIT) : EndIf
    If Len(ConstValue) >= 4  : SetGF(#GF_16BIT) : EndIf
    
;**** NO MORE USE OF THIS
;     ; if we have a "*" in the beginning like : STA *+2
;     If IsSetLF(#LF_MULTIPLY) : SetGF(#GF_16BIT) : EndIf
;**** NO MORE USE OF THIS

    ; we have a '#' and a 16bit defined => back to 8Bits
    If IsSetLF(#LF_DIESE) And IsSetGF(#GF_16BIT) : UnSetGF(#GF_16BIT) : EndIf

    _ConstValue = ConstValue                               ; Global Value = local Value
  EndIf

  ;Checking parenthesis
  If IsSetLF(#LF_OPARENT) And IsSetLF(#LF_CPARENT) : SetGF(#GF_PARENT) : EndIf

  If IsSetLF(#LF_OPARENT) And isNotSetGF(#GF_PARENT)
    DEBUG_LOG("*** Error: Closed Parenthesis missing for "+value)
    AddError(#ERR_CLOSED_PARENT_MISS, LineOfInstruction, value)
    mode = #NA
  EndIf
  
  If IsSetLF(#LF_CPARENT) And isNotSetGF(#GF_PARENT)
    DEBUG_LOG("*** Error: Opened Parenthesis missing for "+value)
    AddError(#ERR_OPENED_PARENT_MISS, LineOfInstruction, value)
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
  If IsNotSetGF(#GF_PARENT) And IsNotSetLF(#LF_DIESE) And IsNotSetGF(#GF_16BIT) And IsNotSetGF(#GF_ISLABEL) ;And mode = #NA 
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

  ProcedureReturn mode
EndProcedure  

Procedure.i GenerateOpcode(Instruction.i, Value.s, LineOfInstruction.i, ValueCompute.s = "")
Protected result.i = #NA

  ; to check if equal in CheckMode
  If ValueCompute = "" : ValueCompute = Value : EndIf

  result = CheckMode(Instruction, Value, LineOfInstruction, ValueCompute)

  ProcedureReturn result
EndProcedure

Procedure.i Pass1()
Protected mode.i = #NA, TheOpcode.i = #NA
Protected Inst.i = 0, value.s = "", SrcLine.i = 0, tdiff.i, posCompute.i, typeCompute.i, i.i
Protected valasc.i
Protected PosElement.i = 0, adr.i, ll.i
Protected lbl$, splbl$, sp$, ll$, a$, aa$, asc$, tdiff$

  _EIP_ = _ORG_

  ForEach CleanSRC()
    SetLabelAdress(GetLabelLine(CleanSRC()\Label\Value),_EIP_)
    Inst    = CleanSRC()\Opcode\Key
    value   = CleanSRC()\Operand\Value
    SrcLine = CleanSRC()\RealLine
    lbl$    = CleanSRC()\Label\Value
    splbl$  = Space(#MAXCHARLABEL - Len(lbl$))
    lbl$ + splbl$

    Select CleanSRC()\IsConst
      Case 0
        PosElement = Inst - #NB_TOK
  
        If SelectElement(tOpcode(), PosElement)
          ;First, check if the lefter char of the value = "*"
          If Left(value,1) = "*"
            DEBUG_LOG("Change Value ("+value+") by "+"$"+HEXA(_EIP_,#S_WORD))
            CleanSRC()\Operand\Value = ReplaceString(value,"*","$"+HEXA(_EIP_,#S_WORD))
            value = CleanSRC()\Operand\Value
          EndIf
          
          ;display if type = Compute
          If CleanSRC()\Operand\Type = #Typ_COMPUTE
            ll$ + " (Compute)"

            posCompute = 0
            For i = 1 To Len(Value)
              a$ = Mid(Value,i,1)
              If FindString("+-*/",a$,1)
                posCompute = i
              EndIf
            Next

            mode = GenerateOpcode(Inst, Value, SrcLine, Mid(Value, 1, posCompute-1))
            ;DEBUG_LOG("Generate for value '"+value+"' and '"+Mid(Value, 1, posCompute-1)+"'")

            AddElement(ComputeLabel())
              ComputeLabel()\Index        = ListIndex(CleanSRC())
              ComputeLabel()\LabelName    = _ConstValue
              ComputeLabel()\ComputeLabel = Mid(Value, 1, posCompute-1)

              Select Mid(Value, posCompute, 1)
                Case "+"
                  typeCompute = #COMPUTE_ADD
                Case "-"
                  typeCompute = #COMPUTE_SUB
                Case "*"
                  typeCompute = #COMPUTE_MUL
                Case "/"
                  typeCompute = #COMPUTE_DIV
              EndSelect

              ComputeLabel()\TypeCompute    = typeCompute
              ComputeLabel()\ValueToCompute = Mid(Value, posCompute+1, Len(Value))
            Else
              mode = GenerateOpcode(Inst, value, SrcLine)
          EndIf

          If mode <> #NA
            TheOpcode = tOpcode()\opc_CODE[mode]
            If TheOpcode <> #NA
              CleanSRC()\DiffLine = _Difference
              ll$ = " $"+HEXA(_EIP_,#S_WORD)+": "+Hexa(TheOpcode)

              If CleanSRC()\Operand\Type = #Typ_COMPUTE
                ll$ + " (Compute)"
              EndIf

              If _Difference <> 0
                If _Difference > 0
                  tdiff$ = "+"+Str(_Difference)
                Else 
                  tdiff$ = Str(_Difference)
                EndIf
                
                ; Get address
                adr = GetLabelAdress(_ConstValue)
                ; we found an address
                If adr <> 0
                  If mode = #Mode_Rel
                    ; we calculate the difference for mode relative (BNE, BEQ, ...)
                    tdiff.i  = $ff - ((_EIP_ + 1) - adr)
                    ll$+" "+HEXA(tdiff)
                  Else
                    ; case of a jsr or jmp
                    ll$+" "+MakeHEXA("$"+HEXA(adr,#S_WORD))
                  EndIf
                Else
                  ; Just put the number of lines between
                  ll$+" "+tdiff$
                  AddElement(MissingLabel())
                    MissingLabel()\Index      = ListIndex(CleanSRC())
                    MissingLabel()\LabelName  = _ConstValue
                EndIf

              Else
                ll$+" "+MakeHEXA(_ConstValue)
              EndIf
              
              ; Just format the string for a better view
              sp$ = Space(30-Len(ll$))
              ll$ + sp$ + RSet(Str(SrcLine),4," ")+": "+lbl$+" "+tOpcode()\opc_MNEMONIC
              If _ConstValue <> ""
                ll$ +" "+value
              EndIf

              sp$ = Space(65-Len(ll$))
              ll$+sp$+"; "+tblMode(mode)
              DEBUG_LOG(ll$)

              ; Calculate len of byte by mode type and add to _EIP_
              _EIP_ + tblByteLen(mode)
            Else
              ;DEBUG_LOG(">>> Line: "+Str(SrcLine)+" -> Opcode Not Found for mode : "+tblMode(mode)+" - Opc: "+tOpcode()\opc_MNEMONIC+" "+_ConstValue)
              DEBUG_LOG(">>> Line: "+Str(SrcLine)+" -> Opcode Not Found for mode : "+tblMode(mode)+" - Opc: "+tOpcode()\opc_MNEMONIC+" "+Value)
              AddError(#ERR_UNKNOWN_MODE, SrcLine, Trim(tblMode(mode)))
            EndIf
          Else
            ;DEBUG_LOG(">>> Line: "+Str(SrcLine)+" -> Mode Not Found, Opc: "+tOpcode()\opc_MNEMONIC+" "+_ConstValue)
            DEBUG_LOG(">>> Line: "+Str(SrcLine)+" -> Mode Not Found, Opc: "+tOpcode()\opc_MNEMONIC+" "+Value)
            AddError(#ERR_UNKNOWN_MODE, SrcLine, "No mode found")
          EndIf
;         Else
;           ;DEBUG_LOG("No element for label ["+CleanSRC()\Label\Value+"] in line ["+Str(SrcLine)+"]")
        EndIf

      Case #Tok_EQUAL

      Case #Tok_ASC                  ;ascii text
        ll$ = " $"+HEXA(_EIP_,#S_WORD)+": "
        asc$ = Mid(value,2,Len(value)-2) : ll = Len(asc$)
        aa$ = ""

        If CleanSRC()\Operand\Key = #Tok_MULTI
          aa$ = "(multi) "+Left(value,13)
          ll = Len(value)
        EndIf

        For i =  1 To ll
          valasc = Asc(Mid(asc$,i,1))
          valasc = valasc | %10000000
          aa$    + HEXA(valasc) + " "
        Next i
        If Len(aa$) > 21
          aa$=Left(aa$,21)
        Else
          sp$=Space(21-Len(aa$))
          aa$+sp$
        EndIf
        DEBUG_LOG(ll$ + aa$ + " " + RSet(Str(SrcLine),4," ")+": "+lbl$+" ASC "+value)
        _EIP_ + ll
        
      Case #Tok_DA                   ;Define Adress
        ll$ = " $"+HEXA(_EIP_,#S_WORD)+": "
        aa$ = hexa(Val(value))

        If CleanSRC()\Operand\Key = #Tok_MULTI
          aa$ = "(multi) "+Left(value,13)
        EndIf

        sp$=Space(21-Len(aa$))
        aa$+sp$
        DEBUG_LOG(ll$ + aa$ + " " + RSet(Str(SrcLine),4," ")+": "+lbl$+" DA  "+value)
        _EIP_ + 1
        
      Case #Tok_DW                   ;Define Word

      Case #Tok_DFB, #Tok_DB         ;Define Byte
        ll$ = " $"+HEXA(_EIP_,#S_WORD)+": "
        aa$ = hexa(Val(value))

        If CleanSRC()\Operand\Key = #Tok_MULTI
          aa$ = "(multi) "+Left(value,13)
        EndIf

        sp$=Space(21-Len(aa$))
        aa$+sp$
        DEBUG_LOG(ll$ + aa$ + " " + RSet(Str(SrcLine),4," ")+": "+lbl$+" DFB "+value)
        _EIP_ + 1

      Case #Tok_HEX                  ;define HEX value
        ll$ = " $"+HEXA(_EIP_,#S_WORD)+": "
        aa$ = ""

        For i =  1 To Len(value) Step 2
          aa$ + UCase(Mid(value,i,2) + " ")
        Next i

        If CleanSRC()\Operand\Key = #Tok_MULTI
          aa$ = "(multi) "+Left(value,13)
        EndIf
        
        If Len(aa$) > 21
          aa$=Left(aa$,21)
        Else
          sp$=Space(21-Len(aa$))
          aa$+sp$
        EndIf
        DEBUG_LOG(ll$ + aa$ + " " + RSet(Str(SrcLine),4," ")+": "+lbl$+" HEX "+value)
        ll = Len(value) / 2
        _EIP_ + ll

      Case #Tok_DS                   ;define whatever

    EndSelect
  Next

  DEBUG_LOG("")
  DEBUG_LOG("-----------------------")
  DEBUG_LOG("")

  ForEach Label()
    ll$ = Label()\LABEL_Name
    sp$ = Space(#MAXCHARLABEL+5-Len(ll$))
    ll$ + sp$ + ": $"
    DEBUG_LOG(ll$+HEXA(Label()\LABEL_Adress,#S_WORD))
  Next

EndProcedure

Procedure.i Pass2()
Protected Inst.i = 0, value.s = "", SrcLine.i = 0, adr.i, adr2.i, val.i
Protected ll$, sp$, adr$, tc$, tmplabel$, TypLabConst$
  
  DEBUG_LOG("")
  DEBUG_LOG("-----------------------")
  DEBUG_LOG("")

  If ListSize(MissingLabel()) > 0
    ForEach MissingLabel()
      SelectElement(CleanSRC(), MissingLabel()\Index)
;       Inst    = CleanSRC()\Opcode\Key
      SrcLine = CleanSRC()\RealLine
      Value   = MissingLabel()\LabelName

      ll$ = "MissingLabel() in line: " + RSet(Str(SrcLine),4,"0")+" - Label: ["+Value+"]"
      sp$ = Space(45+#MAXCHARLABEL-Len(ll$))
      ll$ + sp$ + "Adress: $"
      adr   = GetLabelAdress(value)
      If adr <> 0
        DEBUG_LOG(ll$+HEXA(adr,#S_WORD))
      EndIf
    Next
  EndIf

  DEBUG_LOG("")
  DEBUG_LOG("-----------------------")
  DEBUG_LOG("")

  If ListSize(ComputeLabel()) > 0
    ForEach ComputeLabel()
      SelectElement(CleanSRC(), ComputeLabel()\Index)
      SrcLine = CleanSRC()\RealLine
      Value   = ComputeLabel()\LabelName

      adr$ = GetConstValue(ComputeLabel()\ComputeLabel)
      If adr$ = ""
        adr = GetLabelAdress(value)
        If adr = 0
          adr = Val(ComputeLabel()\LabelName)
        EndIf
        TypLabConst$ = "Label"
        tmplabel$ = TypLabConst$+": ["+ComputeLabel()\LabelName
      Else
        adr = Val(adr$)
        TypLabConst$ = "Const"
        tmplabel$ = TypLabConst$+": ["+ComputeLabel()\ComputeLabel
      EndIf

      adr2 = GetLabelAdress(ComputeLabel()\ValueToCompute)
      If adr2 = 0
        adr2 = Val(ComputeLabel()\ValueToCompute)
      EndIf

      ll$ = "Compute "+TypLabConst$+" in line:  " + RSet(Str(SrcLine),4,"0")+" - "+tmplabel$+"]"
      sp$ = Space(45+#MAXCHARLABEL-Len(ll$))
      ll$ + sp$

      If adr >= 0
        Select ComputeLabel()\TypeCompute
          Case #COMPUTE_ADD
            tc$ = "ADD"
            val = adr + adr2
          Case #COMPUTE_SUB
            tc$ = "SUB"
            val = adr - adr2
          Case #COMPUTE_MUL
            tc$ = "MUL"
            val = adr * adr2
          Case #COMPUTE_DIV
            tc$ = "DIV"
            val = adr / adr2
        EndSelect

        DEBUG_LOG(ll$+tc$+" $"+HEXA(adr2,#S_WORD)+" To $"+HEXA(adr,#S_WORD)+" ==> $"+hexa(val,#S_WORD))
      EndIf
    Next
  EndIf

EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 474
; FirstLine = 441
; Folding = ---
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant