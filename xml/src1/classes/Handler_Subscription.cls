public with sharing class Handler_Subscription
{
    /* Rocky Assad
       Make sure that subscription name is unique
    */
    public static void checkUniqueName(List<Subscription__c> newSubscriptions)
    {
        // grab all existing subscriptions
        Set<String> existingNames = new Set<String>();
        for(Subscription__c subscription : [SELECT Name FROM Subscription__c ORDER BY Name])
        {
            existingNames.add(subscription.Name);
        }
        
        // check for duplicate names
        for(Subscription__c subscription : newSubscriptions)
        {
            if(existingNames.contains(subscription.Name))
            {
                subscription.addError('The subscription name \'' + subscription.Name + '\' already exists.');
            } 
        }
    }
 }