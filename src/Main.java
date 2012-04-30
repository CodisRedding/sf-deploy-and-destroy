
public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		destructiveChanges();
	}
	
	private static void destructiveChanges() {
		DestructiveBuilder builder = new DestructiveBuilder("./xml/src2", "./xml/src1");
		
<<<<<<< HEAD
		// creates destructiveChanges.xml in the passed in dir
=======
>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
		builder.buildDestructiveChanges("./xml");
		builder.printDestructiveChanges();
	}
}
