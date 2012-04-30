public with sharing class Handler_Account
{
    /*Raji : 06.14.2011
    Updated : 08.02.2011
      Functionality : To Update Jurisdiction Lookup Field depending on Annual conference Lookup 
      for Local Church, Collegiate Ministry & School Record Types
      To Update Annual Conference and Jursdiction For District Record Type.
    */
    // Rocky Assad
    /*
    public static void UpdateACandJDDistrict(List<Account> newAccounts)
    {
        // Rocky Assad
        // 10/28/2011
        // Not Used
        //Set<Id> AccountIds = new Set<id>();
        RecordType AccountSchool = Util.getRecordType('Account', 'Educational Institutions');
        RecordType AccountDistrict = Util.getRecordType('Account', 'District');
        RecordType AccountCollegiate = Util.getRecordType('Account', 'Collegiate Ministry');
        RecordType AccountChurch = Util.getRecordType('Account', 'Local Church');
        
        // Rocky Assad
        // 10/28/2011
        // Not Used
        //Account[] account = [Select Id From Account Where Id IN : AccountIds];
        
        // Rocky Assad
        // 10/28/2011
        // This is not right. You're passing in the same array that you're 
        // iterating through. And even if it wasn't the array and it was the
        // iterator, it still wouldn't work because it would still cause too many 
        // queries for a single transaction since it queries and updates within a
        // for-loop. 
        // --
        // This should be an async method called in the AFTER event 
        // and it shouldn't update in a for-loop, instead it should update
        // in a single transaction. 
        // I'm creating a defect for this and commenting it out
        
        for (Account newAccount : newAccounts)
        {  
            if(newAccount.RecordTypeId == AccountDistrict.Id)
            {
                // Rocky Assad
                // 10/28/2011
                // This function does essentially the same exact thing as
                // newAccount.Jurisdiction__c = newAccount.ParentAccount.ParentId;
                // does and with out calling an update on itself as well.
                UpdateAccount_AC_JD_District.DistrictUpdateAccount(newAccounts);
            }
            else if(newAccount.RecordTypeId == AccountSchool.Id || newAccount.RecordTypeId == AccountCollegiate.Id || 
                    newAccount.RecordTypeId == AccountChurch.Id)
            {
                // Rocky Assad
                // 10/28/2011
                // This function is essentially th same thing as the one above
                // except checks the Annual Conference varible instead of ParentAccount     
                UpdateAccount_AC_JD_District.UpdateAccount_AC_JD(newAccounts);
            }   
        }
    } 
    */
    
    public static void UpdateACandJDDistrict(List<Account> newAccounts)
    {
        RecordType school = Util.getRecordType('Account', 'Educational Institutions');
        RecordType district = Util.getRecordType('Account', 'District');
        RecordType collegiate = Util.getRecordType('Account', 'Collegiate Ministry');
        RecordType church = Util.getRecordType('Account', 'Local Church');
        
        // all parents and annual conferences
        Set<Id> parentIds = new Set<Id>();
        Set<Id> annualConferenceIds = new Set<Id>();
        for(Account newAccount : newAccounts)
        {
            if(newAccount.ParentId != null)
            {
                parentIds.add(newAccount.ParentId);
            }
            
            if(newAccount.Annual_Conference__c != null)
            {
                annualConferenceIds.add(newAccount.Annual_Conference__c);
            }
        }
        
        Map<Id, Account> parents = new Map<Id, Account>([select Id, ParentId from Account where id in :parentIds]);
        Map<Id, Account> annualConferences = new Map<Id, Account>([select Id, ParentId from Account where id in :annualConferenceIds]); 
        
        for(Account newAccount : newAccounts)
        {
            System.debug('newAccount.Name: ' + newAccount.Name + ' 1');
            if(newAccount.RecordTypeId == district.Id)
            {
                System.debug('newAccount.Name: ' + newAccount.Name + ' 1.a');
                // parent is annual conference
                if(newAccount.ParentId != null)
                {
                    System.debug('newAccount.Name: ' + newAccount.Name + ' 1.b');
                    // grand-parent is jurisdiction
                    newAccount.Jurisdiction__c = parents.get(newAccount.ParentId).ParentId;
                    
                    System.debug('newAccount.Name: ' + newAccount.Name + ' 1.b: ' + newAccount.Jurisdiction__c);
                }
                else
                {
                    System.debug('newAccount.Name: ' + newAccount.Name + ' 1.c');
                }
            }
            else if(newAccount.RecordTypeId == school.Id || newAccount.RecordTypeId == collegiate.Id || 
                    newAccount.RecordTypeId == church.Id)
            {
                System.debug('newAccount.Name: ' + newAccount.Name + ' 2');
                if(newAccount.Annual_Conference__c != null)
                {
                    System.debug('newAccount.Name: ' + newAccount.Name + ' 2.a');
                    // annual conference parent is jurisdiction
                    newAccount.Jurisdiction__c = annualConferences.get(newAccount.Annual_Conference__c).ParentId;
                    
                    System.debug('newAccount.Name: ' + newAccount.Name + ' 2.a: ' + annualConferences.get(newAccount.Annual_Conference__c).ParentId);
                }
                else
                {
                    System.debug('newAccount.Name: ' + newAccount.Name + ' 2.b');
                }
            }
            else
            {
                System.debug('newAccount.Name: ' + newAccount.Name + ' 0.0');
            }
        }
    }

    /* Raji Created : 06.08.2011
        updated : 07.17.2011
     Accout: Affiliation
    */
    public static void OrganizationSchoolAffiliation(List<Account> newAccounts)
    {
        RecordType AccountSchool = Util.getRecordType('Account', 'Educational Institutions');
        RecordType AccountJurisdiction = Util.getRecordType('Account', 'Jurisdiction');
        RecordType AccountAConference = Util.getRecordType('Account', 'Annual Conference');
            
        for(Account account : newAccounts)
        {
            if(account.RecordTypeId == AccountSchool.Id)
            {
                if (account.Affiliation__c != null)
                {
                    System.debug('Name: ' + account.Name + ' Value: ' + account.Affiliation__c);
                    if ((account.Affiliation__c.Contains('Private') || account.Affiliation__c.Contains('BCF') || account.Affiliation__c.Contains('UM-Related')) 
                        && account.Affiliation__c.Contains('Public'))
                    {
                        account.addError(' In Affiliation the Value Public should not be combined with Private, UM-Related or BCF');    
                    }
                    else if (account.Affiliation__c.Contains('BCF'))
                    {
                        account.Affiliation__c = 'Private;HBCU; UM-Related ; BCF';
                    }
                    else if (account.Affiliation__c.Contains('UM-Related'))
                    {
                        account.Affiliation__c = 'UM-Related ; NASCUMC;IAMSCU';
                    }
                    
                    else if (account.Affiliation__c.Contains('NASCUMC'))
                    {
                        account.Affiliation__c = 'NASCUMC ; Private; UM-Related ';
                    }
                   /* else if (account.Affiliation__c.Contains('AUMTS'))
                    {
                        account.Affiliation__c = 'AUMTS; UM-Related; Private';
                    }*/
                    else if (account.Institution_Type__c != 'Seminary/Theological' && account.Affiliation__c.Contains('UM-Related'))
                    {
                        account.Affiliation__c = 'Private; UM-Related ';
                    }
                    else if (account.Institution_Type__c == 'Seminary/Theological' && account.Affiliation__c.Contains('UM-Related'))
                    {
                        account.Affiliation__c = 'AUMTS; UM-Related; Private';
                    }
                }
            }
        } 
    }
    
    /* Rocky: 05/26/2011
        Restricts GBHEM Account from ever being deleted. Not even Admins can delete this.
    */
    public static void RestrictGBHEMConstitRemove(List<Account> oldAccounts)
    {
        // Restrict Contact base Account from being deleted.
        for(Account account : oldAccounts) {
            
            if(account.Name == 'GBHEM Constituent') {
                
                account.Name.addError(String.format('Cannot delete account: {0}', new String[] { account.Name }));
            }
        }
    }
  
    
}