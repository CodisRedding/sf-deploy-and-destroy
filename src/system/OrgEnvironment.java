package system;

import java.io.File;

public class OrgEnvironment {

	private String name = null;
	private String environment = null;
	private String login = null;
	private String password = null;
	private String token = null;
	private boolean includePackages = false;
	private String authEndpoint = null;
	private String serviceEndpoint = null;
	private String server = null;

	public OrgEnvironment(String name) {

		// This soon needs to be changed to api version per org, not system wide
		Double apiVersion = Double.valueOf(PropertyReader
				.getSystemProperty("sf.api.version"));

		this.name = name;
		this.login = PropertyReader.getEnviromentProperty(name, "sf.login");
		this.password = PropertyReader.getEnviromentProperty(name,
				"sf.password");
		this.token = PropertyReader.getEnviromentProperty(name,
				"sf.security.token");
		this.environment = PropertyReader.getEnviromentProperty(name,
				"sf.environment");
		this.server = PropertyReader.getEnviromentProperty(name,
				"sf.environment.server");
		this.authEndpoint = PropertyReader.getEnvironmentEndpoint(
				this.environment, "auth", this.server, apiVersion);
		this.serviceEndpoint = PropertyReader.getEnvironmentEndpoint(
				this.environment, "service", this.server, apiVersion);

	}

	public String getEnvironment() {
		return environment;
	}

	public String getAuthEndpoint() {
		return authEndpoint;
	}

	public String getName() {
		return name;
	}

	public String getServiceEndpoint() {
		return serviceEndpoint;
	}

	public String getLogin() {
		return login;
	}

	public String getPassword() {
		return password;
	}

	public String getToken() {
		return token;
	}

	public boolean isIncludePackages() {
		return includePackages;
	}

	public String getServer() {
		return server;
	}

	public File getLocationFolder() {
		String folderName = PropertyReader
				.getSystemProperty("sf.environments.loc") + this.name;
		File folder = new File(folderName);

		return folder;
	}

	public File getSourceFolder() {
		String folderName = PropertyReader
				.getSystemProperty("sf.environments.loc")
				+ this.name
				+ File.separator
				+ PropertyReader
						.getSystemProperty("sf.environments.unzip.src.name");
		File folder = new File(folderName);

		return folder;
	}

	public File getRetrieveZip() {
		String zip = PropertyReader.getSystemProperty("sf.environments.loc")
				+ this.name + File.separator
				+ PropertyReader.getSystemProperty("sf.retrieve.zip.file.name");
		File zipFile = new File(zip);

		return zipFile;
	}
}
