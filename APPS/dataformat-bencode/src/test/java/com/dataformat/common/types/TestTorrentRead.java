package com.dataformat.common.types;

import com.dataformat.api.bencode.BEncodeMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Before;
import org.junit.Test;

import javax.xml.bind.DatatypeConverter;
import java.io.*;
import java.nio.charset.Charset;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.assertThat;

/**
 * @author Lazarchuk A.K.
 * @version 2.0
 * @date 31/07/2014
 ******************************************************
 * TestTorrentRead-Test
 */
public class TestTorrentRead {
    private ObjectMapper underTest;

    @Before
    public void startUp() throws IOException {
        underTest = new BEncodeMapper();
    }

    @Test
    public void testReadValueFromStream() throws Exception {
        InputStream in = new ByteArrayInputStream( TUTORIAL_EXAMPLE_ENCODED.getBytes("ISO-8859-1") );
        User user = underTest.readValue( in, User.class );

        assertThat( user.getGender(), is(User.Gender.MALE) );
        assertThat( user.isVerified(), is(false) );
        assertThat( user.getName().getFirst(), is("Joe") );
        assertThat( user.getName().getLast(), is("Sixpack") );
        assertThat( user.getUserImage(), is(BINARY_DATA) );
    }

    @Test
    public void testReadComplexValue() throws Exception {
        Torrent ubuntu = underTest.readValue( new File("src/test/resources/ubuntu-13.10-desktop-amd64.iso.torrent"), Torrent.class );
        assertThat( ubuntu.getAnnounce(), is("http://torrent.ubuntu.com:6969/announce") );
        assertThat( ubuntu.getAnnounceList(), notNullValue() );
        assertThat( ubuntu.getAnnounceList().size(), is(2) );
        assertThat( ubuntu.getAnnounceList().get(0), hasItems("http://torrent.ubuntu.com:6969/announce") );
        assertThat( ubuntu.getAnnounceList().get(1), hasItems("http://ipv6.torrent.ubuntu.com:6969/announce") );
        assertThat( ubuntu.getComment(), is("Ubuntu CD releases.ubuntu.com") );
        assertThat( ubuntu.getCreationDate(), is(1382003607) );
        assertThat( ubuntu.getInfo(), notNullValue() );
        assertThat( ubuntu.getInfo().getLength(), is(925892608L) );
        assertThat( ubuntu.getInfo().getPieceLength(), is(524288) );
        assertThat( ubuntu.getInfo().getPieces().length, is(35320) );
    }


    private static byte[] BINARY_DATA = DatatypeConverter.parseHexBinary("E3811B9539CACFF680E418124272177C47477157");
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
