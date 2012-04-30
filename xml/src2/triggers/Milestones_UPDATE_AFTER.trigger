trigger Milestones_UPDATE_AFTER on Milestones__c (after update) 
{
    // update contact age
    try
    {
        Handler_Milestones.UpdateContactAge(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to update contact age.');
        Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to update contact age.', ex.getMessage());
    }
}