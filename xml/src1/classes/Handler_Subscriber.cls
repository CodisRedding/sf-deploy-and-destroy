public with sharing class Handler_Subscriber
{
    /* Rocky Assad
       Make sure that subscribers are unique
    */
    public static void checkUniqueSubscriber(List<Subscriber__c> newSubscribers)
    {
        Set<Id> subscriberIds = new Set<Id>();
        Set<Id> subscriptionIds = new Set<Id>();
        
        for(Subscriber__c subscriber : newSubscribers)
        {
            subscriptionIds.add(subscriber.Subscription__c);
            if(subscriber.Contact__c != null)
            {
                subscriberIds.add(subscriber.Contact__c);
                break;
            }
            else if(subscriber.Organization__c != null)
            {
                subscriberIds.add(subscriber.Organization__c);
                break;
            }
            else if(subscriber.Position__c != null)
            {
                subscriberIds.add(subscriber.Position__c);
                break;
            }
        }
        
        for(List<Subscriber__c> extSubs : [SELECT Id, Subscription__c, Contact__c, Organization__c, Position__c FROM Subscriber__c WHERE (Organization__c IN :subscriberIds OR Position__c IN :subscriberIds OR Contact__c IN :subscriberIds) AND Subscription__c IN :subscriptionIds])
        {
            for(Subscriber__c extSub : extSubs)
            {
                Boolean exists = false;
                for(Integer i = 0; i < newSubscribers.size(); i++)
                {
                    if(newSubscribers.get(i).Contact__c != null && 
                       newSubscribers.get(i).Contact__c == extSub.Contact__c && 
                       newSubscribers.get(i).Subscription__c == extSub.Subscription__c)
                    {
                        newSubscribers.get(i).addError('Contact already exists in this subscription.');
                        break;
                    }
                    else if(newSubscribers.get(i).Organization__c != null && 
                            newSubscribers.get(i).Organization__c == extSub.Organization__c && 
                            newSubscribers.get(i).Subscription__c == extSub.Subscription__c)
                    {
                        newSubscribers.get(i).addError('Organization already exists in this subscription.');
                        break;
                    }
                    else if(newSubscribers.get(i).Position__c != null && 
                            newSubscribers.get(i).Position__c == extSub.Position__c && 
                            newSubscribers.get(i).Subscription__c == extSub.Subscription__c)
                    {
                        newSubscribers.get(i).addError('Position already exists in this subscription.');
                        break;
                    }
                }
            }
        }
    }
 }