package system;

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
	 * The different property types found on each line of the destroy.properties
	 * file.
	 */
	public static enum DestructivePropertyTypes {
		Directory, MetadataType, XmlName, SearchTerm, SupportsAsterisk, FileExt
	}

	/**
	 * The different property types found on each line of the package.properties
	 * file.
	 */
	public static enum RetrievePropertyTypes {
		MetadataType, SupportsAsterisk, Folder
	}

	private static ArrayList<String> ignoreProperties = null;

	/**
	 * Used to determine if the sf.environment property in
	 * properties/config.properties is set to a production environment or not
	 */
	public final static String PRODUCTION_ENV = "production";

	/**
	 * Some components are compared by file name instead of by xml name, this
	 * property can be used to when reading each property and determining how to
	 * parse.
	 */
	public static final String FILESEACH = "fileName";

	public static final String ASTERISK = "*";
	public static final String ROOT_FOLDER = "root";

	/**
	 * Reads from the package.properties file.
	 * 
	 * @return
	 * 
	 *         Returns an array of all properties to be further parsed and used
	 *         when comparing component types.
	 */
	public static ArrayList<String> getDestructiveProperties() {

		ArrayList<String> properties = new ArrayList<String>();

		try {
			FileInputStream fstream = new FileInputStream(
					getSystemProperty("sf.destruct.properties.loc"));

			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));

			String line;
			while (((line = br.readLine()) != null) && (!line.startsWith("#"))) {
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
	public static String getDestructiveProperty(String property,
			DestructivePropertyTypes type) {

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
	 * Reads properties from an environment file.
	 * 
	 * @param env
	 * 
	 *            The name of the environment file minus the extension.
	 * @param key
	 * 
	 *            The name of the property to retrieve.
	 * @return
	 * 
	 *         The value of the property supplied.
	 */
	public static String getEnviromentProperty(String env, String key) {

		String response = null;

		try {
			Properties prop = new Properties();
			prop.load(new FileInputStream(
					getSystemProperty("sf.environments.loc") + env + ".env"));
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

	/**
	 * Returns the correct URI endpoint service based on the enviroment type
	 * supplied.
	 * 
	 * @param envType
	 * 
	 *            Environment options are: production or sandbox. Assumes
	 *            sandbox if not production or sandbox
	 * @param endpointType
	 * 
	 *            The type of web service end point, options are: auth or
	 *            service.
	 * @return
	 * 
	 *         Returns the endpoint service URI.
	 */
	public static String getEnvironmentEndpoint(String envType,
			String endpointType, String sfServer, Double apiVersion) {

		String response = null;

		try {
			Properties prop = new Properties();
			prop.load(new FileInputStream("properties" + File.separator
					+ "config.properties"));

			if (envType.equals(null) || envType.equals("")) {
				envType = "sandbox";
			}

			// assumes sandbox if production is not specified
			response = prop.getProperty("sf." + endpointType + ".endpoint");

			if (endpointType.equals("auth")) {
				response = String.format(response,
						(envType.equals(PRODUCTION_ENV)) ? "login" : "test",
						String.valueOf(apiVersion));
			}

			if (endpointType.equals("service")) {
				response = String.format(response, sfServer,
						String.valueOf(apiVersion));
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return response;
	}

	public static ArrayList<String> getRetrieveProperties() {

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

	public static String getRetrieveProperty(String property,
			RetrievePropertyTypes type) {

		String[] properties = property.split("\\.");
		String response = null;

		try {
			switch (type) {
			case MetadataType:
				response = properties[0];
				break;
			case SupportsAsterisk:
				try {
					response = properties[1];
				} catch (Exception e) {
					// ignore
				}
				break;
			case Folder:
				try {
					response = properties[2];
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
	
	/**
	 * Reads properties from the source.properties file.
	 * 
	 * @param key
	 * 
	 *            The key of the key/value.
	 * @return
	 * 
	 *         Returns the values for the key supplied. Returns null if not
	 *         found.
	 */
	public static String getSourceProperty(String key) {

		String response = null;

		try {
			Properties prop = new Properties();
			prop.load(new FileInputStream("properties" + File.separator
					+ "source.properties"));
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

	public static boolean shouldIgnoreMetadata(String metadata,
			String metadataPath) {

		if (metadataPath.equals(PropertyReader.ASTERISK)) {
			return false;
		}

		// ignore custom fields
		if (metadata.toLowerCase().equals("customfield")
				&& !metadataPath.toLowerCase().endsWith("__c")) {
			return true;
		}

		if (ignoreProperties == null) {
			ignoreProperties = new ArrayList<String>();

			try {
				FileInputStream fstream = new FileInputStream(
						getSystemProperty("sf.environment.ignore.properties.loc"));

				DataInputStream in = new DataInputStream(fstream);
				BufferedReader br = new BufferedReader(
						new InputStreamReader(in));

				String line;
				while ((line = br.readLine()) != null) {
					ignoreProperties.add(line);
				}
				in.close();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		for (String prop : ignoreProperties) {
			String meta = prop.substring(0, prop.indexOf(":"));
			String path = prop.substring(prop.indexOf(":") + 1);

			if (meta.toLowerCase().equals(metadata.toLowerCase())
					&& path.toLowerCase().equals(metadataPath.toLowerCase())) {
				return true;
			}
		}

		return false;
	}
}
