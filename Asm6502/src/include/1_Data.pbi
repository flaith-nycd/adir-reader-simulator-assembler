DataSection
  dataMode:
    Data.s "Accumulator                      "
    Data.s "Immediate                        "
    Data.s "Zero Page                        "
    Data.s "Zero Page X-Indexed              "
    Data.s "Zero Page Y-Indexed              "
    Data.s "Absolute                         "
    Data.s "Absolute X-Indexed               "
    Data.s "Absolute Y-Indexed               "
    Data.s "Implied                          "
    Data.s "Relative                         "
    Data.s "Zero Page Indexed Indirect       "
    Data.s "Zero Page Indirect Indexed       "
    Data.s "Absolute Indirect                "
    Data.s "Absolute Indexed Indirect (65C02)"
    Data.s "Zero Page Indirect (65C02)       "

  dToken:
    Data.s "ORG","EQU","EPZ","=","LST","AST","ASC","DFB","HEX","DA","DB","DW","DS"
    Data.s "@@@"

  dByteLen_65C02:
    ; Mode 						            #Bytes
    
    ; Accumulator					        1
    ; Immediate					          2
    ; Zero Page					          2
    ; Zero Page X-Indexed			    2
    ; Zero Page Y-Indexed		    	2
    ; Absolute					          3
    ; Absolute X-Indexed			    3
    ; Absolute Y-Indexed			    3
    ; Implied						          1
    ; Relative					          2
    ; Zero Page Indexed Indirect	2
    ; Zero Page Indirect Indexed	2
    ; Absolute Indirect			      3
    ; Absolute Indexed Indirect   3
    ; Zero Page Indirect			    2
    Data.i 1,2,2,2,2,3,3,3,1,2,2,2,3,3,2

  dOpcode_65C02:
    ;Instruction Set Opcodes ----> http://www.home.earthlink.net/~hxa/docs/p65c02.htm#l04
    ;
    ;      Acc Imm ZP ZP,X ZP,Y Abs Abs,X Abs,Y Imp Rel (ZP,X) (ZP),Y (Abs) (Abs,X) (ZP)
    Data.s "ADC","Add Memory to Accumulator with Carry"
    Data.i #NA,$69,$65,$75,#NA,$6D,$7D,$79,#NA,#NA,$61,$71,#NA,#NA,$72
    Data.s "AND","'AND' Memory with Accumulator"
    Data.i #NA,$29,$25,$35,#NA,$2D,$3D,$39,#NA,#NA,$21,$31,#NA,#NA,$32
    Data.s "ASL","Shift Left One Bit (Memory or Accumulator)"
    Data.i $0A,#NA,$06,$16,#NA,$0E,$1E,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "BCC","Branch on Carry Clear"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$90,#NA,#NA,#NA,#NA,#NA
    Data.s "BCS","Branch on Carry Set"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$B0,#NA,#NA,#NA,#NA,#NA
    Data.s "BEQ","Branch on Result Equal or on Result Zero"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$F0,#NA,#NA,#NA,#NA,#NA
    Data.s "BIT","test BITs  in Memory with Accumulator"
    Data.i #NA,$89,$24,$34,#NA,$2C,$3C,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "BMI","Branch on Result MInus"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$30,#NA,#NA,#NA,#NA,#NA
    Data.s "BNE","Branch on Result not Equal or on Result not Zero"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$D0,#NA,#NA,#NA,#NA,#NA
    Data.s "BPL","Branch on Result PLus"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$10,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "BRA","BRanch Always"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$80,#NA,#NA,#NA,#NA,#NA
    Data.s "BRK","Force Break"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$00,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "BVC","Branch on oVerflow Clear"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$50,#NA,#NA,#NA,#NA,#NA
    Data.s "BVS","Branch on oVerflow Set"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$70,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "CLC","CLear Carry Flag"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$18,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "CLD","CLear Decimal Mode"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$D8,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "CLI","CLear Interrupt Disable Bit"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$58,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "CLV","CLear oVerflow Flag"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$B8,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "CMP","Compare Memory and Accumulator"
    Data.i #NA,$C9,$C5,$D5,#NA,$CD,$DD,$D9,#NA,#NA,$C1,$D1,#NA,#NA,$D2
    Data.s "CPX","Compare Memory and Index X"
    Data.i #NA,$E0,$E4,#NA,#NA,$EC,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "CPY","Compare Memory and Index Y"
    Data.i #NA,$C0,$C4,#NA,#NA,$CC,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "DEC","DECrement memory by one"
    Data.i $3A,#NA,$C6,$D6,#NA,$CE,$DE,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "DEX","DEcrement X by one"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$CA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "DEY","DEcrement Y by one"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$88,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "EOR","'Exclusive-Or' Memory with Accumulator"
    Data.i #NA,$49,$45,$55,#NA,$4D,$5D,$59,#NA,#NA,$41,$51,#NA,#NA,$52
    ;
    Data.s "INC","INCrement memory by one"
    Data.i $1A,#NA,$E6,$F6,#NA,$EE,$FE,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "INX","INcrement X by one"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$E8,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "INY","INcrement Y by one"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$C8,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "JMP","Jump to New Location"
    Data.i #NA,#NA,#NA,#NA,#NA,$4C,#NA,#NA,#NA,#NA,#NA,#NA,$6C,$7C,#NA
    Data.s "JSR","Jump to New Location Saving Return Addres"
    Data.i #NA,#NA,#NA,#NA,#NA,$20,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "LDA","LoaD Accumulator with memory"
    Data.i #NA,$A9,$A5,$B5,#NA,$AD,$BD,$B9,#NA,#NA,$A1,$B1,#NA,#NA,$B2
    Data.s "LDX","LoaD X register with memory"
    Data.i #NA,$A2,$A6,#NA,$B6,$AE,#NA,$BE,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "LDY","LoaD Y register with memory"
    Data.i #NA,$A0,$A4,$B4,#NA,$AC,$BC,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "LSR","Shift Right One Bit (Memory or Accumulator) "
    Data.i $4A,#NA,$46,$56,#NA,$4E,$5E,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "NOP","No OPeration"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$EA,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "ORA","'OR' Memory with Accumulator"
    Data.i #NA,$09,$05,$15,#NA,$0D,$1D,$19,#NA,#NA,$01,$11,#NA,#NA,$12
    ;
    Data.s "PHA","PusH Accumulator on stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$48,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "PHP","PusH Processor status flag on stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$08,#NA,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "PHX","PusH X-register on stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$DA,#NA,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "PHY","PusH Y-register on stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$5A,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "PLA","PuLl Accumulator from stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$68,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "PLP","PuLl Processor status flag from stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$28,#NA,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "PLX","PuLl X-register from stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$FA,#NA,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "PLY","PuLl Y-register from stack"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$7A,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "ROL","Rotate One Bit Left (Memory or Accumulator)"
    Data.i $2A,#NA,$26,$36,#NA,$2E,$3E,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "ROR","Rotate One Bit Right (Memory or Accumulator)"
    Data.i $6A,#NA,$66,$76,#NA,$6E,$7E,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "RTI","ReTurn from Interrupt"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$40,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "RTS","ReTurn from Subroutine"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$60,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "SBC","Subtract Memory from Accumulator with Carry (Borrow)"
    Data.i #NA,$E9,$E5,$F5,#NA,$ED,$FD,$F9,#NA,#NA,$E1,$F1,#NA,#NA,$F2
    Data.s "SEC","SEt Carry Flag"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$38,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "SED","SEt Decimal Mode"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$F8,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "SEI","Set Interrupt Disable Status"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$78,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "STA","STore Accumulator in Memory"
    Data.i #NA,#NA,$85,$95,#NA,$8D,$9D,$99,#NA,#NA,$81,$91,#NA,#NA,$92
    Data.s "STX","STore Index X in Memory"
    Data.i #NA,#NA,$86,#NA,$96,$8E,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "STY","STore Index Y in Memory"
    Data.i #NA,#NA,$84,$94,#NA,$8C,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "STZ","Store zero to memory"
    Data.i #NA,#NA,$64,$74,#NA,$9C,$9E,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    ;
    Data.s "TAX","Transfer Accumulator to Index X"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$AA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "TAY","Transfer Accumulator to Index Y"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$A8,#NA,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "TRB","Test and Reset Bits"
    Data.i #NA,#NA,$14,#NA,#NA,$1C,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    ;65C02
    Data.s "TSB","Test and Set Bits"
    Data.i #NA,#NA,$04,#NA,#NA,$0C,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "TSX","Transfer Stack Pointer to Index X "
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$BA,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "TXA","Transfer Index X to Accumulator"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$8A,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "TXS","Transfer Index X to Stack Pointer"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$9A,#NA,#NA,#NA,#NA,#NA,#NA
    Data.s "TYA","Transfer Index Y to Accumulator"
    Data.i #NA,#NA,#NA,#NA,#NA,#NA,#NA,#NA,$98,#NA,#NA,#NA,#NA,#NA,#NA
    
    Data.s "@@@"

EndDataSection

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 22
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant