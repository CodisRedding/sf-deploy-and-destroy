package destroy;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import system.MetadataEnvironment;
import system.PackageBuilder;
import system.PropertyReader;
import system.ZipUtils;

/**
 * @author rocky
 * 
 *         Manages the generation of a destructive changes file to be included
 *         within a Salesforce deployment package.
 */
public class DestructiveBuilder {

	private PackageBuilder packager = new PackageBuilder();
	private MetadataEnvironment orgTo = null;
	private MetadataEnvironment orgFrom = null;
	private Boolean destroyOnly = false;

	public DestructiveBuilder(MetadataEnvironment orgFrom, MetadataEnvironment orgTo) {
		this.orgTo = orgTo;
		this.orgFrom = orgFrom;
	}

	/**
	 * Provides the packager with formatted destructive changes.
	 * 
	 * @param metaType
	 * 
	 *            The metadata type (2nd property in each line in
	 *            package.properties)
	 * @param component
	 * 
	 *            The metadata component type (3rd property in each line in
	 *            package.properties)
	 * @param objectName
	 * 
	 *            The name of the metadata object that the component is a child
	 *            of. Not all components are children.
	 */
	private void addDestructiveComponents(String metaType, String component,
			String objectName) {

		if (component != null) {

			// don't change the file separator. This is the expected forward
			// slash for the destructiveChanges.xml file.
			component = component.replace('\\', '/');
			component = ((objectName.length() > 0) ? objectName + "." : "")
					+ component;
		}

		packager.addNameContent(metaType, component);
	}

