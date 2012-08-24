package system;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class Installer {
	
	public Installer() { }
	
	public void install(Boolean verbose) {

		Boolean reset = true;

		String envPath = PropertyReader.USER_PATH + File.separator + "environments";

		File installDir = new File(PropertyReader.USER_PATH);
		if (!installDir.exists()) {
			installDir.mkdir();
		}

		File installEnvDir = new File(envPath);
		if (!installEnvDir.exists()) {
			installEnvDir.mkdir();
		}

		String[] configFileNames = { "destroy.properties", "config.properties",
				"package.properties", "environment.ignore",
				"github-example-dev.env", "salesforce-example-dev.env" };

		for (String configFileName : configFileNames) {

			String filePathAndName = null;

			if (configFileName.endsWith(".env")) {
				filePathAndName = envPath + File.separator + configFileName;
			} else {
				filePathAndName = PropertyReader.USER_PATH + File.separator + configFileName;
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
						System.out.println("Created configuration file: "
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
	}
}
