; Загрузка и редактирование торрент файла.
; Автор - Пётр
; http://purebasic.mybb.ru/viewtopic.php?id=249

Enumeration
  #Window_0
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Text_0
  #String_0
  #Button_0
  #Text_1
  #Editor_0
  #Text_2
  #String_1
  #Text_3
  #String_2
  #Text_6
  #String_3
  #Text_7
  #String_5
  #Text_8
  #String_6
  #Text_9
  #String_7
  #Text_10
  #String_8
  #Frame3D_0
  #Text_12
  #String_10
  #CheckBox_0
  #Text_14
  #String_11
  #ListIcon_0
  #Button_1
EndEnumeration

XIncludeFile "TorrentFiles.pbi"

Torrent.TorrentFiles_TorrentInfo
FileName.s

Procedure Open_Window_0()
  If OpenWindow(#Window_0, 243, 174, 428, 490, "Редактирование Torrent файла",  #PB_Window_SystemMenu | #PB_Window_Invisible | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
    TextGadget(#Text_0, 5, 15, 40, 15, "Файл:")
    StringGadget(#String_0, 50, 10, 330, 20, "")
    ButtonGadget(#Button_0, 385, 10, 30, 20, "...")
    TextGadget(#Text_1, 5, 40, 75, 15, "Трекеры:")
    EditorGadget(#Editor_0, 5, 55, 410, 65)
    TextGadget(#Text_2, 5, 135, 110, 15, "Публикатор:")
    StringGadget(#String_1, 120, 130, 295, 20, "")
    TextGadget(#Text_3, 5, 160, 110, 15, "Адрес публикатора")
    StringGadget(#String_2, 120, 155, 295, 20, "")
    TextGadget(#Text_6, 5, 185, 110, 15, "Комментарий")
    StringGadget(#String_3, 120, 180, 295, 20, "")
    TextGadget(#Text_7, 5, 210, 110, 15, "Создано:")
    StringGadget(#String_5, 120, 205, 90, 20, "")
    TextGadget(#Text_8, 225, 210, 90, 15, "Дата создания:", #PB_Text_Right)
    StringGadget(#String_6, 320, 205, 95, 20, "", #PB_String_ReadOnly)
    TextGadget(#Text_9, 5, 235, 110, 15, "Размер, байт:")
    StringGadget(#String_7, 120, 230, 90, 20, "", #PB_String_ReadOnly)
    TextGadget(#Text_10, 225, 235, 90, 15, "Размер части:", #PB_Text_Right)
    StringGadget(#String_8, 320, 230, 95, 20, "", #PB_String_ReadOnly)
    Frame3DGadget(#Frame3D_0, 5, 255, 410, 194, "При редактировании изменится идентификатор торрента 'INFO Hash'!")
    TextGadget(#Text_12, 10, 280, 65, 15, "INFO Hash:")
    StringGadget(#String_10, 80, 275, 330, 20, "", #PB_String_ReadOnly)
    CheckBoxGadget(#CheckBox_0, 300, 304, 110, 15, "Частный торрент")
    TextGadget(#Text_14, 10, 306, 94, 15, "Корневая папка:")
    StringGadget(#String_11, 108, 300, 180, 20, "")
    ListIconGadget(#ListIcon_0, 10, 330, 400, 110, "Файл", 290, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)
    SendMessage_(GadgetID(#ListIcon_0), #LVM_SETEXTENDEDLISTVIEWSTYLE, #LVS_EX_LABELTIP, #LVS_EX_LABELTIP)  
    AddGadgetColumn(#ListIcon_0, 1, "Размер", 80)
    ButtonGadget(#Button_1, 330, 457, 80, 24, "Сохранить")
    
    SetActiveGadget(#Button_0)
    SendMessage_(WindowID(#Window_0), #WM_UPDATEUISTATE, $30002,0)
    
    HideWindow(#Window_0, 0)
  EndIf
EndProcedure


Procedure LoadTorrent(FileName.s, *Torrent.TorrentFiles_TorrentInfo)
  SetGadgetText(#String_0, FileName)
  If TorrentFiles_LoadTorrentFile(FileName, *Torrent) <> #True
    TorrentFiles_LoadTorrentFile_ShowEror(*Torrent\ErrorCode, *Torrent\ErrorString, "")
  Else
    ClearGadgetItems(#Editor_0)
    ForEach *Torrent\announce_list()
      AddGadgetItem(#Editor_0, -1, *Torrent\announce_list())
    Next
    SetGadgetText(#String_1, *Torrent\Publisher)
    SetGadgetText(#String_2, *Torrent\Publisher_Url)
    SetGadgetText(#String_3, *Torrent\comment)
    SetGadgetText(#String_5, *Torrent\created_by)
    SetGadgetText(#String_6, FormatDate("%dd.%mm.%yyyy %hh:%ii", *Torrent\creation_date))
    SetGadgetText(#String_7, Str(*Torrent\All_Size))
    SetGadgetText(#String_8, Str(*Torrent\piece_length))
    SetGadgetText(#String_10, *Torrent\INFO_Hash)
    SetGadgetText(#String_11, *Torrent\CurrentDir_Name)
    DisableGadget(#String_11, *Torrent\TypeDir!1)
    SetGadgetState(#CheckBox_0,*Torrent\private)
    ClearGadgetItems(#ListIcon_0)
    ForEach *Torrent\files()
      Count = ListSize(*Torrent\files()\path())
      If Count>0
        File.s=""
        x=0
        ForEach *Torrent\files()\path()
          x + 1
          File + *Torrent\files()\path()
          If x<Count
            File + "\"
          EndIf
        Next
        AddGadgetItem(#ListIcon_0, -1, File+Chr(10)+Str(*Torrent\files()\length))
      EndIf
    Next
  EndIf
EndProcedure

Procedure.b SeveTorrent(FileName.s, *Torrent.TorrentFiles_TorrentInfo)
  Protected Result.b=#False
  ClearList(*Torrent\announce_list())
  *Torrent\announce = ""
  Count = CountGadgetItems(#Editor_0)-1
  x=0
  For i=0 To Count
    String.s = GetGadgetItemText(#Editor_0, i)
    If String<>"" And RemoveString(String, " ")<>""
      If x=0
        x=1
        *Torrent\announce = String
      EndIf
      If AddElement(*Torrent\announce_list())
        *Torrent\announce_list() = String
      EndIf
    EndIf
  Next i
  *Torrent\Publisher = GetGadgetText(#String_1)
  *Torrent\Publisher_Url = GetGadgetText(#String_2)
  *Torrent\comment = GetGadgetText(#String_3)
  *Torrent\created_by = GetGadgetText(#String_5)
  If *Torrent\TypeDir = #True
    *Torrent\CurrentDir_Name = GetGadgetText(#String_11)
  EndIf
  *Torrent\private = GetGadgetState(#CheckBox_0)
  
  If TorrentFiles_CreateSysFile_Torrent(FileName, *Torrent) = #True
    Result=#True
    MessageRequester("", "Торрент файл успешно модифицирован.", #MB_OK|#MB_ICONINFORMATION)
  Else
    MessageRequester("", "Ошибка при модификации торрент файла.", #MB_OK|#MB_ICONWARNING)
  EndIf
  
  ProcedureReturn Result
EndProcedure

Open_Window_0()

Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget
    Select EventGadget()
      Case #Button_0 ; Открытть торрент файл.
        FileName = OpenFileRequester("","","Торрент-файлы (*.torrent)|*.torrent|Все файлы|*.*",0)
        If FileName<>"" And FileSize(FileName)>0
          LoadTorrent(FileName, @Torrent)
        EndIf
        
        
      Case #Button_1 ; Сохранить торрент файл.
        
        If FileName<>"" And FileSize(FileName)>0
          If SeveTorrent(FileName, @Torrent) = #True
            LoadTorrent(FileName, @Torrent)
          EndIf
        Else
          MessageRequester("", "Укажите путь к торрент-файлу", #MB_OK|#MB_ICONWARNING)
        EndIf
        
    EndSelect
  EndIf
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 2
; Folding = -
; EnableUnicode
; EnableXP
; Executable = EditTorrent.exe