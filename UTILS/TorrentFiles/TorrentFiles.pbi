; Создание торрент файла и работа с ним.
; Автор - Пётр
; http://purebasic.mybb.ru/viewtopic.php?id=249

EnableExplicit

;- Создание torrent-файла

Structure TorrentFiles_CreateInfo
  FileName.s         ; Путь к торрент-файлу.
  Path.s             ; Путь к файлам.
  ClientName.s       ; Название торрент-клиента (добавляется в торрент-файл).
  ProgName.s         ; Название торрент-клиента (для вывода сообщений).
  BreakThread.b      ; Признак того, что нужно завершить поток.
  Directory.b        ; 0 - файл; 1- папка.
  
  List announce.s()  ; Список анонс-серверов.
  Publisher.s
  Publisher_Url.s
  comment.s          ; Комментарий к торренту.
  pieceLength.l      ; Размер сегмента в байтах.
  private.b          ; Если 1, то торрент приватный.
  *PiecesCB          ; Адрес процедуры, в котрой будут передаватся данные о обрабатываемом файле и проценте обработки частей при создании torrent-файла.
  ErrorCode.b        ; Код ошибки создания torrent-файла.
  ErrorString.s
  Result.b           ; 1 - ОК; 0 - Ошибка.
EndStructure

Structure TorrentFiles_FindFile
  Path.s
  FileSize.q
EndStructure

