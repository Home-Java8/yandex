package com.bittorrent;

import com.bittorrent.mpetazzoni.client.Client;
import com.bittorrent.mpetazzoni.client.SharedTorrent;
import jargs.gnu.CmdLineParser;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.ConsoleAppender;
import org.apache.log4j.PatternLayout;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.PrintStream;
import java.net.*;
import java.nio.channels.UnsupportedAddressTypeException;
import java.util.Enumeration;

/**
 * @author Lazarchuk A.K.
 * @version 1.0
 * @date 7/08/2014
 * {@link https://ru.wikipedia.org/wiki/BitTorrent}
 ******************************************************
 * Main-Client
 *
 * Programm arguments: -o out -s 3600 -d 50.0 -u 50.0
 * Start App-Client
 *
 * Command-line entry-point for starting a {@link Client}
 */
public class MainClient {

	private static final Logger logger = LoggerFactory.getLogger(MainClient.class);

	/**
	 * Default data output directory.
	 */
	private static final String DEFAULT_OUTPUT_DIRECTORY = "data";

	/**
	 * @param iface The network interface name.
	 * @return A usable IPv4 address as a {@link Inet4Address}.
	 * @throws UnsupportedAddressTypeException If no IPv4 address was available to bind on.
	 */
	private static Inet4Address getIPv4Address(String iface) throws SocketException, UnsupportedAddressTypeException, UnknownHostException {
		if (iface != null) {
            Enumeration<InetAddress> addresses = NetworkInterface.getByName(iface).getInetAddresses();
			while (addresses.hasMoreElements()) {
				InetAddress addr = addresses.nextElement();
				if (addr instanceof Inet4Address) {
					return (Inet4Address)addr;
				}
			}
		}

		InetAddress localhost = InetAddress.getLocalHost();
		if (localhost instanceof Inet4Address) {
			return (Inet4Address)localhost;
		}

		throw new UnsupportedAddressTypeException();
	}

	/**
	 * Display program usage on the given {@link PrintStream}.
	 */
	private static void usage(PrintStream usage) {
        usage.println("usage: Client [options] <torrent>");
        usage.println();
        usage.println("Available options:");
        usage.println("  -h,--help                  Show this help and exit.");
        usage.println("  -o,--output DIR            Read/write data to directory DIR.");
        usage.println("  -i,--iface IFACE           Bind to interface IFACE.");
        usage.println("  -s,--seed SECONDS          Time to seed after downloading (default: infinitely).");
        usage.println("  -d,--max-download KB/SEC   Max download rate (default: unlimited).");
        usage.println("  -u,--max-upload KB/SEC     Max upload rate (default: unlimited).");
        usage.println();
	}

	/**
	 * Main client entry point for stand-alone operation.
	 */
	public static void main(String[] args) {
		BasicConfigurator.configure( new ConsoleAppender(new PatternLayout("%d [%-25t] %-5p: %m%n")) );

		CmdLineParser parser = new CmdLineParser();
		CmdLineParser.Option        help = parser.addBooleanOption('h', "help");
		CmdLineParser.Option      output = parser.addStringOption('o', "output");
		CmdLineParser.Option       iface = parser.addStringOption('i', "iface");
		CmdLineParser.Option    seedTime = parser.addIntegerOption('s', "seed");
		CmdLineParser.Option   maxUpload = parser.addDoubleOption('u', "max-upload");
		CmdLineParser.Option maxDownload = parser.addDoubleOption('d', "max-download");

		try {
			parser.parse(args);
		} catch (CmdLineParser.OptionException oe) {
			System.err.println(oe.getMessage());
			usage(System.err);
			System.exit(1);
		}

		// Display help and exit if requested
		if (Boolean.TRUE.equals((Boolean)parser.getOptionValue(help))) {
			usage(System.out);
			System.exit(0);
		}

		String     outputValue = (String)parser.getOptionValue(output, DEFAULT_OUTPUT_DIRECTORY);
		String      ifaceValue = (String)parser.getOptionValue(iface);
		int      seedTimeValue = (Integer)parser.getOptionValue(seedTime, -1);
		double maxDownloadRate = (Double)parser.getOptionValue(maxDownload, 0.0);
		double   maxUploadRate = (Double)parser.getOptionValue(maxUpload, 0.0);
//		String[]     otherArgs = parser.getRemainingArgs();
        String[]     otherArgs = {"BitTorrent.torrent"};

		if (otherArgs.length != 1) {
			usage(System.err);
			System.exit(1);
		}

		try {
			Client client = new Client( getIPv4Address(ifaceValue), SharedTorrent.fromFile(new File(otherArgs[0]), new File(outputValue)) );

            client.setMaxDownloadRate(maxDownloadRate);
            client.setMaxUploadRate(maxUploadRate);

			// Set a shutdown hook that will stop the sharing/seeding and send a STOPPED announce request.
			Runtime.getRuntime().addShutdownHook( new Thread(new Client.ClientShutdown(client, null)) );

            client.share(seedTimeValue);
			if (Client.ClientState.ERROR.equals(client.getState())) {
				System.exit(1);
			}
		} catch (Exception e) {
			logger.error("Fatal error: {}", e.getMessage(), e);
			System.exit(2);
		}
	}
}
