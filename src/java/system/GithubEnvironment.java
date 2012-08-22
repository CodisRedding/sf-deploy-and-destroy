package system;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.eclipse.egit.github.core.Download;
import org.eclipse.egit.github.core.Repository;
import org.eclipse.egit.github.core.service.DownloadService;
//import org.eclipse.egit.github.core.Repository;
import org.eclipse.egit.github.core.service.RepositoryService;
import org.eclipse.egit.github.core.client.GitHubClient;
import org.eclipse.egit.github.core.event.DownloadPayload;


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
		this.password = PropertyReader.getEnviromentProperty(name, "github.password");
		this.repo = PropertyReader.getEnviromentProperty(name, "github.repo");
		this.organization = PropertyReader.getEnviromentProperty(name, "github.organization");
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
		
		GitHubClient client = new GitHubClient();
		client.setCredentials(this.login, this.password);
		
		RepositoryService service = new RepositoryService(client);
		try {
			Repository rep = service.getRepository(this.organization, this.repo);
			GitHubClient gc = service.getClient();
			DownloadService dls = new DownloadService(gc);
			List<Download> downloads = dls.getDownloads(rep);
			
			
			Repository src = rep.getSource();
			String s = "";
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		/*
		if (!conMan.Login()) {
			System.out.println("Unable to connect.");
			System.exit(1);
		}*/

		System.out.println("### Retrieving " + this.name + " (github) ###");
		
		return null;
	}

	@Override
	public void printRetreiveChanges() {
		// TODO Auto-generated method stub
		
	}

}
