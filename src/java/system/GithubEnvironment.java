package system;

import java.io.File;
import java.io.IOException;

//import org.eclipse.egit.github.core.Repository;
import org.eclipse.egit.github.core.service.RepositoryService;
import org.eclipse.egit.github.core.client.GitHubClient;


public class GithubEnvironment implements MetadataEnvironment {
	
	private PackageBuilder packager = new PackageBuilder();
	private String name = null;
	private String environment = null;
	private String login = null;
	private String password = null;
	private String server = null;
	private String repo = null;
	
	public GithubEnvironment(String name) {
		
		this.name = name;
		this.login = PropertyReader.getEnviromentProperty(name, "github.login");
		this.password = PropertyReader.getEnviromentProperty(name, "github.password");
		this.repo = PropertyReader.getEnviromentProperty(name, "github.repo");
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
		/*
		
		try {
			for (Repository repo : service.getRepositories(this.login)) {
				  System.out.println(repo.getName() + " Watchers: " + repo.getWatchers());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
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
