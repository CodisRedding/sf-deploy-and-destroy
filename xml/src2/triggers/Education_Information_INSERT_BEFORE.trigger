trigger Education_Information_INSERT_BEFORE on Education_Information__c (before insert) 
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
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to check licensing information for education record.', ex.getMessage());
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
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to check for only one highest education.', ex.getMessage());
    }
    //Raji : 11/16/2011
    //Check for Loacl pastor Licensing
    try
    {
        Handler_Education_Information.CheckForOnlyOneEdLocPastorLicensing(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to check for only one Local Pastor Licensing.', ex.getMessage());
    }
}