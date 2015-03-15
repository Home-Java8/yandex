package com.dataformat.common;

import org.kohsuke.args4j.Option;

/**
 * @author Lazarchuk A.K.
 * @version 2.0
 * @date 31/07/2014
 * {@link http://habrahabr.ru/post/119753/}
 ******************************************************
 * Announce Info
 */
public class Announce {
    /**
     * Regular data info
     */
    @Option(name = "-announce-file", usage = "ANNOUNCE_FILE")
    private String       ANNOUNCE_FILE;

    @Option(name = "-announce-file-owner", usage = "ANNOUNCE_FILE_OWNER")
    private String ANNOUNCE_FILE_OWNER;

    @Option(name = "-tracker-url", usage = "TRACKER_URL")
    private String             TRACKER_URL;

    @Option(name = "-text-comment", usage = "TEXT_COMMENT")
    private String            TEXT_COMMENT;

    @Option(name = "-ttorrent-file", usage = "TTORRENT_FILE", required = true)
    private String       TTORRENT_FILE;

    /**
     * Special distribution data
     */
    @Option(name = "-announce-file-size", usage = "file size (in bytes)")
    private long ANNOUNCE_FILE_SIZE;

    @Option(name = "-piece-length", usage = "full size pieces of the file")
    private int        PIECE_LENGTH;

    @Option(name = "-pieces", usage = "pieces of the file for distribution to other clients")
    private int              PIECES;

    @Option(name = "-current-time", usage = "current time in milisekuddah")
    private int        CURRENT_TIME;


    /**
     * URL for the tracker. Along with info is a required field, all the rest - is optional.
     * @param ANNOUNCE_FILE
     */
    public void setANNOUNCE_FILE(String ANNOUNCE_FILE){
        this.ANNOUNCE_FILE = ANNOUNCE_FILE;
    }

    /**
     * URL for the tracker. Along with info is a required field, all the rest - is optional.
     * @return
     */
    public String getANNOUNCE_FILE(){
        return ANNOUNCE_FILE;
    }

    /**
     * Tells us about who created this torrent.
     * @param ANNOUNCE_FILE_OWNER
     */
    public void setANNOUNCE_FILE_OWNER(String ANNOUNCE_FILE_OWNER){
        this.ANNOUNCE_FILE_OWNER = ANNOUNCE_FILE_OWNER;
    }

    /**
     * Tells us about who created this torrent.
     * @return
     */
    public String getANNOUNCE_FILE_OWNER(){
        return ANNOUNCE_FILE_OWNER;
    }

    /**
     * Trackers list, if there are several. In Bencode-form - a list of lists.
     * @param TRACKER_URL
     */
    public void setTRACKER_URL(String TRACKER_URL){
        this.TRACKER_URL = TRACKER_URL;
    }

    /**
     * Trackers list, if there are several. In Bencode-form - a list of lists.
     * @return
     */
    public String getTRACKER_URL(){
        return TRACKER_URL;
    }

    /**
     * A textual description of the torrent. rutracker.org stores the link here on the forum.
     * @param TEXT_COMMENT
     */
    public void setTEXT_COMMENT(String TEXT_COMMENT){
        this.TEXT_COMMENT = TEXT_COMMENT;
    }

    /**
     * A textual description of the torrent. rutracker.org stores the link here on the forum.
     * @return
     */
    public String getTEXT_COMMENT(){
        return TEXT_COMMENT;
    }

    /**
     * The metadata file is a dictionary in bencode format with the extension .torrent - used p2p BitTorrent network and contains information about the files, and other trackers.
     * @param TTORRENT_FILE
     */
    public void setTTORRENT_FILE(String TTORRENT_FILE){
        this.TTORRENT_FILE = TTORRENT_FILE;
    }

    /**
     * The metadata file is a dictionary in bencode format with the extension .torrent - used p2p BitTorrent network and contains information about the files, and other trackers.
     * @return
     */
    public String getTTORRENT_FILE(){
        return TTORRENT_FILE;
    }

    /**
     * If the file is one, it will be set to this field that contains the length of the file, if more than one file, you will see a list of associative arrays.
     * @param ANNOUNCE_FILE_SIZE
     */
    public void setANNOUNCE_FILE_SIZE(long ANNOUNCE_FILE_SIZE){
        this.ANNOUNCE_FILE_SIZE = ANNOUNCE_FILE_SIZE;
    }

