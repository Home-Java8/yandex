........................................................................................................................
1 Сервер "трекер" (BitTorrent-трекер) - осуществляющий координацию клиентов "BitTorrent", этот трекер-сервер соббирает информацию где (на каких клиентах) и какие файлы лежат...
2 Тторрент-клиент - использует заголовочный .torrent-файл выполняет раздачу и загрузку данных (кусков) клиентских файлов между другими клиентами...
3 BEncode - это формат для сборки и разборки заголовочных .ttorrent-файл...
4. Файл-источник, который будет раздаваться другим клиентам - "announce"
5. Лимит по скрости загрузки и раздачи (выгрузки) данных - "max-download", "max-upload"
6. После загрузки потока клиентского файла на сторону другого клиента нужно выполнить раздачу... - "seed" (share)
7. Тип (класс) IP-адресса для клиентской торент-сети - "IFACE"
8 Предварительно файл-источник ("announce") нужно разбить на куски для раздачи - "piece_length"
9. N-количество частей ("piece_length")... - "pieces"
........................................................................................................................


Ttorrent a Java implementation of the BitTorrent protocol
=========================================================================
1. Запускаем серверное приложение: "com.bittorrent.MainTracker"
   Этот BitTorrent-трекер находит (соббирает информацию) все доступные .ttorrent-файлы в корне проекта (потом клиенты смогут находить альтернативные источник)...
   в качестве аргументов указываем порт: "-p 6969"
   подымается хост сервера по URL-адрессу: "http://localhost:6969/announce"
   и в результате получаем следующий информативный лог о расдаче...:
