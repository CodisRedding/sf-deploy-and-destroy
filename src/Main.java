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

		if (args.length != 3) {

			System.out.println("Missing args");
			System.out
					.println("Useage: destroy /deploy/to/src/path /deploy/from/src/path /save/destructive/file/to/path");
			System.exit(1);
		}

		String pathTo = args[0];
		String pathFrom = args[1];
		String saveTo = args[2];

		DestructiveBuilder builder = new DestructiveBuilder(pathFrom, pathTo);
		builder.buildDestructiveChanges(saveTo);
		builder.printDestructiveChanges();
		System.exit(0);
	}
}
