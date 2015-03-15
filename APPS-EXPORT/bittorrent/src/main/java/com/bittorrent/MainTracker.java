package com.bittorrent;

import com.bittorrent.mpetazzoni.tracker.TrackedTorrent;
import com.bittorrent.mpetazzoni.tracker.Tracker;
import jargs.gnu.CmdLineParser;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.ConsoleAppender;
import org.apache.log4j.PatternLayout;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FilenameFilter;
import java.io.PrintStream;
import java.net.InetSocketAddress;

/**
 * @author Lazarchuk A.K.
 * @version 1.0
 * @date 7/08/2014
 * {@link https://ru.wikipedia.org/wiki/BitTorrent}
 ******************************************************
 * Main-Tracker
 *
 * Programm arguments: -p 6969
 * Start on:
 *           http://localhost:6969/announce
 *
 */
public class MainTracker {

	private static final Logger logger = LoggerFactory.getLogger(MainTracker.class);

    /**
     * Display program usage on the given {@link PrintStream}.
     * @param usage
     */
	private static void usage(PrintStream usage) {
        usage.println("usage: Tracker [options] [directory]");
        usage.println();
        usage.println("Available options:");
        usage.println("  -h,--help             Show this help and exit.");
        usage.println("  -p,--port PORT        Bind to port PORT.");
        usage.println();
	}

    /**
     * Main function to start a tracker.
     * @param args
     */

	public static void main(String[] args) {
		BasicConfigurator.configure( new ConsoleAppender(new PatternLayout("%d [%-25t] %-5p: %m%n")) );

		CmdLineParser parser = new CmdLineParser();
		CmdLineParser.Option help = parser.addBooleanOption('h', "help");
		CmdLineParser.Option port = parser.addIntegerOption('p', "port");

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

		Integer portValue = (Integer)parser.getOptionValue( port, Integer.valueOf(Tracker.DEFAULT_TRACKER_PORT) );

		String[] otherArgs = parser.getRemainingArgs();

		if (otherArgs.length > 1) {
			usage(System.err);
			System.exit(1);
		}

		// Get directory from command-line argument or default to current directory
		String directory = otherArgs.length > 0 ? otherArgs[0] : ".";

		FilenameFilter filter = new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				return name.endsWith(".torrent");
			}
		};

		try {
			Tracker t = new Tracker(new InetSocketAddress(portValue.intValue()));

			File parent = new File(directory);
			for (File f : parent.listFiles(filter)) {
				logger.info("Loading torrent from " + f.getName());
				t.announce(TrackedTorrent.load(f));
			}

			logger.info("Starting tracker with {} announced torrents...",
				t.getTrackedTorrents().size());
			t.start();
		} catch (Exception e) {
			logger.error("{}", e.getMessage(), e);
			System.exit(2);
		}
	}

}
