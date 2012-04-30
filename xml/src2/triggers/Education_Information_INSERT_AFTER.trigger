/*Raji : 11/18/2011
For reports : Licensing School
*/
trigger Education_Information_INSERT_AFTER on Education_Information__c (after insert) 
{
    // update licensing info
    try
    {
        Handler_Education_Information.LicensingschoolContactUpdate(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex) 
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to populate licensing school on Contact.', ex.getMessage());
    }
}