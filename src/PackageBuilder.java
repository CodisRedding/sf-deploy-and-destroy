import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

public class PackageBuilder {

	private Hashtable<String, ArrayList<String>> fileContents = new Hashtable<String, ArrayList<String>>();
	private Hashtable<String, ArrayList<String>> nameContents = new Hashtable<String, ArrayList<String>>();

	public void addFileContent(String packageDirName, String pathAndFile) {

		if (!fileContents.containsKey(packageDirName)) {
			fileContents.put(packageDirName, new ArrayList<String>());
		}

		ArrayList<String> destroys = fileContents.get(packageDirName);
		destroys.add(pathAndFile);
	}

	public void addNameContent(String metadataName, String metadataPath) {

		if (!nameContents.containsKey(metadataName)) {
			nameContents.put(metadataName, new ArrayList<String>());
		}

		ArrayList<String> destroys = nameContents.get(metadataName);
		destroys.add(metadataPath);
	}

	public void createFile(String dir) {

		// TODO: create template later
		StringBuilder content = new StringBuilder();
		String LINE_SEP = System.getProperty("line.separator");

		content.append(String.format("<?xml version=\"%s\" encoding=\""
				+ PropertyReader.getSystemProperty("sf.destruct.file.encoding")
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
		Writer out = null;

		try {
			out = new OutputStreamWriter(
					new FileOutputStream(dir
							+ File.separator
							+ PropertyReader
									.getSystemProperty("sf.destruct.file.name")),
					PropertyReader
							.getSystemProperty("sf.destruct.file.encoding"));
			out.write(content.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				out.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public Hashtable<String, ArrayList<String>> getFileContents() {
		return fileContents;
	}

	public Hashtable<String, ArrayList<String>> getNameContents() {
		return nameContents;
	}

	public void printFile() {
		Hashtable<String, ArrayList<String>> destructNames = getNameContents();
		Enumeration<String> keys1 = destructNames.keys();
		while (keys1.hasMoreElements()) {
			Object key = keys1.nextElement();
			System.out.println(key + "  " + destructNames.get(key));
		}
	}
}
