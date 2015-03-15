History:
--------
* Vuze's ...... который очень трудно извлечь из их коде и таким образом, комплекс реинтегрироваться в другое приложение;
* torrent4j ... которая в значительной степени неполным и не могут быть использованы;
* Snark's ..... который стар и к сожалению нестабильная;
* bitext ...... который был также к сожалению нестабильная и очень медленный;


MAVEN console command(s):
-------------------------
# Build project
mvn clean assembly:assembly
...

JAVA run app:
-------------
# Run JAR-file
java -jar target/dataformat-bencode-app.jar -announce-file apache-maven-2.2.1-bin.zip -ttorrent-file apache-maven-2.2.1-bin.zip.torrent -announce-file-owner Lazarchuk%20A.K. -tracker-url http://code.google.com/p/commons-java-weather/downloads/detail?name=apache-maven-2.2.1-bin.zip -text-comment Apache%20Maven%202.2.1
[08/11/2014 09:11:42] Build new .torrent-file
                      -----------------------
                      ANNOUNCE FILE ......... 'apache-maven-2.2.1-bin.zip'
                      ANNOUNCE FILE OWNER ... 'Lazarchuk%20A.K.'
                      TRACKER URL ........... 'http://code.google.com/p/commons-java-weather/downloads/detail?name=apache-maven-2.2.1-bin.zip'
                      TEXT COMMENT .......... 'Apache%20Maven%202.2.1'
                      ANNOUNCE FILE SIZE .... 2846259
                      PIECE LENGTH .......... 32768
                      PIECES ................ 1740
                      CURRENT TIME .......... 1407705102
[08/11/2014 09:11:42] 'apache-maven-2.2.1-bin.zip.torrent' - has been successfully built!

java -jar target/dataformat-bencode-app.jar -ttorrent-file apache-maven-2.2.1-bin.zip.torrent
[08/11/2014 09:12:56] Read .torrent-file 'apache-maven-2.2.1-bin.zip.torrent'
                      ------------------
[08/11/2014 09:12:56] Announce ............. http://code.google.com/p/commons-java-weather/downloads/detail?name=apache-maven-2.2.1-bin.zip
[08/11/2014 09:12:56] Announce List ........ [[http://code.google.com/p/commons-java-weather/downloads/detail?name=apache-maven-2.2.1-bin.zip]]
[08/11/2014 09:12:56] Size ................. 1
[08/11/2014 09:12:56] Creation Date ........ 1407705102
[08/11/2014 09:12:56] Info ................. com.dataformat.common.types.Torrent$Info@4532ba
[08/11/2014 09:12:56] Length ............... 2846259
[08/11/2014 09:12:56] PieceLength .......... 32768
[08/11/2014 09:12:56] Pieces ............... 1740