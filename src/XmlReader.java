import java.util.ArrayList;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

public class XmlReader {

	public static ArrayList<String> compareXml(String fileTo, String fileFrom,
			String metaType, String searchTerm) {

		ArrayList<String> listTo = getExisting(fileTo, metaType, searchTerm);
		ArrayList<String> listFrom = getExisting(fileFrom, metaType, searchTerm);
		ArrayList<String> listDestroy = new ArrayList<String>();

		for (String itemTo : listTo) {
			boolean bfound = false;
			for (String itemFrom : listFrom) {
				if (itemTo.equals(itemFrom)) {
					bfound = true;
					break;
				}
			}

			if (!bfound) {
				listDestroy.add(itemTo);
			}
		}

		return listDestroy;
	}

	private static ArrayList<String> getExisting(String filePath,
			final String metaType, final String searchTerm) {

		ArrayList<String> existing = new ArrayList<String>();

		try {
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();

			SaxyHandler handler = new SaxyHandler();
			handler.metaType = metaType;
			handler.searchTerm = searchTerm;

			saxParser.parse(filePath, handler);
			existing = handler.existing;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return existing;
	}
}