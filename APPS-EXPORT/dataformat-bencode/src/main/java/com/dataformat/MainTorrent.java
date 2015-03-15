package com.dataformat;

import com.dataformat.common.Announce;
import com.dataformat.common.Message;
import com.dataformat.common.TorrentImpl;
import com.dataformat.common.types.Torrent;
import org.kohsuke.args4j.CmdLineException;
import org.kohsuke.args4j.CmdLineParser;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.Date;

/**
 * @author Lazarchuk A.K.
 * @version 2.0
 * @date 31/07/2014
 ******************************************************
 * MainTorrent-Class
 */
public class MainTorrent {

    /**
     * Create 'apache-maven-2.2.1-bin.zip.torrent'
     * Programm arguments: -announce-file data/apache-maven-2.2.1-bin.zip -ttorrent-file data/apache-maven-2.2.1-bin.zip.torrent -announce-file-owner Lazarchuk%20A.K. -tracker-url http://code.google.com/p/commons-java-weather/downloads/detail?name=apache-maven-2.2.1-bin.zip -text-comment Apache%20Maven%202.2.1
     * Parse 'apache-maven-2.2.1-bin.zip.torrent'
     * Programm arguments: -ttorrent-file data/apache-maven-2.2.1-bin.zip.torrent
     *
     * Create 'chtenie-i-zapisi-baitov-java.png.torrent'
     * Programm arguments: -announce-file data/chtenie-i-zapisi-baitov-java.png -ttorrent-file data/chtenie-i-zapisi-baitov-java.png.torrent -announce-file-owner Lazarchuk%20A.K. -tracker-url http://pro-java.ru/java-dlya-nachinayushhix/chtenie-i-zapis-bajtov-java/ -text-comment Чтение%20и%20запись%20байтов%20Java
     * Parse 'chtenie-i-zapisi-baitov-java.png.torrent'
     * Programm arguments: -ttorrent-file data/chtenie-i-zapisi-baitov-java.png.torrent
     *
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        StringBuilder strMessage = new StringBuilder();
        String       currentDate = Message.DATE_FORMAT.format(new Date());

        Announce announce = new Announce();
        CmdLineParser parser = new CmdLineParser( announce );
        parser.setUsageWidth( 120 );
        try{
            parser.parseArgument( args );

            // Select service for creating or reading the file-ttorrent
            if( announce.getANNOUNCE_FILE() != null ){
                // To create .torrent:
                if( create(announce) ){
                    strMessage.append("[").append(currentDate).append("] Build new .torrent-file").append("\n                      -----------------------");
                    strMessage.append("\n").append(announce.toString());
                    strMessage.append("\n[").append(currentDate).append("] '").append(announce.getANNOUNCE_FILE()).append(".torrent' - has been successfully built!");
                } else {
                    // ToDo
                }
            } else if( announce.getTTORRENT_FILE() != null ){
                // To parse .torrent:
                parse( announce.getTTORRENT_FILE() );
            }

        } catch( CmdLineException e ){
            System.err.println( e.getMessage() );
            parser.printUsage( System.err );
            System.exit(1);
        } finally {
            System.out.println(strMessage.toString());
        }
    }

    /**
     *
     * @param announce
     * @throws Exception
     */
    private static boolean create( Announce announce ) throws Exception {
        // Inin announce data for Announce
        TorrentImpl build = new TorrentImpl(announce);
        // to build a torrent file using the BEncode-format:
        Torrent torrent = build.getInitTorrent();
        ByteArrayOutputStream byteTorrent = build.torrentBEncodeByte(torrent);
        // Save data to .torrent-file
        return build.toTorrentFile(byteTorrent);
    }

    /**
     *
     * @param nameTorrentFile
     * @return
     * @throws Exception
     */
    private static boolean parse( String nameTorrentFile ) throws Exception {
        TorrentImpl parse = new TorrentImpl();
        // Get the .torrent-file
        File fileTorrent = parse.getFile(nameTorrentFile);
        // Decodes the BEncode-format content of this .torrent-file
        Torrent torrent = parse.fileBDencodeTorrent(fileTorrent);

        if(torrent != null){
            // Parse out the contextual meaning of the content of this .torrent-file
            String strTorrentValues = parse.toValueString(torrent);
            // To print
            System.out.println(strTorrentValues);
            return true;
        } else {
            // ToDo
            return false;
        }
    }
}