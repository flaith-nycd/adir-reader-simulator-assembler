;-----------------------------------------------------------------------
;-Instruction Set Mnemonics
Procedure CLN()
  ClearSign_N()
EndProcedure
; Clear Overflow Flag
Procedure CLV()
  CallAdrMode(Opcode)
  ClearOverflow_V()
  ShowStatus("CLV")
EndProcedure
; Clear Break Flag
Procedure CLB()
  ClearBreak_B()
EndProcedure
; Clear Decimal Flag
Procedure CLD()
  CallAdrMode(Opcode)
  ClearDecimal_D()
  ShowStatus("CLD")
EndProcedure
; Clear Interrupt disable Flag
Procedure CLI()
  CallAdrMode(Opcode)
  ClearInterrupt_I()
  ShowStatus("CLI")
EndProcedure
; Clear Zero Flag
Procedure CLZ()
  ClearZero_Z()
EndProcedure
; Clear Carry Flag
Procedure CLC()
  CallAdrMode(Opcode)
  ClearCarry_C()
  ShowStatus("CLC")
EndProcedure
;-----------------------------------------------------------------------
; Set Sign Flag
Procedure SEN()
  SetSign_N()
EndProcedure
; Set Overflow Flag
Procedure SEV()
  SetOverflow_V()
EndProcedure
; Set Break Flag
Procedure SEB()
  SetBreak_B()
EndProcedure
; Set Decimal Flag
Procedure SED()
  CallAdrMode(Opcode)
  SetDecimal_D()
  ShowStatus("SED")
EndProcedure
; Set Interrupt disable Flag
Procedure SEI()
  CallAdrMode(Opcode)
  SetInterrupt_I()
  ShowStatus("SEI")
EndProcedure
; Set Zero Flag
Procedure SEZ()
  SetZero_Z()
EndProcedure
; Set Carry Flag
Procedure SEC()
  CallAdrMode(Opcode)
  SetCarry_C()
  ShowStatus("SEC")
