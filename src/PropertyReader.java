import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Properties;

/**
 * @author rocky
 * 
 *         Reads properties from both config.properties and package.properties
 *         files.
 */
public class PropertyReader {

	/**
	 * @author rocky
	 * 
	 *         The different property types found on each line of the
	 *         package.properties file.
	 */
	public static enum PropertyTypes {
		Directory, MetadataType, XmlName, SearchTerm, SupportsAsterisk
	}

	/**
	 * Some components are compared by file name instead of by xml name, this
	 * property can be used to when reading each property and determining hotw
	 * to parse.
	 */
	public static final String FILESEACH = "fileName";

	/**
	 * Reads from the package.properties file.
	 * 
	 * @return
	 * 
	 *         Returns an array of all properties to be further parsed and used
	 *         when comparing component types.
	 */
	public static ArrayList<String> getProperties() {

		ArrayList<String> properties = new ArrayList<String>();

		try {
			FileInputStream fstream = new FileInputStream(
					getSystemProperty("sf.package.properties.loc"));

			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));

			String line;
			while ((line = br.readLine()) != null) {
				properties.add(line);
			}
			in.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return properties;
	}

	/**
	 * Parses the supplied property (a line in the package.properties file) for
	 * the supplied type.
	 * 
	 * @param property
	 * 
	 *            A property line of delimited properties found in the
	 *            paclage.properties file.
	 * @param type
	 * 
	 *            The type of property to needed from the property supplied.
	 * @return
	 * 
	 *         Returns a specific property type determined by the supplied
	 *         PropertyTypes enum.
	 */
	public static String getProperty(String property, PropertyTypes type) {

		String[] properties = property.split("\\.");
		String response = null;

		try {
			switch (type) {
			case Directory:
				response = properties[0];
				break;
			case MetadataType:
				response = properties[1];
				break;
			case XmlName:
				response = properties[2];
				break;
			case SearchTerm:
				response = properties[3];
				break;
			case SupportsAsterisk:
				try {
					response = properties[4];
				} catch (Exception e) {
					// ignore
				}
				break;
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		if (response != null && response.equals("")) {
			response = null;
		}

		return response;
	}

	/**
	 * Reads properties from the config.properties file.
	 * 
	 * @param key
	 * 
	 *            The key of the key/value.
	 * @return
	 * 
	 *         Returns the values for the key supplied. Returns null if not
	 *         found.
	 */
	public static String getSystemProperty(String key) {

		String response = null;

		try {
			Properties prop = new Properties();
			prop.load(new FileInputStream("properties" + File.separator
					+ "config.properties"));
			response = prop.getProperty(key);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return response;
	}
}
