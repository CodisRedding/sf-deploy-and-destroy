/* Rocky: 05/26/2011
    Trigger UnitTest: Education_OnlyOneHighestEd.
*/
@isTest
private class UT_Education_OnlyOneHighestEd 
{
    static testMethod void Education_OnlyOneHighestEd() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        // Rocky Assad
        // Create and account just to ensure that ACCOUNT_GBHEM_CONSTITUENT_ACCOUNT_NAME
        // is created prior to folling tests.
        Contact contactPrior = new Contact(FirstName = 'TestUserSetup', 
                                           LastName = 'UserSetup',
                                           Salutation = 'Mr.',
                                           Appointment__c = 'Local Church',
                                           Dual_Appointment__c= '');
                                           
        insert contactPrior;
        
        Account account = [SELECT Id FROM Account WHERE Name = 'GBHEM Constituent' limit 1];
        Contact contact = new Contact(AccountId = account.Id, 
                                          FirstName = 'Test', 
                                          LastName = 'User',
                                          Salutation = 'Mr.',
                                          Appointment__c = 'Local Church',
                                          Dual_Appointment__c= '');
                                          

        insert contact;
        
        // Stop the test, this changes limit context back to test from trigger.
        for(Integer i = 0; i < 2; i++) {
            
            Education_Information__c education = new Education_Information__c(Education_Type__c = 'Highest Education', 
                                                                                Highest_Education__c = 'High School',
                                                                                Education_Detail__c = contact.id);
                                          
            try 
            {                                                           
                insert education;
                
                if(i == 0)
                {
                    education.Field_of_Study__c = 'new';
                    update education;
                }
            } 
            catch(DmlException ex) 
            {
                System.assert(ex.getMessage().contains('Highest Education may only be added once for any given contact'), ex.getMessage());
            }
        }
    }
    
    //Raji : 11/16/2011 
    //Local Pastor Licensing Unit Test
     static testMethod void Education_OnlyOneLocalPastorLicensing(){
        UnitTest_Exception_Manager.ThrowException = true;
        
        // Create and account just to ensure that ACCOUNT_GBHEM_CONSTITUENT_ACCOUNT_NAME
        // is created prior to following tests.
        Contact contactPrior = new Contact(FirstName = 'Test', 
                                           LastName = 'User',
                                           Salutation = 'Mr.',
                                           Appointment__c = 'Local Church',
                                           Dual_Appointment__c= '');
                                           
        insert contactPrior;
        
        Account account = [SELECT Id FROM Account WHERE Name = 'GBHEM Constituent' limit 1];
        Contact contact = new Contact(AccountId = account.Id, 
                                          FirstName = 'Test', 
                                          LastName = 'User1',
                                          Salutation = 'Mr.',
                                          Appointment__c = 'Local Church',
                                          Dual_Appointment__c= '');
                                          

        insert contact;
        
        // Stop the test, this changes limit context back to test from trigger.
        for(Integer i = 0; i < 2; i++) {
            
            Education_Information__c education = new Education_Information__c(Education_Type__c = 'Local Pastor Licensing', 
                                                                              Education_Detail__c = contact.id);
                                          
            try 
            {                                                           
                insert education;
                
                if(i == 0)
                {
                    education.Field_of_Study__c = 'new';
                    update education;
                }
            } 
            catch(DmlException ex) 
            {
                System.assert(ex.getMessage().contains('Local Pastor Licensing may only be added once for any given contact'), ex.getMessage());
            }
        }
        delete contact;
        delete contactPrior;
        
    }
}