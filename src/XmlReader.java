import java.util.ArrayList;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class XmlReader {
	
	public static ArrayList<String> compareXml(String fileTo, String fileFrom, String metaType, String searchTerm) {
		
		ArrayList<String> listTo = getExisting(fileTo, metaType, searchTerm);
		ArrayList<String> listFrom = getExisting(fileFrom, metaType, searchTerm);
		ArrayList<String> listDestroy = new ArrayList<String>();
		
		for(String itemTo : listTo) {
			boolean bfound = false;
			for(String itemFrom : listFrom) {
				if(itemTo.equals(itemFrom)) {
					bfound = true;
					break;
				}
			}
			
			if(!bfound) {
				listDestroy.add(itemTo);
			}
		}
		
		return listDestroy;
	}
	
	private static ArrayList<String> getExisting(String filePath, final String metaType, final String searchTerm) {

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

	public static void readXmlFile(String absXmlFilePath) {

		try {

			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();

			DefaultHandler handler = new DefaultHandler() {

				boolean bfname = false;
				boolean blname = false;
				boolean bnname = false;
				boolean bsalary = false;

				@Override
				public void startElement(String uri, String localName,
						String qName, Attributes attributes)
						throws SAXException {

					System.out.println("Start Element :" + qName);

					if (qName.equalsIgnoreCase("FIRSTNAME")) {
						bfname = true;
					}

					if (qName.equalsIgnoreCase("LASTNAME")) {
						blname = true;
					}

					if (qName.equalsIgnoreCase("NICKNAME")) {
						bnname = true;
					}

					if (qName.equalsIgnoreCase("SALARY")) {
						bsalary = true;
					}

				}

				@Override
				public void endElement(String uri, String localName,
						String qName) throws SAXException {

					System.out.println("End Element :" + qName);

				}

				@Override
				public void characters(char ch[], int start, int length)
						throws SAXException {

					if (bfname) {
						System.out.println("First Name : "
								+ new String(ch, start, length));
						bfname = false;
					}

					if (blname) {
						System.out.println("Last Name : "
								+ new String(ch, start, length));
						blname = false;
					}

					if (bnname) {
						System.out.println("Nick Name : "
								+ new String(ch, start, length));
						bnname = false;
					}

					if (bsalary) {
						System.out.println("Salary : "
								+ new String(ch, start, length));
						bsalary = false;
					}

				}

			};

			saxParser.parse(absXmlFilePath, handler);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}