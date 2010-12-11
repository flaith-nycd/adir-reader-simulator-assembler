;-Structures

;-Token
Structure sClassToken
  Type.i                              ; KEYWORD or STRING or INT or LABEL or CONST
  Key.i                               ; If it's a KeyWord
  Value.s                             ; Value
  ByteSize.i
  Pos.i                               ; Pos of the Token (1:Label or Const - 2:Keyword or EQU - 3:Value)
  AdressingMode.i
EndStructure

Structure sTOKEN
  TokA.sClassToken
  TokB.sClassToken
  TokC.sClassToken
  TokLabel.i                          ; Is there a label for this line ?
  TokLine.i                           ; Line in the original source (for showing the rerrors)
EndStructure

;-Label
Structure sLABEL
  LABEL_Name.s
  LABEL_Line.i
  LABEL_Adress.i                      ; Hex value of the adress
EndStructure

;-Constant
Structure sCONST
  CONST_Name.s
  CONST_Line.i
  CONST_Value.s
EndStructure

;-Symbol table
Structure sSYMBOL
  ST_Name.s                           ; Name of the symbol (Label or Constant)
  ST_Value.i                          ; Hex Adress or Value
  ST_Used.i                           ; Has it been used ?
EndStructure

;-Opcode
Structure sOPCODE
  opc_MNEMONIC.s                      ; Mnemonic
  opc_DESCRIPTION.s                   ; Description of the Mnemonic
  opc_CODE.i[#NB_MODE_OPC]            ; List of different OpCode
EndStructure

; POP/PUSH EIP for 'DS'
Structure sEIPDS
  EIP.i
  DS_VALUE.i
EndStructure

;-Source
Structure sSOURCE
  line.i
  text.s
  address.i
  totalByte.i
  List Opcode.i()
EndStructure

Structure SCLEANSOURCE
  IsConst.i
  RealLine.i
  Label.sClassToken
  Opcode.sClassToken
  Operand.sClassToken
  DiffLine.i
EndStructure

;Missing Label
Structure sMISSING
  Index.i
  LabelName.s
EndStructure

Structure sCOMPUTE
  Index.i
  LabelName.s
  ComputeLabel.s
  TypeCompute.i
  ValueToCompute.s
EndStructure

;-List Error
Structure sListError
  num.i
  line.i
  value1.s
  value2.s
EndStructure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 48
; FirstLine = 16
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant