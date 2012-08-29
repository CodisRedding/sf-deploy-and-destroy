import java.io.File;

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
		if (args.length < 2 || args.length > 3) {

			System.out
					.println("Useage: java -jar deployAndDestroy.jar [[from env name 'example1'] [to env name 'example2'] [print only '--print-only'] [destroy only '--destroy-only']] [--install-only]");
			System.exit(1);
		}

		// Grab environment names
		String envNameFrom = args[0].toLowerCase();
		String envNameTo = args[1].toLowerCase();

		// Figure out what options were set
		for (Integer i = 0; i < args.length; i++) {
			if (i > 1) {
				if (args[i].toLowerCase().equals(optionPrintOnly)) {
					printOnly = true;
				} else if (args[i].toLowerCase().equals(optionDestroyOnly)) {
					destroyOnly = true;
				}
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
		System.out.println("### Retreiving Source Took " + (endTime - startTime) + " ns");
		
		// Build the destructive changes needed to sync both environments.
		startTime = System.nanoTime();
		DestructiveBuilder destroybuilder = new DestructiveBuilder(
				manager.getFromEnvironment(), manager.getToEnvironment());
		destroybuilder.buildDestructiveChanges(destroyOnly);
		endTime = System.nanoTime();
		System.out.println("### Building Destroyable Changes Took " + (endTime - startTime) + " ns");

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
			System.out.println("### Deployment Took " + (endTime - startTime) + " ns");
		}

		startTime = System.nanoTime();
		deployBuilder.cleanUp();
		endTime = System.nanoTime();
		System.out.println("### Cleanup Took " + (endTime - startTime) + " ns");
	}

	private static Boolean checkForInvalidArgs(String[] args) {
	
		for (String arg : args) {
			
			if(!arg.startsWith("--")) {
				// Check to make sure env file exists
				String envFilePath = Installer.installPath + File.separator + arg + ".env";
				File envFile = new File(envFilePath);
				
				if(!envFile.exists()) {
					System.out.println("NOPE!");
					System.out.println("No environment file " + envFilePath + " found.");
					return false;
				}
			} else if (!arg.equals(optionInstallOnly)
					&& !arg.equals(optionDestroyOnly)
					&& !arg.equals(optionPrintOnly)) {
				
				System.out.println("NOPE!");
				System.out.println(arg + " is not a valid option.");
				return false;
			}
		}

		return true;
	}
}