EndProcedure
;-----------------------------------------------------------------------
;De $00 à $7F représente 0 à 127 et $80 à $FF représente -128 à -1
;Après une instruction ADC ou SBC, le flag N est effacé quand le résultat n'est pas négatif (0 à 127 / $00 à $7F)
;et il est mit quand le résultat est négatif (-128 à -1 / $80 à $FF),
;et le flag V est effacé quand le résultat est compris entre -128 et 127 ($80 et $7F)
;et posé quand le résultat est en dehors de cet interval.
Procedure ADC()
  Protected.a _aValue, _aLow, _aHigh
  Protected.a _aSaveFlag = Registers\P\Flag & #Flag_Carry
  Protected.u _uSum
  Protected.w _wSum
  Protected.b _bAcc = Registers\A, _bValue
  
  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory) : _bValue = _aValue
  ; Vérifie la somme pour le mode Overflow (en additionnant que des octets
  _wSum = _bAcc + _bValue + _aSaveFlag
  ; Si la somme est > 127 ou < -128 alors le flag Overflow est mis (enlevé dans le cas contraire)
  If _wSum > $7F Or _wSum <-$80 : SetOverflow_V() : Else : ClearOverflow_V() : EndIf
  ; Vérifie pour le débordement (Carry)
  _uSum = Registers\A + _aValue + _aSaveFlag
  ; Quand le résultat de l'addition est entre 0 à 255, la retenue est effacée
  ; Sinon la retenue (carry) est posée (> 255)
  If _uSum > $FF : SetCarry_C() : Else : ClearCarry_C() : EndIf
  Registers\A = _uSum

  ;Mode decimal ?
  If registers\P\Flag & #Flag_Decimal = #Flag_Decimal
    ClearCarry_C()
    ; Récupère partie basse de l'octet dans l'accumulateur
    _aLow  = (Registers\A & %00001111)
    ; Récupère partie haute de l'octet
    _aHigh = (Registers\A & %11110000)
    ; Si valeur basse de l'octet est >= à 9
    ; on ajoute 6
    If _aLow >= $09 : Registers\A + $06 : EndIf
    ; et si la valeur de la partie haute est > à 144 ($90)
    ; on ajoute 96 et on pose la retenue
    If _aHigh>= $90 : Registers\A + $60 : SetCarry_C() : EndIf
  EndIf

  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("ADC")
EndProcedure

Procedure AND_()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  Registers\A & _aValue
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("AND")
EndProcedure

Procedure ASL()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  CheckCarryLeft(_aValue)
  _aValue << 1
  _aValue & #Mask_Carry ;bit 0 = 0
  CheckSign(_aValue)
  ShowStatus("ASL")
EndProcedure

Procedure ASL_A()
  CallAdrMode(Opcode)
  CheckCarryLeft(Registers\A)
  Registers\A << 1
  Registers\A & #Mask_Carry ;bit 0 = 0
  CheckSign(Registers\A)
  ShowStatus("ASL")
EndProcedure

Procedure BCC()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Carry = 0
    Registers\PC + Memory
  EndIf

  ShowStatus("BCC")
EndProcedure

Procedure BCS()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Carry
    Registers\PC + Memory
  EndIf

  ShowStatus("BCS")
EndProcedure

Procedure BIT()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  If _aValue & Registers\A : ClearZero_Z() : Else : SetZero_Z() : EndIf
  
  registers\P\Flag = (registers\P\Flag & (#Mask_Sign & #Mask_Overflow)) | (_aValue & (#Flag_Sign | #Flag_Overflow))

  ShowStatus("BIT")
EndProcedure

Procedure BIT_A()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  If Registers\A & _aValue : ClearZero_Z() : Else : SetZero_Z() : EndIf

  ; the BIT immediate instruction does Not change P[N] Or P[V]
  ShowStatus("BIT")
EndProcedure

Procedure BEQ()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Zero
    Registers\PC + Memory
  EndIf

  ShowStatus("BEQ")
EndProcedure

Procedure BMI()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Sign
    Registers\PC + Memory
  EndIf

  ShowStatus("BMI")
EndProcedure

Procedure BNE()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Zero = 0
    Registers\PC + Memory
  ;Else
    ; pas la peine, on incrémente déja dans mode relative
    ;Registers\PC + 1
  EndIf

  ShowStatus("BNE")
EndProcedure

Procedure BPL()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Sign = 0
    Registers\PC + Memory
  EndIf

  ShowStatus("BPL")
EndProcedure

Procedure BRA()
  CallAdrMode(Opcode)
  Registers\PC + Memory
  ShowStatus("BRA")
EndProcedure

Procedure BRK()
  CallAdrMode(Opcode)
  Registers\PC + 1
  PushStack(Registers\PC >> 8)
  PushStack(Registers\PC & $FF)
  PushStack(Registers\P\Flag)
  Registers\P\Flag | (#Flag_Interrupt | #Flag_Break)
  Registers\PC = GetMemory_6502($FFFC) | GetMemory_6502($FFFD) << 8
  ShowStatus("BRK")
EndProcedure

Procedure BVC()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Overflow = 0
    Registers\PC + Memory
  EndIf

  ShowStatus("BVC")
EndProcedure

Procedure BVS()
  CallAdrMode(Opcode)
  If Registers\P\Flag & #Flag_Overflow
    Registers\PC + Memory
  EndIf

  ShowStatus("BVC")
EndProcedure

; Compare Instruction Results
; Compare Result        N Z C
; A, X, Or Y < Memory   * 0 0
; A, X, Or Y = Memory   0 1 1
; A, X, Or Y > Memory   * 0 1
; * The N flag will be bit 7 of A, X, Or Y - Memory 
Procedure CMP()
  Protected.a _aValue, _aResultSubstract

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  CMPREG(A, _aValue)

  ShowStatus("CMP")
EndProcedure

Procedure CPX()
  Protected.a _aValue, _aResultSubstract

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  CMPREG(X, _aValue)
  
  ShowStatus("CPX")
EndProcedure

Procedure CPY()
  Protected.a _aValue, _aResultSubstract

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  CMPREG(Y, _aValue)

  ShowStatus("CPY")
EndProcedure

Procedure DEC()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory) - 1
  PutMemory_6502(Memory, _aValue)
  CheckSign(_aValue) : CheckZero(_aValue)
  ShowStatus("DEC")
EndProcedure

Procedure DEC_A()
  CallAdrMode(Opcode)
  Registers\A - 1
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("INC")
EndProcedure

Procedure DEX()
  CallAdrMode(Opcode)
  Registers\X - 1
  CheckSign(Registers\X) : CheckZero(Registers\X)
  ShowStatus("DEX")
EndProcedure

Procedure DEY()
  CallAdrMode(Opcode)
  Registers\Y - 1
  CheckSign(Registers\Y) : CheckZero(Registers\Y)
  ShowStatus("DEY")
EndProcedure

Procedure EOR()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  Registers\A ! _aValue
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("EOR")
EndProcedure

Procedure INC()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory) + 1
  PutMemory_6502(Memory, _aValue)
  CheckSign(_aValue) : CheckZero(_aValue)
  ShowStatus("INC")
EndProcedure

Procedure INC_A()
  CallAdrMode(Opcode)
  Registers\A + 1
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("INC")
EndProcedure

Procedure INX()
  CallAdrMode(Opcode)
  Registers\X + 1
  CheckSign(Registers\X) : CheckZero(Registers\X)
  ShowStatus("INX")
EndProcedure

Procedure INY()
  CallAdrMode(Opcode)
  Registers\Y + 1
  CheckSign(Registers\Y) : CheckZero(Registers\Y)
  ShowStatus("INY")
EndProcedure

Procedure JSR()
  Protected.a _aValue

  Registers\PC + 1
  PushStack(Registers\PC >> 8)
  PushStack(Registers\PC & $FF)
  Registers\PC - 1

  CallAdrMode(Opcode)
  Registers\PC = Memory
  ShowStatus("JSR")
EndProcedure

Procedure JMP()
  Protected.a _aValue

  CallAdrMode(Opcode)
  Registers\PC = Memory
  ShowStatus("JMP")
EndProcedure

Procedure LDA()
  CallAdrMode(Opcode)
  Registers\A = GetMemory_6502(Memory)
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("LDA")
EndProcedure

Procedure LDX()
  CallAdrMode(Opcode)
  Registers\X = GetMemory_6502(Memory)
  CheckSign(Registers\X) : CheckZero(Registers\X)
  ShowStatus("LDX")
EndProcedure

Procedure LDY()
  CallAdrMode(Opcode)
  Registers\Y = GetMemory_6502(Memory)
  CheckSign(Registers\Y) : CheckZero(Registers\Y)
  ShowStatus("LDY")
EndProcedure

Procedure LSR()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  CheckCarryRight(_aValue)
  _aValue >> 1
  _aValue & #Mask_Sign ;bit 7 = 0
  ; même si LSR ne met jamais le signe N, on verifie pour le mettre à zéro
  CheckSign(_aValue)
  ShowStatus("LSR")
EndProcedure

Procedure LSR_A()
  CallAdrMode(Opcode)
  CheckCarryRight(Registers\A)
  Registers\A >> 1
  Registers\A & #Mask_Sign ;bit 7 = 0
  ; même si LSR ne met jamais le signe N, on verifie pour le mettre à zéro
  CheckSign(Registers\A)
  ShowStatus("LSR")
EndProcedure

Procedure NOP()
  CallAdrMode(Opcode)
  ShowStatus("NOP")
EndProcedure

Procedure ORA()
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  Registers\A | _aValue
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("ORA")
EndProcedure

Procedure PHA()
  CallAdrMode(Opcode)
  PushStack(Registers\A)
  ShowStatus("PHA")
EndProcedure

Procedure PHP()
  CallAdrMode(Opcode)
  PushStack(Registers\P\Flag)
  ShowStatus("PHP")
EndProcedure

Procedure PHX()
  CallAdrMode(Opcode)
  PushStack(Registers\X)
  ShowStatus("PHX")
EndProcedure

Procedure PHY()
  CallAdrMode(Opcode)
  PushStack(Registers\Y)
  ShowStatus("PHY")
EndProcedure

Procedure PLA()
  CallAdrMode(Opcode)
  Registers\A = PopStack()
  ShowStatus("PLA")
EndProcedure

Procedure PLP()
  CallAdrMode(Opcode)
  Registers\P\Flag = PopStack()
  ShowStatus("PLP")
EndProcedure

Procedure PLX()
  CallAdrMode(Opcode)
  Registers\X = PopStack()
  ShowStatus("PLX")
EndProcedure

Procedure PLY()
  CallAdrMode(Opcode)
  Registers\Y = PopStack()
  ShowStatus("PLY")
EndProcedure

Procedure ROL(__Value.i)
  ;Sauve la retenue dans une variable temporaire
  Protected.a _aCarry = Registers\P\Flag & #Flag_Carry
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  ;On vérifie s'il va y avoir une retenue avant la rotation
  ;Si c'est le cas, on met la retenue, sinon on l'enlève
  CheckCarryLeft(_aValue)
  ;on fait la rotation
  _aValue << 1
  ;Si la sauvegarde de la retenue = 1 on l'ajoute dans l'accumulateur
  If _aCarry = 1
    _aValue | #Flag_Carry ;bit 0 à 1
  Else
    _aValue & #Mask_Carry ;bit 0 à 0
  EndIf
  CheckSign(_aValue)
  ShowStatus("ROL")
EndProcedure

Procedure ROL_A()
  ;Sauve la retenue dans une variable temporaire
  Protected.a _aCarry = Registers\P\Flag & #Flag_Carry

  CallAdrMode(Opcode)
  ;On vérifie s'il va y avoir une retenue avant la rotation
  ;Si c'est le cas, on met la retenue, sinon on l'enlève
  CheckCarryLeft(Registers\A)
  ;on fait la rotation
  Registers\A << 1
  ;Si la sauvegarde de la retenue = 1 on l'ajoute dans l'accumulateur
  If _aCarry = 1
    Registers\A | #Flag_Carry ;bit 0 à 1
  Else
    Registers\A & #Mask_Carry ;bit 0 à 0
  EndIf
  CheckSign(Registers\A)
  ShowStatus("ROL")
EndProcedure

Procedure ROR()
  Protected.a _aCarry = Registers\P\Flag & #Flag_Carry
  Protected.a _aValue

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory)
  CheckCarryRight(_aValue)
  _aValue >> 1
  If _aCarry = 1
    _aValue | #Flag_Sign ;bit 7 à 1
    ; le Bit 7 étant à 1, alors le bit Signe sera mis à 1 aussi
    ; pas la peine de lancer la macro CheckCheckSign()
    Registers\P\Flag | #Flag_Sign
  Else
    _aValue & #Mask_Sign ;bit 7 à 0
    Registers\P\Flag & #Mask_Sign
  EndIf
  ;CheckSign() Initule car verif ci-dessus
  ShowStatus("ROR")
EndProcedure

Procedure ROR_A()
  Protected.a _aCarry = Registers\P\Flag & #Flag_Carry

  CallAdrMode(Opcode)
  CheckCarryRight(Registers\A)
  Registers\A >> 1
  If _aCarry = 1
    Registers\A | #Flag_Sign ;bit 7 à 1
    ; le Bit 7 étant à 1, alors le bit Signe sera mis à 1 aussi
    ; pas la peine de lancer la macro CheckCheckSign()
    Registers\P\Flag | #Flag_Sign
  Else
    Registers\A & #Mask_Sign ;bit 7 à 0
    Registers\P\Flag & #Mask_Sign
  EndIf
  ;CheckSign() Initule car verif ci-dessus
  ShowStatus("ROR")
EndProcedure

Procedure RTS()
  CallAdrMode(Opcode)
  Registers\PC = PopStack()
  Registers\PC | (PopStack() << 8)
  Registers\PC + 1

  ShowStatus("RTS")
EndProcedure

Procedure SBC()
  Protected.a _aValue, _aLow, _aHigh
  Protected.a _aSaveFlag = 1 - (Registers\P\Flag & #Flag_Carry)       ;Récupère l'opposé du Carry
  Protected.u _uSum
  Protected.w _wSum
  Protected.b _bAcc = Registers\A, _bValue, _bSum

  CallAdrMode(Opcode) : _aValue = GetMemory_6502(Memory) : _bValue = _aValue
  ; Vérifie la somme pour le mode Overflow
  _wSum = _bAcc - _bValue - _aSaveFlag
  ; Si la somme est > 127 ou < -128 alors le flag Overflow est mis (enlevé dans le cas contraire)
  If _wSum > $7F Or _wSum <-$80 : SetOverflow_V() : Else : ClearOverflow_V() : EndIf
  ; Vérifie pour le débordement (Carry)
  _uSum = Registers\A - _aValue - _aSaveFlag
  ; Quand le résultat de la soustraction est entre 0 et 255, la retenue est possée (Carry = 1)
  ; Sinon la retenue est effacée (si < 0)
  If _uSum > $FF : ClearCarry_C() : Else : SetCarry_C() : EndIf
  Registers\A = _uSum

  ;Mode decimal ?
  If registers\P\Flag & #Flag_Decimal = #Flag_Decimal
    Registers\A - $66
    ClearCarry_C()
    ; Récupère partie basse de l'octet dans l'accumulateur
    _aLow  = (Registers\A & %00001111)
    ; Récupère partie haute de l'octet
    _aHigh = (Registers\A & %11110000)
    ; Si valeur basse de l'octet est >= à 9
    ; on ajoute 6
    If _aLow >= $09 : Registers\A + $06 : EndIf
    ; et si la valeur de la partie haute est > à 144 ($90)
    ; on ajoute 96 et on pose la retenue
    If _aHigh>= $90 : Registers\A + $60 : SetCarry_C() : EndIf
  EndIf

  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("SBC")
EndProcedure

Procedure STA()
  CallAdrMode(Opcode)
  PutMemory_6502(Memory, Registers\A)
  ShowStatus("STA")
EndProcedure

Procedure STX()
  CallAdrMode(Opcode)
  PutMemory_6502(Memory, Registers\X)
  ShowStatus("STX")
EndProcedure

Procedure STY()
  CallAdrMode(Opcode)
  PutMemory_6502(Memory, Registers\Y)
  ShowStatus("STY")
EndProcedure

Procedure STZ()
  CallAdrMode(Opcode)
  PutMemory_6502(Memory, $00)
  ShowStatus("STZ")
EndProcedure

Procedure TAX()
  CallAdrMode(Opcode)
  Registers\X = Registers\A
  CheckSign(Registers\X) : CheckZero(Registers\X)
  ShowStatus("TAX")
EndProcedure

Procedure TAY()
  CallAdrMode(Opcode)
  Registers\Y = Registers\A
  CheckSign(Registers\Y) : CheckZero(Registers\Y)
  ShowStatus("TAY")
EndProcedure

;-TO DO
Procedure TRB()
  CallAdrMode(Opcode)
  ShowStatus("TRB")
EndProcedure

;-TO DO
Procedure TSB()
  CallAdrMode(Opcode)
  ShowStatus("TSB")
EndProcedure

Procedure TSX()
  CallAdrMode(Opcode)
  Registers\X = Registers\S
  CheckSign(Registers\X) : CheckZero(Registers\X)
  ShowStatus("TSX")
EndProcedure

Procedure TXA()
  CallAdrMode(Opcode)
  Registers\A = Registers\X
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("TXA")
EndProcedure

Procedure TYA()
  CallAdrMode(Opcode)
  Registers\A = Registers\Y
  CheckSign(Registers\A) : CheckZero(Registers\A)
  ShowStatus("TYA")
EndProcedure

Procedure TXS()
  CallAdrMode(Opcode)
  Registers\S = Registers\X
  CheckSign(Registers\S) : CheckZero(Registers\S)
  ShowStatus("TXS")
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 68
; FirstLine = 27
; Folding = -------------
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant