import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import system.EnvironmentManager;
import system.Installer;
import system.OrgEnvironment;
import deploy.DeployBuilder;
import destroy.DestructiveBuilder;

/**
 * @author rocky
 * 
 */
public class Main {

	private final static String optionInstallOnly = "--install-only";
	private final static String optionPrintOnly = "--print-only";
	private final static String optionDestroyOnly = "--destroy-only";
	private final static String optionEnvironment = "-e";
	private final static String optionPath = "-p";

	/**
	 * @param args
	 *            [0]
	 * 
	 *            The name of the environment file for the org that you want to
	 *            deploy from. if the files name is example1.env then use
	 *            example1 without the .env
	 * 
	 * @param args
	 *            [1]
	 * 
	 *            The name of the environment file for the org that you want to
	 *            deploy to. if the files name is example1.env then use example1
	 *            without the .env
	 * 
	 * @param args
	 *            [2]
	 * 
	 *            The arg 'po' will ensure that the destructive changes are not
	 *            deployed, but instead only printed.
	 */
	public static void main(String[] args) {

		boolean printOnly = false;
		boolean destroyOnly = false;

		// Check for valid args
		if (!checkForInvalidArgs(args)) {
			System.out
					.println("Useage: java -jar deployAndDestroy.jar [[from env name 'example1'] [to env name 'example2'] [print only '--print-only'] [destroy only '--destroy-only']] [--install-only]");
			System.exit(1);
		}

		// Install user preferences
		if (args.length == 1 && args[0].toLowerCase().equals(optionInstallOnly)) {

			// Install user preferences
			system.Installer installer = new system.Installer();
			installer.install(true);

			return;
		}

		// Check for valid amount of args
		if (args.length < 2 || args.length > 4) {

			System.out
					.println("Useage: java -jar deployAndDestroy.jar [[from env name 'example1'] [to env name 'example2'] [print only '--print-only'] [destroy only '--destroy-only']] [--install-only]");
			System.exit(1);
		}

		// Grab environment names
		Boolean isEnvPath = (args[0].toLowerCase().equals("-e"));
		Boolean isArgPath = (args[0].toLowerCase().equals("-p"));

		String envNameFrom = args[1].toLowerCase();
		String envNameTo = args[2].toLowerCase();

		// Figure out what options were set
		for (Integer i = 0; i < args.length; i++) {
			if (i > 2) {
				if (args[i].toLowerCase().equals(optionPrintOnly)) {
					printOnly = true;
				} else if (args[i].toLowerCase().equals(optionDestroyOnly)) {
					destroyOnly = true;
				}
			}
		}
		
		if(isArgPath) {
			// create temp env file for this dir path
			envNameFrom = "dynamic-env";
			String dynamicEnvFile = Installer.installPath + File.separator + envNameFrom + ".env";
			File tmpFile = new File(dynamicEnvFile);
			
			Properties prop = new Properties();
			prop.setProperty("dir.source.root", args[1]);
			prop.setProperty("type", "directory");
			
			try {
				prop.store(new FileOutputStream(tmpFile), "Dynamic Environment Created by jar option -p");
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		// Tell the environment manager which environments to work with.
		EnvironmentManager manager = new EnvironmentManager(
				EnvironmentManager.createEnvironment(envNameFrom),
				EnvironmentManager.createEnvironment(envNameTo));

		// Retreive metadata from each environment
		long startTime = System.nanoTime();
		manager.getFromEnvironment().retreive(null);
		manager.getToEnvironment().retreive(null);
		long endTime = System.nanoTime();
		System.out.println("### Retreiving Source Took "
				+ (endTime - startTime) + " ns");

		// Build the destructive changes needed to sync both environments.
		startTime = System.nanoTime();
		DestructiveBuilder destroybuilder = new DestructiveBuilder(
				manager.getFromEnvironment(), manager.getToEnvironment());
		destroybuilder.buildDestructiveChanges(destroyOnly);
		endTime = System.nanoTime();
		System.out.println("### Building Destroyable Changes Took "
				+ (endTime - startTime) + " ns");

		// Tell the deploy builder which environments to work with.
		DeployBuilder deployBuilder = new DeployBuilder(
				manager.getFromEnvironment(),
				(OrgEnvironment) manager.getToEnvironment());

		// Always print the destructive changes that are being made.
		destroybuilder.printDestructiveChanges();

		// Actually deploy the destructive changes and metadata.
		if (!printOnly) {
			// Deploy environment and apply destructive changes.
			startTime = System.nanoTime();
			deployBuilder.deploy();
			endTime = System.nanoTime();
			System.out.println("### Deployment Took " + (endTime - startTime)
					+ " ns");
		}

		startTime = System.nanoTime();
		deployBuilder.cleanUp();
		endTime = System.nanoTime();
		System.out.println("### Cleanup Took " + (endTime - startTime) + " ns");
	}

	private static Boolean checkForInvalidArgs(String[] args) {

		Integer count = -1;
		for (String arg : args) {
			count++;
			
			if (!arg.startsWith("-")) {
				// Check to make sure env file exists
				String envFilePath = null;

				if (args[0].equals(optionEnvironment) || count == 2) {
					envFilePath = Installer.installPath + File.separator + arg
							+ ".env";
				} else if (args[0].equals(optionPath)) {
					envFilePath = arg;
				}
				
				File envFile = new File(envFilePath);

				if (!envFile.exists()) {
					System.out.println("NOPE!");
					System.out.println("No environment file " + envFilePath
							+ " found.");
					return false;
				}
			} else if (!arg.equals(optionInstallOnly)
					&& !arg.equals(optionDestroyOnly)
					&& !arg.equals(optionPrintOnly)
					&& !arg.equals(optionEnvironment)
					&& !arg.equals(optionPath)) {

				System.out.println("NOPE!");
				System.out.println(arg + " is not a valid option.");
				return false;
			}
		}

		return true;
	}
}