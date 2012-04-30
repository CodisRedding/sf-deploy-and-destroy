public with sharing class UT_Handler_Subscriber
{
    private static addSubscribersExtension.SubscriptionManager subscription
    {
        get
        {
            if(subscription == null)
            {
                // contact
                Contact con = new Contact(FirstName = 'Test', LastName = 'Contact');
                insert con ;
                
                // position
                Id posRtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Position__c' AND Name = 'Annual Conference'].Id;
                Position__c pos = new Position__c(RecordTypeId = posRtId, Contact__c = con.Id);
                insert pos;
                
                // organization
                Id accRtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Annual Conference'].Id;
                Account org = new Account(RecordTypeId = accRtId, Name = 'Test Org');
                insert org;

                Subscription__c subscription_temp = new Subscription__c(Name = 'SubscriptionTesting');
                subscription_temp.Mailing_Reports__c = 'TestReport;';
                insert subscription_temp;
                
                subscription = new addSubscribersExtension.SubscriptionManager(subscription_temp);
                
                List<Subscriber__c> subs = new List<Subscriber__c>();
                Subscriber__c sub1 = new Subscriber__c(Contact__c = con.Id, Status__c = 'Opt In');
                Subscriber__c sub2 = new Subscriber__c(Organization__c = org.Id, Status__c = 'Opt In', Sticky__c = true);
                Subscriber__c sub3 = new Subscriber__c(Position__c = pos.Id, Status__c = 'Opt Out', Sticky__c = true);
                
                sub1.Subscription__c = subscription.subscription.Id;
                sub2.Subscription__c = subscription.subscription.Id;
                sub3.Subscription__c = subscription.subscription.Id;
                
                subs.add(sub1);
                subs.add(sub2);
                subs.add(sub3);
                
                insert subs;
            }
            
            return subscription;
        }
        private set;
    }
    
    static testMethod void checkUniqueSubscriber()
    {
        if(subscription != null)
        {
         //
        }
        
        // contact
        Contact[] con = [SELECT Id FROM Contact WHERE FirstName = 'Test' AND LastName = 'Contact'];
        Account[] org = [SELECT Id FROM Account WHERE Name = 'Test Org'];

        Id posRtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Position__c' AND Name = 'Annual Conference'].Id;
        Position__c[] pos = [SELECT Id FROM Position__c WHERE RecordTypeId = :posRtId LIMIT 1];

        List<Subscriber__c> subs = new List<Subscriber__c>();
        Subscriber__c sub1 = new Subscriber__c(Contact__c = con[0].Id, Status__c = 'Opt In');
        Subscriber__c sub2 = new Subscriber__c(Organization__c = org[0].Id, Status__c = 'Opt In', Sticky__c = true);
        Subscriber__c sub3 = new Subscriber__c(Position__c = pos[0].Id, Status__c = 'Opt Out', Sticky__c = true);
        
        sub1.Subscription__c = subscription.subscription.Id;
        sub2.Subscription__c = subscription.subscription.Id;
        sub3.Subscription__c = subscription.subscription.Id;
        
        
        try
        {
            insert sub1;
        }
        catch(DmlException e)
        {
             System.assert( e.getMessage().contains('Contact already exists in this subscription'), e.getMessage());
        }
        
        try
        {
            insert sub2;
        }
        catch(DmlException e)
        {
             System.assert( e.getMessage().contains('Organization already exists in this subscription'), e.getMessage());
        }
        
        try
        {
            insert sub3;
        }
        catch(DmlException e)
        {
             System.assert( e.getMessage().contains('Position already exists in this subscription'), e.getMessage());
        }
    }
}