package system;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

public class GithubEnvironment implements MetadataEnvironment {

	private String name = null;
	private String login = null;
	private String password = null;
	private String repo = null;
	private String organization = null;

	public GithubEnvironment(String name) {

		this.name = name;
		this.login = PropertyReader.getEnviromentProperty(name, "github.login");
		this.password = PropertyReader.getEnviromentProperty(name,
				"github.password");
		this.repo = PropertyReader.getEnviromentProperty(name, "github.repo");
		this.organization = PropertyReader.getEnviromentProperty(name,
				"github.organization");
	}

	@Override
	public String getEnvironment() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getName() {
		// TODO Auto-generated method stub
		return this.name;
	}

	@Override
	public String getLogin() {
		// TODO Auto-generated method stub
		return this.login;
	}

	@Override
	public String getPassword() {
		// TODO Auto-generated method stub
		return this.password;
	}

	@Override
	public String getServer() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public File getLocationFolder() {
		String folderName = PropertyReader.USER_PATH + File.separator
				+ this.name;
		File folder = new File(folderName);

		return folder;
	}

	@Override
	public File getSourceFolder() {
		String folderName = PropertyReader.USER_PATH
				+ File.separator
				+ this.name
				+ File.separator
				+ PropertyReader
						.getSystemProperty("sf.environments.unzip.src.name");
		File folder = new File(folderName);

		return folder;
	}

	public File getRetrieveZip() {
		String zip = PropertyReader.USER_PATH + File.separator + this.name
				+ File.separator
				+ PropertyReader.getSystemProperty("sf.retrieve.zip.file.name");
		File zipFile = new File(zip);

		return zipFile;
	}

	@Override
	public File getDestroyZip() {
		String zip = PropertyReader.USER_PATH + File.separator + this.name
				+ File.separator
				+ PropertyReader.getSystemProperty("sf.destruct.zip.file.name");
		File zipFile = new File(zip);

		return zipFile;
	}

	@Override
	public PackageBuilder retreive() {

		String zipLoc = PropertyReader.USER_PATH + File.separator + this.name
				+ File.separator
				+ PropertyReader.getSystemProperty("sf.retrieve.zip.file.name");

		String url = String.format(
				PropertyReader.getSystemProperty("github.api.zipball"),
				this.login, this.password, this.organization, this.repo);
		url = url.replace("repos//", "repos/");

		System.out.println("### Retrieving " + this.name + " (github) ###");

		DefaultHttpClient httpclient = new DefaultHttpClient();
		File dir = new File(PropertyReader.USER_PATH + File.separator
				+ this.name);
		dir.mkdirs();

		File zipFile = new File(zipLoc);
		try {
			zipFile.createNewFile();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		FileOutputStream os = null;

		try {

			os = new FileOutputStream(zipFile);
			HttpGet httpget = new HttpGet(url);
			HttpResponse response = httpclient.execute(httpget);
			HttpEntity entity = response.getEntity();
			os.write(EntityUtils.toByteArray(entity));
			System.out.println(response.getStatusLine());
			EntityUtils.consume(entity);

			ZipUtils utils = new ZipUtils();
			utils.unzip(zipFile, this.getLocationFolder());

		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {

			try {
				if (os != null) {
					os.flush();
					os.close();
					System.gc();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			// When HttpClient instance is no longer needed,
			// shut down the connection manager to ensure
			// immediate deallocation of all system resources
			httpclient.getConnectionManager().shutdown();
		}

		zipFile.delete();

		File[] zipFiles = this.getLocationFolder().listFiles();

		String destRename = this.getLocationFolder()
				+ File.separator
				+ PropertyReader
						.getSystemProperty("sf.environments.unzip.src.name");
		File renameFile = new File(destRename);
		zipFiles[0].renameTo(renameFile);

		String envSFDir = PropertyReader.getEnviromentProperty(this.name,
				"github.sf.root");
		File srcDir = new File(destRename + File.separator + envSFDir);

		// Rename to tmp
		File tmpFile = new File(destRename + "_tmp");
		srcDir.renameTo(tmpFile);

		// Remove orig
		try {
			destroy.DestructiveBuilder.doDelete(renameFile);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		File finalRenameFile = new File(destRename);
		tmpFile.renameTo(finalRenameFile);

		return null;
	}

	@Override
	public void printRetreiveChanges() {
		// TODO Auto-generated method stub

	}
}
