trigger Account_DELETE_BEFORE on Account (before delete) 
{
    // restrict the GBHEM Constituent account from being deleted.
    try
    {
        Handler_Account.RestrictGBHEMConstitRemove(trigger.old);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logRecordErrors(trigger.oldMap.keySet(), 'ERROR: Unable to restrict GBHEM Constituent account.');
        Util_Logging.logSystemErrors(trigger.oldMap.keySet(), 'ERROR: Unable to restrict GBHEM Constituent account.', ex.getMessage());
    }
}