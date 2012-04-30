import java.io.File;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

public class DestructiveBuilder {

<<<<<<< HEAD
	//private Hashtable<String, ArrayList<String>> destructStrings = new Hashtable<String, ArrayList<String>>();
	private PackageBuilder packager = new PackageBuilder();
=======
	private Hashtable<String, ArrayList<String>> destructStrings = new Hashtable<String, ArrayList<String>>();
>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
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
<<<<<<< HEAD
			createDestructiveChangesXmlFile(destXmlFile.getPath());
=======
>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
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
					PropertyReader.PropertyTypes.SearchTerm);
			if (searchTerm == null) {
				continue;
			}
			
			// get package name
			final String xmlName = PropertyReader.getProperty(property,
					PropertyReader.PropertyTypes.XmlName);
			if (xmlName == null) {
				//continue;
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
						.getPath(), metadataType, dirName, metadataType);
			} else {
				seekAndDestroy(deployToPath, deployToPath, srcDirDeployingFrom
						.getPath(), xmlName, dirName, searchTerm, metadataType);
			}
		}
	}

	// XML level destroys
	private void seekAndDestroy(final String origPath, String toPath,
			String fromPath, String metaType, String dirName, String searchTerm, String packageName) {

		File root = new File(toPath);
		File[] list = root.listFiles();

		for (File f : list) {
			if (f.isDirectory()) {
				seekAndDestroy(origPath, f.getPath(), fromPath, metaType,
						dirName, searchTerm, packageName);
			} else {
				// Compare xml
				File fromFile = new File(f.getPath().replace(
						srcDirDeployingTo.getPath(),
						srcDirDeployingFrom.getPath()));

				if (fromFile.exists() && !fromFile.getName().endsWith(".xml")) {
					ArrayList<String> rets = XmlReader.compareXml(f.getPath(),
							fromFile.getPath(), metaType, searchTerm);

					String name = f.getName();
					name = name.substring(0, name.indexOf('.'));
					for(String component : rets) {
						addDestructiveComponents(packageName, component, name);
					}
				}
			}
		}
	}

	// File level destroys
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
						srcDirDeployingTo.getPath(),
						srcDirDeployingFrom.getPath()));
				
<<<<<<< HEAD
				/*
=======
>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
				if (!fromFile.exists() && !fromFile.getName().endsWith(".xml")) {
					String component = f.getPath().replace(origPath + "\\", "");
					addDestructiveComponents(metaType, component, "");
				}
<<<<<<< HEAD
				*/
				
				if (!fromFile.exists()) {
					
					if(!fromFile.getName().endsWith(".xml")) {
						String component = f.getPath().replace(origPath + "\\", "");
						addDestructiveComponents(metaType, component, "");
					}
					
					packager.addFileContent(metaType, f.getPath());
				}
=======
>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
			}
		}
	}
	
	private void addDestructiveComponents(String metaType, String component, String objectName) {
		
		if(component.indexOf('.') > -1) {
			component = component.substring(0, component.indexOf('.'));
		}
		
		component = component.replace('\\', '/');
		component = ((objectName.length() > 0) ? objectName + "." : "") + component;
		
<<<<<<< HEAD
		/*
=======
>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
		if (!destructStrings.containsKey(metaType)) {
			destructStrings.put(metaType, new ArrayList<String>());
		}

		ArrayList<String> destroys = destructStrings.get(metaType);
		destroys.add(component);
<<<<<<< HEAD
		*/
		
		packager.addNameContent(metaType, component);
	}

	/*
=======
	}

>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
	@SuppressWarnings("unchecked")
	public void printDestructiveChanges() {

		Enumeration keys = destructStrings.keys();
		while (keys.hasMoreElements()) {
			Object key = keys.nextElement();
			System.out.println(key + "  " + destructStrings.get(key));
		}
	}
<<<<<<< HEAD
	*/
	
	public void printDestructiveChanges() {
		packager.printFile();
	}
	
	public void createDestructiveChangesXmlFile(String dir) {
		packager.createFile(dir);
	}
=======
>>>>>>> 83234ffa27066021e0be5004bba801e44071a994
}
