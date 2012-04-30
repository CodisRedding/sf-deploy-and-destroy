/**
 Raji : 08.11.2011
 1.Test class for Address Trigger Functionality.
 */
@isTest
private class UT_Address {
  
    static testMethod void UT_Address_insert() {
        RecordType addressHome = Util.getRecordType('Address__c', 'Contact  Home Address');
        RecordType addressSchool = Util.getRecordType('Address__c', 'Contact School Address');
        RecordType addressMilitary = Util.getRecordType('Address__c', 'Contact Military Address');
        
        Contact contact1 = new Contact(
            LastName = 'Last Name',
            Salutation = 'Mr.'
            );
        
        Contact contact2 = new Contact(
            LastName = 'Last Name2',
            Salutation = 'Mr.'
            );
        
        test.startTest();
        insert contact1;
        insert contact2;
        
        Address__c address1 = new Address__c(
            RecordTypeId = addressHome.Id,
            Contact__c = contact1.Id,
            Primary_Mailing_Address__c = true,
            Confidential_Mailing_Address__c = true,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'NY',
            Country__c = 'UNITED STATES OF AMERICA',
            Primary_Email_Address__c = true,
            Email_Confidential_Only__c = true,
            Email__c = 'email1@test.com',
            //Primary_Phone__c = 'Landline',
            Phone__c = '1234567890',
            Mobile__c = '2345671234',
            Phone_Extension__c = '2345',
            URL__C = 'www.test.com',
            Fax__c = '1234567890'
            );
                        
        insert address1;
        
        Address__c address2 = new Address__c(
            RecordTypeId = addressSchool.Id,
            Contact__c = contact1.Id,
            Primary_Mailing_Address__c = true,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'Other/Specify',
            State_Other__c = 'State test',
            Country__c = 'ARGENTINA'
            );
                        
        try{
            insert address2;
            }
        catch (DmlException e){
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
            
        Address__c address2a = new Address__c(
            RecordTypeId = addressSchool.Id,
            Contact__c = contact1.Id,
            Confidential_Mailing_Address__c = true,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'NY',
            Country__c = 'UNITED STATES OF AMERICA'
            );
                        
        try{
            insert address2a;
            }
        catch (DmlException e){
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
        
        Address__c address3 = new Address__c(
            RecordTypeId = addressSchool.Id,
            Contact__c = contact1.Id,
            Primary_Email_Address__c = true,
            Email__c = 'email1@test.com'
            );
                        
        try{
            insert address3;
            }
        catch (DmlException e){
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
        
        Address__c address3a = new Address__c(
            RecordTypeId = addressSchool.Id,
            Contact__c = contact1.Id,
            Email_Confidential_Only__c = true,
            Email__c = 'email1@test.com'
            );
                        
        try{
            insert address3a;
            }
        catch (DmlException e){
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
            
        Address__c address4 = new Address__c(
            RecordTypeId = addressSchool.Id,
            Contact__c = contact1.Id,
            //Primary_Phone__c = 'Landline',
            Phone__c = '1234567890'
            );
                        
        try{
            insert address4;
            }
        catch (DmlException e){
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
        
        Address__c address5 = new Address__c(
            RecordTypeId = addressMilitary.Id,
            Contact__c = contact2.Id,
            Primary_Mailing_Address__c = true,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'Other/Specify',
            State_Other__c = 'State test',
            Country__c = 'ARGENTINA'
            );
        
        insert address5;
        
        test.stopTest();
        Address__c Address1Record = [SELECT Mobile__c,Phone__c,URL__c, Email__c FROM Address__c WHERE Id =: address1.Id];
        
        Contact contact1record = [SELECT LastName, Salutation, Phone,Phone_Extension__c, MobilePhone, 
            Contact_Address_Line1__c, Contact_Address_Line2__c, Contact_State__c, Contact_Country__c, Contact_City__c, URL__c, Fax, Email FROM Contact WHERE Id =: contact1.Id];
        System.assertEquals(address1.City__c, contact1record.Contact_City__c);
        System.debug(contact1record.Contact_Address_Line1__c);
        System.debug(contact1record.Phone);
        System.debug(contact1record.Phone_Extension__c);
        System.debug(contact1record.Contact_State__c);
        System.debug(contact1record.Contact_Country__c);
        System.assertEquals(address1.Email__C, contact1record.Email);
        System.debug(contact1record.Fax);
        System.assertEquals(address1.URL__c, contact1record.URL__c);
        
        Contact contact2record = [SELECT LastName, Salutation, 
            Contact_Address_Line1__c, Contact_Address_Line2__c, Contact_State__c, Contact_Country__c, Contact_City__c FROM Contact WHERE Id =: contact2.Id];     
      Address__c Address2Record = [SELECT Mobile__c,Phone__c,URL__c, Email__c FROM Address__c WHERE Id =: address5.Id]; 
       System.debug(contact2record.Contact_Address_Line1__c);
      System.debug(contact2record.Contact_State__c);
      System.debug(contact2record.Contact_Country__c);
      System.debug(contact2record.Contact_Address_Line2__c);
        
        
        
        delete address5;
        delete address1;
        //delete address6;
        delete contact1;
        delete contact2;
    
    }
    
    static testMethod void UT_Address_update() {
    
        RecordType addressHome = Util.getRecordType('Address__c', 'Contact  Home Address');
        RecordType addressSchool = Util.getRecordType('Address__c', 'Contact School Address');
        Contact contact1 = new Contact(
            LastName = 'Last Name',
            Salutation = 'Mr.'
            );
        
        test.startTest();
        insert contact1;
        Address__c address1 = new Address__c(
            //Id = address1.Id,
            RecordTypeId = addressHome.Id,
            Contact__c = contact1.Id,
            Primary_Mailing_Address__c = true,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'NY',
            Country__c = 'UNITED STATES OF AMERICA',
            Primary_Email_Address__c = true,
            Email__c = 'email1@test.com',
            //Primary_Phone__c = 'Mobile',
            Mobile__c = '1234567890',
            Start_Date__c = Date.valueOf('2010-08-10') 
            );
                        
        insert address1;
        Contact contactrecord = [SELECT LastName, Salutation, Phone, MobilePhone, 
            Contact_Address_Line1__c, Contact_Address_Line2__c, Contact_State__c, Contact_Country__c, Contact_City__c,Email FROM Contact WHERE Id =: contact1.Id];
            
        System.assertEquals(address1.Main_Switchboard__c, contactrecord.Phone);
        //System.assertEquals(address1.Mobile__c, contactrecord.MobilePhone);
        
        Address__c address3 = new Address__c(
            RecordTypeId = addressHome.Id,
            Contact__c = contact1.Id,
            //Primary_Phone__c = 'Mobile',
            Mobile__c = '1234567890'
            );
                        
        try{
            insert address3;
            }
        catch (DmlException e){
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
        
        Address__c address4 = new Address__c(
            RecordTypeId = addressSchool.Id,
            Contact__c = contact1.Id,
            //Primary_Phone__c = 'Mobile',
            Mobile__c = '123456789'
            );
                        
        try{
            insert address4;
            }
        catch (DmlException e){
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
        Address__c address2 = new Address__c(
            Id = address1.Id,
            RecordTypeId = addressHome.Id,
            Contact__c = contact1.Id,
            Primary_Mailing_Address__c = false,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'NY',
            Country__c = 'UNITED STATES OF AMERICA',
            Primary_Email_Address__c = false,
            Email__c = 'email1@test.com',
            //Primary_Phone__c = 'Landline',
            Phone__c = '2345678999',
            //Phone_Extension__c = '2345',
            End_Date__c = Date.today() 
            );
                        
        update address2;
        
        //Update NON USA & Canada
        
        Address__c addressNONUSA = new Address__c(
            //Id = address1.Id,
            RecordTypeId = addressHome.Id,
            Contact__c = contact1.Id,
            Primary_Mailing_Address__c = true,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'Other/Specify',
            State_Other__c = 'State test',
            Country__c = 'ARGENTINA',
            //Primary_Email_Address__c = true,
            Email__c = 'email1@test.com',
            //Primary_Phone__c = 'Mobile',
            Mobile__c = '1234567890',
            Start_Date__c = Date.valueOf('2010-08-10') 
            );
                        
        insert addressNONUSA ;
        
        Address__c addressNONUSAUpdate = new Address__c(
            Id = addressNONUSA.Id,
            RecordTypeId = addressHome.Id,
            Contact__c = contact1.Id,
            Address_Line1__c = 'Address Line 1 NON USA',
            Address_Line2__c = 'Address Line 2 NON USA',
            City__c = 'City 1 NON USA',
            State__c = 'Other/Specify',
            State_Other__c = 'State test NON USA',
            Country__c = 'ARGENTINA',
            Email__c = 'email1@test.com'
            );
                        
        Update addressNONUSAUpdate;
        
        test.stopTest();
        
        Contact contact1record = [SELECT LastName, Salutation, Phone, MobilePhone,Phone_Extension__c, 
            Contact_Address_Line1__c, Contact_Address_Line2__c,Contact_State__c, Contact_Country__c, Contact_City__c,Email FROM Contact WHERE Id =: contact1.Id];
        
        System.assertNotEquals(address2.City__c, contact1record.Contact_City__c);
        System.debug(contact1record.Contact_Address_Line1__c);
        System.assertNotEquals(address2.City__c, contact1record.Contact_City__c);
        System.debug('contact1record.Phone :'+contact1record.Phone);
        System.debug('contact1record.MobilePhone :'+contact1record.MobilePhone);
        System.debug('contact1record.Phone_Extension__c :'+contact1record.Phone_Extension__c);
        System.assertNotEquals(address2.State__c, contact1record.Contact_State__c);
        System.assertNotEquals(address2.Country__c, contact1record.Contact_Country__c);
        System.assertNotEquals(address2.Email__C, contact1record.Email);
       
        Address__c addressrecord = [SELECT Contact__c, Phone__c,Status__c, End_Date__c FROM Address__c WHERE Id =: address2.Id];
        System.assertEquals('Inactive', addressrecord.Status__c);
       
        // For Not USA & Canada
        Address__c address1record = [SELECT Contact__c, Phone__c,Status__c, End_Date__c FROM Address__c WHERE Id =: addressNONUSAUpdate.Id];
        System.debug(contact1record.Contact_State__c);
        System.debug(contact1record.Contact_Country__c);
        System.debug(contact1record.Contact_City__c);
        
        delete address2;
        //delete address1;
        delete contact1;
        
    }
    //Test for Organization mailing Address & Organization Location Updates
    static testMethod void UT_Address_update_Organization() {
    
    RecordType OrgMail = Util.getRecordType('Address__c', 'Organization Mailing');
    RecordType OrgLoc = Util.getRecordType('Address__c', 'Organization Location');
    RecordType AccountSchool = Util.getRecordType('Account', 'Educational Institutions');
    
    Account account1 = new Account(
            Name='Test School 1',
            RecordTypeId = AccountSchool.Id,
            Affiliation__c = 'BCF'
            );
    Address__c address1 = new Address__c(
            RecordTypeId = OrgMail.Id,
            Organization_Name__c = account1.Id,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'NY',
            Country__c = 'UNITED STATES OF AMERICA',
            //Primary_Phone__c = 'Landline',
            Main_Switchboard__c = '2345678999',
            //Phone_Extension__c = '2345',
            End_Date__c = Date.today() 
            );  
    Address__c addressmailing = new Address__c(
            Id = address1.Id,
            RecordTypeId = OrgMail.Id,
            Organization_Name__c = account1.Id,
            Address_Line1__c = 'Address Line 1 mailing',
            Address_Line2__c = 'Address Line 2 ',
            City__c = 'City 1',
            State__c = 'NY',
            Country__c = 'UNITED STATES OF AMERICA',
            //Primary_Phone__c = 'Landline',
            Main_Switchboard__c = '2345678999',
            //Phone_Extension__c = '2345',
            End_Date__c = Date.today() 
            );  
            
    Address__c address2 = new Address__c(
            RecordTypeId = OrgMail.Id,
            Organization_Name__c = account1.Id,
            Address_Line1__c = 'Address Line 1',
            Address_Line2__c = 'Address Line 2',
            City__c = 'City 1',
            State__c = 'Other/Specify',
            State_Other__c = 'State test',
            Country__c = 'ARGENTINA',
            //Primary_Phone__c = 'Landline',
            Main_Switchboard__c = '2345678999',
            Phone_Extension__c = '2345',
            Alternate_Phone__c = '1234567812',
            End_Date__c = Date.today() 
            );  
    Address__c address3 = new Address__c(
            Id = address2.Id,
            RecordTypeId = OrgMail.Id,
            Organization_Name__c = account1.Id,
            Address_Line1__c = 'Address Line 1non',
            Address_Line2__c = 'Address Line 2non',
            City__c = 'City 1Update',
            State__c = 'Other/Specify',
            State_Other__c = 'State test update',
            Country__c = 'ARGENTINA',
            Alternate_Phone__c = '1236767812',
            Main_Switchboard__c = '2345678444'
            );
     //Organization Loc State & City
     Address__c address3LOC = new Address__c(
            //Id = address2.Id,
            RecordTypeId = OrgLoc.Id,
            Organization_Name__c = account1.Id,
            Address_Line1__c = 'Address Line 1loc',
            City__c = 'City 1',
            State__c = 'NY',
            Country__c = 'UNITED STATES OF AMERICA',
            Alternate_Phone__c = '1236767812',
            Main_Switchboard__c = '2345678444'
            );
            
    test.startTest();
    insert account1;
    insert address1;
    
     Account accountrecord = [Select id, Organization_Mailing_Country__c, Organization_Mailing_City__c, 
        Organization_Mailing_State__c, SearchLayout_City__c,Organization_Mailing_AddressLine1__c ,
        Organization_Mailing_Address_Line2__c , 
        Organization_Mailing_Zip_Postal_Code__c, SearchLayout_State__c from Account WHERE Id =: account1.Id];
    Address__c addresMailingsrecord = [SELECT City__c,State__c,Organization_Name__c FROM Address__c WHERE Id =: address1.Id];
    System.debug('Organization_Mailing_AddressLine1__c :' + accountrecord .Organization_Mailing_AddressLine1__c );
    System.debug('Organization_Mailing_Address_Line2__c :' + accountrecord .Organization_Mailing_Address_Line2__c );
    System.debug('Organization_Mailing_Country__c:' + accountrecord .Organization_Mailing_Country__c);
    System.debug('Organization_Mailing_City__c:' + accountrecord .Organization_Mailing_City__c);
    System.debug('Organization_Mailing_State__c:' + accountrecord .Organization_Mailing_State__c);
    System.debug('Organization_Mailing_Country__c:' + accountrecord .Organization_Mailing_Country__c); 
    insert addressmailing;
    Address__c addresMailing1srecord = [SELECT City__c,State__c,Organization_Name__c FROM Address__c WHERE Id =: address1.Id];
    System.debug('Organization_Mailing_AddressLine1__c :' + accountrecord .Organization_Mailing_AddressLine1__c );
    System.debug('Organization_Mailing_Address_Line2__c :' + accountrecord .Organization_Mailing_Address_Line2__c );
    System.debug('Organization_Mailing_Country__c:' + accountrecord .Organization_Mailing_Country__c);
    
    insert address2;
    insert address3;
    insert address3LOC ;
    test.stopTest();
    
    Account account1record = [Select id, Organization_Mailing_Country__c, Organization_Mailing_City__c, 
        Organization_Mailing_State__c, SearchLayout_City__c, Organization_Mailing_AddressLine1__c ,
        Organization_Mailing_Address_Line2__c , 
        Organization_Mailing_Zip_Postal_Code__c, SearchLayout_State__c from Account WHERE Id =: account1.Id];
    
    Address__c addressrecord = [SELECT City__c,State__c,Organization_Name__c FROM Address__c WHERE Id =: address2.Id];
    System.debug('Organization_Mailing_AddressLine1__c :' + accountrecord .Organization_Mailing_AddressLine1__c );
    System.debug('Organization_Mailing_Address_Line2__c :' + accountrecord .Organization_Mailing_Address_Line2__c );
    System.debug('Organization_Mailing_Country__c:' + accountrecord .Organization_Mailing_Country__c);
   
    Address__c address1record = [SELECT City__c,State__c,Organization_Name__c FROM Address__c WHERE Id =: address3LOC.Id];
    System.debug('SearchLayout_City__c :' + account1record.SearchLayout_City__c); 
    System.debug('SearchLayout_State__c :' + account1record.SearchLayout_State__c); 
        
    delete address1;
    delete address2;
    delete address3;
    delete account1;    
    
    }
}