package com.dataformat.common;

import com.dataformat.api.bencode.BEncodeMapper;
import com.dataformat.common.types.Torrent;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.*;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;

/**
 * @author Lazarchuk A.K.
 * @version 2.0
 * @date 31/07/2014
 * {@link http://purebasic.mybb.ru/viewtopic.php?id=249}
 ******************************************************
 * An example of using the library to build a torrent file using the BEncode-format
 */
public class TorrentImpl {

    private byte[] pieces;
    private Announce announce;
    private String NAME_TORRENT_FILE = null;

    public TorrentImpl(){
    }
    public TorrentImpl(Announce announce){
        this.announce = announce;

        try {
            this.announce.setANNOUNCE_FILE_SIZE( new File( announce.getANNOUNCE_FILE() ).length() );
            this.announce.setPIECE_LENGTH( recommendedPieceLength(this.announce.getANNOUNCE_FILE_SIZE()) );
            this.announce.setPIECES( (int)getPieces(this.announce.getANNOUNCE_FILE_SIZE(), recommendedPieceLength(this.announce.getANNOUNCE_FILE_SIZE())) );
        }  catch (Exception ioe){
            String       currentDate = Message.DATE_FORMAT.format(new Date());
            StringBuilder strMessage = new StringBuilder();

            strMessage.append("[").append(currentDate).append("] ERROR: ").append(Message.CANT_BUILD_ANNOUNCE);

            System.out.println(strMessage.toString());
            ioe.printStackTrace();
        }finally {
            pieces = new byte[ this.announce.getPIECES() ];
            this.announce.setCURRENT_TIME( (int)(System.currentTimeMillis()/1000) );
        }
    }
    public TorrentImpl(String nameTorrentFile) {
        NAME_TORRENT_FILE = nameTorrentFile;
    }


    /**
     *
     * @return
     */
    public Torrent getInitTorrent(){
        // Set info to announce file
        Torrent.Info iTorrent = new com.dataformat.common.types.Torrent.Info();
        iTorrent.setLength( announce.getANNOUNCE_FILE_SIZE() );
        iTorrent.setName( announce.getANNOUNCE_FILE() );
        iTorrent.setPieceLength( announce.getPIECE_LENGTH() );
        iTorrent.setPieces( pieces );

        // Set torrent to announce file
        Torrent torrent = new com.dataformat.common.types.Torrent();
        torrent.setAnnounce( announce.getTRACKER_URL() );
        torrent.setAnnounceList(Arrays.asList(
                Collections.singletonList( announce.getTRACKER_URL() )
        ));
        torrent.setComment( announce.getTEXT_COMMENT() );
        torrent.setCreatedBy( announce.getANNOUNCE_FILE_OWNER() );
        torrent.setCreationDate( announce.getCURRENT_TIME() );
        torrent.setInfo( iTorrent );

        return torrent;
    }

    /**
     *
     * @param torrent
     * @return
     */
    public ByteArrayOutputStream torrentBEncodeByte(Torrent torrent){
        ByteArrayOutputStream byteTorrent = null;

        try {
            byteTorrent          = new ByteArrayOutputStream();
            ObjectMapper bencode = new BEncodeMapper();
            bencode.writeValue( byteTorrent, torrent );
        }  catch (IOException ioe){ ioe.printStackTrace(); }

        return byteTorrent;
    }

    /**
     *
     * @param byteTorrent
     * @return
     * @throws IOException
     */
    public boolean toTorrentFile(ByteArrayOutputStream byteTorrent) throws IOException {
        boolean isFile = false;

        FileOutputStream fileTorrent = null;
        try {
            fileTorrent = new FileOutputStream( announce.getTTORRENT_FILE() );
            BufferedWriter bufferedWriter = new BufferedWriter( new OutputStreamWriter(fileTorrent, "ISO-8859-1") );
            bufferedWriter.append( byteTorrent.toString("ISO-8859-1") );
            bufferedWriter.flush();
            bufferedWriter.close();
            fileTorrent.flush();
            fileTorrent.close();

            isFile = true;
        } catch (FileNotFoundException e) {
            String       currentDate = Message.DATE_FORMAT.format(new Date());
            StringBuilder strMessage = new StringBuilder();

            strMessage.append("[").append(currentDate).append("] Build .torrent-file ... ").append("\n                      ------------------")
                    .append("\n[").append(currentDate).append("] ERROR: ").append(Message.NOT_FOUND_FILE);

            System.out.println(strMessage.toString());
            e.printStackTrace();
        } finally {
        }

        return isFile;
    }

