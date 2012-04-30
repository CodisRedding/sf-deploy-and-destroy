import java.io.File;
import java.util.ArrayList;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		destructiveChanges();
	}
	
	private static void destructiveChanges() {
		DestructiveBuilder builder = new DestructiveBuilder("./xml/src2", "./xml/src1");
		
		builder.buildDestructiveChanges("./xml");
		builder.printDestructiveChanges();
	}

	private static void readXml() {
		ArrayList<File> xmlFiles = new ArrayList<File>();
		xmlFiles.add(new File("xml/Account.object"));
		xmlFiles.add(new File("xml/AccountContactRole.object"));
		
		for(File xmlFile : xmlFiles) {
			XmlReader.readXmlFile(xmlFile.getAbsolutePath());
		}
	}
}
