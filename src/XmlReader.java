

import java.util.ArrayList;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

/**
 * @author rocky
 * 
 *         Searches two xml files for a given metadata type and term to search
 *         for.
 */
public class XmlReader {

	/**
	 * Creates a list of matching search term xml components that only belong in
	 * the fileTo xml file.
	 * 
	 * @param fileTo
	 * 
	 *            The metadata xml to be searched through from the salesforce
	 *            org being deployed to.
	 * @param fileFrom
	 * 
	 *            The metadata xml to be searched through from the salesforce
	 *            org being deployed from.
	 * @param metaType
	 * 
	 *            The salesforce metadata type to search through for supplied
	 *            search term.
	 * @param searchTerm
	 * 
	 *            The term to find in the supplied meadata type.
	 * @return
	 * 
	 *         Returns and arraylist of all xml nodes matching the metadata type
	 *         and search term that were in the deploy to file, but not the
	 *         deploy from file.
	 */
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

	/**
	 * Searches an xml file for the supplied metadata type search term.
	 * 
	 * @param filePath
	 * 
	 *            The path of the file being searched.
	 * @param metaType
	 * 
	 *            The salesforce metadata type to search through for the
	 *            supplied search term.
	 * @param searchTerm
	 * 
	 *            The term to find in the supplied meadata type.
	 * @return
	 * 
	 *         Returns and arraylist of all xml nodes matching the metadata type
	 *         and search term that were in the deploy to file, but not the
	 *         deploy from file.
	 */
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