    /**
     * All in all, a torrent should have around 1000-1500 pieces, to get a reasonably small torrent file and an efficient client and swarm download.
     * On the other hand, too large pieces (4 MB and larger) can slow down piece announce, as a single piece will have 256 or more 16 kB "blocks", which are the actual smallest transmission units in the bittorent protocol.
     * @param announceSize
     * @return
     */
    public static int recommendedPieceLength(long announceSize){
        // Check all piece sizes that are multiples of 32kB
        //
        //  TorrentImpl File/Directory Size: 65 MB
        //  2103 x 32 KB - RecommendedPieceSize()
        //  526 x 128 KB - uTorrent Auto Detect
        //
        //  TorrentImpl File/Directory Size: 164 MB
        //  2638 x 64 KB - RecommendedPieceSize()
        //  660 x 256 KB - uTorrent Auto Detect
        //
        //  TorrentImpl File/Directory Size: 357 MB
        //  2859 x 128 KB - RecommendedPieceSize()
        //  715 x 512 KB - uTorrent Auto Detect
        //
        //  TorrentImpl File/Directory Size: 1.3 GB
        //  2737 x 512 KB - RecommendedPieceSize()
        //  685 x 2048 KB - uTorrent Auto Detect

        for (int i = 32768; i < 4 * 1024 * 1024; i *= 2)
        {
            int pieces = (int)(announceSize / i) + 1;
            if ((pieces * 20) < (60 * 1024))
                return i;
        }

        // If we get here, we're hashing a massive file, so lets limit to a max of 4MB pieces.
        return (4 * 1024 * 1024);
    }

    /**
     * Count pieces: ((<AnnounceSize> / <PieceLength>) + 1) * 20
     * @param announceSize
     * @param pieceLength
     * @return
     */
    public static long getPieces(long announceSize, long pieceLength){
        return (((announceSize / pieceLength) + 1) * 20);
    }


    /**
     * Open Torrent-File
     * @param nameTorrentFile
     * @return
     * @throws Exception
     */
    public File getFile(String nameTorrentFile) throws Exception {
        NAME_TORRENT_FILE = nameTorrentFile;
        File         file = null;

        try {
            file = new File(nameTorrentFile);
        } catch (IOError ioe){
            String       currentDate = Message.DATE_FORMAT.format(new Date());
            StringBuilder strMessage = new StringBuilder();

            strMessage.append("[").append(currentDate).append("] Read .torrent-file ... ").append("\n                      ------------------")
                    .append("\n[").append(currentDate).append("] ERROR: ").append(Message.NOT_FOUND_FILE);

            System.out.println(strMessage.toString());
            ioe.printStackTrace();
        } finally {
        }

        return file;
    }

    /**
     * Parse BEncode-Torrent
     * @param fileTorrent
     * @return
     * @throws Exception
     */
    public Torrent fileBDencodeTorrent(File fileTorrent) throws Exception {
        Torrent torrent = null;
        try {
            ObjectMapper  under = new BEncodeMapper();
            torrent             = under.readValue(fileTorrent, Torrent.class);
        } catch (IOException ioe) {
            String       currentDate = Message.DATE_FORMAT.format(new Date());
            StringBuilder strMessage = new StringBuilder();

            strMessage.append("[").append(currentDate).append("] Read .torrent-file ... ").append("\n                      ------------------")
                    .append("\n[").append(currentDate).append("] ERROR: ").append(Message.NOT_FOUND_FILE);

            System.out.println(strMessage.toString());
            ioe.printStackTrace();
        } finally {
        }

        return torrent;
    }

    /**
     * Get String Torrent-Value(s)
     * @param torrent
     */
    public String toValueString(Torrent torrent){
        StringBuilder torrentValues = new StringBuilder();
        String          currentDate = Message.DATE_FORMAT.format(new Date());

        torrentValues.append("[").append(currentDate).append("] Read .torrent-file '").append(NAME_TORRENT_FILE).append("'\n                      ------------------")
                .append("\n[").append(currentDate).append("] Announce ............. ").append(torrent.getAnnounce())
                .append("\n[").append(currentDate).append("] Announce List ........ ").append(torrent.getAnnounceList())
                .append("\n[").append(currentDate).append("] Size ................. ").append(torrent.getAnnounceList().size())
                .append("\n[").append(currentDate).append("] Creation Date ........ ").append(torrent.getCreationDate())
                .append("\n[").append(currentDate).append("] Info ................. ").append(torrent.getInfo())
                .append("\n[").append(currentDate).append("] Length ............... ").append(torrent.getInfo().getLength())
                .append("\n[").append(currentDate).append("] PieceLength .......... ").append(torrent.getInfo().getPieceLength())
                .append("\n[").append(currentDate).append("] Pieces ............... ").append(torrent.getInfo().getPieces().length);

        return torrentValues.toString();
    }

}