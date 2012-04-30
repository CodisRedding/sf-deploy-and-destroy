trigger Contact_INSERT_BEFORE on Contact (before insert) 
{   
    // associate with account
    try
    {
        Handler_Contact.AssociateWithAccount(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to associate with gbhem constituent account.', ex.getMessage());
    }
    
    // Update Contact AC JD District APC
    try
    {
        Handler_Contact.UpdateContact_AC_JD_District_APC(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to update contact AC JD district APC.', ex.getMessage());
    }
    
    // Update Contact Appointments
    /* Rocky Assad : TA616
    try
    {
        Handler_Contact.UpdateAppointmentConferences(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to update contact appointments.', ex.getMessage());
    }*/
    
    //Contact Salutation, Phone & SSN
    try
    {
        Handler_Contact.ContactSalutationPhoneSSN(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to apply salutation, phone and SSN.', ex.getMessage());
    }
    
    // Restrict associating a district to a contact if the contact is a District Superintendent
    try
    {
        Handler_Contact.RestrictDistrictType(trigger.new);
        
        UnitTest_Exception_Manager.HandleUnitTestException();
    }
    catch(Exception ex)
    {
        // logging
        Util_Logging.logSystemErrors(Util_Logging.NullRecordIds, 'ERROR: Unable to check if district should be restricted for contact.', ex.getMessage());
    }
    
   }