    /**
     * If the file is one, it will be set to this field that contains the length of the file, if more than one file, you will see a list of associative arrays.
     * @return
     */
    public long getANNOUNCE_FILE_SIZE(){
        return ANNOUNCE_FILE_SIZE;
    }

    /**
     * The size of one piece of - 512 kb, 1 meter, and so forth. Too many pieces will "blow» .torrent-file.
     * @param PIECE_LENGTH
     */
    public void setPIECE_LENGTH(int PIECE_LENGTH){
        this.PIECE_LENGTH = PIECE_LENGTH;
    }

    /**
     * The size of one piece of - 512 kb, 1 meter, and so forth. Too many pieces will "blow» .torrent-file.
     * @return
     */
    public int getPIECE_LENGTH(){
        return PIECE_LENGTH;
    }

    /**
     * String that contains the concatenation of the SHA1-hashes describing each piece. The length of this line is 20 * the number of pieces.
     * @param PIECES
     */
    public void setPIECES(int PIECES){
        this.PIECES = PIECES;
    }

    /**
     * String that contains the concatenation of the SHA1-hashes describing each piece. The length of this line is 20 * the number of pieces.
     * @return
     */
    public int getPIECES(){
        return PIECES;
    }

    /**
     *
     * @param CURRENT_TIME
     */
    public void setCURRENT_TIME(int CURRENT_TIME){
        this.CURRENT_TIME = CURRENT_TIME;
    }

    /**
     *
     * @return
     */
    public int getCURRENT_TIME(){
        return CURRENT_TIME;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Announce)) return false;

        Announce announce = (Announce) o;

        if (ANNOUNCE_FILE_SIZE != announce.ANNOUNCE_FILE_SIZE) return false;
        if (CURRENT_TIME != announce.CURRENT_TIME) return false;
        if (PIECES != announce.PIECES) return false;
        if (PIECE_LENGTH != announce.PIECE_LENGTH) return false;
        if (ANNOUNCE_FILE != null ? !ANNOUNCE_FILE.equals(announce.ANNOUNCE_FILE) : announce.ANNOUNCE_FILE != null)
            return false;
        if (ANNOUNCE_FILE_OWNER != null ? !ANNOUNCE_FILE_OWNER.equals(announce.ANNOUNCE_FILE_OWNER) : announce.ANNOUNCE_FILE_OWNER != null)
            return false;
        if (TEXT_COMMENT != null ? !TEXT_COMMENT.equals(announce.TEXT_COMMENT) : announce.TEXT_COMMENT != null)
            return false;
        if (TRACKER_URL != null ? !TRACKER_URL.equals(announce.TRACKER_URL) : announce.TRACKER_URL != null)
            return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = ANNOUNCE_FILE != null ? ANNOUNCE_FILE.hashCode() : 0;
        result = 31 * result + (ANNOUNCE_FILE_OWNER != null ? ANNOUNCE_FILE_OWNER.hashCode() : 0);
        result = 31 * result + (TRACKER_URL != null ? TRACKER_URL.hashCode() : 0);
        result = 31 * result + (TEXT_COMMENT != null ? TEXT_COMMENT.hashCode() : 0);
        result = 31 * result + (int) (ANNOUNCE_FILE_SIZE ^ (ANNOUNCE_FILE_SIZE >>> 32));
        result = 31 * result + PIECE_LENGTH;
        result = 31 * result + PIECES;
        result = 31 * result + CURRENT_TIME;
        return result;
    }

    @Override
    public String toString() {
        return "                      ANNOUNCE FILE ......... '" + ANNOUNCE_FILE + '\'' +
               "\n                      ANNOUNCE FILE OWNER ... '" + ANNOUNCE_FILE_OWNER + '\'' +
               "\n                      TRACKER URL ........... '" + TRACKER_URL + '\'' +
               "\n                      TEXT COMMENT .......... '" + TEXT_COMMENT + '\'' +
               "\n                      ANNOUNCE FILE SIZE .... " + ANNOUNCE_FILE_SIZE +
               "\n                      PIECE LENGTH .......... " + PIECE_LENGTH +
               "\n                      PIECES ................ " + PIECES +
               "\n                      CURRENT TIME .......... " + CURRENT_TIME;
    }
}