	/**
	 * Makes sure that all needed dirs exist before allowing to start processing
	 * changes file.
	 * 
	 * @param dirToPlaceXmlFile
	 * 
	 *            The path to where the destructiveChanges.xml (default name,
	 *            configurable in config.properties) file will be created.
	 * @return
	 * 
	 *         Returns false if the objects src to dir, or src from dir, or
	 *         passed in param path is missing. Returns false if generation of
	 *         file fails anywhere in the process. Returns true is all paths,
	 *         file generation completes successfully.
	 */
	public boolean buildDestructiveChanges(Boolean destroyOnly) {
		this.destroyOnly = destroyOnly;
		boolean successful = false;

		try {
			if (!orgTo.getSourceFolder().exists()) {
				throw new Exception(
						"Source directory that your deploying to does not exist.");
			}

			if (!orgFrom.getSourceFolder().exists()) {
				throw new Exception(
						"Source directory that your deploying from does not exist.");
			}

			File destXmlFile = new File(orgFrom.getSourceFolder().getPath());
			if (!destXmlFile.exists()) {
				throw new Exception(
						"Directory to place destructiveChanges.xml in does not exist.");
			}

			buildXmlFile(destXmlFile.getPath());
			createDestructiveChangesXmlFile(destXmlFile.getPath());
			ZipUtils zipUtils = new ZipUtils();
			zipUtils.zip(orgFrom.getSourceFolder().getPath(), orgFrom
					.getLocationFolder().getPath(), destroyOnly);

			System.gc();
			doDelete(orgTo.getLocationFolder());
			doDelete(orgFrom.getSourceFolder());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return successful;
	}

	/**
	 * Kicks off the entire search and create file process based on the
	 * package.properties file.
	 * 
	 * @param dirToPlaceXmlFile
	 * 
	 *            Responsible for reading all properties in
	 *            package.properties and parsing each delimited property before
	 *            passing off for further parsing.
	 */
	private void buildXmlFile(String dirToPlaceXmlFile) {

		ArrayList<String> properties = PropertyReader
				.getDestructiveProperties();

		for (String property : properties) {

			// get directory name
			String dirName = PropertyReader.getDestructiveProperty(property,
					PropertyReader.DestructivePropertyTypes.Directory);
			File dirMetadata = new File(orgTo.getSourceFolder().getPath()
					+ File.separator + dirName);
			if (!dirMetadata.exists()) {
				continue;
			}

			// get metadata type
			String metadataType = PropertyReader.getDestructiveProperty(
					property,
					PropertyReader.DestructivePropertyTypes.MetadataType);
			if (metadataType == null) {
				continue;
			}

			// get search term
			final String searchTerm = PropertyReader.getDestructiveProperty(
					property,
					PropertyReader.DestructivePropertyTypes.SearchTerm);
			if (searchTerm == null) {
				continue;
			}

			// get package name
			final String xmlName = PropertyReader.getDestructiveProperty(
					property, PropertyReader.DestructivePropertyTypes.XmlName);

			// get some work done
			String deployToPath = orgTo.getSourceFolder().getPath()
					+ File.separator + dirName;
			if (searchTerm.equals(PropertyReader.FILESEACH)) {

				// check if dirDeployToSrc has files that we need to destroy
				walkAndDestroy(deployToPath, deployToPath, orgFrom
						.getSourceFolder().getPath(), metadataType, dirName,
						metadataType);
			} else {
				seekAndDestroy(deployToPath, deployToPath, orgFrom
						.getSourceFolder().getPath(), xmlName, dirName,
						searchTerm, metadataType);
			}
		}
	}

	/**
	 * @param dir
	 * 
	 *            Calls the packager, passing the dir path to where the packager
	 *            should create the destructiveChanges.xml file.
	 */
	public void createDestructiveChangesXmlFile(String dir) {
		packager.createFile(dir,
				PropertyReader.getSystemProperty("sf.destruct.file.name"), true);
	}

	/**
	 * This debugging method prints out the contents of the destructive changes
	 * buffered at the time.
	 */
	public void printDestructiveChanges() {
		packager.printFile();
	}

	// XML level destroys
	/**
	 * Parses all xml in a given src dir for xml to compare with the deploy from
	 * src xml looking for destructive changes to create.
	 * 
	 * @param origPath
	 * 
	 *            The original path where the metadata type being parsed lives
	 *            in the src dir.
	 * @param toPath
	 * 
	 *            The dir path to the src dir of the Salesforce org to be
	 *            deployed to.
	 * @param fromPath
	 * 
	 *            The dir path to the src dir of the Salesforce org being
	 *            deployed from.
	 * @param metaType
	 * 
	 *            The metadata type (2nd property in each line in
	 *            package.properties) to be parsed for destruction.
	 * @param dirName
	 * 
	 *            The directory name where the metadata type (1st property in
	 *            each line in package.properties) lives in the src dir.
	 * @param searchTerm
	 * 
	 *            This term (4th property in each line in package.properties)
	 *            determines the xml data node name to search for. This is
	 *            usually fullName, but not always.
	 * @param packageName
	 * 
	 *            The metadata type (2nd property in each line in
	 *            package.properties) to be parsed for destruction.
	 */
	private void seekAndDestroy(final String origPath, String toPath,
			String fromPath, String metaType, String dirName,
			String searchTerm, String packageName) {

		File root = new File(toPath);
		File[] list = root.listFiles();

		for (File f : list) {
			if (f.isDirectory()) {
				seekAndDestroy(origPath, f.getPath(), fromPath, metaType,
						dirName, searchTerm, packageName);
			} else {
				// Compare xml
				File fromFile = new File(f.getPath().replace(
						orgTo.getSourceFolder().getPath(),
						orgFrom.getSourceFolder().getPath()));

				if (fromFile.exists() && !fromFile.getName().endsWith(".xml")) {
					ArrayList<String> rets = XmlReader.compareXml(f.getPath(),
							fromFile.getPath(), metaType, searchTerm);

					String name = f.getName();
					name = name.substring(0, name.indexOf('.'));
					for (String component : rets) {
						if (component.indexOf('|') > -1) {
							component = component.replace("|", ".");
						}

						addDestructiveComponents(packageName, component, name);
					}
				}
			}
		}
	}

	// File level destroys
	/**
	 * Parses all xml in a given src dir for xml to compare with the deploy from
	 * src xml looking for destructive changes to create.
	 * 
	 * @param origPath
	 * 
	 *            The original path where the metadata type being parsed lives
	 *            in the src dir.
	 * @param toPath
	 * 
	 *            The dir path to the src dir of the Salesforce org to be
	 *            deployed to.
	 * @param fromPath
	 * 
	 *            The dir path to the src dir of the Salesforce org being
	 *            deployed from.
	 * @param metaType
	 * 
	 *            The metadata type (2nd property in each line in
	 *            package.properties) to be parsed for destruction.
	 * @param dirName
	 * 
	 *            The directory name where the metadata type (1st property in
	 *            each line in package.properties) lives in the src dir.
	 * @param packageName
	 * 
	 *            The metadata type (2nd property in each line in
	 *            package.properties) to be parsed for destruction.
	 */
	private void walkAndDestroy(final String origPath, String toPath,
			String fromPath, String metaType, String dirName, String packageName) {

		File root = new File(toPath);
		File[] list = root.listFiles();

		for (File f : list) {

			if (f.isDirectory()) {
				walkAndDestroy(origPath, f.getPath(), fromPath, metaType,
						dirName, packageName);
			} else {

				// check to see if file exists in fromPath
				File fromFile = new File(f.getPath().replace(
						orgTo.getSourceFolder().getPath(),
						orgFrom.getSourceFolder().getPath()));

				if (!fromFile.exists() && !fromFile.getName().endsWith(".xml")) {

					String component = f.getPath().replace(
							origPath + File.separator, "");

					if (component.indexOf('.') > -1) {
						component = component.substring(0,
								component.indexOf('.'));
					}

					addDestructiveComponents(metaType, component, "");
				}
			}
		}
	}

	public static void doDelete(File path) throws IOException {
		if (path.isDirectory()) {
			for (File child : path.listFiles()) {
				doDelete(child);
			}
		}
		if (!path.delete()) {
			throw new IOException("Could not delete " + path);
		}
	}
}
