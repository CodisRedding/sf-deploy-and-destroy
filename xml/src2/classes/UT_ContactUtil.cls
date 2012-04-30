/**
 Raji : 08.10.2011
 1.Test class for Contact Util Functionality.
 */
@isTest
private class UT_ContactUtil 
{
    static testMethod void ContactUtil() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        //Test for Annual Conference & Appoitment Conference on Contact
        RecordType AccountAnnualConf = Util.getRecordType('Account', 'Annual Conference');
        Account account1 = new Account(
            Name = 'Annual Conference 1',
            RecordTypeId = AccountAnnualConf.Id
            );
        insert account1;
        
        Account account2 = new Account(
            Name = 'Annual Conference 2',
            RecordTypeId = AccountAnnualConf.Id
            );
        insert account2;
        
        Contact contact1 = new Contact(
            LastName = 'Last Name 1',
            Salutation = '',
            Salutation_Other__c = ' '
            );
        Contact contact2 = new Contact(
            LastName = 'Last Name 2',
            Salutation = '',
            Salutation_Other__c = 'test salutation',
            Annual_Conference__c = account1.Id
            );
        Contact contact3 = new Contact(
            LastName = 'Last Name 3',
            Salutation = 'Mr.',
            Salutation_Other__c = 'Miss'
            );
        /* Rocky Assad : TA616
        Contact contact4 = new Contact(
            LastName = 'Last Name 4',
            Salutation = 'The Rev.',
            Salutation_Other__c = '',
            Annual_Conference__c = account1.Id,
            Appointment_Conference__c = account2.Id
            );
        */
            
        test.startTest();
            
            //try{
                insert contact1;
           /* }
            catch (DmlException e){
                System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }*/
            insert contact2;
            /* Rocky Assad : TA616
            insert contact4;
            */
            
            try{
                insert contact3;
            }
            catch (DmlException e){
                System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
            
            System.debug('Contact2'+ contact2);
                            
        test.stopTest();
        
        Contact contact1record = [SELECT LastName, Salutation, Salutation_Other__c FROM Contact WHERE Id =: contact1.Id];
        //Commented out only for migration phase. Rocky Assad 2/1/2012
        //System.assertEquals('The Rev.', contact1record.Salutation); 
        
        
        Contact contact2record = [SELECT LastName, Salutation, Salutation_Other__c, Annual_Conference__c, Appointment_Conference__c  FROM Contact WHERE Id =: contact2.Id];
        System.assertEquals('test salutation', contact2record.Salutation);
        /* Rocky Assad : TA616 
        System.assertEquals(contact2record.Appointment_Conference__c, contact2record.Annual_Conference__c); 
        */
        
        /* Rocky Assad : TA616
        Contact contact3record = [SELECT LastName, Salutation, Salutation_Other__c, Annual_Conference__c, Appointment_Conference__c  FROM Contact WHERE Id =: contact4.Id];
        System.assertNotEquals(contact3record.Appointment_Conference__c, contact3record.Annual_Conference__c);
        */ 
        
        delete contact1;
        delete contact2;
        /* Rocky Assad : TA616
        delete contact4;
        */
        
        delete account2;
        delete account1;
          
    }
    
 }