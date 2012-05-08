import retrieve.RetrieveBuilder;
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
	 *            The src dir of the salesforce org you're deploying to.
	 * 
	 * @param args
	 *            [1]
	 * 
	 *            The src dir of the salesforce org you're deploying from.
	 * 
	 * @param args
	 *            [2]
	 * 
	 *            The dir where you want the destructiveChanges.xml file to be
	 *            created.
	 */
	public static void main(String[] args) {

		if (args.length != 2) {

			System.out.println("Missing args");
			System.out
					.println("Useage: deployAndDestroy [from env name] [to env name]");
			System.exit(1);
		}

		String envNameFrom = args[0].toLowerCase();
		String envNameTo = args[1].toLowerCase();
		
		OrgEnvironment orgFrom = new OrgEnvironment(envNameFrom);
		OrgEnvironment orgTo = new OrgEnvironment(envNameTo);
		
		RetrieveBuilder retrieveFrom = new RetrieveBuilder(orgFrom);
		retrieveFrom.retreive();
		
		RetrieveBuilder retrieveTo = new RetrieveBuilder(orgTo);
		retrieveTo.retreive();

		DestructiveBuilder destroybuilder = new DestructiveBuilder(orgFrom, orgTo);
		destroybuilder.buildDestructiveChanges();
		destroybuilder.printDestructiveChanges();
		
		//DeployBuilder deployBuilder = new DeployBuilder(orgFrom, orgTo);
		//deployBuilder.deploy();
	}
}