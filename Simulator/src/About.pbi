; ABOUT
; Useful Links:
; How To Write a Computer Emulator : http://fms.komkon.org/EMUL8/HOWTO.html
; http://marcfiasse.com/micro/6502_apple/index.htm
; http://www.home.earthlink.net/~hxa/docs/p65c02.htm
; http://www.home.earthlink.net/~hxa/docs/p65c02.htm
; http://www.baltissen.org/newhtm/rb6502.htm
; http://www.akk.org/~flo/6502%20OpCode Disass.pdf
;
; **** Carry & overflow flags ****
; http://forum.6502.org/viewtopic.php?t=62
;
; **** ADC - SBC ****
; http://forum.6502.org/viewtopic.php?t=465
; http://forum.6502.org/viewtopic.php?t=475
; http://forum.6502.org/viewtopic.php?t=1280
;
; Status Flags
; ------------
; The 65C02 status flags are the same As the 6502 status flags, but their operation has been enhanced.
;
; Status Flags Register
; Bit 	7 	6 	5 	4 	3 	2 	1 	0
; Flag 	N 	V 	- 	B 	D 	I 	Z 	C
; 
; Symbol 	Name 	                  Clear (=0) 	                    Set (=1)
;  N/S	  Sign 	                Result is Positive 	            Result is Negative
;   V 	  Overflow 	            No Signed Arithmetic Overflow 	Signed Arithmetic Overflow
;   B 	  Break 	              No Software Break Occurred 	    Software Break Occurred
;   D 	  Decimal Mode 	        Binary Arithmetic Enabled 	    BCD Arithmetic Enabled
;   I 	  Interrupt Disable     Maskable IRQs Enabled 	        Maskable IRQs Disabled
;   Z 	  Zero 	                Result is Not Zero 	            Result is Zero
;   C 	  Carry 	              No Carryout/Borrow Required 	  Carryout/No Borrow Required
;
; Notes:
; ------
;   6502/65C02 :
;           Après une soustraction le flag C est effacé si une retenue est requise, sinon il est mis à 1
;           Après un IRQ ou NMI le flag B est effacé; après une instructon BRK il est mis à 1
;   6502  : Les flags N, V et Z sont invalides en mode decimal
;           Le flag D est indéterminé après un reset du processeur
;           Le flag D n'est pas modifié par les interruptions
;   65C02 : Les flags N, V et Z sont valides en mode decimal;   
;           Le flag D est effacé après un reset du processeur
;           Le flag D est effacé par les interruptions
;------------------------------------------------------------------------------------------
; Apple IIe Memory Map
; $FFFF - $D000 Bank Switched RAM |                                                  ROM
; $CFFF - $C000                  |                                      I/O Devices
; $BFFF - $6000 RAM              |
; $5FFF - $4000 RAM              | Hi-res Graphics Page 2 Display 		
; $3FFF - $2000 RAM              | Hi-res Graphics Page 1 Display 		
; $1FFF - $0C00 RAM              |
; $0BFF - $0800 RAM              | Text/Lo-res Graphics Page 2 Display
; $07FF - $0400 RAM              | Text/Lo-res Graphics Page 1 Display  I/O Devices
; $03FF - $0300 RAM Vectors      |
; $02FF - $0200 RAM Input Buffer |
; $01FF - $0100 RAM 6502 Stack   |
; $0000 - $00FF RAM Zero Page    |
;------------------------------------------------------------------------------------------
;NB: Concernant les couleurs sur Apple (plus d'info sur http://www.apple2.org.za/gswv/a2zine/GS.WorldView/Resources/APPLESOFT/hires.txt)
; les colonnes paires (EVEN) sont de couleur Violette ou Bleue
; les colonnes impaires (ODD) sont de couleur Verte ou Orange
; Admettons que l'on fasse ceci (colonne paire):
;
;     ]HGR:HCOLOR=3:HPLOT 0,0 TO 0,191
;
; le résultat est une ligne violette verticale
;
; si on fait (colonne impaire):
;
;     ]HGR:HCOLOR=3:HPLOT 1,0 TO 1,191
;
; le résultat est une ligne verte verticale
;
; Pour avoir du blanc il faut faire ainsi :
;
;     ]HGR:HCOLOR=1:HPLOT 1,0 TO 1,191:REM Ligne verte
;     ]HCOLOR=2:HPLOT 0,0 To 0,191:REM Ajout d'une ligne violette donne une ligne blanche

; IDE Options = PureBasic 4.51 (Windows - x86)
; EnableXP
; DisableDebugger
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0