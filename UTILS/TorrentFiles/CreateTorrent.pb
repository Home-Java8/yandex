; Создание торрент файла.
; Автор - Пётр
; http://purebasic.mybb.ru/viewtopic.php?id=249

XIncludeFile "TorrentFiles.pbi"

; Идентификаторы окон.
Enumeration
  #CreateTorrent_Win
EndEnumeration

; Идентификаторы гаджетов.
Enumeration
  ; Гаджеты окна "Создание торрента".
  
  #CreateTorrent_Text_0
  #CreateTorrent_Radio_File
  #CreateTorrent_Radio_Dir
  #CreateTorrent_String_Path
  #CreateTorrent_Button_Path
  #CreateTorrent_Text_5
  #CreateTorrent_String_TorrentFile
  #CreateTorrent_Button_TorrentFile
  #CreateTorrent_Frame3D_0
  #CreateTorrent_Text_1
  #CreateTorrent_String_Treker
  #CreateTorrent_Text_2
  #CreateTorrent_String_Comment
  #CreateTorrent_Text_3
  #CreateTorrent_CheckBox_Private
  #CreateTorrent_Combo_Piece
  #CreateTorrent_ProgressBar
  #CreateTorrent_Button_Start
  #CreateTorrent_CurrentFile
EndEnumeration

; Идентификаторы таймеров
Enumeration
  #CreateTorrent_Timer
EndEnumeration

