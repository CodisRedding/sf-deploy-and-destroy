trigger Subscription_INSERT_BEFORE on Subscription__c (before insert) 
{
    // check that no other subscription has the same name
    try
    {
        Handler_Subscription.checkUniqueName(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to check for unique subscription name.', ex.getMessage());
    }
}