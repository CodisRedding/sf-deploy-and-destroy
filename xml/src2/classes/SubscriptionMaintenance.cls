global class SubscriptionMaintenance implements schedulable
{
    global void execute(SchedulableContext ctx) 
    {
        // setup
        List<Subscription__c> subscriptions = new List<Subscription__c>();
        Map<Id, List<String>> subReports = new Map<Id, List<String>>();
        
        for(Subscription__c subscription : subscriptions)
        {
            String[] reportsDel = subscription.Mailing_Reports__c.split(';', 0);
            List<String> reports = new List<String>();
            
            for(String report : reportsDel )
            {
                reports.add(report.trim());
            }
            
            subReports.put(subscription.Id, reports);
        }
        
        // start working
        for(Subscription__c subb : subscriptions)
        {
           
        }
    } 
}