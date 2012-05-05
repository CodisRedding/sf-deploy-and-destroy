package system;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

/**
 * @author rocky
 * 
 *         Builds the actual destructiveChanges.xml file.
 * 
 */
public class PackageBuilder {

	private Hashtable<String, ArrayList<String>> nameContents = new Hashtable<String, ArrayList<String>>();

	/**
	 * Adds supplied params to the buffer of metadata to build.
	 * 
	 * @param metadataName
	 * 
	 *            The metadata name of the component being built.
	 * @param metadataPath
	 * 
	 *            The path and component name to be built.
	 */
	public void addNameContent(String metadataName, String metadataPath) {

		if (!nameContents.containsKey(metadataName)) {
			nameContents.put(metadataName, new ArrayList<String>());
		}

		ArrayList<String> builds = nameContents.get(metadataName);
		builds.add(metadataPath);
	}

	/**
	 * Generates the *.xml. If no changes are found, a file is still created and
	 * is still safe to deploy within your deployment package.
	 * 
	 * @param dir
	 * 
	 *            The dir path where the generated *.xml should be created.
	 */
	public void createFile(String dir, String fileName) {

		// TODO: create template later
		StringBuilder content = new StringBuilder();
		String LINE_SEP = System.getProperty("line.separator");

		content.append(String.format("<?xml version=\"%s\" encoding=\""
				+ PropertyReader.getSystemProperty("sf.package.file.encoding")
				+ "\"?>" + LINE_SEP,
				PropertyReader.getSystemProperty("sf.package.xml.version")));
		content.append(String.format("<Package xmlns=\"%s\">" + LINE_SEP,
				PropertyReader.getSystemProperty("sf.package.namespace")));

		Hashtable<String, ArrayList<String>> destructNames = getNameContents();
		Enumeration<String> keys1 = destructNames.keys();
		while (keys1.hasMoreElements()) {
			Object key = keys1.nextElement();

			content.append("  <types>" + LINE_SEP);
			for (String val : destructNames.get(key)) {
				content.append("    <members>" + val + "</members>" + LINE_SEP);
			}
			content.append("    <name>" + key + "</name>" + LINE_SEP);
			content.append("  </types>" + LINE_SEP);
		}

		content.append(String.format("  <version>%s</version>" + LINE_SEP,
				PropertyReader.getSystemProperty("sf.api.version")));
		content.append("</Package>" + LINE_SEP);

		// eek! help
		// TODO: clean this up
		Writer out = null;

		// make the dir if it doesn't exist
		File dirPath = new File(dir);
		dirPath.mkdir();

		try {
			out = new OutputStreamWriter(new FileOutputStream(dir
					+ File.separator + fileName),
					PropertyReader
							.getSystemProperty("sf.package.file.encoding"));
			out.write(content.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				out.close();
			} catch (IOException e) {
				// TODO catch block
				e.printStackTrace();
			}
		}
	}

	/**
	 * Gets the buffer of package components to be built.
	 * 
	 * @return
	 * 
	 *         The package components to be built.
	 */
	public Hashtable<String, ArrayList<String>> getNameContents() {
		return nameContents;
	}

	/**
	 * Prints out the package components to be built.
	 */
	public void printFile() {
		Hashtable<String, ArrayList<String>> names = getNameContents();
		Enumeration<String> keys1 = names.keys();
		while (keys1.hasMoreElements()) {
			Object key = keys1.nextElement();
			System.out.println(key);

			for (String name : names.get(key)) {
				System.out.println("\t" + name);
			}
			System.out.println("");
		}
	}
}
