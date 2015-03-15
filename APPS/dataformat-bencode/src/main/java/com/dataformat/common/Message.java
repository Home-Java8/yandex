package com.dataformat.common;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

/**
 * @author Aleksandr Konstantinovitch
 * @version 1.0
 * @date 25/07/2014
 ******************************************************
 * list Message types
 */
public final class Message {

    public static final DateFormat     DATE_FORMAT = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
    public static final String  NOT_FOUND_ARGUMENT = "Not found argument";
    public static final String      NOT_FOUND_FILE = "Not found file";
    public static final String      CANT_READ_FILE = "Can't read file";
    public static final String     CANT_WRITE_FILE = "Can't write file";
    public static final String        SUCCESSFULLY = "Is successfully will";
    public static final String        CANT_BENCODE = "Can't b-encode format to file";
    public static final String CANT_BUILD_ANNOUNCE = "Can't build announce to file";

}
