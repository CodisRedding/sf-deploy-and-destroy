/**
 Raji : 08.09.2011
 Raji Update : 08.10.2011
 1.Test class for Account Util Functionality.
 Raji : 08.10.2011
 2.Test Class for UpdateAccount_AC_JD_District Functionality
 3.Test class for UpdateContact_AC_JD_District_APC for Appoitment conference(trigger).
 4.Test class for UpdateContact_AC_JD_District_APC for Functionality(Class & trigger)
 Infuture if the code is not completely covered : Include one more contact giving value for Annual Conference,
    and check if the Jurisdiction is getting populated. 
 */ 
@isTest
private class UT_AccountUtil {
/*
    static testMethod void AccountUtil_Bulk() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
            
        RecordType rtDistrict = Util.getRecordType('Account', 'District');
        RecordType rtAnnualConference = Util.getRecordType('Account', 'Annual Conference');
        RecordType rtJurisdiction = Util.getRecordType('Account', 'Jurisdiction');
        RecordType rtChurch = Util.getRecordType('Account', 'Local Church');
        
        List<Account> acJurisdictions = new List<Account>();
        
        for(Integer x = 0; x < 200; x++)
        {
            acJurisdictions.Add(new Account(Name = 'Jurisdiction ' + x,
                                            RecordTypeId = rtDistrict.Id));
        }
        
        test.startTest();
        
        insert acJurisdictions;
        update acJurisdictions;
        
        test.stopTest();
        
        // needs test asserts
    }
*/ 
    static testMethod void AccountUtil() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        RecordType AccountSchool = Util.getRecordType('Account', 'Educational Institutions');
        
        Account account1 = new Account(
            Name='Test School 1',
            RecordTypeId = AccountSchool.Id,
            Affiliation__c = 'BCF'
            );
        Account account2 = new Account(
            Name='Test School 2',
            RecordTypeId = AccountSchool.Id,
            Affiliation__c = 'UM-Related'
            );
        Account account3 = new Account(
            Name='Test School 3',
            RecordTypeId = AccountSchool.Id,
            Affiliation__c = 'NASCUMC'
            );
        Account account4 = new Account(
            Name='Test School 4',
            RecordTypeId = AccountSchool.Id,
            Affiliation__c = 'Public;UM-Related'
            );
        test.startTest();
        //System.runAs(u1) {
            insert account1;
            insert account2;
            insert account3;
            try {
                insert account4;
            }
            catch (DmlException e) {
                System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                e.getMessage());
            }
             
        test.stopTest();
          //  }
        Account account1record = [SELECT Name, RecordTypeId, Affiliation__c FROM Account WHERE Id =: account1.Id];
        //System.assertEquals('Private;UM-Related;BCF', account1record.Affiliation__c);
        
        System.assert(account1record.Affiliation__c.contains('BCF'));
        System.assert(account1record.Affiliation__c.contains('UM-Related'));
        System.assert(account1record.Affiliation__c.contains('Private'));
        System.assert(account1record.Affiliation__c.contains('HBCU'));
        String[] parts1 = account1record.Affiliation__c.split(';');
        System.assertEquals(parts1.size(), 4);
                
        Account account2record = [SELECT Name, RecordTypeId, Affiliation__c FROM Account WHERE Id =: account2.Id];
        //System.assertEquals('Private;UM-Related', account2record.Affiliation__c);
        
        System.assert(account2record.Affiliation__c.contains('UM-Related'));
        System.assert(account2record.Affiliation__c.contains('NASCUMC'));
                System.assert(account2record.Affiliation__c.contains('IAMSCU'));

        String[] parts2 = account2record.Affiliation__c.split(';');
        System.assertEquals(parts2.size(), 3);
        
        Account account3record = [SELECT Name, RecordTypeId, Affiliation__c FROM Account WHERE Id =: account3.Id];
        //System.assertEquals('Private;UM-Related;NASCUMC', account3record.Affiliation__c);
        
        System.assert(account3record.Affiliation__c.contains('NASCUMC'));
        System.assert(account3record.Affiliation__c.contains('UM-Related'));
        System.assert(account3record.Affiliation__c.contains('Private'));
        String[] parts3 = account3record.Affiliation__c.split(';');
        System.assertEquals(parts3.size(), 3);
                
        account1.Affiliation__c = 'NASCUMC';
        update account1;
        
        delete account1;
        delete account2;
        delete account3;
                
    }
    
    static testMethod void UpdateAccount_AC_JD_District() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
            
        RecordType rtDistrict = Util.getRecordType('Account', 'District');
        RecordType rtAnnualConference = Util.getRecordType('Account', 'Annual Conference');
        RecordType rtJurisdiction = Util.getRecordType('Account', 'Jurisdiction');
        RecordType rtChurch = Util.getRecordType('Account', 'Local Church');
        
        test.startTest();
        
        Account acJurisdiction = new Account(
            Name = 'Jurisdiction 1',
            RecordTypeId = rtJurisdiction.Id
        );
        insert acJurisdiction;
        
        Account acAnnualConference = new Account(
            Name = 'Annual Conference 1',
            RecordTypeId = rtAnnualConference.Id,
            ParentId = acJurisdiction.Id
        );
        insert acAnnualConference;
        
        Account acDistrict = new Account(
            Name = 'District 1',
            RecordTypeId = rtDistrict.Id,
            ParentId = acAnnualConference.Id
        );
        insert acDistrict;
        
        Account acChurch = new Account(
            Name = 'LocalChurch 1',
            RecordTypeId = rtChurch.Id,
            Annual_Conference__c = acAnnualConference.Id
        );
        insert acChurch;
        
        Contact contact = new Contact(
            LastName = 'Last Name 2',
            Salutation = 'The Rev.',
            District__c = acDistrict.Id
        );
        insert contact;
        
        test.stopTest();
        
        Account account1record = [SELECT Name, RecordTypeId FROM Account WHERE Id = :acJurisdiction.Id];
        Account account2record = [SELECT Name, RecordTypeId, ParentId, Parent.Name  FROM Account WHERE Id = :acAnnualConference.Id];
        // tests?
        
        Account account3record = [SELECT Name, RecordTypeId, ParentId, Parent.Name, Jurisdiction__c  FROM Account WHERE Id = :acDistrict.Id];
        System.assertEquals(account1record.Id, account3record.Jurisdiction__c);
                
        
        Account account4record = [SELECT Name, RecordTypeId, Annual_Conference__c, Jurisdiction__c  FROM Account WHERE Id = :acChurch.Id];
        System.assertEquals(account1record.Id, account4record.Jurisdiction__c);
                
        Contact contact1record = [SELECT LastName, Salutation, District__c, Annual_Conference__c, Jurisdiction__c, Appointment_Conference__c FROM Contact WHERE Id = :contact.Id];
        System.assertEquals(contact1record.Annual_Conference__c, account2record.Id);
        System.assertEquals(contact1record.Jurisdiction__c, account1record.Id);
    }
}