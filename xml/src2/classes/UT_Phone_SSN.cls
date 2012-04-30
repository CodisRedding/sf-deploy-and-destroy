/**
 Raji : 08.11.2011
 Test class for SSN& Phone for Contact & Address Functionality .
 */
@isTest
private class UT_Phone_SSN 
{
    static testMethod void UT_Phone_SSN_Contact() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        Contact contact1 = new Contact(
            LastName = 'Last Name',
            Salutation = 'Mr.',
            SSN__c = '234567890',
            Phone = '2345678901',
            MobilePhone = '2345678901',
            MailingCountry =  'UNITED STATES OF AMERICA'
            );
        
        test.startTest();    
        insert contact1;
        Address__c address = new Address__c(
            Contact__c = contact1.Id,
            Main_Switchboard__c = '2345678901',
            Phone__c = '2345678901',
            Mobile__c = '2345678901',
            Country__c = 'UNITED STATES OF AMERICA'
            );
        
        insert address;     
           
        test.stopTest();
        System.debug('contact1' + contact1);
        System.debug('address'+ address); 
        
        Contact contact1record = [SELECT LastName, Salutation, SSN__c, Phone, MobilePhone, MailingCountry FROM Contact WHERE Id =: contact1.Id];
        System.assertEquals('234-56-7890', contact1record.SSN__C);
        //System.assertEquals('(234) 567-8901', contact1record.Phone);
        //System.assertEquals('(234) 567-8901', contact1record.MobilePhone);
        
        Address__c addressrecord = [SELECT Contact__c, Phone__c, Mobile__c, Country__c FROM Address__c WHERE Id =: address.Id];
        System.debug(addressrecord.Phone__c);
        System.debug(addressrecord.Mobile__c);
        
        delete address;
        delete contact1;  
    }
}