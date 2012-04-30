@isTest
private class UT_Education_Information_Licensing 
{

    static testMethod void Education_Information_Licensing_School_Single() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        Contact contact = new Contact(Email = 'test@test.com', 
        							  FirstName = 'Rocky', 
        							  LastName = 'Assad_01',
        							  Salutation = 'Mr.');
        							  
        Account[] school = [SELECT Id FROM Account WHERE Name = 'Non-Licensing School'];
        
        if(school.size() == 0)
        {
        	Account act = new Account(Name = 'Non-Licensing School');
        	insert act;
        	
        	school = [SELECT Id FROM Account WHERE Name = 'Non-Licensing School'];
        }
        
        Education_Information__c ed = new Education_Information__c();
        
        insert contact;
        
        ed.Education_Detail__c = contact.Id;
        ed.Education_Type__c = 'Licensing';
        ed.School__c = school[0].Id;
        
        try
        {
        	test.startTest();
        	
        	insert ed;
        }
        catch(DmlException e)
        {
			//Assert Error Message
			System.assert(e.getMessage().contains('Licensing Program not offered for this school'), e.getMessage());
        }
        finally
        {
        	test.stopTest();
        }
    }
}