-------------------------------------------------------------------------
2014-08-08 13:10:13,341 [main                     ] INFO : Loading torrent from chtenie-i-zapisi-baitov-java.png.torrent
2014-08-08 13:10:13,373 [main                     ] INFO : Single-file torrent information:
2014-08-08 13:10:13,373 [main                     ] INFO :   Torrent name: chtenie-i-zapisi-baitov-java.png
2014-08-08 13:10:13,373 [main                     ] INFO :   Announced at:
2014-08-08 13:10:13,374 [main                     ] INFO :      1. http://pro-java.ru/java-dlya-nachinayushhix/chtenie-i-zapis-bajtov-java/
2014-08-08 13:10:13,376 [main                     ] INFO :   Created on..: Tue Aug 05 22:44:59 EEST 2014
2014-08-08 13:10:13,376 [main                     ] INFO :   Comment.....: Чтение и запись байтов Java
2014-08-08 13:10:13,376 [main                     ] INFO :   Created by..: Lazarchuk A.K.
2014-08-08 13:10:13,377 [main                     ] INFO :   Pieces......: 1 piece(s) (65536 byte(s)/piece)
2014-08-08 13:10:13,378 [main                     ] INFO :   Total size..: 27 282 byte(s)
2014-08-08 13:10:13,378 [main                     ] INFO : Registered new torrent for 'chtenie-i-zapisi-baitov-java.png' with hash 6FC27C7BA2758A2E228EB954636DD147FEAB2619.
2014-08-08 13:10:13,378 [main                     ] INFO : Loading torrent from BitTorrent.torrent
2014-08-08 13:10:13,400 [main                     ] INFO : Multi-file torrent information:
2014-08-08 13:10:13,400 [main                     ] INFO :   Torrent name: BitTorrent
2014-08-08 13:10:13,400 [main                     ] INFO :   Announced at:
2014-08-08 13:10:13,400 [main                     ] INFO :      1. udp://tracker.publicbt.com:80/announce
2014-08-08 13:10:13,401 [main                     ] INFO :      2. udp://tracker.openbittorrent.com:80/announce
2014-08-08 13:10:13,401 [main                     ] INFO :      3. http://tracker.todium.com/780121a01736a2d19789c4e66f9e1f16611b5d58/announce
2014-08-08 13:10:13,401 [main                     ] INFO :   Created on..: Sat Jun 15 00:57:28 EEST 2013
2014-08-08 13:10:13,401 [main                     ] INFO :   Comment.....: Official BitTorrent Content
2014-08-08 13:10:13,401 [main                     ] INFO :   Created by..: BitTorrent, Inc.
2014-08-08 13:10:13,401 [main                     ] INFO :   Found 31 file(s) in multi-file torrent structure.
2014-08-08 13:10:13,401 [main                     ] DEBUG:      1. BitTorrent/bittorrentisnotacrime-sticker.pdf (51 090 byte(s))
2014-08-08 13:10:13,401 [main                     ] DEBUG:      2. BitTorrent/How To/How to - Remote.png (197 070 byte(s))
2014-08-08 13:10:13,402 [main                     ] DEBUG:      3. BitTorrent/How To/How to - Surf.png (160 804 byte(s))
2014-08-08 13:10:13,402 [main                     ] DEBUG:      4. BitTorrent/How To/uTorrent_Tetris.png (75 402 byte(s))
2014-08-08 13:10:13,402 [main                     ] DEBUG:      5. BitTorrent/Videos/BitTorrent Bundle.mp4 (33 251 599 byte(s))
2014-08-08 13:10:13,402 [main                     ] DEBUG:      6. BitTorrent/Videos/BitTorrent Sessions - Tim Ferriss- Your Book is a Startup.mp4 (400 411 710 byte(s))
2014-08-08 13:10:13,403 [main                     ] DEBUG:      7. BitTorrent/Videos/BitTorrent Surf.mp4 (8 562 877 byte(s))
2014-08-08 13:10:13,403 [main                     ] DEBUG:      8. BitTorrent/Wallpapers/061113-BT-field-1280x1280.png (2 336 537 byte(s))
2014-08-08 13:10:13,403 [main                     ] DEBUG:      9. BitTorrent/Wallpapers/061113-BT-field-640x960.png (892 167 byte(s))
2014-08-08 13:10:13,403 [main                     ] DEBUG:     10. BitTorrent/Wallpapers/061113-BT-projection-1280x1280.png (829 322 byte(s))
2014-08-08 13:10:13,403 [main                     ] DEBUG:     11. BitTorrent/Wallpapers/061113-BT-projection-2560x1600.png (8 723 797 byte(s))
2014-08-08 13:10:13,404 [main                     ] DEBUG:     12. BitTorrent/Wallpapers/061113-BT-projection-640x960.png (475 004 byte(s))
2014-08-08 13:10:13,404 [main                     ] DEBUG:     13. BitTorrent/Wallpapers/061113-BT-type-1280x1280.png (20 641 byte(s))
2014-08-08 13:10:13,404 [main                     ] DEBUG:     14. BitTorrent/Wallpapers/061113-BT-type-2560x1600.png (73 219 byte(s))
2014-08-08 13:10:13,404 [main                     ] DEBUG:     15. BitTorrent/Wallpapers/061113-BT-type-640x960.png (14 475 byte(s))
2014-08-08 13:10:13,404 [main                     ] DEBUG:     16. BitTorrent/Wallpapers/061113-SoShare-lines-1280x1280.png (103 049 byte(s))
2014-08-08 13:10:13,405 [main                     ] DEBUG:     17. BitTorrent/Wallpapers/061113-SoShare-lines-2560x1600.png (165 153 byte(s))
2014-08-08 13:10:13,405 [main                     ] DEBUG:     18. BitTorrent/Wallpapers/061113-SoShare-lines-640x960.png (57 747 byte(s))
2014-08-08 13:10:13,405 [main                     ] DEBUG:     19. BitTorrent/Wallpapers/061113-SoShare-tools-1280x1280.png (13 364 byte(s))
2014-08-08 13:10:13,405 [main                     ] DEBUG:     20. BitTorrent/Wallpapers/061113-SoShare-tools-2560x1600.png (23 897 byte(s))
2014-08-08 13:10:13,406 [main                     ] DEBUG:     21. BitTorrent/Wallpapers/061113-SoShare-tools-640x960.png (8 667 byte(s))
2014-08-08 13:10:13,406 [main                     ] DEBUG:     22. BitTorrent/Wallpapers/061113-UT-hummingbird-1280x1280.png (234 093 byte(s))
2014-08-08 13:10:13,406 [main                     ] DEBUG:     23. BitTorrent/Wallpapers/061113-UT-hummingbird-2560x1600.png (406 153 byte(s))
2014-08-08 13:10:13,406 [main                     ] DEBUG:     24. BitTorrent/Wallpapers/061113-UT-hummingbird-640x960.png (149 274 byte(s))
2014-08-08 13:10:13,406 [main                     ] DEBUG:     25. BitTorrent/Wallpapers/061113-UT-swarm-1280x1280.png (207 728 byte(s))
2014-08-08 13:10:13,407 [main                     ] DEBUG:     26. BitTorrent/Wallpapers/061113-UT-swarm-2560x1600.png (438 953 byte(s))
2014-08-08 13:10:13,407 [main                     ] DEBUG:     27. BitTorrent/Wallpapers/061113-UT-swarm-640x960.png (105 897 byte(s))
2014-08-08 13:10:13,407 [main                     ] DEBUG:     28. BitTorrent/Wallpapers/061113-UT-type-1280x1280.png (22 923 byte(s))
2014-08-08 13:10:13,407 [main                     ] DEBUG:     29. BitTorrent/Wallpapers/061113-UT-type-2560x1600.png (90 843 byte(s))
2014-08-08 13:10:13,408 [main                     ] DEBUG:     30. BitTorrent/Wallpapers/061113-UT-type-640x960.png (16 457 byte(s))
2014-08-08 13:10:13,408 [main                     ] DEBUG:     31. BitTorrent/Wallpapers/BitTorrent Wallpaper.png (8 723 797 byte(s))
2014-08-08 13:10:13,408 [main                     ] INFO :   Pieces......: 1781 piece(s) (262144 byte(s)/piece)
2014-08-08 13:10:13,408 [main                     ] INFO :   Total size..: 466 843 709 byte(s)
2014-08-08 13:10:13,408 [main                     ] INFO : Registered new torrent for 'BitTorrent' with hash 29B979CBE93445281719FBE7331933CE679F6BBE.
2014-08-08 13:10:13,408 [main                     ] INFO : Starting tracker with 2 announced torrents...
2014-08-08 13:10:13,410 [tracker:6969             ] INFO : Starting BitTorrent tracker on http://0.0.0.0:6969/announce...
2014-08-08 13:10:13,410 [peer-collector:6969      ] INFO : Starting tracker peer collection for tracker at http://0.0.0.0:6969/announce...
2014-08-08 13:10:56,519 [Dispatcher-0             ] WARN : Could not process announce request (Missing info hash) !

