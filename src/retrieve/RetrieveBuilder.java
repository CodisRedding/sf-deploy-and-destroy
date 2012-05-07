package retrieve;

import java.io.File;
import java.rmi.RemoteException;
import java.util.ArrayList;

import system.OrgEnvironment;
import system.PackageBuilder;
import system.PropertyReader;
import system.ZipUtils;
import api.ConnectionManager;

import com.sforce.soap.metadata.FileProperties;
import com.sforce.soap.metadata.ListMetadataQuery;
import com.sforce.ws.ConnectionException;

public class RetrieveBuilder {

	private ConnectionManager conMan = null;
	private PackageBuilder packager = new PackageBuilder();
	private OrgEnvironment environment = null;
	private Double API_VERSION = Double.valueOf(PropertyReader
			.getSystemProperty("sf.api.version"));

	public RetrieveBuilder(OrgEnvironment environment) {
		this.environment = environment;

		String username = this.environment.getLogin();
		String password = this.environment.getPassword();
		String token = this.environment.getToken();
		String authEndpoint = this.environment.getAuthEndpoint();
		String serviceEndpoint = this.environment.getServiceEndpoint();

		conMan = new ConnectionManager(username, password, token, authEndpoint,
				serviceEndpoint);
	}

	public void retreive() {

		ArrayList<String> properties = PropertyReader.getRetrieveProperties();

		if(!conMan.Login()) {
			System.out.println("Unable to connect.");
			System.exit(1);
		}

		System.out.println("### Retrieving " + environment.getName() + " ###");
		
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
				if(folderName.equals(PropertyReader.ROOT_FOLDER)) {
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
				+ File.separator + this.environment.getName();
		
		File dirPath = new File(dir);
		dirPath.mkdir();

		Zipper zipper = new Zipper(this.environment, packager, conMan);

		try {
			zipper.retrieveZip();

			// unzipping long enough to compare then delete
			ZipUtils utils = new ZipUtils();
			utils.unzip(this.environment.getRetrieveZip(),
					this.environment.getLocationFolder());
			
			this.environment.getRetrieveZip().delete();
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void createFromApiFolder(String metadataType, String metaFolderName) {
		try {
			ListMetadataQuery query = new ListMetadataQuery();
			query.setType(metaFolderName);

			FileProperties[] lmr = conMan.getMetadataConnection().listMetadata(
					new ListMetadataQuery[] { query }, API_VERSION);
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
					new ListMetadataQuery[] { query }, API_VERSION);
			if (lmr != null) {
				for (FileProperties n : lmr) {
					packager.addNameContent(metadataType, n.getFullName());
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
