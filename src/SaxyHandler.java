import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class SaxyHandler extends DefaultHandler {

	final ArrayList<String> existing = new ArrayList<String>();
	boolean bfoundMetaType = false;
	boolean bfoundSearchTerm = false;
	String metaType = null;
	String searchTerm = null;

	@Override
	public void characters(char ch[], int start, int length)
			throws SAXException {

		if (bfoundSearchTerm && bfoundMetaType) {

			String data = new String(ch, start, length);

			if (!data.contains("\n")) {
				existing.add(data);
				bfoundSearchTerm = false;
				bfoundMetaType = false;
			}
		}
	}

	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {

		if (qName.equalsIgnoreCase(metaType)) {
			bfoundMetaType = true;
		}

		if (qName.equalsIgnoreCase(searchTerm)) {
			bfoundSearchTerm = true;
		}
	}
}
