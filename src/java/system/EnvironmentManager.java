package system;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public class EnvironmentManager {

	private MetadataEnvironment fromEnv = null;
	private MetadataEnvironment toEnv = null;

	public EnvironmentManager(MetadataEnvironment fromEnv,
			MetadataEnvironment toEnv) {
		this.fromEnv = fromEnv;
		this.toEnv = toEnv;
	}

	public MetadataEnvironment getFromEnvironment() {
		return this.fromEnv;
	}

	public MetadataEnvironment getToEnvironment() {
		return this.toEnv;
	}

	public static MetadataEnvironment createEnvironment(String name) {

		MetadataEnvironment env = null;
		Constructor con = null;
		String classTypeKey = PropertyReader
				.getEnviromentProperty(name, "type");
		String className = PropertyReader.getSourceProperty(classTypeKey);

		try {
			con = Class.forName(className).getConstructor(String.class);
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		try {
			env = (MetadataEnvironment) con.newInstance(name);
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return env;
	}
}
