import retrieve.RetrieveBuilder;
import system.OrgEnvironment;
import destory.DestructiveBuilder;

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

		String envNameTo = args[0].toLowerCase();
		String envNameFrom = args[1].toLowerCase();
		
		OrgEnvironment orgTo = new OrgEnvironment(envNameTo);
		OrgEnvironment orgFrom = new OrgEnvironment(envNameFrom);
		
		RetrieveBuilder retrieveTo = new RetrieveBuilder(orgTo);
		retrieveTo.retreive();
		
		RetrieveBuilder retrieveFrom = new RetrieveBuilder(orgFrom);
		retrieveFrom.retreive();

		DestructiveBuilder builder = new DestructiveBuilder(orgFrom, orgTo);
		builder.buildDestructiveChanges();
		builder.printDestructiveChanges();
	}
}