/*
Raji : 01/19/2012
Certified Updates : Certified renewal status & Status Functionality for Reports.
*/
trigger CertifiedUpdates_UPDATE_BEFORE on Certification_Updates__c (before update) {
  try
  {
        Handler_CertifiedUpdates.UpdateStatus(trigger.new);
    
        UnitTest_Exception_Manager.HandleUnitTestException();
  }
  catch(Exception ex)
  {
    // logging
    Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to Update Status field on Certified Update Object.', ex.getMessage());
  }
  
  //cerfitification/renewal status
  try
  {
        Handler_CertifiedUpdates.UpdateCertifiedStatus(trigger.new);
    
        UnitTest_Exception_Manager.HandleUnitTestException();
  }
  catch(Exception ex)
  {
    // logging
    Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to Update certification/renewal Status field on Education certification Object.', ex.getMessage());
  }
}