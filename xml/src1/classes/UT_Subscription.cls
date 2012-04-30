@isTest(SeeAllData=true)
private class UT_Subscription 
{
    static testMethod void testInsert() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        Subscription__c sub1 = new Subscription__c(Name = 'TestName');
        Subscription__c sub2 = new Subscription__c(Name = 'TestName');
        
        
        test.startTest();
        
        insert sub1;
        
        try 
        {
            insert sub2;
        } 
        catch(DmlException ex) 
        {
            System.assert(ex.getMessage().contains('already exists.'), ex.getMessage());
        } 
        finally 
        {
            // Stop the test, this changes limit context back to test from trigger.
            test.stopTest();
        }
    }
}