import com.sun.xml.internal.bind.v2.schemagen.xmlschema.List;

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
}