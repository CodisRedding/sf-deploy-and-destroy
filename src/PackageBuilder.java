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
	
	public Hashtable<String, ArrayList<String>> getFileContents() {
		return fileContents;
	}
	
	public void addNameContent(String metadataName, String metadataPath) {
		
		if (!nameContents.containsKey(metadataName)) {
			nameContents.put(metadataName, new ArrayList<String>());
		}

		ArrayList<String> destroys = nameContents.get(metadataName);
		destroys.add(metadataPath);
	}
	
	public Hashtable<String, ArrayList<String>> getNameContents() {
		return nameContents;
	}
	
	public void createFile(String dir) {
		
		// TODO: create template later
		StringBuilder content = new StringBuilder();
		
		content.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
		content.append("<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">\n");
		
		Hashtable<String, ArrayList<String>> destructNames = getNameContents();
		Enumeration keys1 = destructNames.keys();
		while (keys1.hasMoreElements()) {
			Object key = keys1.nextElement();
			//System.out.println(key + "  " + destructNames.get(key));
			
			content.append("  <types>\n");
			for(String val : destructNames.get(key)) {
				content.append("    <members>" + val + "</members>\n");
			}
			content.append("    <name>" + key + "</name>\n");
			content.append("  </types>\n");
		}
		
		content.append("  <version>24.0</version>\n");
		content.append("</Package>\n");
		
		Writer out = null;
		
		try {
			out = new OutputStreamWriter(new FileOutputStream(dir + "/destructiveChanges.xml"), "UTF-8");
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
	
	public void printFile() {
		Hashtable<String, ArrayList<String>> destructNames = getNameContents();
		Enumeration keys1 = destructNames.keys();
		while (keys1.hasMoreElements()) {
			Object key = keys1.nextElement();
			System.out.println(key + "  " + destructNames.get(key));
		}
		
		Hashtable<String, ArrayList<String>> destructFiles = getFileContents();
		Enumeration keys2 = destructFiles.keys();
		while (keys2.hasMoreElements()) {
			Object key = keys2.nextElement();
			System.out.println(key + "  " + destructFiles.get(key));
		}
	}
}
