package com.dataformat.common.types;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * @author Aleksandr Konstantinovitch
 * @version 2.0
 * @date 31/07/2014
 * {@link http://ru.wikipedia.org/wiki/Bencode}
 */

@SuppressWarnings("UnusedDeclaration")
public class Torrent {
    private String announce;

    @JsonProperty("announce-list")
    private List<List<String>> announceList;

    private String comment;

    @JsonProperty("created by")
    private String createdBy;

    @JsonProperty("creation date")
    private int creationDate;
    private Info info;

    @JsonProperty("url-list")
    private String urlList;

    @JsonProperty("private")
    private Byte privateFlag;

    public static class Info {
        private Long length;
        private String name;

        private List<File> files;

        @JsonProperty("piece length")
        private int pieceLength;

        private byte[] pieces;

        public static class File {
            private List<String> path;
            private long length;

            public File(List<String> path, long length) {
                this.path = path;
                this.length = length;
            }

            public List<String> getPath() {
                return path;
            }

            public void setPath(List<String> path) {
                this.path = path;
            }

            public long getLength() {
                return length;
            }

            public void setLength(long length) {
                this.length = length;
            }
        }

        public Long getLength() {
            return length;
        }

        public void setLength(Long length) {
            this.length = length;
        }

        public String getName() {
            return name;
        }

        public List<File> getFiles() {
            return files;
        }

        public void setFiles(List<File> files) {
            this.files = files;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getPieceLength() {
            return pieceLength;
        }

        public void setPieceLength(int pieceLength) {
            this.pieceLength = pieceLength;
        }

        public byte[] getPieces() {
            return pieces;
        }

        public void setPieces(byte[] pieces) {
            this.pieces = pieces;
        }
    }

    public String getAnnounce() {
        return announce;
    }

    public void setAnnounce(String announce) {
        this.announce = announce;
    }

    public List<List<String>> getAnnounceList() {
        return announceList;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public void setAnnounceList(List<List<String>> announceList) {
        this.announceList = announceList;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(int creationDate) {
        this.creationDate = creationDate;
    }

    public String getUrlList() {
        return urlList;
    }

    public void setUrlList(String urlList) {
        this.urlList = urlList;
    }

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }

    public Byte getPrivateFlag() {
        return privateFlag;
    }

    public void setPrivateFlag(Byte privateFlag) {
        this.privateFlag = privateFlag;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Torrent)) return false;

        Torrent torrent = (Torrent) o;

        if (creationDate != torrent.creationDate) return false;
        if (announce != null ? !announce.equals(torrent.announce) : torrent.announce != null) return false;
        if (announceList != null ? !announceList.equals(torrent.announceList) : torrent.announceList != null)
            return false;
        if (comment != null ? !comment.equals(torrent.comment) : torrent.comment != null) return false;
        if (createdBy != null ? !createdBy.equals(torrent.createdBy) : torrent.createdBy != null) return false;
        if (info != null ? !info.equals(torrent.info) : torrent.info != null) return false;
        if (privateFlag != null ? !privateFlag.equals(torrent.privateFlag) : torrent.privateFlag != null) return false;
        if (urlList != null ? !urlList.equals(torrent.urlList) : torrent.urlList != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = announce != null ? announce.hashCode() : 0;
        result = 31 * result + (announceList != null ? announceList.hashCode() : 0);
        result = 31 * result + (comment != null ? comment.hashCode() : 0);
        result = 31 * result + (createdBy != null ? createdBy.hashCode() : 0);
        result = 31 * result + creationDate;
        result = 31 * result + (info != null ? info.hashCode() : 0);
        result = 31 * result + (urlList != null ? urlList.hashCode() : 0);
        result = 31 * result + (privateFlag != null ? privateFlag.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "Torrent{" +
                "announce='" + announce + '\'' +
                ", announceList=" + announceList +
                ", comment='" + comment + '\'' +
                ", createdBy='" + createdBy + '\'' +
                ", creationDate=" + creationDate +
                ", info=" + info +
                ", urlList='" + urlList + '\'' +
                ", privateFlag=" + privateFlag +
                '}';
    }
}
