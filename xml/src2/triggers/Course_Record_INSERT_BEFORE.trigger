trigger Course_Record_INSERT_BEFORE on Course_Record__c (before insert) 
{
    // set default amount paid
    try
    {
        Handler_Course_Record.DefaultAmountPaid(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to apply the default amount paid for a course record.', ex.getMessage());
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