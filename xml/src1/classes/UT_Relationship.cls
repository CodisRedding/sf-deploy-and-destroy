@isTest
private class UT_Relationship 
{
    static testMethod void insertSingle() 
    {
        // SETUP
        UnitTest_Exception_Manager.ThrowException = true;
        
        npe4__Relationship__c relationship = new npe4__Relationship__c();
        RecordType rtSpouse = [SELECT Id FROM RecordType WHERE Name = 'Spouse'];
        Contact contact1 = new Contact(FirstName = 'Test', LastName = 'User', Salutation = 'Mr.');
        Contact contact2 = new Contact(FirstName = 'Test', LastName = 'User', Salutation = 'Mr.');
                       
        insert contact1;
        insert contact2;
        
        // TEST
        test.startTest();
        
        relationship.npe4__Contact__c = contact1.Id;
        relationship.npe4__RelatedContact__c = contact2.Id;
        relationship.npe4__Status__c = 'Current';
        relationship.RecordTypeId = rtSpouse.Id;
        
        insert relationship;
        
        test.stopTest();
        
        // TEST RESULTS
        npe4__Relationship__c testReleationship1 = [SELECT npe4__Contact__c, npe4__RelatedContact__c, npe4__Status__c, RecordTypeId FROM npe4__Relationship__c WHERE npe4__Contact__c = :contact1.Id];
        npe4__Relationship__c testReleationship2 = [SELECT npe4__Contact__c, npe4__RelatedContact__c, npe4__Status__c, RecordTypeId FROM npe4__Relationship__c WHERE npe4__Contact__c = :contact2.Id];
        
        System.assertEquals(testReleationship1.npe4__RelatedContact__c, contact2.Id);
        System.assertEquals(testReleationship2.npe4__RelatedContact__c, contact1.Id);
        System.assertEquals(testReleationship1.RecordTypeId, rtSpouse.Id);
        System.assertEquals(testReleationship2.RecordTypeId, rtSpouse.Id);
        System.assertEquals(testReleationship1.npe4__Status__c, 'Current');
        System.assertEquals(testReleationship2.npe4__Status__c, 'Current');
    }
    
    static testMethod void insertBulk() 
    {
        // SETUP
        UnitTest_Exception_Manager.ThrowException = true;
        
        List<npe4__Relationship__c> relationships = new List<npe4__Relationship__c>();
        List<Contact> contacts1 = new List<Contact>();
        List<Contact> contacts2 = new List<Contact>();
        RecordType rtSpouse = [SELECT Id FROM RecordType WHERE Name = 'Spouse'];
        
        for(Integer x = 0; x < 400; x++)
        {
            contacts1.add(new Contact(FirstName = 'Contact1[' + x + ']', LastName = 'User', Salutation = 'Mr.'));
            contacts2.add(new Contact(FirstName = 'Contact2[' + x + ']', LastName = 'User', Salutation = 'Mr.'));
        }
        
        insert contacts1;
        insert contacts2;
        
        Contact[] qContacts1 = [SELECT Id FROM Contact WHERE FirstName LIKE 'Contact1%' ORDER BY ID ASC];
        Contact[] qContacts2 = [SELECT Id FROM Contact WHERE FirstName LIKE 'Contact2%' ORDER BY ID ASC];
        
        for(Integer x = 0; x < qContacts1.size(); x++)
        {
            npe4__Relationship__c relationship = new npe4__Relationship__c();
            relationship.npe4__Contact__c = qContacts1[x].Id;
            relationship.npe4__RelatedContact__c = qContacts2[x].Id;
            relationship.npe4__Status__c = 'Current';
            relationship.RecordTypeId = rtSpouse.Id;
            
            relationships.add(relationship);    
        }
        
        // TEST
        test.startTest();
        
        insert relationships;
        
        test.stopTest();
        
        // TEST RESULTS
        Integer cnt = [SELECT COUNT() FROM npe4__Relationship__c WHERE npe4__Contact__c IN :qContacts1];
        
        System.assertEquals(400, cnt);
        
        // iterate over batches of 200
        for(npe4__Relationship__c[] rels : [SELECT npe4__Status__c, RecordTypeId, npe4__Contact__c, npe4__RelatedContact__c FROM npe4__Relationship__c WHERE npe4__Contact__c IN :qContacts1])
        {
            // iterate through 200
            for(npe4__Relationship__c rel : rels)
            {
                System.assertEquals('Current', rel.npe4__Status__c);
                System.assertEquals(rtSpouse.Id, rel.RecordTypeId);
            }
        }
    }
}