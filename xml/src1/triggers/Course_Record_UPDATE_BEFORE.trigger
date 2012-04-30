trigger Course_Record_UPDATE_BEFORE on Course_Record__c (before update) 
{
    // remove historical grade
    try
    {
        Handler_Course_Record.RemoveHistoricalGrade(trigger.new, trigger.oldMap);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex) 
    {
        // logging
        Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to update historical grade for a course record.');
        Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to update historical grade for a course record.', ex.getMessage());
    }
    
    // set default amount paid
    try
    {
        Handler_Course_Record.DefaultAmountPaid(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logRecordErrors(trigger.newMap.keySet(), 'ERROR: Unable to set default amount paid for a course record.');
        Util_Logging.logSystemErrors(trigger.newMap.keySet(), 'ERROR: Unable to set default amount paid for a course record.', ex.getMessage());
    }
    
 
     //Raji : 2/20/2012
   //Logic to avoid Lookup Filter Limitation
   try
    {
        Handler_Course_Record.CR_LookupFilterValidation(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to apply the Lookup Filter Logic for a course record.', ex.getMessage());
    } 
}