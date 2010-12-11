; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***        CATALOG GUI        ***
; ***                           ***
; *********************************
Procedure.l ADD_Line_CAT(line.s,type.l)
Protected aa.l, i.l, PosX.l, pos_car.l, line_pos_car.l, colonne_pos_car.l
Protected x.l, y.l

  aa = CreateImage(#PB_Any,#CHAR_W * 37,#CHAR_H + 6)        ; 37 car c'est la largeur maxi du filename (30) + nblock (3) + espace(2) + lock (1) + type (1)
                                                            ; + 6 pour enlever le maximum de couleur de la ligne sélectionnée

  If aa
    Posx = 0
    For i = 1 To Len(line)
      a$=Mid(line,i,1)
      pos_car = Asc(a$)-32
      Line_pos_car = pos_car / 16                           ; recupère la ligne ou se trouve le caractère
      If Line_pos_car > 0
        colonne_pos_car = pos_car - (Line_pos_car * 16)     ; recupère la colonne
      Else
        colonne_pos_car = pos_car
      EndIf
      
;       line_pos_car + 6                                      ; pour car inverse
  
      x = colonne_pos_car * #CHAR_W : y = Line_pos_car * #CHAR_H
      If GrabImage(#IMG_CHAR_40,#IMG_CHAR_TMP,x,y,#CHAR_W,#CHAR_H)
        StartDrawing(ImageOutput(aa))
          DrawImage(ImageID(#IMG_CHAR_TMP),PosX,3)               ; 3 est la moitié de 6 (pour la ligne sélectionnée)
          PosX + #CHAR_W
        StopDrawing()
      Else
        ADIR_Error("",#ERR_GRAB_IMG)
      EndIf
    Next i
  Else
    ADIR_Error("",#ERR_CREATE_IMG)
  EndIf
  
  ProcedureReturn aa
EndProcedure

Procedure.l ADD_List_CAT(Texte.s)
  AddGadgetItem(#CATALOG, -1, Texte)
EndProcedure

Procedure GUI_CATALOG()
  If OpenDSK() > 0
    ClearGadgetItems(#CATALOG)
    SetGadgetText(#TEXT_DISK, "")

    *offset = AllocateMemory(SizeOf(Character))
    T$ = "Diskette "+Chr(34)+DiskName+Chr(34)+" - size : "+Str(SizeOfDisk)

    If GetByte($11,$00,$03) <> 3 
      T$ + " => !!! Not a valid dos diskette !!!"
      _ADIR_DISK_FORMAT = #False
      DisableGadget(#Button_VTOC,#Disable)
    Else
      _ADIR_DISK_FORMAT = #True
      DisableGadget(#Button_VTOC,#Enable)
    EndIf

    ReadVTOC($11,$00)
    CATALOG(*vtoc\track,*vtoc\sector)

    ForEach Catfile()
      a$ = Trim(catfile()\filename)
        Select Catfile()\type
          Case #FILE_TEXT     : typ$="TXT"
          Case #FILE_INTEGER  : typ$="INT"
          Case #FILE_BASIC    : typ$="BAS"
          Case #FILE_BINARY   : typ$="BIN"
          Case #FILE_TYPE_S   : typ$="S"
          Case #FILE_RELOC    : typ$="REL"
          Case #FILE_TYPE_A   : typ$="A"
          Case #FILE_TYPE_B   : typ$="B"
        EndSelect
;       b$ = RSet(Str(catfile()\type),3," ")
      b$ = typ$
      c$ = RSet(Str(catfile()\block_used),3," ")
      d$ = RSet(Str(catfile()\llist\track),2," ")+"/"+LSet(Str(catfile()\llist\sector),2," ")
      e$ = "$"+RSet(Hex(catfile()\org),4,"0")
      f$ = RSet(Str(catfile()\length),5," ")
      g$ = "---" : h$ = "---"
      If catfile()\locked : g$ = "lck" : EndIf
      If catfile()\deleted : h$ = "del" : EndIf
      ADD_LIST_CAT(a$+#SEP_LIST+b$+#SEP_LIST+c$+#SEP_LIST+d$+#SEP_LIST+e$+#SEP_LIST+f$+#SEP_LIST+g$+#SEP_LIST+h$)
    Next

    SetGadgetText(#TEXT_DISK, T$+" - #Files: "+Str(CountGadgetItems(#CATALOG)))
    SetWindowTitle(#MAIN_WIN_ADIR,"[A]pple [D]isk [I]mage [R]eader ver#"+_ADIR_VERSION+" - "+DISK_DOS_Version+" - VOLUME #"+DISK_VOLUME_Number)

  EndIf
EndProcedure
; IDE Options = PureBasic 4.30 (Linux - x86)
; CursorPosition = 6
; Folding = -
; Executable = adir_gui_catalog
; DisableDebugger
; CompileSourceDirectory