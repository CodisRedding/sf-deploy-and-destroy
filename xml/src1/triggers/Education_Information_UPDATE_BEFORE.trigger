trigger Education_Information_UPDATE_BEFORE on Education_Information__c (before update) 
{
	// update licensing info
	try
	{
		Handler_Education_Information.CheckLicensingProgram(trigger.new);
		
		UnitTest_Exception_Manager.HandleUnitTestException();
	}
	catch(Exception ex)
	{
		// logging
		Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to check licensing information for education record.');
		Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to check licensing information for education record.', ex.getMessage());
	}
	
	// check for only one licensing info
	try
	{
		Handler_Education_Information.CheckForOnlyOneEducationRec(trigger.new);
		
		UnitTest_Exception_Manager.HandleUnitTestException();
	}
	catch(Exception ex)
	{
		// logging
		Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to check for only one highest education.');
		Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to check for only one highest education.', ex.getMessage());
	}
}