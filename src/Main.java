
public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		destructiveChanges();
	}
	
	private static void destructiveChanges() {
		DestructiveBuilder builder = new DestructiveBuilder("./xml/src2", "./xml/src1");
		
		// creates destructiveChanges.xml in the passed in dir
		builder.buildDestructiveChanges("./xml");
		builder.printDestructiveChanges();
	}
}