Procedure TorrentFiles_Bencoding_W_String(File, String.s)
  Protected Bytes
  If String<>""
    Bytes = StringByteLength(String, #PB_UTF8)
    If Bytes>0
      WriteString(File, Str(Bytes)+":"+String, #PB_UTF8)
    EndIf
  EndIf
EndProcedure

Procedure TorrentFiles_Bencoding_W_Int(File, Number.q)
  WriteByte(File,'i')
  WriteString(File, Str(Number))
  WriteByte(File,'e')
EndProcedure

Procedure.l TorrentFiles_W_CalcPieces(AllSize.q) ; Вычисление требуемого числа частей, исходя из общего размера файлов.
  Protected Result.l
  Result = 65536 ; 64 КБ.
  If AllSize>0
    If AllSize / 65536 <= 1000         ; 64 КБ.
      Result = 65536
    ElseIf AllSize / 131072 <= 1000    ; 128 КБ.
      Result = 131072
    ElseIf AllSize / 262144 <= 1000    ; 256 КБ.
      Result = 262144
    ElseIf AllSize / 524288 <= 1000    ; 512 КБ.
      Result = 524288
    ElseIf AllSize / 1048576 <= 1000   ; 1024 КБ.
      Result = 1048576
    ElseIf AllSize / 2097152 <= 1000   ; 2048 КБ.
      Result = 2097152
    ElseIf AllSize / 4194304 <= 4000   ; 4096 КБ.
      Result = 4194304
    ElseIf AllSize / 8388608 <= 4000   ; 8 МБ.
      Result = 8388608
    ElseIf AllSize / 16777216 <=8000   ; 16 МБ.
      Result = 16777216
    ElseIf AllSize / 33554432 <=10000  ; 32 МБ.
      Result = 33554432
    Else                               ; 64 МБ..
      Result = 67108864
    EndIf
  EndIf
  ProcedureReturn Result
EndProcedure


Procedure.q TorrentFiles_SizeFiles(List ListFiles.TorrentFiles_FindFile())
  Protected Result.q
  Result = 0
  ForEach ListFiles()
    Result + ListFiles()\FileSize
  Next
  ProcedureReturn Result
EndProcedure

Prototype TorrentFiles_W_GetPieces_CB(File.s, Pos.f) ; Прогресс обработки частей. Имя файла и процент обработаного (0 - 100).

Procedure.b TorrentFiles_W_GetPieces(File_torrent, Piece_Length, Path.s, List ListFiles.TorrentFiles_FindFile(), List SHA1data.s(), *ProcCB, *BreakThread)
  Protected FileID, Result.b, *mem, ReadByte
  Protected SHA1.s, Err.b, FileName.s
  Protected SizeList, Count, MemPos, t_Piece_Length
  Protected CB_Piece.f, CB_Piece_Plus.f, Pieces_CB
  
  Result = #False
  Err    = #False
  
  ClearList(SHA1data())
  t_Piece_Length = Piece_Length
  *mem = AllocateMemory(Piece_Length+1000)
  
  CB_Piece_Plus = 100 / (TorrentFiles_SizeFiles(ListFiles())/Piece_Length)
  CB_Piece = 0
  If *ProcCB
    Pieces_CB.TorrentFiles_W_GetPieces_CB = *ProcCB
    Pieces_CB("",0)
  EndIf
  
  If *mem
    SizeList = ListSize(ListFiles()) - 1
    Count = 0
    MemPos = 0
    ForEach ListFiles()
      
      If PeekB(*BreakThread)=1 ; Принудительное прекращение создания торрент-файла.
        FreeMemory(*mem)
        ProcedureReturn 0
      EndIf
      
      FileName=Path+ListFiles()\Path
      FileID = ReadFile(#PB_Any, FileName)
      If FileID
        
        While Eof(FileID) = 0
          ReadByte = ReadData(FileID, *mem+MemPos, t_Piece_Length)
          If ReadByte+MemPos>=Piece_Length Or (ReadByte>0 And Count>=SizeList And Eof(FileID) <> 0)
            SHA1=SHA1Fingerprint(*mem, ReadByte+MemPos)
            If Len(SHA1) = 40
              If AddElement(SHA1data())
                SHA1data() = SHA1
              Else
                Err = #True
                Break
              EndIf
            Else
              Err = #True
              Break
            EndIf
            MemPos = 0
            t_Piece_Length = Piece_Length
            
            If *ProcCB
              CB_Piece + CB_Piece_Plus
              Pieces_CB(FileName, CB_Piece)
            EndIf
          Else
            t_Piece_Length - ReadByte
            MemPos + ReadByte
            If ReadByte<=0
              Break
            EndIf
          EndIf
          
          
          If PeekB(*BreakThread)=1 ; Принудительное прекращение создания торрент-файла.
            CloseFile(FileID)
            FreeMemory(*mem)
            ProcedureReturn 0
          EndIf
          
        Wend 
        Count + 1
        CloseFile(FileID)
      EndIf
      
      If Err = #True
        Break
      EndIf
    Next
    
    If Err = #False
      Result = #True
      If *ProcCB
        CB_Piece + CB_Piece_Plus
        Pieces_CB("", 100)
      EndIf
    EndIf
    
    FreeMemory(*mem)
  EndIf
  
  ProcedureReturn Result
EndProcedure


Procedure TorrentFiles_FindFiles(Path.s, SubPath.s, Count, List ListFiles.TorrentFiles_FindFile(), *BreakThread) ; Сканирование выбранной папки для добавления файлов в torrent-файл.
  Protected Directory, Type, Name.s
  
  If PeekB(*BreakThread)=1 ; Принудительное прекращение создания торрент-файла.
    ProcedureReturn
  EndIf
  
  If Right(Path,1)<>"\":Path + "\":EndIf
  
  If Count<100
    Directory = ExamineDirectory(#PB_Any, Path, "*.*") ; Начало сканирования папки.
    If Directory
      While NextDirectoryEntry(Directory) ; Следующий файл / папка.
        If PeekB(*BreakThread)=1 ; Принудительное прекращение создания торрент-файла.
          Break
        EndIf
        Type   = DirectoryEntryType(Directory) ; Тип объекта (файл или папка).
        Name.s = DirectoryEntryName(Directory) ; Имя объекта.
        If Name="." Or Name=".."
          Continue
        EndIf
        If Type = #PB_DirectoryEntry_File ; Найден файл.
          InsertElement(ListFiles()) 
          ListFiles()\Path = SubPath + Name
          ListFiles()\FileSize = DirectoryEntrySize(Directory)
        ElseIf Type = #PB_DirectoryEntry_Directory ; Найдена папка.
          TorrentFiles_FindFiles(Path+Name, SubPath+Name+"\", Count+1, ListFiles(), *BreakThread)
        EndIf
      Wend
      FinishDirectory(Directory) ; Завершение сканирования папки.
    EndIf
  EndIf
  
EndProcedure


Procedure.b TorrentFiles_CreateTorrent(*TorrentInfo.TorrentFiles_CreateInfo)
  Protected File_t, Result.b, Piece_Length, Err
  Protected NewList SHA1_Data.s(), ListSize
  Protected NewList ListFiles.TorrentFiles_FindFile();, 
  Protected *SHA1_mem, i, Count, Char_b.a
  Protected String.s, SHA1_FilePath.s, sTemp.s, Pos
  Protected GMT, tzi.TIME_ZONE_INFORMATION, Pieces_CB
  Protected FileName.s, AddFile.s, Directory.b, TorrentClientName.s, ProgName.s
   
  ClearList(SHA1_Data())
  ClearList(ListFiles())
  
  If *TorrentInfo\PiecesCB
    Pieces_CB.TorrentFiles_W_GetPieces_CB = *TorrentInfo\PiecesCB
    Pieces_CB("",0)
  EndIf
  
  FileName = *TorrentInfo\FileName
  AddFile = *TorrentInfo\Path
  Directory = *TorrentInfo\Directory
  TorrentClientName = *TorrentInfo\ClientName
  ProgName = *TorrentInfo\ProgName
  
  Piece_Length = *TorrentInfo\pieceLength
  
  *TorrentInfo\ErrorCode = 0
  *TorrentInfo\ErrorString = ""
  *TorrentInfo\Result = 0
  *TorrentInfo\BreakThread = 0
    
  Result = #False
  Err    = #False
  
  If Directory = #True
    If FileSize(AddFile) <> -2
      *TorrentInfo\ErrorCode = 1
      *TorrentInfo\ErrorString = AddFile
      ProcedureReturn 0
    EndIf
  Else
    If FileSize(AddFile)<=0
      *TorrentInfo\ErrorCode = 2
      *TorrentInfo\ErrorString = AddFile
      ProcedureReturn 0
    EndIf
  EndIf
  
  *SHA1_mem = AllocateMemory(32)
  If *SHA1_mem = 0
    *TorrentInfo\ErrorCode = 3
    ProcedureReturn 0
  EndIf
  
  File_t = CreateFile(#PB_Any, FileName)
  If File_t
    
    WriteByte(File_t,'d')
    
    ListSize = ListSize(*TorrentInfo\announce())
    If ListSize>0
      TorrentFiles_Bencoding_W_String(File_t, "announce")
      SelectElement(*TorrentInfo\announce(),0)
      TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\announce())
      If ListSize > 1
        TorrentFiles_Bencoding_W_String(File_t, "announce-list")
        WriteByte(File_t,'l')
        WriteByte(File_t,'l')
        ForEach *TorrentInfo\announce()
          TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\announce())
        Next
        WriteByte(File_t,'e')
        WriteByte(File_t,'e')
      EndIf
    EndIf
    
    If *TorrentInfo\comment<>""
      TorrentFiles_Bencoding_W_String(File_t, "comment")
      TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\comment)
    EndIf
    
    If TorrentClientName<>""
      TorrentFiles_Bencoding_W_String(File_t, "created by")
      TorrentFiles_Bencoding_W_String(File_t, TorrentClientName)
    EndIf
    
    TorrentFiles_Bencoding_W_String(File_t, "creation date")
    If GetTimeZoneInformation_(@tzi) = 2 ; значит время летнее 
      GMT = tzi\Bias/(-60)+1 ; Например в Лондоне 12 часов, в Москве 15, разница tzi\Bias = 12-15 = -180 минут 
    Else 
      GMT = tzi\Bias/(-60)   ; Иначе - стандартное время 
    EndIf 
    TorrentFiles_Bencoding_W_Int(File_t, AddDate(Date(),#PB_Date_Hour,-GMT))
    
    TorrentFiles_Bencoding_W_String(File_t, "encoding")
    TorrentFiles_Bencoding_W_String(File_t, "UTF-8")
    
    TorrentFiles_Bencoding_W_String(File_t, "info")
    
    WriteByte(File_t,'d')
    
    If *TorrentInfo\BreakThread = 1 ; Принудительное прекращение создания торрент-файла.
      CloseFile(File_t)
      FreeMemory(*SHA1_mem)
      ProcedureReturn 0
    EndIf

    If Directory = #True ; Добавляем папку
      
      sTemp=ReverseString(AddFile)
      Pos=FindString(sTemp,"\",2)
      If Pos>0
        sTemp = Right(AddFile, Pos-1)
        sTemp = RemoveString(sTemp,"\")
        If sTemp=""
          *TorrentInfo\ErrorCode = 4 ; Нет папки.
        EndIf
      Else
        *TorrentInfo\ErrorCode = 4 ; Странно, выбрана папка, а слеша нет.
        *TorrentInfo\ErrorString = AddFile
        Err = #True
      EndIf
      
      If Err = #False
        
        If *TorrentInfo\PiecesCB
          Pieces_CB("Сбор информации о файлах.",0)
        EndIf
        
        TorrentFiles_FindFiles(AddFile, "", 0, ListFiles(), @*TorrentInfo\BreakThread) ; Получаем список файлов для добавления в торрент.
        
        If *TorrentInfo\BreakThread = 1 ; Принудительное прекращение создания торрент-файла.
          CloseFile(File_t)
          FreeMemory(*SHA1_mem)
          ProcedureReturn 0
        EndIf
        
        ListSize = ListSize(ListFiles())
        If ListSize>0 And TorrentFiles_SizeFiles(ListFiles())>0
          TorrentFiles_Bencoding_W_String(File_t, "files")
          WriteByte(File_t,'l')
          ForEach ListFiles()
            WriteByte(File_t,'d')
            TorrentFiles_Bencoding_W_String(File_t, "length")
            TorrentFiles_Bencoding_W_Int(File_t, ListFiles()\FileSize)
            TorrentFiles_Bencoding_W_String(File_t, "path")
            WriteByte(File_t,'l')
            String = ListFiles()\Path
            String = ReplaceString(String, "/","\") 
            Count  = CountString(String, "\")
            If Count>0
              For i=1 To Count
                TorrentFiles_Bencoding_W_String(File_t, StringField(String, i, "\"))
              Next i
            EndIf
            String = GetFilePart(String)
            TorrentFiles_Bencoding_W_String(File_t, String)
            WriteByte(File_t,'e')
            WriteByte(File_t,'e')
            
            If *TorrentInfo\BreakThread = 1 ; Принудительное прекращение создания торрент-файла.
              CloseFile(File_t)
              FreeMemory(*SHA1_mem)
              ProcedureReturn 0
            EndIf
            
          Next
          WriteByte(File_t,'e')
          
          TorrentFiles_Bencoding_W_String(File_t, "name")
          TorrentFiles_Bencoding_W_String(File_t, sTemp)
        Else
          *TorrentInfo\ErrorCode = 5
          Err = #True
        EndIf
      EndIf
      
      SHA1_FilePath = AddFile
      
    Else ; Добавляем только один файл
      If FileSize(AddFile)>0
        
        TorrentFiles_Bencoding_W_String(File_t, "length")
        TorrentFiles_Bencoding_W_Int(File_t, FileSize(AddFile))
        
        TorrentFiles_Bencoding_W_String(File_t, "name")
        TorrentFiles_Bencoding_W_String(File_t, GetFilePart(AddFile))
        
        If AddElement(ListFiles())
          ListFiles()\Path = GetFilePart(AddFile)
          ListFiles()\FileSize = FileSize(AddFile)
        Else
          *TorrentInfo\ErrorCode = 6
          Err = #True
        EndIf
        SHA1_FilePath = GetPathPart(AddFile)
        
      Else
        *TorrentInfo\ErrorCode = 7 ; Файл пустой.
        Err = #True
      EndIf
    EndIf 
    
    If Err = #False
      
      If Piece_Length < 16*1024
        Piece_Length = TorrentFiles_W_CalcPieces(TorrentFiles_SizeFiles(ListFiles())) ; Автоматический рассчет размера частей.
      EndIf
      
      If *TorrentInfo\BreakThread = 1 ; Принудительное прекращение создания торрент-файла.
        CloseFile(File_t)
        FreeMemory(*SHA1_mem)
        ProcedureReturn 0
      EndIf
      
      TorrentFiles_Bencoding_W_String(File_t, "piece length") ; Размер сегмента в байтах
      TorrentFiles_Bencoding_W_Int(File_t, Piece_Length)
      
      TorrentFiles_Bencoding_W_String(File_t, "pieces")
      
      If SHA1_FilePath<>"" And Right(SHA1_FilePath,1)<>"\":SHA1_FilePath + "\":EndIf
      ; Создание хешей.
      If TorrentFiles_W_GetPieces(File_t, Piece_Length, SHA1_FilePath, ListFiles(), SHA1_Data(), *TorrentInfo\PiecesCB, @*TorrentInfo\BreakThread) = #True
        ListSize = ListSize(SHA1_Data())
        If ListSize>0
          WriteString(File_t, Str(ListSize*20)+":")
          ForEach SHA1_Data()
            FillMemory(*SHA1_mem, 20, 0)
            Count=0
            String = SHA1_Data()
            For i=1 To 40 Step 2
              Char_b = Val("$"+Mid(String, i, 2))
              PokeA(*SHA1_mem+Count, Char_b)
              Count + 1
            Next i
            WriteData(File_t, *SHA1_mem, 20)
            
            If *TorrentInfo\BreakThread = 1 ; Принудительное прекращение создания торрент-файла.
              CloseFile(File_t)
              FreeMemory(*SHA1_mem)
              ProcedureReturn 0
            EndIf
            
          Next
        Else
          *TorrentInfo\ErrorCode = 8
          Err = #True
        EndIf
      Else
        *TorrentInfo\ErrorCode = 9
        Err = #True
      EndIf
      
      If *TorrentInfo\private = 1
        TorrentFiles_Bencoding_W_String(File_t, "private")
        TorrentFiles_Bencoding_W_Int(File_t, 1)
      EndIf
      
      WriteByte(File_t,'e')

      
      If *TorrentInfo\Publisher<>""
        TorrentFiles_Bencoding_W_String(File_t, "publisher")
        TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\Publisher)
      EndIf
      
      If *TorrentInfo\Publisher_Url<>""
        TorrentFiles_Bencoding_W_String(File_t, "publisher-url")
        TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\Publisher_Url)
      EndIf
      
      WriteByte(File_t,'e')
      If Err = #False
        Result = #True
      EndIf
    EndIf
    
    CloseFile(File_t)
    
  Else
    *TorrentInfo\ErrorCode = 10
    *TorrentInfo\ErrorString = FileName
  EndIf
  
  If Err = #True
    If FileSize(FileName)>=0
      DeleteFile(FileName)
    EndIf
  EndIf
  
  FreeMemory(*SHA1_mem)
  FreeList(ListFiles())
  FreeList(SHA1_Data())
  
  *TorrentInfo\Result = Result
  
  ProcedureReturn Result
EndProcedure

Procedure TorrentFiles_CreateTorrent_ShowError(ErrorCode.b, Err_String.s="", ProgName.s="") ; Отображение ошибок, произошедших при создании torrent-файла.
  Protected ErrorString.s
  If ErrorCode>0
    If ProgName<>"" : ProgName + " —  " : EndIf
    Select ErrorCode
      Case 1
        ErrorString = "Не найдена папка с файлами."+Chr(10)+Err_String
      Case 2
        ErrorString = "Не найден добавляемый файл."+Chr(10)+Err_String
      Case 3
        ErrorString = "Ошибка выделения памяти под SHA1 хеш."
      Case 4
        ErrorString = "Ошибка в пути к папке с файлами."+Chr(10)+"ВНИМАНИЕ! Нельзя указывать в раздаче корневую папку диска!"+Chr(10)+Err_String
      Case 5
        ErrorString = "Выбранные файлы или папки пустые!"+Chr(10)+"Выберите другое место с файлами."
      Case 6
        ErrorString = "Ошибка при добавлении элемента в список!"+Chr(10)+"Возможно заканчивается свободная память."
      Case 7
        ErrorString = "Выбранный файл пустой (0 байт)!"+Chr(10)+"Выберите другй файл."
      Case 8
        ErrorString = "Отсутсвуют SHA1 хеши файлов."
      Case 9
        ErrorString = "Ошибка при генерации SHA1 хешей файлов."
      Case 10
        ErrorString = "Не удалось создать torrent-файл."+Chr(10)+Err_String
    EndSelect
    MessageRequester(ProgName + "создание torrent-файла.", ErrorString, #MB_ICONWARNING)
  EndIf
EndProcedure




;- Расшифровка torrent-файла.

Structure TorrentFiles_TorrentInfo_pieces ; Описание частей.
  SHA1_string.s        ; SHA1 хеш в виде строки (нижний регистр).
  SHA1_bin.a[20]       ; SHA1 хеш в бинарном виде (20 байт).
EndStructure

Structure TorrentFiles_TorrentInfo_file ; Информация о файлах торрента.
  length.q             ; Размер файла.
  List path.s()        ; Путь, (все папки по отдельности и в конце имя файла).
EndStructure

Structure TorrentFiles_TorrentInfo ; Информация из torrent-файла.
  announce.s           ; Адрес трекера.
  List  announce_list.s()  ; Если есть еще адреса трекеров, то они будут здесь.
  Publisher.s
  Publisher_Url.s
  comment.s            ; Комментарий в torrent-файле.
  created_by.s         ; Информация о создавшем torrent-файл.
  creation_date.l      ; Дата создания torrent-файла по Гринвичу (UTC).
  encoding.b           ; Кодировка файла.
  INFO_Hash.s          ; SHA1 хеш-сумма области "info" torrent-файла.
  TypeDir.b            ; Тип торрента. 1 - папка; любое другое значение - файл.
  CurrentDir_Name.s    ; Имя корневой папки с файлами торрента (только если TypeDir = 1). 
  List files.TorrentFiles_TorrentInfo_file() ; Список всех файлов торрента.
  All_Size.q           ; Размер всех файлов торрента в байтах.
  piece_length.l       ; Размер части.
  Array pieces.TorrentFiles_TorrentInfo_pieces(0) ; SHA1 хеш-суммы частей.
  private.b            ; 1 - торрент приватный; 0 не приватный.
  ErrorCode.b          ; Признак ошбки при расшифровке torrent-файла.
  ErrorString.s        ; Описание ошибки (чаще всего - имя файла, при работе с которым произошла ошибка).
EndStructure


Procedure.s TorrentFiles_GetBencoding_String(*TorrentMem, *M_Pos, MaxSize, encoding, *ErrFlag)
  Protected MemPos, Bytes, i
  Protected Err.b, Char.a, String.s
  
  String=""
  Err = #False
  MemPos = PeekI(*M_Pos)
  
  For i=MemPos To MemPos+18
    Char = PeekA(*TorrentMem+i)
    If Char=':'
      i+1
      Break
    ElseIf Char<'0' Or Char>'9'
      Err = #True
      Break
    EndIf
  Next i
  
  If Err = #False And Char=':' And i>MemPos+1 And i<=MemPos+18
    Bytes = Val(PeekS(*TorrentMem+MemPos, i-MemPos, #PB_Ascii))
    If Bytes>=0 And Bytes <= MaxSize-i
      MemPos + (i-MemPos)
      If Bytes>0
        String = PeekS(*TorrentMem+MemPos, Bytes, encoding)
      Else
        String = ""
      EndIf
      MemPos + Bytes
      PokeI(*M_Pos, MemPos)
    Else
      Err = #True
    EndIf
  Else
    Err = #True
  EndIf
  
  If Err = #True
    PokeB(*ErrFlag, 1)
  EndIf
    
  ProcedureReturn String
EndProcedure

Procedure.q TorrentFiles_GetBencoding_Int(*TorrentMem, *M_Pos, MaxSize, *ErrFlag)
  Protected MemPos, Int.q, i
  Protected Err.b, Char.a
  
  Int = 0
  Err = #False
  MemPos = PeekI(*M_Pos)
  Char = PeekA(*TorrentMem+MemPos)
  If Char='i' Or Char='I'
    MemPos+1
    For i=MemPos To MemPos+18
      Char = PeekA(*TorrentMem+i)
      If Char='e' Or Char='E'
        i+1
        Break
      ElseIf (Char<'0' Or Char>'9') And Char<>'-'
        Err = #True
        Break
      EndIf
    Next i
    
    If Err = #False And i-MemPos-1 > 0 And (Char='e' Or Char='E') And i<=MemPos+18
      Int = Val(PeekS(*TorrentMem+MemPos, i-MemPos-1, #PB_Ascii))
      MemPos = i
      PokeI(*M_Pos, MemPos)
    Else
      Err = #True
    EndIf
  EndIf
  
  If Err = #True
    PokeB(*ErrFlag, 1)
  EndIf
  
  ProcedureReturn Int
EndProcedure

Procedure.a TorrentFiles_GetBencoding_Pieces(*Torrent.TorrentFiles_TorrentInfo, *TorrentMem, *M_Pos, MaxSize)
  Protected MemPos, String.s, i
  Protected Bytes, Result.a, Char.a, EndData
  Protected x, y
  
  String=""
  
  Result = #True
  MemPos = PeekI(*M_Pos)
  
  For i=MemPos To MemPos+18
    Char = PeekA(*TorrentMem+i)
    If Char=':'
      i+1
      Break
    ElseIf Char<'0' Or Char>'9'
      Result = #False
      Break
    EndIf
  Next i
  
  If Result = #True And i>MemPos+1 And Char=':' And i<=MemPos+18
    Bytes = Val(PeekS(*TorrentMem+MemPos, i-MemPos, #PB_Ascii))
    If Bytes>0 And Bytes < MaxSize-i
      If Bytes % 20 = 0
        ReDim *Torrent\pieces(Bytes/20)
        MemPos + (i-MemPos)
        EndData = MemPos + Bytes - 20
        
        x = 0
        For i=MemPos To EndData Step 20
          CopyMemory(*TorrentMem+i, @*Torrent\pieces(x)\SHA1_bin, 20)
          String=""
          For y=i To i+19
            String+RSet(Hex(PeekA(*TorrentMem+y),#PB_Ascii), 2, "0")
          Next y
          *Torrent\pieces(x)\SHA1_string = LCase(String)
          x+1
        Next i
        
        PokeI(*M_Pos, MemPos + Bytes)
      Else
        Result = #False
      EndIf
    Else
     Result = #False
    EndIf
  Else
    Result = #False
  EndIf
  
  ProcedureReturn Result
EndProcedure


Procedure.b TorrentFiles_Bencode_D_Decoder(Comand.s, *Parameter, *Torrent.TorrentFiles_TorrentInfo, *Temp_f)
  Protected Result.b
  
  Result = #True
  
  If Comand<>""
    Select LCase(Comand)
      Case "created by"
        *Torrent\created_by = PeekS(*Parameter)
        
      Case "creation date"
        *Torrent\creation_date = PeekL(*Parameter)
        
      Case "encoding"
        Select LCase(PeekS(*Parameter))
          Case "ascii", "ansi"
            *Torrent\encoding = #PB_Ascii
          Case "utf-8", "utf 8"
            *Torrent\encoding = #PB_UTF8
          Case "unicode"
            *Torrent\encoding = #PB_Unicode
        EndSelect
        
      Case "comment"
        *Torrent\comment = PeekS(*Parameter)
        
      Case "announce"
        *Torrent\announce = PeekS(*Parameter)
        
      Case "announce-list"
        AddElement(*Torrent\announce_list())
        *Torrent\announce_list() = PeekS(*Parameter)
        
      Case "length"
        If PeekB(*Temp_f)=0
          
          If ListSize(*Torrent\files())>0
            LastElement(*Torrent\files())
          EndIf
          
          If AddElement(*Torrent\files()) = 0
            *Torrent\ErrorCode = 5
            Result = #False
            ProcedureReturn Result
          EndIf
          PokeB(*Temp_f, 1)
        EndIf
        *Torrent\files()\length = PeekQ(*Parameter)
        
      Case "path"
        If *Torrent\TypeDir = #True
          If ListSize(*Torrent\files())>0
            LastElement(*Torrent\files())
            If AddElement(*Torrent\files()\path())
              *Torrent\files()\path() = PeekS(*Parameter)
            Else
              *Torrent\ErrorCode = 5
              Result = #False
            EndIf
          Else
            Result = #False
          EndIf
        Else
          Result = #False ; Если это не папка, то чего присутсвует "path"? Значит ошибка.
        EndIf
 
      Case "name"
        If *Torrent\TypeDir = #True ; Много файлов (папка).
          *Torrent\CurrentDir_Name = PeekS(*Parameter)
        Else                       ; Один файл.
          If PeekB(*Temp_f)=0
            If AddElement(*Torrent\files()) = 0
              *Torrent\ErrorCode = 5
              Result = #False
              ProcedureReturn Result
            EndIf
            PokeB(*Temp_f, 1)
          EndIf
          
          If AddElement(*Torrent\files()\path())
            *Torrent\files()\path() = PeekS(*Parameter)
          Else
            *Torrent\ErrorCode = 5
            Result = #False
          EndIf
        EndIf
        
      Case "piece length"
        *Torrent\piece_length = PeekL(*Parameter)
        
      Case "private"
        If PeekQ(*Parameter) = 1
          *Torrent\private = 1
        EndIf
        
      Case "publisher"
        *Torrent\Publisher = PeekS(*Parameter)

      Case "publisher-url"
        *Torrent\Publisher_Url = PeekS(*Parameter)
        
    EndSelect
  EndIf

ProcedureReturn Result
EndProcedure

Procedure TorrentFiles_LoadTorrent_CheckErr(*Torrent.TorrentFiles_TorrentInfo) ; Проверка на ошибки данных torrent-файла.
  Protected Result, F_Size.q, A_size, l_size
  
  Result = #False
  F_Size = 0
  l_size=ListSize(*Torrent\files())
  If l_size>0
    If ListSize(*Torrent\files()\path())>0
      If *Torrent\INFO_Hash<>""
        A_size = ArraySize(*Torrent\pieces())
        If A_size > 0
          ForEach *Torrent\files()
            F_Size + *Torrent\files()\length
          Next
          
          If *Torrent\piece_length >= 16384 And F_Size =< *Torrent\piece_length*A_size And F_Size >= *Torrent\piece_length*(A_size-1)
            *Torrent\All_Size = F_Size
            If *Torrent\TypeDir = #True ; В торренте папка.
              Result = #True
            Else                        ; В торренте файл.
              *Torrent\TypeDir = #False
              If l_size = 1 And ListSize(*Torrent\files()\path()) = 1 ; Поскольку в торренте файл, то должна быть только одна запись о файле.
                Result = #True
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
  EndIf

  ProcedureReturn Result
EndProcedure

Procedure TorrentFiles_BencodeParser(deep.l, Command.a,  MaxSize, ComString.s, *TorrentMem, *Torrent.TorrentFiles_TorrentInfo, *PosMem, *ErrState)
  Protected Char.a, State_D.b, Temp_f.b, MemPos
  Protected qVar.q, String.s, SubErr.b, Info_pos
  
  If deep>=20 Or PeekB(*ErrState)<>0
    ProcedureReturn
  EndIf
  
  State_D=0
  MemPos = PeekI(*PosMem)
  Temp_f = 0
  SubErr = 0
  Info_pos = 0
  
  Repeat 
    Char = PeekA(*TorrentMem + MemPos)
   
    Select Char
      Case 'd', 'D' ; Найдена директива.
        MemPos + 1     
        TorrentFiles_BencodeParser(deep+1, 'd',  MaxSize, ComString, *TorrentMem, *Torrent, @MemPos, *ErrState)
        State_D = 0 : Temp_f = 0 
        
        If Info_pos>0 And LCase(ComString) = "info"
          If Info_pos < MemPos
            *Torrent\INFO_Hash = SHA1Fingerprint(*TorrentMem+Info_pos, MemPos-Info_pos)
          Else
            PokeB(*ErrState, 1)
          EndIf
        EndIf

      Case 'l', 'L' ; Найден список.
        MemPos + 1
        TorrentFiles_BencodeParser(deep+1, 'l',  MaxSize, ComString, *TorrentMem, *Torrent, @MemPos, *ErrState)
        State_D = 0 : Temp_f = 0 
          
      Case 'i', 'I' ; Найдено число (в символьном виде).
        If Command='d'
          SubErr = 0
          qVar = TorrentFiles_GetBencoding_Int(*TorrentMem, @MemPos, MaxSize, @SubErr)
          If SubErr = 0
            If State_D <> 0 
              State_D = 0
              If TorrentFiles_Bencode_D_Decoder(ComString, @qVar, *Torrent, @Temp_f) = #False
                PokeB(*ErrState, 1)
              EndIf
            EndIf
          Else
            PokeB(*ErrState, 1)
          EndIf
          
        ElseIf Command='l'
          If TorrentFiles_Bencode_D_Decoder(ComString, @qVar, *Torrent, @Temp_f) = #False
            PokeB(*ErrState, 1)
          EndIf
        EndIf
        
      Case '0' To '9' ; Найдена строка.
        If State_D = 0 Or  LCase(ComString)<>"pieces"
          
          SubErr = 0
          String=TorrentFiles_GetBencoding_String(*TorrentMem, @MemPos, MaxSize, *Torrent\encoding, @SubErr)
          If SubErr = 0
            If Command='d'
              
              If LCase(String)="files" And LCase(ComString)="info"
                *Torrent\TypeDir = #True
                State_D = 0
              Else  
                If State_D = 0 And String<>""
                  State_D = 1
                  ComString = String
                  If LCase(ComString)="info"
                    Info_pos = MemPos
                  EndIf              
                Else
                  State_D = 0
                  If TorrentFiles_Bencode_D_Decoder(ComString, @String, *Torrent, @Temp_f) = #False
                    PokeB(*ErrState, 1)
                  EndIf
                                    
                  ComString = ""
                EndIf
              EndIf
              
            ElseIf Command='l'
              If TorrentFiles_Bencode_D_Decoder(ComString, @String, *Torrent, @Temp_f) = #False
                PokeB(*ErrState, 1)
              EndIf
            EndIf
          Else
            PokeB(*ErrState, 1)
          EndIf
          
        Else  ; SHA1 хеши.
          State_D = 0
          If TorrentFiles_GetBencoding_Pieces(*Torrent, *TorrentMem, @MemPos, MaxSize) = #False
            PokeB(*ErrState, 1)
          EndIf
                  
        EndIf
      
      Case 'e', 'E' ; Найдена завершающая команда.
        PokeI(*PosMem, MemPos+1)
        ProcedureReturn 
        
      Default
        MemPos + 1
        PokeB(*ErrState, 1)
    EndSelect
    
    If PeekB(*ErrState)<>0
      PokeI(*PosMem, MemPos)
      ProcedureReturn
    EndIf
 
  Until deep>=20 Or MemPos>MaxSize
  
  If deep>=20
    PokeI(*PosMem, MemPos)
  ElseIf MemPos>MaxSize And deep>0
    PokeI(*PosMem, MemPos)
  EndIf
  
EndProcedure

Procedure TorrentFiles_LoadTorrentFile(TorrentFile.s, *Torrent.TorrentFiles_TorrentInfo)
  Protected Result.b, Err.b, File_t, FileSize.q
  Protected *TorrentMem,MemPos, Char.a, FileSize_t.q
  Protected NewList CommandInfo.a(), deep
  
  Result = #False
  Err    = #False
  deep = 0       ; Глубина рекурсии.
  
  ClearStructure(*Torrent, TorrentFiles_TorrentInfo)
  ClearList(CommandInfo())
  NewList *Torrent\announce_list()
  NewList *Torrent\files()
  Dim *Torrent\pieces(0)
  
  *Torrent\ErrorCode = 0
  *Torrent\encoding = #PB_UTF8
  *Torrent\TypeDir = #False
  *TorrentMem = 0
  File_t = 0
  
  File_t = ReadFile(#PB_Any, TorrentFile)
  If File_t
    FileSize = Lof(File_t)
    If FileSize>0 And FileSize<20000000
      *TorrentMem = AllocateMemory(FileSize+10)
      If *TorrentMem
        FillMemory(*TorrentMem, FileSize+8, 0)
        If ReadData(File_t, *TorrentMem, FileSize) <> FileSize
          Err = #True
          *Torrent\ErrorCode = 1 ; Число считанных байт не равно размеру файла.
        EndIf
      Else
        Err = #True
        *Torrent\ErrorCode = 2 ; Ошибка выделения памяти.
      EndIf
    Else
      Err = #True
      *Torrent\ErrorCode = 3 ; Некорректный размер torrent-файла.
    EndIf
    CloseFile(File_t)
    File_t = 0
  Else
    Err = #True
    *Torrent\ErrorCode = 4 ; Не получилось открыть для чтения torrent-файл.
  EndIf
  
  If Err = #True
    *Torrent\ErrorString  = TorrentFile
    
    If *TorrentMem
      FreeMemory(*TorrentMem)
    EndIf
    
    If File_t
      CloseFile(File_t)
    EndIf
    
    FreeList(CommandInfo())
    ProcedureReturn 0
  EndIf
  
  MemPos=0
  FileSize_t = FileSize - 1
    
  TorrentFiles_BencodeParser(0, 0, FileSize_t, "", *TorrentMem, *Torrent, @MemPos, @Err)
  
  If Err = #False
    If TorrentFiles_LoadTorrent_CheckErr(*Torrent) = #True
      Result = #True
      If *Torrent\announce<>""
         Char=0
         ForEach *Torrent\announce_list()
           If *Torrent\announce_list() = *Torrent\announce
             Char=1
             Break
           EndIf
         Next
         
         If Char=0
           FirstElement(*Torrent\announce_list())
           If InsertElement(*Torrent\announce_list())
             *Torrent\announce_list() = *Torrent\announce
           EndIf
         EndIf
         
      EndIf
    EndIf
  EndIf
  
  If Result <> #True 
    *Torrent\ErrorString  = TorrentFile 
    If *Torrent\ErrorCode <> 5 : *Torrent\ErrorCode = 6 : EndIf
  EndIf
    
  If *TorrentMem
    FreeMemory(*TorrentMem)
  EndIf
  
  FreeList(CommandInfo())
    
  ProcedureReturn Result
EndProcedure

Procedure TorrentFiles_LoadTorrentFile_ShowEror(ErrorCode.a, Err_String.s="", ProgName.s="")
  Protected ErrorString.s
  If ErrorCode>0
    If ProgName<>"" : ProgName + " —  " : EndIf
    Select ErrorCode
      Case 1
        ErrorString = "Ошибка при чтении torrent-файла."+Chr(10)+Err_String
      Case 2
        ErrorString = "Ошибка при чтении torrent-файла (память)."+Chr(10)+Err_String
      Case 3
        ErrorString = "Некорректный размер torrent-файла."+Chr(10)+Err_String
      Case 4
        ErrorString = "Не получилось открыть для чтения torrent-файл."+Chr(10)+Err_String
      Case 5
        ErrorString = "Ошибка при выделении памяти под данные."+Chr(10)+Err_String
      Case 6
        ErrorString = "Ошибка в структуре torrent-файла."+Chr(10)+Err_String
    EndSelect
    MessageRequester(ProgName + "декодирование torrent-файла.", ErrorString, #MB_ICONWARNING)
  EndIf
EndProcedure



; Эта процедура вызывается для создания тррент файла по уже известным данным.
Procedure.b TorrentFiles_CreateSysFile_Torrent(FileName.s, *TorrentInfo.TorrentFiles_TorrentInfo)
  Protected File_t, Result.b, Err, SizeArray
  Protected *SHA1_mem, i, Count, Char_b.a
  Protected String.s, Pos
  Protected Pieces_CB, ListSize
    
  Result = #False
  Err    = #False
  
  *SHA1_mem = AllocateMemory(32)
  If *SHA1_mem = 0
    *TorrentInfo\ErrorCode = 3
    ProcedureReturn 0
  EndIf
  
  File_t = CreateFile(#PB_Any, FileName)
  If File_t
    
    WriteByte(File_t,'d')
    
    If *TorrentInfo\announce<>""
      TorrentFiles_Bencoding_W_String(File_t, "announce")
      TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\announce)
    EndIf
    
    ListSize = ListSize(*TorrentInfo\announce_list())
    If ListSize>0
        TorrentFiles_Bencoding_W_String(File_t, "announce-list")
        WriteByte(File_t,'l')
        WriteByte(File_t,'l')
        ForEach *TorrentInfo\announce_list()
          TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\announce_list())
        Next
        WriteByte(File_t,'e')
        WriteByte(File_t,'e')
    EndIf
    
    If *TorrentInfo\comment<>""
      TorrentFiles_Bencoding_W_String(File_t, "comment")
      TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\comment)
    EndIf
    
    If *TorrentInfo\created_by<>""
      TorrentFiles_Bencoding_W_String(File_t, "created by")
      TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\created_by)
    EndIf
    
    TorrentFiles_Bencoding_W_String(File_t, "creation date") 
    TorrentFiles_Bencoding_W_Int(File_t, *TorrentInfo\creation_date)
    
    TorrentFiles_Bencoding_W_String(File_t, "encoding")
    TorrentFiles_Bencoding_W_String(File_t, "UTF-8")
    
    TorrentFiles_Bencoding_W_String(File_t, "info")
    
    WriteByte(File_t,'d')
        
    If *TorrentInfo\TypeDir = #True ; Добавляем папку
      
      If Err = #False
        ListSize = ListSize(*TorrentInfo\files())
        If ListSize>0
          TorrentFiles_Bencoding_W_String(File_t, "files")
          WriteByte(File_t,'l')
          ForEach *TorrentInfo\files()
            WriteByte(File_t,'d')
            TorrentFiles_Bencoding_W_String(File_t, "length")
            TorrentFiles_Bencoding_W_Int(File_t, *TorrentInfo\files()\length)
            TorrentFiles_Bencoding_W_String(File_t, "path")
            WriteByte(File_t,'l')
            ForEach *TorrentInfo\files()\path()
              TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\files()\path())
            Next
            WriteByte(File_t,'e')
            WriteByte(File_t,'e')
            
          Next
          WriteByte(File_t,'e')
          
          TorrentFiles_Bencoding_W_String(File_t, "name")
          TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\CurrentDir_Name)

        EndIf
      EndIf
      
    Else ; Добавляем только один файл
      
        SelectElement(*TorrentInfo\files(),0)
        TorrentFiles_Bencoding_W_String(File_t, "length")
        TorrentFiles_Bencoding_W_Int(File_t, *TorrentInfo\files()\length)
        
        SelectElement(*TorrentInfo\files()\path(),0)
        TorrentFiles_Bencoding_W_String(File_t, "name")
        TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\files()\path())

    EndIf 
    
    If Err = #False
      
      TorrentFiles_Bencoding_W_String(File_t, "piece length") ; Размер сегмента в байтах
      TorrentFiles_Bencoding_W_Int(File_t, *TorrentInfo\Piece_Length)
      
      TorrentFiles_Bencoding_W_String(File_t, "pieces")
      
      ; Создание хешей.
      SizeArray = ArraySize(*TorrentInfo\pieces())-1
      If SizeArray>=0
        WriteString(File_t, Str((SizeArray+1)*20)+":")
        For i=0 To SizeArray
          FillMemory(*SHA1_mem, 20, 0)
          For Pos=0 To 19
            PokeA(*SHA1_mem+Pos, *TorrentInfo\pieces(i)\SHA1_bin[Pos])
          Next Pos
          WriteData(File_t, *SHA1_mem, 20)
        Next i
      EndIf
      
      If *TorrentInfo\private = 1
        TorrentFiles_Bencoding_W_String(File_t, "private")
        TorrentFiles_Bencoding_W_Int(File_t, 1)
      EndIf
      
      WriteByte(File_t,'e')
      
      If *TorrentInfo\Publisher<>""
        TorrentFiles_Bencoding_W_String(File_t, "publisher")
        TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\Publisher)
      EndIf
      
      If *TorrentInfo\Publisher_Url<>""
        TorrentFiles_Bencoding_W_String(File_t, "publisher-url")
        TorrentFiles_Bencoding_W_String(File_t, *TorrentInfo\Publisher_Url)
      EndIf
      
      WriteByte(File_t,'e')
      If Err = #False
        Result = #True
      EndIf
    EndIf
    
    CloseFile(File_t)
    
  EndIf
  
  If Err = #True
    If FileSize(FileName)>=0
      DeleteFile(FileName)
    EndIf
  EndIf
  
  FreeMemory(*SHA1_mem)
 
  ProcedureReturn Result
EndProcedure

DisableExplicit
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 2
; Folding = ---
; EnableUnicode