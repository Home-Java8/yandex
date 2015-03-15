package com.dataformat.common.types;

import com.dataformat.api.bencode.BEncodeMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Before;
import org.junit.Test;

import javax.xml.bind.DatatypeConverter;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.Collections;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;

/**
 * @author Lazarchuk A.K.
 * @version 2.0
 * @date 31/07/2014
 ******************************************************
 * TestTorrentWrite-Test
 */
@SuppressWarnings("UnusedDeclaration")
public class TestTorrentWrite {

    private ObjectMapper underTest;

    @Before
    public void startUp() throws IOException {
        underTest = new BEncodeMapper();
    }

    @Test
    public void testWriteValueToStream() throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        User user = new User();
        User.Name uName = new User.Name();
        uName.setFirst( "Joe" );
        uName.setLast( "Sixpack" );
        user.setGender( User.Gender.MALE );
        user.setUserImage( BINARY_DATA );
        user.setName( uName );
        user.setVerified( false );

        underTest.writeValue( baos, user );

        assertThat( baos.toString("ISO-8859-1"), is(TUTORIAL_EXAMPLE_ENCODED) );
    }

    @Test
    public void testWriteValueToStreamComplex() throws Exception {
        byte[] tUbuntu = readFileBinary("/ubuntu-13.10-desktop-amd64.iso.torrent");
        byte[]  pieces = new byte[35320];
        System.arraycopy( tUbuntu, 0x014f, pieces, 0, pieces.length );

        Torrent.Info iTorrent = new Torrent.Info();
        iTorrent.setLength(925892608L);
        iTorrent.setName("ubuntu-13.10-desktop-amd64.iso");
        iTorrent.setPieceLength(524288);
        iTorrent.setPieces(pieces);

        Torrent torrent = new Torrent();
        torrent.setAnnounce("http://torrent.ubuntu.com:6969/announce");
        torrent.setAnnounceList(Arrays.asList(
                Collections.singletonList("http://torrent.ubuntu.com:6969/announce"),
                Collections.singletonList("http://ipv6.torrent.ubuntu.com:6969/announce")
        ));
        torrent.setComment("Ubuntu CD releases.ubuntu.com");
        torrent.setCreationDate(1382003607);
        torrent.setInfo(iTorrent);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        underTest.writeValue( baos, torrent );

        assertThat( baos.toString("ISO-8859-1"), is(new String(tUbuntu, "ISO-8859-1")) );
    }

    private static byte [] BINARY_DATA = DatatypeConverter.parseHexBinary("E3811B9539CACFF680E418124272177C47477157");
    private static final String TUTORIAL_EXAMPLE_ENCODED =
            "d6:gender4:MALE4:named5:first3:Joe4:last7:Sixpacke9:userImage20:" +
                    new String(BINARY_DATA, Charset.forName("ISO-8859-1")) +
                    "8:verified5:falsee";

    private byte[] readFileBinary(String path) {
        InputStream is = TestTorrentWrite.class.getResourceAsStream( path );
        int nRead;
        byte[]                  data = new byte[1 << 12];
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        try {
            while ((nRead = is.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, nRead);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        return buffer.toByteArray();
    }

}
