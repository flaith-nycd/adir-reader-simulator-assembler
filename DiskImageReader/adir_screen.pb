;{- Enumerations / DataSections
;{ Windows
Enumeration
    #Window_Main
    #Window_About
EndEnumeration

; about box
Enumeration 
  #W_About_OK
EndEnumeration
;}
;{ Toolbars
Enumeration
    #Toolbar_Window_Main
EndEnumeration
;}
;{ Menu bars
Enumeration
    #Menu_Window_Main
EndEnumeration
;}
;{ Menu/Toolbar items
Enumeration
    #Menu_Window_Main_Open
    #Menu_apple_II
    #Menu_apple_II_plus
    #Menu_apple_II_enh
    #Menu_format_40
    #Menu_format_80
    #Menu_color_BW
    #Menu_color_GREEN
    #Menu_color_AMBRE
    #Menu_color_REAL_BW
    #Menu_color_REAL_GREEN
    #Menu_color_REAL_AMBRE
    #Menu_Window_Main_Quit
    #Menu_Window_Main_Help
    #Menu_Window_Main_About_msg
    #Toolbar_Window_Main_Help
    #Toolbar_Window_Main_Open
EndEnumeration
;}
;{ Status bars
Enumeration
    #StatusBar_Window_Main
EndEnumeration
;}
;}
; Enumeration
;   #SPR_CHAR_40
;   #SPR_CHAR_80
; EndEnumeration

Enumeration 
  #APPLE_II
  #APPLE_II_PLUS
  #APPLE_II_ENH
EndEnumeration

#CHAR_WIDTH           = 14
#CHAR_HEIGHT          = 16
#CHAR_NORMAL          = $00
#CHAR_INVERSE         = $01

#COLOR_BW             = 1                       ; (1:B&W", "2:GREEN)
#COLOR_GREEN          = 2
#COLOR_AMBRE          = 3
#COLOR_REAL_BW        = 4
#COLOR_REAL_GREEN     = 5
#COLOR_REAL_AMBRE     = 6

#Cursor_Speed         = 250

Global _NO_PRINT.i          = #False
Global _INVERSE.i           = #False
Global _ADIR_COLOR_CHAR.i   = #COLOR_BW                                   ; Set color Char
Global _ADIR_BACK.i         = #False

Global spr_char_40.i, spr_char_80.i, spr_cursor.i, spr_mark.i
Global spr_char_40_tmp.i, spr_char_80_tmp.i
Global spr_graphic_char_40.i, spr_graphic_char_80.i
Global spr_mouse.i

Global CursorX.i, CursorY.i
Global spr_titre.i
Global APPLE_VERSION.i      = #APPLE_II
Global apple_name.s         = ""

Global COL_4080.i           = 1                                           ; (1:40 col - 2:80 col)
Global CHAR_W.i             = #CHAR_WIDTH/COL_4080
Global CHAR_H.i             = #CHAR_HEIGHT
Global SCR_W.i              = 40*COL_4080

Structure TSPR
  num.i
EndStructure

