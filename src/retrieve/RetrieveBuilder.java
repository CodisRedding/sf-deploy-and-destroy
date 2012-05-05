package retrieve;

import java.io.File;
import java.rmi.RemoteException;
import java.util.ArrayList;

import system.PackageBuilder;
import system.PropertyReader;
import api.ConnectionManager;

import com.sforce.soap.metadata.FileProperties;
import com.sforce.soap.metadata.ListMetadataQuery;
import com.sforce.ws.ConnectionException;

public class RetrieveBuilder {

	private ConnectionManager conMan = null;
	private PackageBuilder packager = new PackageBuilder();
	private String environment = null;
	private Double API_VERSION = Double.valueOf(PropertyReader
			.getSystemProperty("sf.api.version"));

	public RetrieveBuilder(String environment) {
		this.environment = environment;

		String username = PropertyReader.getEnviromentProperty(
				this.environment, "sf.login");
		String password = PropertyReader.getEnviromentProperty(
				this.environment, "sf.password");
		String token = PropertyReader.getEnviromentProperty(this.environment,
				"sf.security.token");
		String env = PropertyReader.getEnviromentProperty(this.environment,
				"sf.environment");
		String authEndpoint = PropertyReader
				.getEnvironmentEndpoint(env, "auth");
		String serviceEndpoint = PropertyReader.getEnvironmentEndpoint(env,
				"service");

		conMan = new ConnectionManager(username, password, token, authEndpoint,
				serviceEndpoint);
	}

	public void retreive() {

		ArrayList<String> properties = PropertyReader.getRetrieveProperties();

		conMan.Login();
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
				createFromApiFolder(metadataType, folderName);
			}
		}

		packager.createFile(
				PropertyReader.getSystemProperty("sf.environments.loc")
						+ File.separator + this.environment,
				PropertyReader.getSystemProperty("sf.package.file.name"));
		retrieveFromApi();
		
		Zipper zipper = new Zipper(this.environment, packager, conMan);
		try {
			zipper.retrieveZip();
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

	private void retrieveFromApi() {

	}
}
