/**
 Raji : 08.10.2011
 Test class for Milestone Contact Functionality Functionality.
 Raji : 1/05/2011
 Updated Birth date & Death Date as 2 different fields
 */
@isTest
private class UT_MilestoneContact 
{
    static testMethod void MilestoneContact() {
        UnitTest_Exception_Manager.ThrowException = true;
        
        Contact contact1 = new Contact(
            LastName = 'Last Name',
            Salutation = 'Mr.'
            );
        test.startTest();
        insert contact1;
        
        Milestones__c milestone1 = new Milestones__c(
            Contact__c = contact1.Id,
            Milestone__c = 'Birth Date',
            Birth_Date__c = Date.valueOf('1990-08-10') //date.newinstance(1990, 2, 17) //1990-08-10
            );
            System.debug('Birth Date'+milestone1.Birth_Date__c);
        
        insert milestone1;
        
        milestone1.Comments__c = 'something';
        update milestone1;
        
        Milestones__c milestone2 = new Milestones__c(
            Contact__c = contact1.Id,
            Milestone__c = 'Death Date',
            Death_Date__c = Date.today() 
            );
            
        insert milestone2;
        
        test.stopTest();
        
        Contact contact1record = [SELECT LastName, Salutation, Age__c, Death_Date__c, DOB_Month__c, Date_of_Birth__c,Status__c  FROM Contact WHERE Id =: contact1.Id];
        Milestones__c milestone1record = [SELECT Contact__c, Milestone__c, Birth_Date__c, Death_Date__c, Date__c, Age__c FROM Milestones__c WHERE Id =: milestone1.Id];
        System.assertEquals(milestone1record.Age__c, contact1record.Age__c);
        System.debug('contact1record.Date_of_Birth__c : '+contact1record.Date_of_Birth__c);
        System.debug('contact1record.DOB_Month__c :'+contact1record.DOB_Month__c);
        
        Milestones__c milestone2record = [SELECT Contact__c, Milestone__c, Birth_Date__c, Death_Date__c, Date__c  FROM Milestones__c WHERE Id =: milestone2.Id];
       // System.assertEquals(milestone2record.Death_Date__c, contact1record.Death_Date__c); 
       // System.assertEquals('Inactive', contact1record.Status__c);
        
       
        delete milestone1; 
        delete milestone2;
        delete contact1;
    }
}