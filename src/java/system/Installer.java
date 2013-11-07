package system;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import system.ANSIControlCodes;

public class Installer {

	public static final String installPath = PropertyReader.USER_PATH + File.separator
			+ "environments";

	public Installer() {
	}

	public void install(Boolean verbose) {

		System.out.println(ANSIControlCodes.GREEN + "Installing...");
		System.out.println("\n");

		Boolean reset = true;

		File installDir = new File(PropertyReader.USER_PATH);
		if (!installDir.exists()) {
			installDir.mkdir();
		}

		File installEnvDir = new File(installPath);
		if (!installEnvDir.exists()) {
			installEnvDir.mkdir();
		}

		String[] configFileNames = { "destroy.properties", "config.properties",
				"package.properties", "environment.ignore",
				"github-example.env", "salesforce-example.env" };

		for (String configFileName : configFileNames) {

			String filePathAndName = null;

			if (configFileName.endsWith(".env")) {
				filePathAndName = installPath + File.separator + configFileName;
			} else {
				filePathAndName = PropertyReader.USER_PATH + File.separator
						+ configFileName;
			}

			File propFile = new File(filePathAndName);

			if (!propFile.exists() || reset) {

				InputStream jarPropFile = Thread.currentThread()
						.getContextClassLoader()
						.getResourceAsStream(configFileName);

				OutputStream out = null;
				try {
					out = new FileOutputStream(propFile);
					byte buf[] = new byte[1024];
					int len;
					while ((len = jarPropFile.read(buf)) > 0) {
						out.write(buf, 0, len);
					}

					if (verbose) {
						System.out.println(ANSIControlCodes.GREEN + "Created configuration file: "
								+ filePathAndName);
					}

					// these functions also throw IOExceptions... didn't want to
					// nest try/catches
					// come up with better approach. Didn't want this function
					// to throw error either
					out.close();
					jarPropFile.close();
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}

		System.out.println(ANSIControlCodes.GREEN + "Complete!");
		System.out.println("***************************************************");
		System.out.println("Go configure your environments here " + installPath);
		System.out.println("***************************************************");
	}
}
