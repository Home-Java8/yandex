Использую API BencodeLibrary - 'Bitext'
1. Объеденил структуру обоих мавен-проектов (1) 'torrentbuild-dataformat-bencode' и (2) 'torrentparse-dataformat-bencode' в мавен-проект: 'dataformat-bencode'.
   - теперь только одно java-приложение - 'dataformat-bencode-app.jar' - выполняет сборку (создает) и разборку (читает) .torrent-файлов
   - для передачи параметров в java-приложение использую ключи:
     * -announce-file       : ANNOUNCE_FILE
     * -announce-file-owner : ANNOUNCE_FILE_OWNER
     * -announce-file-size  : file size (in bytes)
     * -current-time        : current time in milisekuddah
     * -piece-length        : full size pieces of the file
     * -pieces              : pieces of the file for distribution to other clients
     * -text-comment        : TEXT_COMMENT
     * -tracker-url         : TRACKER_URL
     * -ttorrent-file       : TTORRENT_FILE
   - в 'com.dataformat.api' лежит API BencodeLibrary
   - в 'com.dataformat.common' лежат классы по реализации задания
   - 'com.dataformat.MainTorrent' (main)
   - в 'data' складываются обрабатываемые файлы
2. Для запуска java-приложения 'dataformat-bencode-app.jar' в консоли:
   - создать .torrent-файл
     java -jar target/dataformat-bencode-app.jar -announce-file apache-maven-2.2.1-bin.zip -ttorrent-file apache-maven-2.2.1-bin.zip.torrent -announce-file-owner Lazarchuk%20A.K. -tracker-url http://code.google.com/p/commons-java-weather/downloads/detail?name=apache-maven-2.2.1-bin.zip -text-comment Apache%20Maven%202.2.1
   - распарсить .torrent-файл
     java -jar target/dataformat-bencode-app.jar -ttorrent-file apache-maven-2.2.1-bin.zip.torrent
3. Собрать мавен-проекты командой: 'mvn assembly:assembly'

4. Для демонстрации законченой идеи (схемы трекер-клиент) использовал API 'turn' в проекте - 'bittorrent'
   - для сборки использую мавен-3
   - класс 'com.ttorrent.MainTracker', запускается с аргументами: '-p 6969'
   - и класс 'com.ttorrent.MainClient', запускается с аргументами: '-o out -s 3600 -d 50.0 -u 50.0'
   - в результате работы приложения: трекер собирает информацию о клиентах...; а клиенты могут загружать файлы в потоке;
     раздаваемый файл лежит в корне проекта; а данные клиентом загружаются в 'data'