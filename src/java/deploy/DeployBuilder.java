package deploy;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;

import system.OrgEnvironment;
import system.PropertyReader;
import api.ConnectionManager;

import com.sforce.soap.metadata.AsyncRequestState;
import com.sforce.soap.metadata.AsyncResult;
import com.sforce.soap.metadata.CodeCoverageWarning;
import com.sforce.soap.metadata.DeployMessage;
import com.sforce.soap.metadata.DeployOptions;
import com.sforce.soap.metadata.DeployResult;
import com.sforce.soap.metadata.RunTestFailure;
import com.sforce.soap.metadata.RunTestsResult;
	
public class DeployBuilder {

	private static final long ONE_SECOND = 1000;
	private static final int MAX_NUM_POLL_REQUESTS = Integer
			.valueOf(PropertyReader
					.getSystemProperty("sf.retrieve.max.num.poll.requests"));
	private ConnectionManager conMan = null;
	private OrgEnvironment orgFrom = null;
	private OrgEnvironment orgTo = null;

	public DeployBuilder(OrgEnvironment orgFrom, OrgEnvironment orgTo) {
		this.orgFrom = orgFrom;
		this.orgTo = orgTo;

		// set creds to the org we're deploying to
		String username = this.orgTo.getLogin();
		String password = this.orgTo.getPassword();
		String token = this.orgTo.getToken();
		String authEndpoint = this.orgTo.getAuthEndpoint();
		String serviceEndpoint = this.orgTo.getServiceEndpoint();

		conMan = new ConnectionManager(username, password, token, authEndpoint,
				serviceEndpoint);
	}

	public void deploy() {

		if (!conMan.Login()) {
			System.out.println("Unable to connect.");
			System.exit(1);
		}

		try {
			byte zipBytes[] = readZipFile();
			
			DeployOptions deployOptions = new DeployOptions();
			deployOptions.setPerformRetrieve(false);
			deployOptions.setRollbackOnError(true);
			deployOptions.setSinglePackage(true);
			deployOptions.setPurgeOnDelete(orgTo.getEnvironment().toLowerCase().equals(PropertyReader.PRODUCTION_ENV) ? false : true);
			
			AsyncResult asyncResult = conMan.getMetadataConnection().deploy(
					zipBytes, deployOptions);
			// Wait for the deploy to complete
			int poll = 0;
			long waitTimeMilliSecs = ONE_SECOND;
			while (!asyncResult.isDone()) {
				Thread.sleep(waitTimeMilliSecs);
				// double the wait time for the next iteration
				waitTimeMilliSecs *= 2;
				if (poll++ > MAX_NUM_POLL_REQUESTS) {
					throw new Exception(
							"Request timed out. If this is a large set "
									+ "of metadata components, check that the time allowed by "
									+ "MAX_NUM_POLL_REQUESTS is sufficient.");
				}
				asyncResult = conMan.getMetadataConnection().checkStatus(
						new String[] { asyncResult.getId() })[0];
				System.out.println("Status is: " + asyncResult.getState());
			}
			if (asyncResult.getState() != AsyncRequestState.Completed) {
				throw new Exception(asyncResult.getStatusCode() + " msg: "
						+ asyncResult.getMessage());
			}
			DeployResult result = conMan.getMetadataConnection()
					.checkDeployStatus(asyncResult.getId());
			if (!result.isSuccess()) {
				printErrors(result);
				throw new Exception("The files were not successfully deployed");
			}
			System.out.println("The file " + orgFrom.getDestroyZip().getPath()
					+ " was successfully deployed");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void printErrors(DeployResult result) {
		DeployMessage messages[] = result.getMessages();
		StringBuilder buf = new StringBuilder("Failures:\n");
		for (DeployMessage message : messages) {
			if (!message.isSuccess()) {
				String loc = (message.getLineNumber() < 0 ? "" : ("("
						+ message.getLineNumber() + ","
						+ message.getColumnNumber() + ")"));
				if (loc.length() == 0
						&& !message.getFileName().equals(message.getFullName())) {
					loc = "(" + message.getFullName() + ")";
				}
				buf.append(
						message.getFileName() + loc + ":"
								+ message.getProblem()).append('\n');
			}
		}
		RunTestsResult rtr = result.getRunTestResult();
		if (rtr.getFailures() != null) {
			for (RunTestFailure failure : rtr.getFailures()) {
				String n = (failure.getNamespace() == null ? "" : (failure
						.getNamespace() + ".")) + failure.getName();
				buf.append("Test failure, method: " + n + "."
						+ failure.getMethodName() + " -- "
						+ failure.getMessage() + " stack "
						+ failure.getStackTrace() + "\n\n");
			}
		}
		if (rtr.getCodeCoverageWarnings() != null) {
			for (CodeCoverageWarning ccw : rtr.getCodeCoverageWarnings()) {
				buf.append("Code coverage issue");
				if (ccw.getName() != null) {
					String n = (ccw.getNamespace() == null ? "" : (ccw
							.getNamespace() + ".")) + ccw.getName();
					buf.append(", class: " + n);
				}
				buf.append(" -- " + ccw.getMessage() + "\n");
			}
		}
		System.out.println(buf.toString());
	}

	private byte[] readZipFile() throws Exception {
		// We assume here that you have a deploy.zip file.
		// See the retrieve sample for how to retrieve a zip file.
		File deployZip = new File(orgFrom.getDestroyZip().getPath());
		if (!deployZip.exists() || !deployZip.isFile())
			throw new Exception(
					"Cannot find the zip file to deploy. Looking for "
							+ deployZip.getAbsolutePath());
		FileInputStream fos = new FileInputStream(deployZip);
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		int readbyte = -1;
		while ((readbyte = fos.read()) != -1) {
			bos.write(readbyte);
		}
		fos.close();
		bos.close();
		return bos.toByteArray();
	}
}
