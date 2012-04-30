trigger Account_UPDATE_BEFORE on Account (before update) 
{
        // Organization, School and Affiliation
        try
        {
            Handler_Account.OrganizationSchoolAffiliation(Trigger.new);
            
            UnitTest_Exception_Manager.HandleUnitTestException();
        }
        catch(Exception ex)
        {
            // logging
            Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to associate organization school and affiliation on account.');
            Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to associate organization school and affiliation on account.', ex.getMessage());
        }
        
        // Update AC and AJ
        try
        {
            Handler_Account.UpdateACandJDDistrict(Trigger.new);
            
            UnitTest_Exception_Manager.HandleUnitTestException();
        }
        catch(Exception ex)
        {
            // logging
            Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to udpate AC and JD on an account.');
            Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to udpate AC and JD on an account.', ex.getMessage());
        }
        
       
}