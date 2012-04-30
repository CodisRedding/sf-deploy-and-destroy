// test
public with sharing class Handler_Contact
{
    /* Rocky Assad : TA616
    public static void UpdateAppointmentConferences(List<Contact> newContacts)
    {
        // iterate through contacts
        for(Contact contact : newContacts)
        {
            // if appointment is null but not annual conference
            if(contact.Appointment_Conference__c == null && contact.Annual_Conference__c != null)
            {
                contact.Appointment_Conference__c = contact.Annual_Conference__c; 
            }
        }
    }
    */
    
    public static void UpdateContact_AC_JD_District_APC(List<Contact> newContacts)
    {
        // all parents and annual conferences
        Set<Id> districtIds = new Set<Id>();
        for(Contact newContact : newContacts)
        {
            if(newContact.District__c != null)
            {
                districtIds.add(newContact.District__c);
            }
        }
        // get all available districts
        Map<Id, Account> districts = new Map<Id, Account>([select Id, ParentId, Parent.ParentId from Account where id in :districtIds]);
        
        Set<Id> annualConferenceIds = new Set<Id>();
        for(Contact newContact : newContacts)
        {
            if(newContact.Annual_Conference__c != null)
            {
                annualConferenceIds.add(newContact.Annual_Conference__c);
            }
        }
        // get all available annual conferences 
        Map<Id, Account> annualConferences = new Map<Id, Account>([select Id, ParentId from Account where id in :annualConferenceIds]);
        
        // iteratate through contacts updating annual conferences and jurisdictions
        for(Contact contact : newContacts)
        {
            // check if district is null
            if(contact.District__c != null)
            {
                // check if parent (annual conference) is null
                if(districts.get(contact.District__c).ParentId != null)
                {
                    // set the annual conference to the parent id of district
                    contact.Annual_Conference__c = districts.get(contact.District__c).ParentId;
                    
                    // if parent (Jurisdiction) is not null
                    if(districts.get(contact.District__c).Parent.ParentId != null)
                    {
                        // set the jurisdiction
                        contact.Jurisdiction__c = districts.get(contact.District__c).Parent.ParentId;
                    }
                }
            }
            else
            {
                // if annual conference is not null
                if(contact.Annual_Conference__c != null)
                {
                    // set the jurisdiction
                    contact.Jurisdiction__c = annualConferences.get(contact.Annual_Conference__c).ParentId;
                }
            }
        }
    }
    
    /* Raji: 05/13/2011
       Format phone number before insert/update
       Validation rule checks if the format is acceptable
       Raji: 05/17/2011
       Format SSN number before insert/update
       Raji: 07/28/2011
       Salutation Functionality 
     */
    public static void ContactSalutationPhoneSSN(List<Contact> newContacts)
    {
        for (Contact con : newContacts) {
            
            //Phone and SSN
            con.Phone = Util.formatPhone(con.Phone, con.MailingCountry);
            con.Fax = Util.formatPhone(con.Fax, con.MailingCountry);
            con.MobilePhone = Util.formatPhone(con.MobilePhone, con.MailingCountry); 
            con.Emergency_Contact_Number__c= Util.formatPhone(con.Emergency_Contact_Number__c, con.MailingCountry);        
            con.SSN__c = Util.formatSSN(con.SSN__c);
            
            if ((con.Salutation == null ||con.Salutation == 'Missing') && con.Salutation_Other__c == null)
            {
                //Commented out only for migration phase. Rocky Assad 2/1/2012
                //con.Salutation = 'The Rev.';
                //Should Revert back to 'The Rev.',Once migrations are done
                con.Salutation = null;
            }
            else if ((con.Salutation == null||con.Salutation == 'Missing') && con.Salutation_Other__c != null)
            {
                con.Salutation = con.Salutation_Other__c;
                con.Salutation_Other__c = null;
            }
            else if ((con.Salutation != null  ||con.Salutation == 'Missing')&& con.Salutation_Other__c != null)
            {
                con.addError('Salutation Other and First Name : Salutation may not contain values at the same time');
            }
        }
    }
    
    public static void RestrictDistrictType(List<Contact> contacts)
    {   
        // Find all the contacts that have dist super positions
        for(Contact contact : [Select c.Id, (Select Id From Positions__r WHERE Position_Title__c = 'District Superintendent') From Contact c WHERE District__c != null AND c.Id IN :contacts])
        {
            for(Contact con : contacts)
            {
                if(con.Id == contact.Id && !contact.Positions__r.isEmpty())
                {
                    con.District__c.addError('A District Superintendent\'s district is associated with their position. A specific district cannot be associated with a contact record.');
                    break;
                }
            }
        }
    }
    
    public static void ToProperName(List<Contact> newContacts)
    {
        for(Contact contact : newContacts) 
        {
            contact.FirstName = Util.toUpperCase(1, contact.FirstName);
            contact.LastName = Util.toUpperCase(1, contact.LastName);
            contact.Middle_Name__c = Util.toUpperCase(1, contact.Middle_Name__c); 
        }
    }
    
    @future
    public static void ToProperNameAysnc(Set<Id> newContactIds)
    {
        Contact[] contacts = [select Id, FirstName, LastName, Middle_Name__c from Contact where id in :newContactIds];
        
        if(contacts.size() > 0)
        {
            for(Contact contact : contacts) 
            {
                contact.FirstName = Util.toUpperCase(1, contact.FirstName);
                contact.LastName = Util.toUpperCase(1, contact.LastName);
                contact.Middle_Name__c = Util.toUpperCase(1, contact.Middle_Name__c); 
            }
            
            update contacts;
        }
    }
    
    public static void AssociateWithAccount(List<Contact> newContacts)
    {
        Account[] accounts = [SELECT Id FROM Account WHERE Name = 'GBHEM Constituent' limit 1];
        Account account = null;
        
        if(accounts.size() == 0) 
        {
            RecordType recordType = Util.getRecordType('Account', 'Business Account');
            
            account = new Account(Name = 'GBHEM Constituent', RecordTypeId = recordType.Id);
            
            insert account;
        }
        else
        {
            account = accounts[0];
        }
        
        for(Contact contact : newContacts) 
        {   
            contact.AccountId = account.Id;
        }
    }
    
   }
