package system;

import java.io.File;

public interface MetadataEnvironment {
	
	public Double apiVersion = Double.valueOf(PropertyReader
			.getSystemProperty("sf.api.version"));

	public abstract String getEnvironment();

	public abstract String getName();

	public abstract String getLogin();

	public abstract String getPassword();

	public abstract String getServer();

	public abstract File getLocationFolder();

	public abstract File getSourceFolder();

	public abstract File getDestroyZip();
	
	public abstract PackageBuilder retreive();
	
	public abstract void printRetreiveChanges();

}
