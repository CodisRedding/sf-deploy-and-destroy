package system;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

import system.ANSIControlCodes;

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

		if (PropertyReader.shouldIgnoreMetadata(metadataName, metadataPath)) {
			System.out.println("Ignored metadataName: " + metadataName + " metadataPath: " + metadataPath);
			return;
		}

		if (!nameContents.containsKey(metadataName)) {
			System.out.println("OK metadataName: " + metadataName + " metadataPath: " + metadataPath);
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
	public void createFile(String dir, String fileName, Boolean includeContent) {

		inspectAndClean();

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

		if (includeContent) {
			while (keys1.hasMoreElements()) {
				Object key = keys1.nextElement();

				content.append("  <types>" + LINE_SEP);
				for (String val : destructNames.get(key)) {
					content.append("    <members>" + val + "</members>"
							+ LINE_SEP);
				}
				content.append("    <name>" + key + "</name>" + LINE_SEP);
				content.append("  </types>" + LINE_SEP);
			}
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

		Boolean printed = false;
		if (names.size() == 0) {
			System.out.println(ANSIControlCodes.BLUE + "No destructable changes.");
			printed = true;
		}

		while (keys1.hasMoreElements()) {
			Object key = keys1.nextElement();

			if (names.get(key).size() > 0) {
				System.out.println(ANSIControlCodes.BLUE + key);
				printed = true;
			}

			for (String name : names.get(key)) {
				System.out.println(ANSIControlCodes.BLUE + "\t" + name);
				printed = true;
			}
			System.out.println("");
		}
		
		if(!printed) {
			System.out.println(ANSIControlCodes.BLUE + "No destructable changes.");
		}
	}

	// First bit of hardcoded-ness that i've encountered so far.
	// TODO: cleanup & refactor
	private void inspectAndClean() {

		ArrayList<String> picklistValues = new ArrayList<String>();

		try {
			// check to make sure picklist values are not set to be destroyed if
			// the
			// whole field is set to be destroyed
			if (getNameContents() != null) {

				if (getNameContents().get("PicklistValue") != null) {
					for (String picklistValue : getNameContents().get(
							"PicklistValue")) {
						Integer idx1 = picklistValue.indexOf(".");
						String field = picklistValue.substring(0,
								picklistValue.indexOf(".", idx1 + 1));

						if (!field.endsWith("__c")) {
							picklistValues.add(picklistValue);
						}

						// check if a custom field with same name exists
						if (getNameContents().get("CustomField") != null) {
							for (String customField : getNameContents().get(
									"CustomField")) {
								if (field.equals(customField)) {
									picklistValues.add(picklistValue);
								}
							}
						}

						// check if a record type with the same name exists
						if (getNameContents().get("RecordType") != null) {
							for (String recordType : getNameContents().get(
									"RecordType")) {
								if (field.equals(recordType)) {
									picklistValues.add(picklistValue);
								}
							}
						}
					}
				}

				if (picklistValues.size() > 0) {
					getNameContents().get("PicklistValue").removeAll(
							picklistValues);
				}
			}
		} catch (Exception e) {
			// nothing...
			// this was rushed .. redo when you're not
			System.out.println(e.getMessage());
		}
	}
}
