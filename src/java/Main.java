import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

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

		install();

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

	private static void install() {

		/*
		Boolean reset = false;

		String LINE_SEP = System.getProperty("file.separator");

		// create install dir if it does not exist
		String installPath = System.getProperty("user.home") + LINE_SEP
				+ ".sf-deploy-and-destroy";

		File installDir = new File(installPath);
		if (!installDir.exists()) {
			installDir.mkdir();
		}
		
		InputStream config = Thread.currentThread().getContextClassLoader().getResourceAsStream("/config.properties");
		InputStream destroy = Thread.currentThread().getContextClassLoader().getResourceAsStream("/destroy.properties");
		InputStream pack = Thread.currentThread().getContextClassLoader().getResourceAsStream("/pack.properties");
		InputStream environment = Thread.currentThread().getContextClassLoader().getResourceAsStream("/environment.properties");

		File configFile = new File(installPath + LINE_SEP + "/config.properties");
		if(!configFile.exists()) {
			input = Thread.currentThread().getContextClassLoader()
					.getResourceAsStream("/" + file.getName());

			OutputStream out = new FileOutputStream(f);
			byte buf[] = new byte[1024];
			int len;
			while ((len = input.read(buf)) > 0) {
				out.write(buf, 0, len);
			}
			out.close();
			input.close();
		}
		
		for (File file : installDir.listFiles()) {
			InputStream input = null;
			String checkPath = installDir.getPath() + file.getName();
			File checkFile = new File(checkPath);
			File f = new File(installPath + checkFile.getName());

			try {
				if ((!file.getName().equals("source.properties") && !checkFile
						.exists()) || reset) {
					input = Thread.currentThread().getContextClassLoader()
							.getResourceAsStream("/" + file.getName());

					OutputStream out = new FileOutputStream(f);
					byte buf[] = new byte[1024];
					int len;
					while ((len = input.read(buf)) > 0) {
						out.write(buf, 0, len);
					}
					out.close();
					input.close();
				}
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} */
	}
}