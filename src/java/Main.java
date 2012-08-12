import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Properties;

import system.EnvironmentManager;
import system.OrgEnvironment;
import deploy.DeployBuilder;
import destroy.DestructiveBuilder;

/**
 * @author rocky
 * 
 */
public class Main {

	/**
	 * @param args
	 *            [0]
	 * 
	 *            The name of the environemnt file for the org that you want to
	 *            deploy from. if the files name is example1.env then use
	 *            example1 without the .env
	 * 
	 * @param args
	 *            [1]
	 * 
	 *            The name of the environemnt file for the org that you want to
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

		if (args.length < 2 || args.length > 3) {

			System.out
					.println("Useage: java -jar deployAndDestroy.jar [from env name 'example1'] [to env name 'example2'] [print only 'print-only'] [destroy only 'destroy-only']");
			System.exit(1);
		}

		install(true);

		String envNameFrom = args[0].toLowerCase();
		String envNameTo = args[1].toLowerCase();

		for (Integer i = 0; i < args.length; i++) {
			if (i > 1) {
				if (args[i].toLowerCase().equals("print-only")) {
					printOnly = true;
				} else if (args[i].toLowerCase().equals("destroy-only")) {
					destroyOnly = true;
				}
			}
		}

		EnvironmentManager manager = new EnvironmentManager(
				EnvironmentManager.createEnvironment(envNameFrom),
				EnvironmentManager.createEnvironment(envNameTo));

		manager.getFromEnvironment().retreive();
		manager.getToEnvironment().retreive();

		DestructiveBuilder destroybuilder = new DestructiveBuilder(
				manager.getFromEnvironment(), manager.getToEnvironment());
		destroybuilder.buildDestructiveChanges(destroyOnly);

		if (printOnly) {
			destroybuilder.printDestructiveChanges();
		} else {
			DeployBuilder deployBuilder = new DeployBuilder(
					manager.getFromEnvironment(),
					(OrgEnvironment) manager.getToEnvironment());
			destroybuilder.printDestructiveChanges();
			deployBuilder.deploy();
		}
	}

	private static void install(Boolean verbose) {

		Boolean reset = false;

		String LINE_SEP = System.getProperty("file.separator");

		// create install dir if it does not exist
		String installPath = System.getProperty("user.home") + LINE_SEP
				+ ".sf-deploy-and-destroy";

		String envPath = installPath + LINE_SEP + "environments";

		try {
			InputStream fileStream = Thread.currentThread()
					.getContextClassLoader()
					.getResourceAsStream("config.properties");
			Properties prop = new Properties();
			prop.load(fileStream);
			prop.setProperty("sf.environments.loc", envPath);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		File installDir = new File(installPath);
		if (!installDir.exists()) {
			installDir.mkdir();
		}
		
		File installEnvDir = new File(envPath);
		if (!installEnvDir.exists()) {
			installEnvDir.mkdir();
		}

		String[] configFileNames = { "destroy.properties",
				"package.properties", "environment.ignore", "github.env",
				"salesforce.env" };

		for (String configFileName : configFileNames) {

			String filePathAndName = null;

			if (configFileName.endsWith(".env")) {
				filePathAndName = envPath + LINE_SEP + configFileName;
			} else {
				filePathAndName = installPath + LINE_SEP + configFileName;
			}

			File propFile = new File(filePathAndName);

			if (!propFile.exists() || reset) {
				InputStream jarPropFile = Thread.currentThread()
						.getContextClassLoader()
						.getResourceAsStream(configFileName);

				OutputStream out = null;
				try {
					out = new FileOutputStream(propFile);
					byte buf[] = new byte[1024];
					int len;
					while ((len = jarPropFile.read(buf)) > 0) {
						out.write(buf, 0, len);
					}

					if (verbose) {
						System.out.println("Created configuration file: "
								+ filePathAndName);

						printOutSummary(configFileName);
					}

					// these functions also throw IOExceptions... didn't want to
					// nest try/catches
					// come up with better approach. Didn't want this function
					// to throw error either
					out.close();
					jarPropFile.close();
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

	private static void printOutSummary(String propFile) {

		if (propFile.equals("destroy.properties")) {
			System.out.println("TODO: ADD FILE SUMMARY");
			System.out.println("----------------------");
		} else if (propFile.equals("package.properties")) {
			System.out.println("TODO: ADD FILE SUMMARY");
			System.out.println("----------------------");
		} else if (propFile.equals("environment.ignore")) {
			System.out.println("TODO: ADD FILE SUMMARY");
			System.out.println("----------------------");
		} else if (propFile.equals("github.env")) {
			System.out.println("TODO: ADD FILE SUMMARY");
		} else if (propFile.equals("salesforce.env")) {
			System.out.println("TODO: ADD FILE SUMMARY");
		}
	}
}