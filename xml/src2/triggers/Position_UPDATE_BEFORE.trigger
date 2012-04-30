trigger Position_UPDATE_BEFORE on Position__c (before update) 
{
    // check if positions is district superintendent and if the contact has a district
    try
    {
        Handler_Position.RemoveDistrictFromContactIfDistSuper(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to check if positions is district superintendent and if the contact has a district.');
        Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to check if positions is district superintendent and if the contact has a district.', ex.getMessage());
    }
    
    //Raji : 2/21/2012
   //Logic to avoid Lookup Filter Limitation
   try
    {
        Handler_Position.Pos_LookupFilterValidation(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to apply the Lookup Filter Logic for a Position.', ex.getMessage());
    }
}