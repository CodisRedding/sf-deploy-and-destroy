trigger Milestones_INSERT_AFTER on Milestones__c (after insert) 
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
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to update contact age.', ex.getMessage());
    }
}