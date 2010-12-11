; *********************************
; ***                           ***
; ***  APPLE DISK IMAGE READER  ***
; ***                           ***
; ***        GUI Version        ***
; ***                           ***
; *********************************
#COMPILER_CONSOLE = #False

XIncludeFile "adir_constants.pbi"
XIncludeFile "adir_structures.pbi"
XIncludeFile "adir_globals.pbi"
XIncludeFile "adir_procedures.pbi"
XIncludeFile "adir_dos3.pbi"
XIncludeFile "adir_vtoc.pbi"
XIncludeFile "adir_gui_catalog.pbi"
XIncludeFile "adir_datasection.pbi"

Procedure OpenWindow_MAIN_WIN_ADIR()
  If OpenWindow(#MAIN_WIN_ADIR, 420, 190, 600, 400, "", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_TitleBar)
    ListIconGadget(#CATALOG, 10, 5, 505, 350, "FILE", 220, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
    AddGadgetColumn(#CATALOG, 1, "TYP", 35)  ;40
    AddGadgetColumn(#CATALOG, 2, "BLK", 35)
    AddGadgetColumn(#CATALOG, 3, "TSL", 50)  ;50
    AddGadgetColumn(#CATALOG, 4, "ORG", 50)
    AddGadgetColumn(#CATALOG, 5, "LEN", 50)
    AddGadgetColumn(#CATALOG, 6, "LCK", 40)
    AddGadgetColumn(#CATALOG, 7, "DEL", 40)  ;40
      SetGadgetFont(#CATALOG, FontID(0))
    TextGadget(#TEXT_DISK, 10, 360, 590, 20, "")
    
    ButtonGadget(#Button_OPEN, 515, 25, 80, 40, "Open Disk")
    ButtonGadget(#Button_VTOC, 515, 65, 80, 40, "Show VTOC")
    ButtonGadget(#Button_QUIT, 515, 315, 80, 40, "Quit")

    ; Gadget Colors
;     SetGadgetColor(#CATALOG, #PB_Gadget_FrontColor, $FFFFFF)
;     SetGadgetColor(#CATALOG, #PB_Gadget_BackColor, $0)
    SetGadgetColor(#CATALOG, #PB_Gadget_FrontColor, $D0D0D0)
    SetGadgetColor(#CATALOG, #PB_Gadget_BackColor, $202020)

    ; IMAGE VTOC
    If CreateImage(#IMG_VTOC, #IMG_VTOC_WIDTH, #IMG_VTOC_HEIGHT)
      StartDrawing(ImageOutput(#IMG_VTOC))
        Box(0,0,#IMG_VTOC_WIDTH, #IMG_VTOC_HEIGHT,$000000)
      StopDrawing()
    EndIf

    ; IMAGE ONE UNUSED SECTOR (BLACK)
    If CreateImage(#IMG_VTOC_NOT_USED, #IMG_VTOC_W-1, #IMG_VTOC_H-1)
      StartDrawing(ImageOutput(#IMG_VTOC_NOT_USED))
        Box(0,0,#IMG_VTOC_W, #IMG_VTOC_H,$000000)
      StopDrawing()
    EndIf

    ; IMAGE ONE USED SECTOR (BLUE)
    If CreateImage(#IMG_VTOC_USED, #IMG_VTOC_W-1, #IMG_VTOC_H-1)
      StartDrawing(ImageOutput(#IMG_VTOC_USED))
        Box(0,0,#IMG_VTOC_W, #IMG_VTOC_H,$FF0000)
        LineXY(#IMG_VTOC_W-1, 0, #IMG_VTOC_W-1, #IMG_VTOC_H-1, $000000)
        LineXY(0, #IMG_VTOC_H-1, 0, #IMG_VTOC_H-1, $000000)
      StopDrawing()
    EndIf

    ; IMAGE ONE TSList SECTOR (RED)
    If CreateImage(#IMG_VTOC_TS_LIST, #IMG_VTOC_W-1, #IMG_VTOC_H-1)
      StartDrawing(ImageOutput(#IMG_VTOC_TS_LIST))
        Box(0,0,#IMG_VTOC_W, #IMG_VTOC_H,$0000FF)
        LineXY(#IMG_VTOC_W-1, 0, #IMG_VTOC_W-1, #IMG_VTOC_H-1, $000000)
        LineXY(0, #IMG_VTOC_H-1, 0, #IMG_VTOC_H-1, $000000)
      StopDrawing()
    EndIf

    ; Create Gadget image for VTOC
    ImageGadget(#IMG_GADGET, 10, 400, #IMG_VTOC_WIDTH, #IMG_VTOC_HEIGHT, ImageID(#IMG_VTOC), #PB_Image_Border)

  EndIf
EndProcedure

Procedure OpenWindow_VIEWFILE_WIN_ADIR(element.i)
  If OpenWindow(#VIEWFILE_WIN_ADIR, 380, 250, 630, 410, "View Files...",#PB_Window_SystemMenu,WindowID(#MAIN_WIN_ADIR))
    EditorGadget(#Editor_FILE, 5, 5, 550, 400, #PB_Editor_ReadOnly)
      SetGadgetFont(#Editor_FILE, FontID(1))
    ButtonGadget(#Button_SAVE, 555, 345, 75, 30, "Save", #PB_Button_Default)
    ButtonGadget(#Button_CLOSE, 555, 375, 75, 30, "Close", #PB_Button_Default)
    ContainerGadget(#Container_VIEWFILE, 555, 5, 75, 340, #PB_Container_Raised)
      OptionGadget(#Option_ASCII, 2, 15, 60, 18, "Ascii")
        SetGadgetFont(#Option_ASCII, FontID(0))
      OptionGadget(#Option_HEX, 2, 32, 60, 18, "Hexa")
        SetGadgetFont(#Option_HEX, FontID(0))
      OptionGadget(#Option_BASIC, 2, 49, 60, 18, "Basic")
        SetGadgetFont(#Option_BASIC, FontID(0))
      OptionGadget(#Option_DISASM, 2, 66, 60, 18, "DisASM")
        SetGadgetFont(#Option_DISASM, FontID(0))
    CloseGadgetList()

    ; Gadget Colors
    SetGadgetColor(#Editor_FILE, #PB_Gadget_FrontColor, $D0D0D0)
    SetGadgetColor(#Editor_FILE, #PB_Gadget_BackColor, $202020)

    ClearGadgetItems(#Editor_FILE)
    ShowFile(element)
    SetActiveGadget(#Editor_FILE)

    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #Button_SAVE
              EXPORT_File(element,GetGadgetText(#Editor_FILE))
            Case #Button_CLOSE
              ; We clear linkedlist or it add everytime
              ClearList(DumpFile())
              CloseWindow(#VIEWFILE_WIN_ADIR)
              Break
            EndSelect
      EndSelect
    ForEver
  EndIf
EndProcedure

Procedure Init_GUI()
  CatchImage(#IMG_LABEL_TRACK, ?Label_track_img)
  CatchImage(#IMG_LABEL_SECTOR, ?Label_sector_img)
  CatchImage(#IMG_CHAR_40, ?Label_char_img_40)
  CatchImage(#IMG_CHAR_80, ?Label_char_img_80)

  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      CatchImage(#IMG_BUTTON_DISK, ?Label_button_disk,#PB_Image_DisplayFormat)
    CompilerCase #PB_OS_Linux
      CatchImage(#IMG_BUTTON_DISK, ?Label_button_disk,#PB_Image_DisplayFormat)
    CompilerCase #PB_OS_MacOS
      CatchImage(#IMG_BUTTON_DISK, ?Label_button_disk)
  CompilerEndSelect

  OpenWindow_MAIN_WIN_ADIR()
  SetWindowTitle(#MAIN_WIN_ADIR,"[A]pple [D]isk [I]mage [R]eader ver#"+_ADIR_VERSION)
  DisableGadget(#Button_VTOC,#Disable)
EndProcedure

; ****************
; ***          ***
; ***   MAIN   ***
; ***          ***
; ****************
Global Font_Loaded.i

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    Font_Loaded = LoadFont(0,"Print Char 21",6)
    If Font_Loaded = 0
      LoadFont(1,"PR Number 3",12)
    Else
      LoadFont(0,"Courier New",8)
      LoadFont(1,"Courier New",9)
    EndIf

  CompilerCase #PB_OS_Linux
    Font_Loaded = LoadFont(0,"PrintChar21",6)              ;Page principale
    If Font_Loaded = 0
      LoadFont(1,"PRNumber3",12)                ;Page de visualisation
    Else
      LoadFont(0,"Monospace",8)
      LoadFont(1,"Monospace",9)
    EndIf
  CompilerCase #PB_OS_MacOS
    LoadFont(0,"Courier",8)
    LoadFont(1,"Courier",9)
CompilerEndSelect

_ADIR_DEBUG = #True
Init_ADIR(#ADIR_GUI)
Init_6502(#CPU_6502_OPCODE)
Init_GUI()

Repeat
  Select WaitWindowEvent()
    ; ///////////////////
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #CATALOG
          If ListSize(Catfile()) > 0
            Select EventType()
              Case #PB_EventType_LeftDoubleClick
                element = GetGadgetState(#CATALOG)
                If element <> -1
                  ; We clear linkedlist or it add everytime
                  ClearList(DumpFile())
                  OpenWindow_VIEWFILE_WIN_ADIR(element)
                EndIf
            EndSelect
          EndIf
        Case #Button_OPEN
          _ADIR_VTOC = #False
          SetGadgetText(#Button_VTOC,"Show VTOC")
          ResizeWindow(#MAIN_WIN_ADIR, 420, 190, 600, 400)
          GUI_CATALOG()
          SetActiveGadget(#CATALOG)
        Case #Button_VTOC
          GUI_VTOC()
        Case #Button_QUIT
          _ADIR_GUI_QUIT = #True
      EndSelect
    ; ////////////////////////
    Case #PB_Event_CloseWindow
      Select EventWindow()
        Case #MAIN_WIN_ADIR
          ;CloseWindow(#MAIN_WIN_ADIR)
          _ADIR_GUI_QUIT = #True
      EndSelect
  EndSelect
Until _ADIR_GUI_QUIT = #True
; IDE Options = PureBasic 4.30 (Linux - x86)
; CursorPosition = 147
; FirstLine = 111
; Folding = -
; Executable = adir_gui
; DisableDebugger
; CompileSourceDirectory