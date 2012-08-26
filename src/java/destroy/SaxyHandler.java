package destroy;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * @author rocky
 * 
 *         Handles xml data as it is iterated through.
 */
public class SaxyHandler extends DefaultHandler {

	/**
	 * All components found that should be destroyed.
	 */
	final ArrayList<String> existing = new ArrayList<String>();
	boolean bfoundMetaType = false;
	boolean bfoundSearchTerm = false;
	String metaType = null;
	String searchTerm = null;
	String LINE_SEP = System.getProperty("line.separator");
	String lastParentNameFound = "";
	boolean lookForParentName = false;
	boolean foundParent = false;
	String parentMetaType = null;
	boolean bfoundParentMetaType = false;
	boolean bfoundParentSearchTerm = false;
	String parentSearchTerm = null;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.xml.sax.helpers.DefaultHandler#characters(char[], int, int)
	 * 
	 * When data is found while iterating all nodes it passes through here. When
	 * data is found for the xml name we're searching for then we add it to the
	 * existing property array.
	 */
	@Override
	public void characters(char ch[], int start, int length)
			throws SAXException {

		if (lookForParentName && bfoundParentMetaType && bfoundParentSearchTerm) {

			String data = new String(ch, start, length);

			if (!data.contains(LINE_SEP)) {
				lastParentNameFound = data;

				bfoundParentMetaType = false;
				bfoundParentSearchTerm = false;
			}
		}

		if (bfoundSearchTerm && bfoundMetaType) {

			String data = new String(ch, start, length);

			if (!data.contains(LINE_SEP)) {
				if (lookForParentName) {
					data = lastParentNameFound + "|" + data;
				}

				existing.add(data);
				bfoundSearchTerm = false;
				bfoundMetaType = false;
			}
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.xml.sax.helpers.DefaultHandler#startElement(java.lang.String,
	 * java.lang.String, java.lang.String, org.xml.sax.Attributes)
	 * 
	 * When an xml node name is found while iterating all xml it passes through
	 * here. If the name matches that of the xml name we're searching for then
	 * we flag it as found for the characters() event to know when to read the
	 * correct data.
	 */
	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {

		if (qName.equalsIgnoreCase(metaType)) {
			bfoundMetaType = true;
		}

		if (qName.equalsIgnoreCase(searchTerm)) {
			bfoundSearchTerm = true;
		}

		if (qName.equalsIgnoreCase(parentMetaType)) {
			bfoundParentMetaType = true;
		}

		if (qName.equalsIgnoreCase(parentSearchTerm)) {
			bfoundParentSearchTerm = true;
		}
	}

	@Override
	public void endElement(String uri, String localName, String qName)
			throws SAXException {

		// if (lookForParentName && (qName.equalsIgnoreCase(parentMetaType) &&
		// bfoundParentMetaType)) {
		// bfoundParentMetaType = false;
		// }
	}
}
