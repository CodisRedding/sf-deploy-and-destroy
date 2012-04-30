trigger Address_UPDATE_BEFORE on Address__c (before update) 
{
    // format phone number
    try
    {
        Handler_Address.FormatPhone(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to format phone number for an address.', ex.getMessage());
    }
}