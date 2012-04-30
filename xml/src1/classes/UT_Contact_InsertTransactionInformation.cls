/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UT_Contact_InsertTransactionInformation {
/*Commented Out By Raji : To remove Transcript Info
    static testMethod void InsertTransactionInformation_Bulk() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        // local vars
        Map<Id, Contact> mappedContacts = new Map<Id, Contact>();
        List<Contact> contacts = new List<Contact>();
          
        for(Integer i = 0; i < 200; i++)
        {
            // Create new contact 
            Contact contact = new Contact(FirstName = 'testing', 
                                          LastName = 'bulk' + String.valueOf(i),
                                          Salutation = 'Mr.');
                        
            // Add new Contact to a List for bulk Insertion later
            contacts.add(contact);
        }
          
        test.startTest();
        
        // Insert all contacts (Trigger should fire after each is created.)
        insert contacts;
        
        test.stopTest();
        
        for(Contact contact : contacts)
        {
            mappedContacts.put(contact.Id, contact);
        }
        
        Integer transCount = [select count() from Transcript_Information__c where Contact__c in :mappedContacts.keySet()];
        
        // ASSERT
        System.assertEquals(contacts.size(), 200);
        System.assertEquals(contacts.size(), transCount);
    }
    
    static testMethod void InsertTransactionInformation_Bulk_As_Users() 
    {
        Profile dataAdministratorProfile = [select id from profile where name='System Administrator' limit 1]; 
        User dataAdministrator = new User(alias = 'testda', 
                                          email='test@test.com',
                                          emailencodingkey='UTF-8', 
                                          lastname='test', 
                                          languagelocalekey='en_US',
                                          localesidkey='en_US', 
                                          profileid = dataAdministratorProfile.Id,
                                          timezonesidkey='America/Chicago', 
                                          username='testDataAdministrator@test.com'
        ); 
        
        System.runAs(dataAdministrator) 
        { 
            InsertTransactionInformation_Bulk();
        }
    }Raji : To remove Transcript info*/
}