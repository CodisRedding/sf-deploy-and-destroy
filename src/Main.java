public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		DestructiveBuilder builder = new DestructiveBuilder("./tmp/src2",
				"./tmp/src1");

		builder.buildDestructiveChanges("./tmp");
		builder.printDestructiveChanges();
	}
}
