package system;

import java.io.File;
import java.rmi.RemoteException;
import java.util.ArrayList;
import com.sforce.soap.metadata.FileProperties;
import com.sforce.soap.metadata.ListMetadataQuery;
import com.sforce.ws.ConnectionException;
import retrieve.Zipper;
import api.ConnectionManager;

public class OrgEnvironment implements MetadataEnvironment {

	private ConnectionManager conMan = null;
	private PackageBuilder packager = new PackageBuilder();
	private String name = null;
	private String environment = null;
	private String login = null;
	private String password = null;
	private String token = null;
	private boolean includePackages = false;
	private String authEndpoint = null;
	private String serviceEndpoint = null;
	private String server = null;

	public OrgEnvironment(String name) {

		this.name = name;
		this.login = PropertyReader.getEnviromentProperty(name, "sf.login");
		this.password = PropertyReader.getEnviromentProperty(name,
				"sf.password");
		this.token = PropertyReader.getEnviromentProperty(name,
				"sf.security.token");
		this.environment = PropertyReader.getEnviromentProperty(name,
				"sf.environment");
		this.server = PropertyReader.getEnviromentProperty(name,
				"sf.environment.server");
		this.authEndpoint = PropertyReader.getEnvironmentEndpoint(
				this.environment, "auth", this.server, this.apiVersion);
		this.serviceEndpoint = PropertyReader.getEnvironmentEndpoint(
				this.environment, "service", this.server, this.apiVersion);
		
		conMan = new ConnectionManager(this.login, password, token,
				authEndpoint, serviceEndpoint);

	}

	@Override
	public String getEnvironment() {
		return environment;
	}

	public String getAuthEndpoint() {
		return authEndpoint;
	}

	@Override
	public String getName() {
		return name;
	}

	public String getServiceEndpoint() {
		return serviceEndpoint;
	}

	@Override
	public String getLogin() {
		return login;
	}

	@Override
	public String getPassword() {
		return password;
	}

	public String getToken() {
		return token;
	}

	public boolean isIncludePackages() {
		return includePackages;
	}

	@Override
	public String getServer() {
		return server;
	}

	@Override
	public File getLocationFolder() {
		String folderName = PropertyReader
				.getSystemProperty("sf.environments.loc") + this.name;
		File folder = new File(folderName);

		return folder;
	}

	@Override
	public File getSourceFolder() {
		String folderName = PropertyReader
				.getSystemProperty("sf.environments.loc")
				+ this.name
				+ File.separator
				+ PropertyReader
						.getSystemProperty("sf.environments.unzip.src.name");
		File folder = new File(folderName);

		return folder;
	}

	public File getRetrieveZip() {
		String zip = PropertyReader.getSystemProperty("sf.environments.loc")
				+ this.name + File.separator
				+ PropertyReader.getSystemProperty("sf.retrieve.zip.file.name");
		File zipFile = new File(zip);

		return zipFile;
	}

	@Override
	public File getDestroyZip() {
		String zip = PropertyReader.getSystemProperty("sf.environments.loc")
				+ this.name + File.separator
				+ PropertyReader.getSystemProperty("sf.destruct.zip.file.name");
		File zipFile = new File(zip);

		return zipFile;
	}

	@Override
	public PackageBuilder retreive() {

		ArrayList<String> properties = PropertyReader.getRetrieveProperties();

		if (!conMan.Login()) {
			System.out.println("Unable to connect.");
			System.exit(1);
		}

		System.out.println("### Retrieving " + this.name + " (saleforce) ###");

		for (String property : properties) {

			// get metadata type
			String metadataType = PropertyReader.getRetrieveProperty(property,
					PropertyReader.RetrievePropertyTypes.MetadataType);
			if (metadataType == null) {
				continue;
			}

			// get folder name
			String folderName = PropertyReader.getRetrieveProperty(property,
					PropertyReader.RetrievePropertyTypes.Folder);

			// get asterisk support
			String asterisk = PropertyReader.getRetrieveProperty(property,
					PropertyReader.RetrievePropertyTypes.SupportsAsterisk);
			boolean supportsAsterisk = (asterisk != null && asterisk
					.equals(PropertyReader.ASTERISK));

			if (supportsAsterisk) {
				packager.addNameContent(metadataType, PropertyReader.ASTERISK);
			} else {
				if (folderName.equals(PropertyReader.ROOT_FOLDER)) {
					createFromApi(metadataType, null);
				} else {
					createFromApiFolder(metadataType, folderName);
				}
			}
		}

		// no longer a need to create the package.xml file.
		// packager.createFile(
		// PropertyReader.getSystemProperty("sf.environments.loc")
		// + File.separator + this.environment.getName(),
		// PropertyReader.getSystemProperty("sf.package.file.name"));

		String dir = PropertyReader.getSystemProperty("sf.environments.loc")
				+ File.separator + this.name;

		File dirPath = new File(dir);
		dirPath.mkdir();

		Zipper zipper = new Zipper(this, packager, this.conMan);

		try {
			zipper.retrieveZip();

			// unzipping long enough to compare then delete
			ZipUtils utils = new ZipUtils();
			utils.unzip(this.getRetrieveZip(), this.getLocationFolder());

			this.getRetrieveZip().delete();
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return packager;
	}

	private void createFromApiFolder(String metadataType, String metaFolderName) {
		try {
			ListMetadataQuery query = new ListMetadataQuery();
			query.setType(metaFolderName);

			FileProperties[] lmr = conMan.getMetadataConnection().listMetadata(
					new ListMetadataQuery[] { query }, this.apiVersion);
			if (lmr != null) {
				for (FileProperties n : lmr) {
					createFromApi(metadataType, n.getFullName());
				}
			}
		} catch (ConnectionException ce) {
			ce.printStackTrace();
		}
	}

	private void createFromApi(String metadataType, String folder) {
		try {
			ListMetadataQuery query = new ListMetadataQuery();
			query.setType(metadataType);
			query.setFolder(folder);

			FileProperties[] lmr = conMan.getMetadataConnection().listMetadata(
					new ListMetadataQuery[] { query }, this.apiVersion);
			if (lmr != null) {
				for (FileProperties n : lmr) {
					// commented out because this is not a good solution.
					// if(metadataType.equals("CustomObject") &&
					// !n.getFullName().endsWith("__c")) {
					packager.addNameContent(metadataType, n.getFullName());
					// }
				}
			}
		} catch (ConnectionException ce) {
			ce.printStackTrace();
		}
	}

	/**
	 * This debugging method prints out the contents of the build buffered at
	 * the time.
	 */
	public void printRetreiveChanges() {
		packager.printFile();
	}
}
