import java.io.File;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

public class DestructiveBuilder {

	private Hashtable<String, ArrayList<String>> destructStrings = new Hashtable<String, ArrayList<String>>();
	private File srcDirDeployingTo = null;
	private File srcDirDeployingFrom = null;

	public DestructiveBuilder(String dirDeployingTo, String dirDeployingFrom) {
		srcDirDeployingTo = new File(dirDeployingTo);
		srcDirDeployingFrom = new File(dirDeployingFrom);
	}

	public boolean buildDestructiveChanges(String dirToPlaceXmlFile) {
		boolean successful = false;

		try {
			if (!srcDirDeployingTo.exists()) {
				throw new Exception(
						"Source directory that your deploying to does not exist.");
			}

			if (!srcDirDeployingFrom.exists()) {
				throw new Exception(
						"Source directory that your deploying from does not exist.");
			}

			File destXmlFile = new File(dirToPlaceXmlFile);
			if (!destXmlFile.exists()) {
				throw new Exception(
						"Directory to place destructiveChanges.xml in does not exist.");
			}

			buildXmlFile(destXmlFile.getPath());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return successful;
	}

	private void buildXmlFile(String dirToPlaceXmlFile) {

		ArrayList<String> properties = PropertyReader.getProperties();

		for (String property : properties) {

			// get directory name
			String dirName = PropertyReader.getProperty(property,
					PropertyReader.PropertyTypes.Directory);
			File dirMetadata = new File(srcDirDeployingTo + "/" + dirName);
			if (!dirMetadata.exists()) {
				continue;
			}

			// get metadata type
			String metadataType = PropertyReader.getProperty(property,
					PropertyReader.PropertyTypes.MetadataType);
			if (metadataType == null) {
				continue;
			}

			// get search term
			final String searchTerm = PropertyReader.getProperty(property,
					PropertyReader.PropertyTypes.SeachTerm);
			if (searchTerm == null) {
				continue;
			}

			// determine if supports *
			String asterisk = PropertyReader.getProperty(property,
					PropertyReader.PropertyTypes.SupportsAsterisk);
			boolean supportsAsterisk = (asterisk != null);

			// get some work done
			String deployToPath = srcDirDeployingTo.getPath() + "\\" + dirName;
			if (searchTerm.equals(PropertyReader.FILESEACH)) {

				// check if dirDeployToSrc has files that we need to destroy
				walkAndDestroy(deployToPath, deployToPath, srcDirDeployingFrom
						.getPath(), metadataType, dirName);
			} else {
				seekAndDestroy(deployToPath, deployToPath, srcDirDeployingFrom
						.getPath(), metadataType, dirName, searchTerm);
			}
		}
	}

	// XML level destroys
	private void seekAndDestroy(final String origPath, String toPath,
			String fromPath, String metaType, String dirName, String searchTerm) {

		File root = new File(toPath);
		File[] list = root.listFiles();

		for (File f : list) {
			if (f.isDirectory()) {
				seekAndDestroy(origPath, f.getPath(), fromPath, metaType,
						dirName, searchTerm);
			} else {
				// Compare xml
				File fromFile = new File(f.getPath().replace(
						srcDirDeployingTo.getPath(),
						srcDirDeployingFrom.getPath()));

				if (fromFile.exists() && !fromFile.getName().endsWith(".xml")) {
					ArrayList<String> rets = XmlReader.compareXml(f.getPath(),
							fromFile.getPath(), metaType, searchTerm);
					int count = rets.size();
				}
			}
		}
	}

	// File level destroys
	private void walkAndDestroy(final String origPath, String toPath,
			String fromPath, String metaType, String dirName) {

		File root = new File(toPath);
		File[] list = root.listFiles();

		for (File f : list) {
			if (f.isDirectory()) {
				walkAndDestroy(origPath, f.getPath(), fromPath, metaType,
						dirName);
			} else {
				// check to see if file exists in fromPath
				File fromFile = new File(f.getPath().replace(
						srcDirDeployingTo.getPath(),
						srcDirDeployingFrom.getPath()));
				if (!fromFile.exists() && !fromFile.getName().endsWith(".xml")) {
					if (!destructStrings.containsKey(metaType)) {
						destructStrings.put(metaType, new ArrayList<String>());
					}

					ArrayList<String> destroys = destructStrings.get(metaType);
					destroys.add(f.getPath().replace(origPath + "\\", ""));
				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	public void printDestructiveChanges() {

		Enumeration keys = destructStrings.keys();
		while (keys.hasMoreElements()) {
			Object key = keys.nextElement();
			System.out.println(" Name :" + key + " Member: "
					+ destructStrings.get(key));
		}
	}
}
