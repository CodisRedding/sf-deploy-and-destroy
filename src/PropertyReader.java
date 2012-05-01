import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Properties;

public class PropertyReader {

	public static enum PropertyTypes {
		Directory, MetadataType, XmlName, SearchTerm, SupportsAsterisk
	}

	public static final String FILESEACH = "fileName";

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
