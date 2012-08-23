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

	private PackageBuilder packager = new PackageBuilder();
	private String name = null;
	private String environment = null;
	private String login = null;
	private String password = null;
	private String server = null;
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
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public File getSourceFolder() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public File getDestroyZip() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PackageBuilder retreive() {

		String LINE_SEP = System.getProperty("file.separator");

		String installPath = System.getProperty("user.home") + LINE_SEP
				+ ".sf-deploy-and-destroy";
		
		String zipLoc = installPath
				+ File.separator + this.name + File.separator
				+ PropertyReader.getSystemProperty("sf.retrieve.zip.file.name");

		String url = String.format(
				PropertyReader.getSystemProperty("github.api.zipball"),
				this.login, this.password, this.organization, this.repo);
		url = url.replace("repos//", "repos/");

		System.out.println("### Retrieving " + this.name + " (github) ###");

		DefaultHttpClient httpclient = new DefaultHttpClient();
		File f = new File(zipLoc);
		FileOutputStream os = null;

		try {

			os = new FileOutputStream(f);
			HttpGet httpget = new HttpGet(url);
			HttpResponse response = httpclient.execute(httpget);
			HttpEntity entity = response.getEntity();
			os.write(EntityUtils.toByteArray(entity));
			System.out.println(response.getStatusLine());
			if (entity != null) {
				System.out.println("Response content length: "
						+ entity.getContentLength());
			}

			EntityUtils.consume(entity);
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

		return null;
	}

	@Override
	public void printRetreiveChanges() {
		// TODO Auto-generated method stub

	}
}
