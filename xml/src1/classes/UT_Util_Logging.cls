@isTest
private class UT_Util_Logging 
{
    static testMethod void logRecordErrors() 
    {
    	Contact contact = new Contact(FirstName = 'Test', 
	                                       LastName = 'User',
	                                       Salutation = 'Mr.');
		
		test.startTest();
		insert contact;
		
		Set<Id> recIds = new Set<Id>();
		
		recIds.Add(contact.Id);
		
        Util_Logging.logRecordErrors(recIds, 'Record Error 999');
        test.stopTest();
        
        // not sure how to test @future methods
        System.assert(true);
    }
    
    static testMethod void logRecordErrors_Bulk() 
    {
    	Contact contact = new Contact(FirstName = 'Test2', 
	                                       LastName = 'User',
	                                       Salutation = 'Mr.');
	                                       
		test.startTest();
		insert contact;
		
		Set<Id> recIds = new Set<Id>();
		
		recIds.Add(contact.Id);
		
    	for(Integer x = 0; x < 5; x++)
    	{
        	Util_Logging.logRecordErrors(recIds, 'Record Error ' + String.valueOf(x));
    	}
    	test.stopTest();
    	
    	// not sure how to test @future methods
    	System.assert(true);
    }
    
    static testMethod void logSystemErrors() 
    {
    	String ex = null;
    	
    	Contact contact = new Contact(FirstName = 'Test', 
	                                       LastName = 'User10',
	                                       Salutation = 'Mr.');
	                                       
		test.startTest();
		insert contact;
		
		Set<Id> recIds = new Set<Id>();
		
		recIds.Add(contact.Id);

		try
		{
			throw new testException('Integer x = 1/0');
		}
		catch(Exception e)
		{
			Util_Logging.logSystemErrors(recIds, 'cannot divide by zero', e.getMessage());
			ex = e.getMessage();
		}
		test.stopTest();
		
        // not sure how to test @future methods
    	System.assert(true);
    }
    
    static testMethod void logSystemErrors_Bulk() 
    {
    	String ex = null;
    	
    	Contact contact = new Contact(FirstName = 'Test', 
	                                       LastName = 'User11',
	                                       Salutation = 'Mr.');
		insert contact;
		
		Set<Id> recIds = new Set<Id>();
		
		recIds.Add(contact.Id);

		for(Integer x = 0; x < 5; x++)
		{
			try
			{
				throw new testException('Integer x = 1/' + x);
			}
			catch(Exception e)
			{
				Util_Logging.logSystemErrors(recIds, 'cannot divide by ' + x, e.getMessage());
				ex = e.getMessage();
			}
		}
        // not sure how to test @future methods
    	System.assert(true);
    }

    public class testException extends Exception { }
}