package system;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;

public class ZipUtils {

	List<String> fs = new ArrayList<String>();

	public void unzip(File archive, File outputDir) {
		try {
			ZipFile zipfile = new ZipFile(archive);
			for (Enumeration e = zipfile.entries(); e.hasMoreElements();) {
				ZipEntry entry = (ZipEntry) e.nextElement();
				unzipEntry(zipfile, entry, outputDir);
			}
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

	public void zip(String sourceFolder, String folderToZipTo, Boolean destroyOnly) {

		byte[] buffer = new byte[1024];

		try {

			FileOutputStream fos = new FileOutputStream(
					folderToZipTo
							+ File.separator
							+ PropertyReader
									.getSystemProperty("sf.destruct.zip.file.name"));
			ZipOutputStream zos = new ZipOutputStream(fos);

			for (String file : generateFileList(new File(sourceFolder),
					new File(sourceFolder).getAbsolutePath(), destroyOnly)) {

				ZipEntry ze = new ZipEntry(file);
				zos.putNextEntry(ze);

				FileInputStream in = new FileInputStream(sourceFolder
						+ File.separator + file);

				int len;
				while ((len = in.read(buffer)) > 0) {
					zos.write(buffer, 0, len);
				}

				in.close();
			}

			zos.closeEntry();
			zos.close();

			System.out.println("Done");
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

	public List<String> generateFileList(File node, String sourceFolder, Boolean destroyOnly) {

		// add file only
		if (node.isFile()) {
			if(destroyOnly) {
				if(node.getName().equals(PropertyReader.getSystemProperty("sf.destruct.file.name")) ||
						node.getName().equals(PropertyReader.getSystemProperty("sf.package.file.name"))) {
					
					if(node.getName().equals(PropertyReader.getSystemProperty("sf.package.file.name"))) {
						PackageBuilder builder = new PackageBuilder();
						builder.createFile(sourceFolder, node.getName(), false);
					}
					fs.add(generateZipEntry(node.getAbsoluteFile().toString(),
							sourceFolder));
				}
			} else {
				fs.add(generateZipEntry(node.getAbsoluteFile().toString(),
						sourceFolder));
			}
		}

		if (node.isDirectory()) {
			String[] subNote = node.list();
			for (String filename : subNote) {
				generateFileList(new File(node, filename), sourceFolder, destroyOnly);
			}
		}

		return fs;
	}

	private String generateZipEntry(String file, String sourceFolder) {
		return file.substring(sourceFolder.length() + 1, file.length());
	}

	private void unzipEntry(ZipFile zipfile, ZipEntry entry, File outputDir)
			throws IOException {

		if (entry.isDirectory()) {
			createDir(new File(outputDir, entry.getName()));
			return;
		}

		File outputFile = new File(outputDir, entry.getName());
		if (!outputFile.getParentFile().exists()) {
			createDir(outputFile.getParentFile());
		}

		BufferedInputStream inputStream = new BufferedInputStream(
				zipfile.getInputStream(entry));
		BufferedOutputStream outputStream = new BufferedOutputStream(
				new FileOutputStream(outputFile));

		try {
			IOUtils.copy(inputStream, outputStream);
		} finally {
			outputStream.close();
			inputStream.close();
		}
	}

	private void createDir(File dir) {
		if (!dir.mkdirs())
			throw new RuntimeException("Can not create dir " + dir);
	}
}