trigger Contact_INSERT_AFTER on Contact (after insert) 
{
    // make proper name
    try
    {
        Handler_Contact.ToProperNameAysnc(trigger.newMap.keySet());
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to make proper name for contact.');
        Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to make proper name for contact.', ex.getMessage());
    }
        
}