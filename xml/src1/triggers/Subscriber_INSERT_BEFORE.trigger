trigger Subscriber_INSERT_BEFORE on Subscriber__c (before insert) 
{
    // check that no other subscription has the same name
    try
    {
        Handler_Subscriber.checkUniqueSubscriber(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to check for unique subscriber.', ex.getMessage());
    }
}