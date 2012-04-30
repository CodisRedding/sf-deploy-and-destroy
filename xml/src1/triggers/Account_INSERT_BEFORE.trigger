trigger Account_INSERT_BEFORE on Account (before insert) 
{
        try
        {
            Handler_Account.OrganizationSchoolAffiliation(trigger.new);
            
            UnitTest_Exception_Manager.HandleUnitTestException();
        }
        catch(Exception ex)
        {
            // logging
            Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to associate organization school and affiliation on account.', ex.getMessage());
        }
        
        // Update AC and AJ
        try
        {
            Handler_Account.UpdateACandJDDistrict(trigger.new);
            
            UnitTest_Exception_Manager.HandleUnitTestException();
        }
        catch(Exception ex)
        {
            // logging
            Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to udpate AC and JD on an account.', ex.getMessage());
        }
        
        
}