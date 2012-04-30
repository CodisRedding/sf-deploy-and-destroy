/*
Raji : 11/23/2011
Functionality : Unique Spouse
*/
trigger Relationship_UPDATE_BEFORE on npe4__Relationship__c (before update) {
try
    {
        Handler_Relationship.UpdateUniqueSpouse(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to update the field on Relationships.', ex.getMessage());
    }
}