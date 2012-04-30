public with sharing class UT_Handler_Subscription
{

    static testMethod void checkUniqueName()
    {
        Subscription__c subscription_temp = new Subscription__c(Name = 'SubscriptionTesting');
        insert subscription_temp;

        Subscription__c subscription_temp2 = new Subscription__c(Name = 'SubscriptionTesting');
        
        try
        {
            insert subscription_temp2 ;
        }
        catch(DmlException e)
        {
             System.assert( e.getMessage().contains('The subscription name \'SubscriptionTesting\' already exists'), e.getMessage());
        }

    }
}