2. Запускаем клиентское приложение: "com.bittorrent.MainClient"
   в качестве аргументов указываем порт: "-o out -s 3600 -d 50.0 -u 50.0"
   и в результате получаем следующий информативный лог о...:
-------------------------------------------------------------------------
2014-08-08 15:46:49,503 [main                     ] INFO : Multi-file torrent information:
2014-08-08 15:46:49,503 [main                     ] INFO :   Torrent name: BitTorrent
2014-08-08 15:46:49,503 [main                     ] INFO :   Announced at:
2014-08-08 15:46:49,506 [main                     ] INFO :      1. udp://tracker.publicbt.com:80/announce
2014-08-08 15:46:49,506 [main                     ] INFO :      2. udp://tracker.openbittorrent.com:80/announce
2014-08-08 15:46:49,506 [main                     ] INFO :      3. http://tracker.todium.com/780121a01736a2d19789c4e66f9e1f16611b5d58/announce
2014-08-08 15:46:49,509 [main                     ] INFO :   Created on..: Sat Jun 15 00:57:28 EEST 2013
2014-08-08 15:46:49,509 [main                     ] INFO :   Comment.....: Official BitTorrent Content
2014-08-08 15:46:49,509 [main                     ] INFO :   Created by..: BitTorrent, Inc.
2014-08-08 15:46:49,509 [main                     ] INFO :   Found 31 file(s) in multi-file torrent structure.
2014-08-08 15:46:49,509 [main                     ] DEBUG:      1. BitTorrent/bittorrentisnotacrime-sticker.pdf (51 090 byte(s))
2014-08-08 15:46:49,510 [main                     ] DEBUG:      2. BitTorrent/How To/How to - Remote.png (197 070 byte(s))
2014-08-08 15:46:49,510 [main                     ] DEBUG:      3. BitTorrent/How To/How to - Surf.png (160 804 byte(s))
2014-08-08 15:46:49,510 [main                     ] DEBUG:      4. BitTorrent/How To/uTorrent_Tetris.png (75 402 byte(s))
2014-08-08 15:46:49,510 [main                     ] DEBUG:      5. BitTorrent/Videos/BitTorrent Bundle.mp4 (33 251 599 byte(s))
2014-08-08 15:46:49,511 [main                     ] DEBUG:      6. BitTorrent/Videos/BitTorrent Sessions - Tim Ferriss- Your Book is a Startup.mp4 (400 411 710 byte(s))
2014-08-08 15:46:49,511 [main                     ] DEBUG:      7. BitTorrent/Videos/BitTorrent Surf.mp4 (8 562 877 byte(s))
2014-08-08 15:46:49,511 [main                     ] DEBUG:      8. BitTorrent/Wallpapers/061113-BT-field-1280x1280.png (2 336 537 byte(s))
2014-08-08 15:46:49,511 [main                     ] DEBUG:      9. BitTorrent/Wallpapers/061113-BT-field-640x960.png (892 167 byte(s))
2014-08-08 15:46:49,511 [main                     ] DEBUG:     10. BitTorrent/Wallpapers/061113-BT-projection-1280x1280.png (829 322 byte(s))
2014-08-08 15:46:49,512 [main                     ] DEBUG:     11. BitTorrent/Wallpapers/061113-BT-projection-2560x1600.png (8 723 797 byte(s))
2014-08-08 15:46:49,512 [main                     ] DEBUG:     12. BitTorrent/Wallpapers/061113-BT-projection-640x960.png (475 004 byte(s))
2014-08-08 15:46:49,512 [main                     ] DEBUG:     13. BitTorrent/Wallpapers/061113-BT-type-1280x1280.png (20 641 byte(s))
2014-08-08 15:46:49,512 [main                     ] DEBUG:     14. BitTorrent/Wallpapers/061113-BT-type-2560x1600.png (73 219 byte(s))
2014-08-08 15:46:49,512 [main                     ] DEBUG:     15. BitTorrent/Wallpapers/061113-BT-type-640x960.png (14 475 byte(s))
2014-08-08 15:46:49,513 [main                     ] DEBUG:     16. BitTorrent/Wallpapers/061113-SoShare-lines-1280x1280.png (103 049 byte(s))
2014-08-08 15:46:49,513 [main                     ] DEBUG:     17. BitTorrent/Wallpapers/061113-SoShare-lines-2560x1600.png (165 153 byte(s))
2014-08-08 15:46:49,513 [main                     ] DEBUG:     18. BitTorrent/Wallpapers/061113-SoShare-lines-640x960.png (57 747 byte(s))
2014-08-08 15:46:49,513 [main                     ] DEBUG:     19. BitTorrent/Wallpapers/061113-SoShare-tools-1280x1280.png (13 364 byte(s))
2014-08-08 15:46:49,514 [main                     ] DEBUG:     20. BitTorrent/Wallpapers/061113-SoShare-tools-2560x1600.png (23 897 byte(s))
2014-08-08 15:46:49,514 [main                     ] DEBUG:     21. BitTorrent/Wallpapers/061113-SoShare-tools-640x960.png (8 667 byte(s))
2014-08-08 15:46:49,514 [main                     ] DEBUG:     22. BitTorrent/Wallpapers/061113-UT-hummingbird-1280x1280.png (234 093 byte(s))
2014-08-08 15:46:49,514 [main                     ] DEBUG:     23. BitTorrent/Wallpapers/061113-UT-hummingbird-2560x1600.png (406 153 byte(s))
2014-08-08 15:46:49,514 [main                     ] DEBUG:     24. BitTorrent/Wallpapers/061113-UT-hummingbird-640x960.png (149 274 byte(s))
2014-08-08 15:46:49,515 [main                     ] DEBUG:     25. BitTorrent/Wallpapers/061113-UT-swarm-1280x1280.png (207 728 byte(s))
2014-08-08 15:46:49,515 [main                     ] DEBUG:     26. BitTorrent/Wallpapers/061113-UT-swarm-2560x1600.png (438 953 byte(s))
2014-08-08 15:46:49,515 [main                     ] DEBUG:     27. BitTorrent/Wallpapers/061113-UT-swarm-640x960.png (105 897 byte(s))
2014-08-08 15:46:49,515 [main                     ] DEBUG:     28. BitTorrent/Wallpapers/061113-UT-type-1280x1280.png (22 923 byte(s))
2014-08-08 15:46:49,515 [main                     ] DEBUG:     29. BitTorrent/Wallpapers/061113-UT-type-2560x1600.png (90 843 byte(s))
2014-08-08 15:46:49,516 [main                     ] DEBUG:     30. BitTorrent/Wallpapers/061113-UT-type-640x960.png (16 457 byte(s))
2014-08-08 15:46:49,516 [main                     ] DEBUG:     31. BitTorrent/Wallpapers/BitTorrent Wallpaper.png (8 723 797 byte(s))
2014-08-08 15:46:49,516 [main                     ] INFO :   Pieces......: 1781 piece(s) (262144 byte(s)/piece)
2014-08-08 15:46:49,516 [main                     ] INFO :   Total size..: 466 843 709 byte(s)
2014-08-08 15:46:49,554 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/bittorrentisnotacrime-sticker.pdf.part...
2014-08-08 15:46:49,556 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/bittorrentisnotacrime-sticker.pdf.part (0+51090 byte(s)).
2014-08-08 15:46:49,556 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/How To/How to - Remote.png.part...
2014-08-08 15:46:49,556 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/How To/How to - Remote.png.part (51090+197070 byte(s)).
2014-08-08 15:46:49,556 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/How To/How to - Surf.png.part...
2014-08-08 15:46:49,556 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/How To/How to - Surf.png.part (248160+160804 byte(s)).
2014-08-08 15:46:49,557 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/How To/uTorrent_Tetris.png.part...
2014-08-08 15:46:49,557 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/How To/uTorrent_Tetris.png.part (408964+75402 byte(s)).
2014-08-08 15:46:49,557 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Videos/BitTorrent Bundle.mp4.part...
2014-08-08 15:46:49,557 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Videos/BitTorrent Bundle.mp4.part (484366+33251599 byte(s)).
2014-08-08 15:46:49,557 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Videos/BitTorrent Sessions - Tim Ferriss- Your Book is a Startup.mp4.part...
2014-08-08 15:46:49,557 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Videos/BitTorrent Sessions - Tim Ferriss- Your Book is a Startup.mp4.part (33735965+400411710 byte(s)).
2014-08-08 15:46:49,557 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Videos/BitTorrent Surf.mp4.part...
2014-08-08 15:46:49,558 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Videos/BitTorrent Surf.mp4.part (434147675+8562877 byte(s)).
2014-08-08 15:46:49,558 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-field-1280x1280.png.part...
2014-08-08 15:46:49,558 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-field-1280x1280.png.part (442710552+2336537 byte(s)).
2014-08-08 15:46:49,558 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-field-640x960.png.part...
2014-08-08 15:46:49,558 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-field-640x960.png.part (445047089+892167 byte(s)).
2014-08-08 15:46:49,558 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-projection-1280x1280.png.part...
2014-08-08 15:46:49,558 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-projection-1280x1280.png.part (445939256+829322 byte(s)).
2014-08-08 15:46:49,559 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-projection-2560x1600.png.part...
2014-08-08 15:46:49,559 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-projection-2560x1600.png.part (446768578+8723797 byte(s)).
2014-08-08 15:46:49,559 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-projection-640x960.png.part...
2014-08-08 15:46:49,559 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-projection-640x960.png.part (455492375+475004 byte(s)).
2014-08-08 15:46:49,559 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-type-1280x1280.png.part...
2014-08-08 15:46:49,559 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-type-1280x1280.png.part (455967379+20641 byte(s)).
2014-08-08 15:46:49,559 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-type-2560x1600.png.part...
2014-08-08 15:46:49,560 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-type-2560x1600.png.part (455988020+73219 byte(s)).
2014-08-08 15:46:49,560 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-type-640x960.png.part...
2014-08-08 15:46:49,560 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-BT-type-640x960.png.part (456061239+14475 byte(s)).
2014-08-08 15:46:49,560 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-lines-1280x1280.png.part...
2014-08-08 15:46:49,560 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-lines-1280x1280.png.part (456075714+103049 byte(s)).
2014-08-08 15:46:49,560 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-lines-2560x1600.png.part...
2014-08-08 15:46:49,560 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-lines-2560x1600.png.part (456178763+165153 byte(s)).
2014-08-08 15:46:49,560 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-lines-640x960.png.part...
2014-08-08 15:46:49,561 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-lines-640x960.png.part (456343916+57747 byte(s)).
2014-08-08 15:46:49,561 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-tools-1280x1280.png.part...
2014-08-08 15:46:49,561 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-tools-1280x1280.png.part (456401663+13364 byte(s)).
2014-08-08 15:46:49,561 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-tools-2560x1600.png.part...
2014-08-08 15:46:49,561 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-tools-2560x1600.png.part (456415027+23897 byte(s)).
2014-08-08 15:46:49,561 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-tools-640x960.png.part...
2014-08-08 15:46:49,561 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-SoShare-tools-640x960.png.part (456438924+8667 byte(s)).
2014-08-08 15:46:49,562 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-hummingbird-1280x1280.png.part...
2014-08-08 15:46:49,562 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-hummingbird-1280x1280.png.part (456447591+234093 byte(s)).
2014-08-08 15:46:49,562 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-hummingbird-2560x1600.png.part...
2014-08-08 15:46:49,562 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-hummingbird-2560x1600.png.part (456681684+406153 byte(s)).
2014-08-08 15:46:49,562 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-hummingbird-640x960.png.part...
2014-08-08 15:46:49,562 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-hummingbird-640x960.png.part (457087837+149274 byte(s)).
2014-08-08 15:46:49,562 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-swarm-1280x1280.png.part...
2014-08-08 15:46:49,562 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-swarm-1280x1280.png.part (457237111+207728 byte(s)).
2014-08-08 15:46:49,563 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-swarm-2560x1600.png.part...
2014-08-08 15:46:49,563 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-swarm-2560x1600.png.part (457444839+438953 byte(s)).
2014-08-08 15:46:49,563 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-swarm-640x960.png.part...
2014-08-08 15:46:49,563 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-swarm-640x960.png.part (457883792+105897 byte(s)).
2014-08-08 15:46:49,563 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-type-1280x1280.png.part...
2014-08-08 15:46:49,563 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-type-1280x1280.png.part (457989689+22923 byte(s)).
2014-08-08 15:46:49,563 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-type-2560x1600.png.part...
2014-08-08 15:46:49,564 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-type-2560x1600.png.part (458012612+90843 byte(s)).
2014-08-08 15:46:49,564 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-type-640x960.png.part...
2014-08-08 15:46:49,564 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/061113-UT-type-640x960.png.part (458103455+16457 byte(s)).
2014-08-08 15:46:49,564 [main                     ] DEBUG: Downloading new file to /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/BitTorrent Wallpaper.png.part...
2014-08-08 15:46:49,564 [main                     ] INFO : Initialized byte storage file at /home/artur/IdeaProjects/ttorrent-master/bin/BitTorrent/Wallpapers/BitTorrent Wallpaper.png.part (458119912+8723797 byte(s)).
2014-08-08 15:46:49,570 [main                     ] INFO : Initialized torrent byte storage on 31 file(s) (466843709 total byte(s)).
2014-08-08 15:46:49,612 [main                     ] INFO : Listening for incoming connections on pb/127.0.1.1:6881.
2014-08-08 15:46:54,202 [main                     ] INFO : Initialized announce sub-system with 3 trackers on BitTorrent.
2014-08-08 15:46:54,202 [main                     ] INFO : BitTorrent client [..383365] for BitTorrent started and listening at 127.0.1.1:6881...
2014-08-08 15:46:54,205 [bt-client(..383365)      ] INFO : Analyzing local data for BitTorrent with 4 threads (1781 pieces)...
2014-08-08 15:46:54,366 [bt-client(..383365)      ] INFO :   ... 10% complete
2014-08-08 15:46:54,497 [bt-client(..383365)      ] INFO :   ... 20% complete
2014-08-08 15:46:54,621 [bt-client(..383365)      ] INFO :   ... 30% complete
2014-08-08 15:46:54,773 [bt-client(..383365)      ] INFO :   ... 40% complete
2014-08-08 15:46:54,921 [bt-client(..383365)      ] INFO :   ... 50% complete
2014-08-08 15:46:55,086 [bt-client(..383365)      ] INFO :   ... 60% complete
2014-08-08 15:46:55,255 [bt-client(..383365)      ] INFO :   ... 70% complete
2014-08-08 15:46:55,439 [bt-client(..383365)      ] INFO :   ... 80% complete
2014-08-08 15:46:55,565 [bt-client(..383365)      ] INFO :   ... 90% complete
2014-08-08 15:46:55,718 [bt-client(..383365)      ] DEBUG: BitTorrent: we have 0/466843709 bytes (0,0%) [0/1781 pieces].
2014-08-08 15:46:55,719 [bt-announce(..383365)    ] INFO : Starting announce loop...
2014-08-08 15:46:55,720 [bt-announce(..383365)    ] INFO : Announcing STARTED to tracker with 0U/0D/466843709L bytes...
2014-08-08 15:46:55,759 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:46:58,760 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:01,761 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:04,761 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:07,762 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:10,763 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:13,764 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:16,765 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:19,765 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:22,766 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:25,767 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:28,767 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:31,768 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:34,768 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:37,769 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:40,770 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:43,770 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:46,771 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:49,772 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:52,772 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:55,773 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:47:58,774 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:01,774 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:04,775 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:07,776 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:10,776 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:13,777 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:16,778 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:19,778 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:22,779 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:25,779 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:28,780 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:31,781 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:34,781 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:37,782 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:40,783 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:43,783 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:46,784 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:49,785 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:52,785 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:55,786 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:48:58,787 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:49:01,787 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:49:04,788 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
2014-08-08 15:49:07,788 [bt-client(..383365)      ] INFO : SHARING 0/1781 pieces (0,00%) [0/0] with 0/0 peers at 0,00/0,00 kB/s.
