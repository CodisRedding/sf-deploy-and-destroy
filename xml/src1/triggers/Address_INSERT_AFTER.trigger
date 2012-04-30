/*Raji : 12.09.2011
Functionality : Organization mailing address For Reports
Search Layouts : City & State on all Search Layouts
*/
trigger Address_INSERT_AFTER on Address__c (after insert) {
try
    {
        Handler_Address.ReportsOrgMailingAddress(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to Update Report and Search Layout Fields on Organization.', ex.getMessage());
    }
    
}