Procedure Load_Sprite()
  spr_char_40 = CatchSprite(#PB_Any, ?char_40)
;  spr_char_80 = CatchSprite(#PB_Any, ?char_80)

;   spr_char_40_tmp = CatchSprite(#PB_Any, ?char_40)
  spr_char_40_tmp = CopySprite(spr_char_40,#PB_Any)
;  spr_char_80_tmp = CatchSprite(#PB_Any, ?char_80)

  spr_mouse = CatchSprite(#PB_Any, ?my_mouse)
  TransparentSpriteColor(spr_mouse,$FF00FF)

  spr_graphic_char_40 = CatchSprite(#PB_Any, ?graphic_char)
EndProcedure

Procedure.i HalfWidthSprite(spr.i)
Protected tmp_spr.i, spr_bis.i
Protected sw.i, sh.i, k.i, j.i

  sw = SpriteWidth(spr)
  sh = SpriteHeight(spr)
  
  spr_bis = CopySprite(spr,#PB_Any)

  tmp_spr = CreateSprite(#PB_Any,sw/2,sh)
  UseBuffer(tmp_spr)
    k = sw : j = 0
    For x = 0 To sw Step 2
      ClipSprite(spr_bis,x,0,k,sh)
      DisplaySprite(spr_bis,j,0)
      k - 2
      j + 1
    Next x
  UseBuffer(#PB_Default)

  FreeSprite(spr_bis)
  ProcedureReturn tmp_spr
EndProcedure

Procedure.i HalfHeightSprite(spr.i)
Protected tmp_spr.i, spr_bis.i
Protected sw.i, sh.i, k.i, j.i

  sw = SpriteWidth(spr)
  sh = SpriteHeight(spr)

  spr_bis = CopySprite(spr,#PB_Any)

  tmp_spr = CreateSprite(#PB_Any,sw,sh/2)
  UseBuffer(tmp_spr)
    k = sh : j = 0
    For y = 0 To sh Step 2
      ClipSprite(spr_bis,0,y,sw,k)
      DisplaySprite(spr_bis,0,j)
      k - 2
      j + 1
    Next y
  UseBuffer(#PB_Default)
  ProcedureReturn tmp_spr
EndProcedure

Procedure.i HalfSprite(spr.i)
Protected tmp_spr.i, tmp_spr2.i

  tmp_spr = HalfWidthSprite(spr)
  tmp_spr2 = HalfHeightSprite(tmp_spr)
  
  ProcedureReturn tmp_spr2
EndProcedure

Procedure ADIR_Set_Color(colorC.i = #COLOR_BW)
  _ADIR_COLOR_CHAR = ColorC
EndProcedure

Procedure GenerateFont()
Protected spr_width.i, spr_height.i, spr.i, Spr_tmp.i, spr_bis.i
Protected the_color.i

  Select _ADIR_COLOR_CHAR
    Case #COLOR_BW
      the_color = $FFFFFF
    Case #COLOR_GREEN
      the_color = $00EE00
    Case #COLOR_AMBRE
      the_color = $007FFF
    Case #COLOR_REAL_BW
      the_color = $FFFFFF
    Case #COLOR_REAL_GREEN
      the_color = $00EE00
    Case #COLOR_REAL_AMBRE
      the_color = $007FFF
  EndSelect

  Select COL_4080
    Case 1
      spr = spr_char_40_tmp
    Case 2
      spr = spr_char_80_tmp
  EndSelect
  
  spr_width = SpriteWidth(spr)
  spr_height = SpriteHeight(spr)
  
  spr_bis = CopySprite(spr,#PB_Any)
  TransparentSpriteColor(spr_bis,$FFFFFF)
  
  Spr_tmp = CreateSprite(#PB_Any, spr_width, spr_height)
  StartDrawing(SpriteOutput(Spr_tmp))
    Box(0,0,spr_width,spr_height,the_color)
    If _ADIR_COLOR_CHAR = #COLOR_REAL_BW Or _ADIR_COLOR_CHAR = #COLOR_REAL_GREEN Or _ADIR_COLOR_CHAR = #COLOR_REAL_AMBRE
      For i = 1 To spr_height Step 2
        Line(0,i,spr_width,0,$0)
      Next i
    EndIf
  StopDrawing()
  UseBuffer(Spr_tmp)
    DisplayTransparentSprite(spr_bis,0,0)
  UseBuffer(#PB_Default)

  Select COL_4080
    Case 1
      ;CopySprite(spr_tmp,spr_char_40)
      spr_char_40 = spr_tmp
    Case 2
      ;CopySprite(spr_tmp,spr_char_80)
      spr_char_80 = spr_tmp
  EndSelect
  
EndProcedure

Procedure.i MakeTXT(text.s, length.i)
Protected aa.i, i.i, PosX.i, pos_car.i, line_pos_car.i, colonne_pos_car.i
Protected x.i, y.i
Protected a$
Protected spr.i

  _NO_PRINT = #False
  _INVERSE = #False

  aa = CreateSprite(#PB_Any,CHAR_W * length,CHAR_H)        ; Créer une image correspondant à 
                                                            ; une ligne de length car

  If aa
    PosX = 0 : i = 1 : _ADIR_BACK = #False
    While i <= Len(text)

      a$ = Mid(text,i,1)

      If a$ = "\" And _ADIR_BACK = #False
        i + 1
        a$ = Mid(text,i,1)
        _ADIR_BACK = #True
      EndIf

      If _ADIR_BACK = #True
        If a$ = "i" : _INVERSE = #True : EndIf
        If a$ = "n" And _INVERSE = #True : _INVERSE = #False : EndIf
        i + 1
        _ADIR_BACK = #False
        ;If i < Len(text) : a$ = Mid(text,i,1) : Else : Break : EndIf
      Else
        pos_car = Asc(a$)-32
        Line_pos_car = pos_car / 16                           ; recupère la ligne ou se trouve le caractère
        If Line_pos_car > 0
          colonne_pos_car = pos_car - (Line_pos_car * 16)     ; recupère la colonne
        Else
          colonne_pos_car = pos_car
        EndIf
  
        If _INVERSE
          line_pos_car + 6                                    ; pour car inverse
        EndIf
  
        x = colonne_pos_car * CHAR_W : y = Line_pos_car * CHAR_H
  
        Select COL_4080
          Case 1
            spr = spr_char_40
          Case 2
            spr = spr_char_80
        EndSelect

        UseBuffer(spr)
          spr_tmp = GrabSprite(#PB_Any,x,y,CHAR_W,CHAR_H)
        UseBuffer(aa)
          DisplaySprite(spr_tmp,PosX,0)
          PosX + CHAR_W
        UseBuffer(#PB_Default)

      i + 1
      EndIf
    Wend

  Else
    End
  EndIf

  ProcedureReturn aa

EndProcedure

Procedure Make_cursor(A_VERSION.i)

  Select A_VERSION
    Case #APPLE_II
      spr_cursor = MakeTXT("\i \n",1)
      apple_name = "APPLE II"
    Case #APPLE_II_PLUS
      spr_cursor = MakeTXT("\i \n",1)
      apple_name = "Apple ]["
    Case #APPLE_II_ENH
      spr_cursor = MakeTXT(Chr(127),1)
      apple_name = "Apple //e"
  EndSelect
  spc = ((40 * COL_4080) - (Len(apple_name))) / 2:espace$ = Space(spc)
;spr_titre = MakeTXT(spc$+"\i"+apple$+"\n",#SCR_W)
  spr_titre = MakeTXT(espace$+apple_name,SCR_W)
  APPLE_VERSION = A_VERSION
EndProcedure

Procedure ShowCursor()
  Static CursorTimer.i
  Static CursorMode.i
  Shared CursorX.i, CursorY.i

  If APPLE_VERSION > #APPLE_II
    If CursorTimer = 0  ; first call
      CursorTimer = ElapsedMilliseconds()
    EndIf
  
    If ElapsedMilliseconds() > CursorTimer
      CursorTimer + #Cursor_Speed
      CursorMode = 1 - CursorMode
    EndIf
  
    If CursorMode
      DisplayTransparentSprite(spr_cursor, CHAR_W*CursorX, CHAR_H*CursorY)
    EndIf
  Else
     DisplayTransparentSprite(spr_cursor, CHAR_W*CursorX, CHAR_H*CursorY)
  EndIf
EndProcedure

Procedure ChangeResolution(value.i)
  COL_4080     = value                                           ; (1:40 col - 2:80 col)
  CHAR_W       = #CHAR_WIDTH/COL_4080
  CHAR_H       = #CHAR_HEIGHT
  SCR_W        = 40*COL_4080
EndProcedure

Procedure MakeFnt(ver_type_apple.i)
  APPLE_VERSION = ver_type_apple
  GenerateFont()
  Make_cursor(ver_type_apple)
  spr_mark = MakeTXT("]",1)
EndProcedure

Procedure Open_About()
  If OpenWindow(#Window_About,0,0,150,100,"About...",#PB_Window_WindowCentered,WindowID(#Window_Main))
    ButtonGadget(#W_About_OK,50,70,50,25,"OK")
  EndIf
  Repeat
    Select WaitWindowEvent()
        ; ///////////////////
        Case #PB_Event_Gadget
            Select EventGadget()
              Case #W_About_OK
                CloseWindow(#Window_About)
                Break
            EndSelect
    EndSelect
  ForEver
EndProcedure

Procedure SetMenu(which,menu)

  Select which
    Case 0
      SetMenuItemState(#Menu_Window_Main,#Menu_apple_II,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_apple_II_plus,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_apple_II_enh,0)
      SetMenuItemState(#Menu_Window_Main,menu,1)
    Case 1
      SetMenuItemState(#Menu_Window_Main,#Menu_format_40,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_format_80,0)
      SetMenuItemState(#Menu_Window_Main,menu,1)
    Case 2
      SetMenuItemState(#Menu_Window_Main,#Menu_color_BW,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_color_GREEN,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_color_AMBRE,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_color_REAL_BW,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_color_REAL_GREEN,0)
      SetMenuItemState(#Menu_Window_Main,#Menu_color_REAL_AMBRE,0)
      SetMenuItemState(#Menu_Window_Main,menu,1)
  EndSelect
EndProcedure

Procedure OpenWindow_Window_Main()
    If OpenWindow(#Window_Main, 458, 213, 564, 455, "[A]PPLE [D]ISK [I]MAGE [R]EADER", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_TitleBar)
        If CreateMenu(#Menu_Window_Main, WindowID(#Window_Main))
            MenuTitle("File")
              MenuItem(#Menu_Window_Main_Open, "Open")

              MenuBar()
              
              OpenSubMenu("Apple type")       ; Crée un sous-menu
                MenuItem(#Menu_apple_II, "Apple ][")
                MenuItem(#Menu_apple_II_plus, "Apple II+")
                MenuItem(#Menu_apple_II_enh, "Apple IIe")
              CloseSubMenu()

              OpenSubMenu("Dimension")       ; Crée un sous-menu
                MenuItem(#Menu_format_40, "40 Columns")
                MenuItem(#Menu_format_80, "80 columns")
              CloseSubMenu()
              
              OpenSubMenu("Color")       ; Crée un sous-menu
                MenuItem(#Menu_color_BW, "Black and White")
                MenuItem(#Menu_color_GREEN, "Green")
                MenuItem(#Menu_color_AMBRE, "Ambre")

                MenuBar()
                OpenSubMenu("Original Color")       ; Crée un sous-menu
                  MenuItem(#Menu_color_REAL_BW, "Real Black and White")
                  MenuItem(#Menu_color_REAL_GREEN, "Real Green")
                  MenuItem(#Menu_color_REAL_AMBRE, "Real Ambre")
                CloseSubMenu()
              CloseSubMenu()

              MenuBar()

              MenuItem(#Menu_Window_Main_Quit, "Quit"+Chr(9)+"Ctrl-X")
            MenuTitle("About")
              MenuItem(#Menu_Window_Main_Help, "Help")
              MenuItem(#Menu_Window_Main_About_msg, "About")
        EndIf
        If CreateToolBar(#Toolbar_Window_Main, WindowID(#Window_Main))
            ToolBarStandardButton(#Toolbar_Window_Main_Open, #PB_ToolBarIcon_Open)
            ToolBarSeparator()
            ToolBarStandardButton(#Toolbar_Window_Main_Help, #PB_ToolBarIcon_Help)
        EndIf
        If CreateStatusBar(#StatusBar_Window_Main, WindowID(#Window_Main))
        EndIf
    EndIf
    OpenWindowedScreen(WindowID(#Window_Main),1, 31, 560, 384, 0, 0, 0)
EndProcedure

UsePNGImageDecoder()
InitSprite() : InitKeyboard() : InitMouse()
OpenWindow_Window_Main()

Load_Sprite()
ADIR_Set_Color(#COLOR_BW)
MakeFnt(#APPLE_II_ENH)
SetMenuItemState(#Menu_Window_Main,#Menu_apple_II_enh,1) ; Coche l'élément #Menu_apple_II_enh du menu.
SetMenuItemState(#Menu_Window_Main,#Menu_format_40,1)
SetMenuItemState(#Menu_Window_Main,#Menu_color_BW,1)

spr_char_80 = HalfWidthSprite(spr_char_40)
spr_char_80_tmp = CopySprite(spr_char_80,#PB_Any)
spr_graphic_char_80 = HalfWidthSprite(spr_graphic_char_40)

CursorX = 1
CursorY = 2

quit = 0

spr_test_half1 = HalfSprite(spr_graphic_char_40)
SaveSprite(spr_test_half1,"spr_test_half1.bmp")
spr_test_half2 = HalfSprite(spr_char_40)
SaveSprite(spr_test_half2,"spr_test_half2.bmp")
spr_test_half3 = HalfSprite(spr_mouse)
SaveSprite(spr_test_half3,"spr_test_half3.bmp")
; 
; 
spr_tur = LoadSprite(#PB_Any,"catalog_ex_1.png")
spr_test_half4 = HalfSprite(spr_tur)
SaveSprite(spr_test_half4,"spr_test_half4.bmp")
spr_test_half5 = HalfSprite(spr_test_half4)
SaveSprite(spr_test_half5,"spr_test_half5.bmp")

CompilerIf #PB_Compiler_OS = #PB_OS_Linux
; all the pixel Data is then in *pointer\pixels
  *pointer_sprite.sdl_surface = SpriteID(spr_tur)
  *pointer_screen.sdl_surface = ScreenID()
  Debug "ptr sprite : "+Str(*pointer_sprite.sdl_surface)
  Debug "ptr screen : "+Str(*pointer_screen.sdl_surface)
CompilerEndIf

;{- Event loop
Repeat
  ;Repeat
      Event = WaitWindowEvent(20) ;WindowEvent()

      Select Event 
        ; ///////////////////
        Case #PB_Event_Gadget
            Select EventGadget()

            EndSelect
        ; /////////////////
        Case #PB_Event_Menu
            Select EventMenu()
                Case #Menu_Window_Main_Open

                Case #Menu_apple_II
                  SetMenu(0,#Menu_apple_II)
                  MakeFnt(#APPLE_II)
                Case #Menu_apple_II_plus
                  SetMenu(0,#Menu_apple_II_plus)
                  MakeFnt(#APPLE_II_PLUS)
                Case #Menu_apple_II_enh
                  SetMenu(0,#Menu_apple_II_enh)
                  MakeFnt(#APPLE_II_ENH)

                Case #Menu_format_40
                  SetMenu(1,#Menu_format_40)
                  ChangeResolution(1)
                  MakeFnt(APPLE_VERSION)
                Case #Menu_format_80
                  SetMenu(1,#Menu_format_80)
                  ChangeResolution(2)
                  MakeFnt(APPLE_VERSION)

                Case #Menu_color_BW
                  SetMenu(2,#Menu_color_BW)
                  ADIR_Set_Color(#COLOR_BW)
                  MakeFnt(APPLE_VERSION)
                Case #Menu_color_GREEN
                  SetMenu(2,#Menu_color_GREEN)
                  ADIR_Set_Color(#COLOR_GREEN)
                  MakeFnt(APPLE_VERSION)
                Case #Menu_color_AMBRE
                  SetMenu(2,#Menu_color_AMBRE)
                  ADIR_Set_Color(#COLOR_AMBRE)
                  MakeFnt(APPLE_VERSION)
                Case #Menu_color_REAL_BW
                  SetMenu(2,#Menu_color_REAL_BW)
                  ADIR_Set_Color(#COLOR_REAL_BW)
                  MakeFnt(APPLE_VERSION)
                Case #Menu_color_REAL_GREEN
                  SetMenu(2,#Menu_color_REAL_GREEN)
                  ADIR_Set_Color(#COLOR_REAL_GREEN)
                  MakeFnt(APPLE_VERSION)
                Case #Menu_color_REAL_AMBRE
                  SetMenu(2,#Menu_color_REAL_AMBRE)
                  ADIR_Set_Color(#COLOR_REAL_AMBRE)
                  MakeFnt(APPLE_VERSION)

                Case #Menu_Window_Main_Quit
                  quit = 1

                Case #Menu_Window_Main_Help
                Case #Menu_Window_Main_About_msg
                  Open_About()

                Case #Toolbar_Window_Main_Open
                Case #Toolbar_Window_Main_Help
            EndSelect
        ; ////////////////////////
        Case #PB_Event_CloseWindow
            Select EventWindow()
                Case #Window_Main
                    CloseWindow(#Window_Main)
                    Break
            EndSelect
      EndSelect
  ;Until event = 0

  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Escape) : quit = 1 : EndIf
;  ExamineMouse()

  ClearScreen($202020)
  DisplayTransparentSprite(spr_titre, 0,0)
  DisplayTransparentSprite(spr_mark, 0, CHAR_H*2)
  
;   x = MouseX() : y = MouseY()
;   If x < 0 Or x > 580 And y < 0 Or y > 384 : ReleaseMouse(#True) : Else : ReleaseMouse(#False) : EndIf
;   If KeyboardPushed(#PB_Key_Escape) : quit = 1 : EndIf
;   DisplayTransparentSprite(spr_mouse,CHAR_W*(x/CHAR_W),CHAR_H*(y/CHAR_H))
  
  ShowCursor()
  FlipBuffers(20)
Until quit

;CloseScreen()
;
;}
End

DataSection
  char_40: IncludeBinary "data/adir_char_40.png"
  graphic_char: IncludeBinary "data/adir_graphic_char_40.png"
  my_mouse: IncludeBinary "data/adir_mouse.png"
EndDataSection
; IDE Options = PureBasic 4.30 (Linux - x86)
; CursorPosition = 583
; FirstLine = 554
; Folding = ----
; Executable = adir_screen.exe
; CompileSourceDirectory