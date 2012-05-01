public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		DestructiveBuilder builder = new DestructiveBuilder("./xml/src2",
				"./xml/src1");

		builder.buildDestructiveChanges("./xml");
		builder.printDestructiveChanges();
	}
}