Procedure CreateTorrentCB(File.s, Pos.f)
  Static Old_File.s, Old_Pos
  Protected Count, Temp
  
  If Old_File <> File
    Old_File = File
    If Len(File) > 40
      Count = CountString(File, "\")
      If Count > 2
        Temp=FindString(File, "\", 1)
        If Temp > 0
          Temp = FindString(File, "\", Temp+1)
          If Temp > 0
            File.s = Left(File, Temp)+"...\"+GetFilePart(File)
          EndIf
        EndIf
      EndIf
    EndIf 
    If IsGadget(#CreateTorrent_CurrentFile)
      SetGadgetText(#CreateTorrent_CurrentFile, File)
    EndIf
  EndIf
  
  If Round(Pos,#PB_Round_Down) <> Old_Pos
    Old_Pos = Pos ;Round(Pos,#PB_Round_Up)
    If IsGadget(#CreateTorrent_ProgressBar)
      SetGadgetState(#CreateTorrent_ProgressBar, Old_Pos)
    EndIf
  EndIf
EndProcedure


Path.s : String.s : Dir.s
Torrent.TorrentFiles_CreateInfo
S_Temp.s


If OpenWindow(#CreateTorrent_Win, 277, 288, 384, 374, "Cоздание торрента.",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_Invisible)
  TextGadget(#CreateTorrent_Text_0, 10, 10, 200, 15, "Путь к файлам:")
  OptionGadget(#CreateTorrent_Radio_File, 220, 10, 65, 15, "Файл")
  OptionGadget(#CreateTorrent_Radio_Dir, 295, 10, 75, 15, "Папка")
  StringGadget(#CreateTorrent_String_Path, 10, 30, 335, 20, "", #PB_String_ReadOnly)
  ButtonGadget(#CreateTorrent_Button_Path, 350, 30, 30, 20, "...")
  TextGadget(#CreateTorrent_Text_5, 10, 65, 335, 15, "Торрент файл:")
  StringGadget(#CreateTorrent_String_TorrentFile, 10, 85, 335, 20, "", #PB_String_ReadOnly)
  ButtonGadget(#CreateTorrent_Button_TorrentFile, 350, 85, 30, 20, "...")
  Frame3DGadget(#CreateTorrent_Frame3D_0, 15, 120, 355, 205, "Свойства торрента")
  TextGadget(#CreateTorrent_Text_1, 25, 140, 335, 15, "Трекеры:")
  StringGadget(#CreateTorrent_String_Treker, 25, 160, 335, 74, "", #ES_MULTILINE|#WS_VSCROLL|#ES_AUTOVSCROLL)
  TextGadget(#CreateTorrent_Text_2, 25, 245, 330, 15, "Комментарий:")
  StringGadget(#CreateTorrent_String_Comment, 25, 265, 335, 20, "")
  TextGadget(#CreateTorrent_Text_3, 165, 300, 110, 15, "Размер частей:", #PB_Text_Right)
  CheckBoxGadget(#CreateTorrent_CheckBox_Private, 25, 300, 120, 15, "Частный торрент")
  ComboBoxGadget(#CreateTorrent_Combo_Piece, 280, 295, 80, 22)
  ProgressBarGadget(#CreateTorrent_ProgressBar, 15, 350, 265, 15, 0, 100, #PB_ProgressBar_Smooth)
  ButtonGadget(#CreateTorrent_Button_Start, 295, 340, 75, 25, "Создать")
  TextGadget(#CreateTorrent_CurrentFile, 15, 335, 265, 15, "")
  
  SetWindowLongPtr_(GadgetID(#CreateTorrent_CurrentFile),#GWL_STYLE, GetWindowLongPtr_(GadgetID(#CreateTorrent_CurrentFile),#GWL_STYLE)|#SS_LEFTNOWORDWRAP)
  SetGadgetState(#CreateTorrent_Radio_File, 1)
  
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "Авто")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "16 КБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "32 КБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "64 КБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "128 КБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "256 КБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "512 КБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "1 МБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "2 МБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "4 МБ")
  AddGadgetItem(#CreateTorrent_Combo_Piece, -1, "8 МБ")
  SetGadgetState(#CreateTorrent_Combo_Piece, 0)
  
  SetActiveGadget(#CreateTorrent_Radio_File)
  SendMessage_(WindowID(#CreateTorrent_Win), #WM_UPDATEUISTATE, $30002,0)
  
  HideWindow(#CreateTorrent_Win, 0)
  Thread_ID = 0
  
  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget And Thread_ID=0
      Select EventGadget()
        Case #CreateTorrent_Button_Path
          
          If GetGadgetState(#CreateTorrent_Radio_File) ; Файл
            Path = OpenFileRequester("","","Все файлы|*.*",0)
            If Path<>"" And FileSize(Path)>0
              SetGadgetText(#CreateTorrent_String_Path, Path)
            EndIf
          Else  ; Папка
            Path = PathRequester("Укажите путь к папке с файлами торрента.",Dir)
            If Path<>"" And FileSize(Path)= -2
              SetGadgetText(#CreateTorrent_String_Path, Path)
            EndIf
          EndIf
          
        Case #CreateTorrent_Button_TorrentFile
          Path = SaveFileRequester("","","Торрент-файлы (*.torrent)|*.torrent|Все файлы|*.*",0)
          If Path<>"" And SelectedFilePattern()>-1
            If SelectedFilePattern() = 0 And GetExtensionPart(Path)="" : Path+".torrent" : EndIf
            SetGadgetText(#CreateTorrent_String_TorrentFile, Path)
          EndIf
          
        Case #CreateTorrent_Radio_File, #CreateTorrent_Radio_Dir
          SetGadgetText(#CreateTorrent_String_Path, "")
          
        Case #CreateTorrent_Button_Start
          SetGadgetState(#CreateTorrent_ProgressBar, 0)
          
          ClearStructure(@Torrent, TorrentFiles_CreateInfo)
          NewList Torrent\announce()
          
          Torrent\Path = GetGadgetText(#CreateTorrent_String_Path)
          Torrent\FileName = GetGadgetText(#CreateTorrent_String_TorrentFile)
          If Torrent\Path<>"" And Torrent\FileName<>""
            
            String=GetGadgetText(#CreateTorrent_String_Treker)
            If String<>""
              String = ReplaceString(String, Chr(13), Chr(10))
              String = ReplaceString(String, Chr(10)+Chr(10), Chr(10))
              If String<>""
                String + Chr(10)
                Temp = CountString(String, Chr(10))
                For i=1 To Temp
                  S_Temp = StringField(String, i, Chr(10))
                  If S_Temp<>""
                    S_Temp=Trim(S_Temp)
                    S_Temp=RemoveString(S_Temp, Chr(9))
                    If S_Temp<>""
                      If AddElement(Torrent\announce())
                        Torrent\announce() =  S_Temp
                      Else
                        MessageRequester("Создание торрента.", "Ошибка выделения памяти!", #MB_OK|#MB_ICONERROR)
                        Break
                      EndIf
                    EndIf
                  EndIf
                Next i
              EndIf
            EndIf
            String="" : S_Temp=""
            
            Torrent\BreakThread = 0 ; Признак того, что не нужно прерывать создание торрент-файла.
            Torrent\ClientName = "MyTorrent 2.0"
            Torrent\comment = GetGadgetText(#CreateTorrent_String_Comment)
            Torrent\Directory = GetGadgetState(#CreateTorrent_Radio_Dir) & 1
            Torrent\ErrorCode = 0
            Torrent\ErrorString = ""
            Torrent\Result = 0
            Temp = GetGadgetState(#CreateTorrent_Combo_Piece)
            If Temp>0 And Temp<12
              Torrent\pieceLength = 16384 << (Temp-1)
            Else
              Torrent\pieceLength = 0
            EndIf
            Torrent\PiecesCB = @CreateTorrentCB()
            Torrent\private = GetGadgetState(#CreateTorrent_CheckBox_Private) & 1
            Torrent\ProgName = "MyTorrent 2.0"
            
            Thread_ID = CreateThread(@TorrentFiles_CreateTorrent(), @Torrent)
            If Thread_ID
              AddWindowTimer(#CreateTorrent_Win, #CreateTorrent_Timer, 400)
            Else
              MessageRequester("Создание торрента.", "Ошибка при создании потока.", #MB_OK|#MB_ICONWARNING)
            EndIf
            
          Else
            MessageRequester("Создание торрента.", "Укажите путь к файлам.", #MB_OK|#MB_ICONWARNING)
          EndIf
      EndSelect
      
      
    ElseIf Event = #PB_Event_CloseWindow
      If Thread_ID <> 0 And IsThread(Thread_ID)
        If MessageRequester("Создание торрента.", "Торрент файл в процессе создания."+Chr(10)+"Прервать?", #MB_YESNO|#MB_ICONQUESTION|#MB_DEFBUTTON2) = #IDYES
          Torrent\BreakThread = 1 ; Прерываем создание файла.
          RemoveWindowTimer(#CreateTorrent_Win, #CreateTorrent_Timer)
          For i=1 To 100
            Delay(100)
            WindowEvent()
            If IsThread(Thread_ID)=0
              Break
            EndIf
          Next i
          
          If IsThread(Thread_ID)
            KillThread(Thread_ID)
          EndIf
          Thread_ID = 0
          
          If FileSize(Torrent\FileName)>=0
            DeleteFile(Torrent\FileName)
          EndIf
          SetGadgetText(#CreateTorrent_CurrentFile, "")
          SetGadgetState(#CreateTorrent_ProgressBar, 0)
          MessageRequester("Создание торрента.", "Торрент файл не был создан - прервано по запросу пользователя.", #MB_OK|#MB_ICONWARNING)
        EndIf
      Else
        Break
      EndIf
      
    ElseIf Event = #PB_Event_Timer
      If EventTimer() = #CreateTorrent_Timer
        If IsThread(Thread_ID) = 0 ; Поток завершился.
          RemoveWindowTimer(#CreateTorrent_Win, #CreateTorrent_Timer)
          Thread_ID = 0
          If Torrent\Result = 1 And Torrent\ErrorCode=0
            MessageRequester("Создание торрента.", "Торрент-файл успешно создан.", #MB_OK|#MB_ICONINFORMATION)
          ElseIf Torrent\ErrorCode>0
            TorrentFiles_CreateTorrent_ShowError(Torrent\ErrorCode, Torrent\ErrorString, "MyTorrent 2.0")              
          EndIf
        EndIf
      EndIf
    EndIf
    
    
    
  ForEver 
  CloseWindow(#CreateTorrent_Win)
Else
  MessageRequester("", "Ошибка при создании окна", #MB_OK|#MB_ICONWARNING)
EndIf

; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 2
; Folding = -
; EnableUnicode
; EnableThread
; EnableXP
; Executable = CreateTorrent.exe