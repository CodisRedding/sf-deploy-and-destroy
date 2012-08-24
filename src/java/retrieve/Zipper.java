package retrieve;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;

import system.OrgEnvironment;
import system.PackageBuilder;
import system.PropertyReader;
import api.ConnectionManager;

import com.sforce.soap.metadata.AsyncRequestState;
import com.sforce.soap.metadata.AsyncResult;
import com.sforce.soap.metadata.PackageTypeMembers;
import com.sforce.soap.metadata.RetrieveMessage;
import com.sforce.soap.metadata.RetrieveRequest;
import com.sforce.soap.metadata.RetrieveResult;

public class Zipper {

	private static final long ONE_SECOND = 1000;
	private static final int MAX_NUM_POLL_REQUESTS = Integer
			.valueOf(PropertyReader
					.getSystemProperty("sf.retrieve.max.num.poll.requests"));
	private OrgEnvironment environment = null;
	private static ConnectionManager conMan = null;
	private PackageBuilder packager = null;
	private static final Double API_VERSION = Double.valueOf(PropertyReader
			.getSystemProperty("sf.api.version"));
	static BufferedReader rdr = new BufferedReader(new InputStreamReader(
			System.in));

	public Zipper(OrgEnvironment environment, PackageBuilder packager,
			ConnectionManager connectionManager) {
		this.environment = environment;
		this.packager = packager;
		conMan = connectionManager;
	}

	public Zipper(OrgEnvironment environment, PackageBuilder packager) {
		this.environment = environment;
		this.packager = packager;

		String username = this.environment.getLogin();
		String password = this.environment.getPassword();
		String token = this.environment.getToken();
		String authEndpoint = this.environment.getAuthEndpoint();
		String serviceEndpoint = this.environment.getServiceEndpoint();

		conMan = new ConnectionManager(username, password, token, authEndpoint,
				serviceEndpoint);
	}

	public void retrieveZip() throws RemoteException, Exception {

		RetrieveRequest retrieveRequest = new RetrieveRequest();
		retrieveRequest.setApiVersion(API_VERSION);

		com.sforce.soap.metadata.Package pack = parsePackage();
		retrieveRequest.setUnpackaged(pack);

		if (conMan.getMetadataConnection() == null) {

			System.out.println("Connection is closed");
			System.exit(1);
		}

		// retrieveRequest.setPackageNames(new String[] { "Conga Composer",
		// "Report Engine",
		// "ExactTarget for AppExchange - Fall 2007 (11/5/2007)",
		// "Relationships", "Find Nearby", "Mass Update And Edit",
		// "Mass Update Contacts 2.0" });
		AsyncResult asyncResult = conMan.getMetadataConnection().retrieve(
				retrieveRequest);

		// Wait for the retrieve to complete
		int poll = 0;
		long waitTimeMilliSecs = ONE_SECOND;
		while (!asyncResult.isDone()) {
			Thread.sleep(waitTimeMilliSecs);
			// double the wait time for the next iteration

			waitTimeMilliSecs *= 2;
			if (poll++ > MAX_NUM_POLL_REQUESTS) {
				throw new Exception(
						"Request timed out.  If this is a large set "
								+ "of metadata components, check that the time allowed "
								+ "by MAX_NUM_POLL_REQUESTS is sufficient.");
			}
			asyncResult = conMan.getMetadataConnection().checkStatus(
					new String[] { asyncResult.getId() })[0];
			System.out.println("Status is: " + asyncResult.getState());
		}

		if (asyncResult.getState() != AsyncRequestState.Completed) {
			throw new Exception(asyncResult.getStatusCode() + " msg: "
					+ asyncResult.getMessage());
		}

		RetrieveResult result = conMan.getMetadataConnection()
				.checkRetrieveStatus(asyncResult.getId());

		// Print out any warning messages
		StringBuilder buf = new StringBuilder();
		if (result.getMessages() != null) {
			for (RetrieveMessage rm : result.getMessages()) {
				buf.append(rm.getFileName() + " - " + rm.getProblem());
			}
		}
		if (buf.length() > 0) {
			System.out.println("Retrieve warnings:\n" + buf);
		}

		// Write the zip to the file system
		// System.out.println("Writing results to zip file");
		ByteArrayInputStream bais = new ByteArrayInputStream(
				result.getZipFile());


		String zipLoc = PropertyReader.USER_PATH + File.separator
				+ this.environment.getName() + File.separator
				+ PropertyReader.getSystemProperty("sf.retrieve.zip.file.name");

		File resultsFile = new File(zipLoc);
		FileOutputStream os = new FileOutputStream(resultsFile);
		try {
			ReadableByteChannel src = Channels.newChannel(bais);
			FileChannel dest = os.getChannel();
			copy(src, dest);

		} finally {
			os.close();
		}

	}

	/**
	 * Helper method to copy from a readable channel to a writable channel,
	 * using an in-memory buffer.
	 */
	private void copy(ReadableByteChannel src, WritableByteChannel dest)
			throws IOException {
		// use an in-memory byte buffer

		ByteBuffer buffer = ByteBuffer.allocate(8092);
		while (src.read(buffer) != -1) {
			buffer.flip();
			while (buffer.hasRemaining()) {
				dest.write(buffer);
			}
			buffer.clear();
		}
	}

	private com.sforce.soap.metadata.Package parsePackage() {

		List<PackageTypeMembers> packageTypesHolder = new ArrayList<PackageTypeMembers>();
		Hashtable<String, ArrayList<String>> contents = packager
				.getNameContents();

		Enumeration<String> keys = contents.keys();
		while (keys.hasMoreElements()) {
			Object key = keys.nextElement();

			PackageTypeMembers packageTypeMembers = new PackageTypeMembers();
			packageTypeMembers.setName(String.valueOf(key));
			String[] mems = contents.get(key).toArray(new String[0]);
			packageTypeMembers.setMembers(mems);

			packageTypesHolder.add(packageTypeMembers);
		}

		com.sforce.soap.metadata.Package pack = new com.sforce.soap.metadata.Package();
		pack.setTypes(packageTypesHolder
				.toArray(new PackageTypeMembers[packageTypesHolder.size()]));
		pack.setVersion(String.valueOf(API_VERSION));

		return pack;
	}
}
