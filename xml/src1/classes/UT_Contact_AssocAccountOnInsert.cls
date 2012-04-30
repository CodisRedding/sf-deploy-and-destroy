/* Rocky: 05/26/2011
    Trigger UnitTest: Contact_AssocAccountOnInsert.
*/

@isTest
private class UT_Contact_AssocAccountOnInsert 
{
    static testMethod void Contact_AssocAccountOnInsert() 
    {
    	UnitTest_Exception_Manager.ThrowException = true;
    	
        List<Contact> contacts = new List<Contact>();

        for(Integer i = 0; i < 200; i++) {
            
            Contact contact = new Contact(FirstName = 'Test', 
                                          LastName = 'User' + i,
                                          Salutation = 'Mr.');
                                          
            //contact.Contact_Type__c = 'Clergy';              
            contacts.add(contact);
        }
    
    	test.startTest();
        insert contacts;
        test.stopTest();
        
        // Query the database for the newly inserted records.  
        List<Contact> insertedContacts = [SELECT FirstName, LastName, AccountId
                                          FROM Contact   
                                          WHERE Id IN :contacts];  
                                          
        Account account = [SELECT Id FROM Account WHERE Name = 'GBHEM Constituent' limit 1];

        // Assert that the Description fields contains the proper value now.  
        for(Contact insertedContact : insertedContacts){  
            
            System.assertEquals(account.id, insertedContact.AccountId);  
        }  
    }
}