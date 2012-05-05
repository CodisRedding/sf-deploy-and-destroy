package api;

import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.metadata.MetadataConnection;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

public class ConnectionManager {

	private EnterpriseConnection entConn = null;
	private MetadataConnection metConn = null;
	private ConnectorConfig config = new ConnectorConfig();

	private String username = null;
	private String password = null;
	private String token = null;
	private String authEndpoint = null;
	private String serviceEndpoint = null;

	public ConnectionManager(String username, String password, String token,
			String authEndpoint, String serviceEndpoint) {
		this.username = username;
		this.password = password;
		this.token = token;
		this.authEndpoint = authEndpoint;
		this.serviceEndpoint = serviceEndpoint;
	}

	public EnterpriseConnection getenterpriseConnection() {
		return this.entConn;
	}

	public MetadataConnection getMetadataConnection() {
		return this.metConn;
	}

	public boolean Login() {

		boolean success = false;

		config.setUsername(username);
		config.setPassword(password + token);
		config.setAuthEndpoint(authEndpoint);

		try {
			entConn = new EnterpriseConnection(config);
			config.setServiceEndpoint(serviceEndpoint);
			metConn = new MetadataConnection(config);

			success = true;
		} catch (ConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return success;
	}
}