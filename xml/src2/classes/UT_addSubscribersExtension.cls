@isTest(SeeAllData=true)
public class UT_addSubscribersExtension
{
    private static User dataAdminUser
    {
        get
        {
            if(dataAdminUser == null)
            {
                Profile profile = [select id from profile where name='Data Administrator' limit 1]; 
                dataAdminUser = new User(alias = 'testd1', 
                                          email='test1@test.com',
                                          emailencodingkey='UTF-8', 
                                          lastname='test', 
                                          languagelocalekey='en_US',
                                          localesidkey='en_US', 
                                          profileid = profile.Id,
                                          timezonesidkey='America/Chicago', 
                                          username='test_subs1@test.com');
            }
            
            return dataAdminUser;
        }
        private set;
    }
    
    private static User sysAdminUser
    {
        get
        {
            if(sysAdminUser == null)
            {
                Profile profile = [select id from profile where name='System Administrator' limit 1]; 
                sysAdminUser = new User(alias = 'testd2', 
                                          email='test2@test.com',
                                          emailencodingkey='UTF-8', 
                                          lastname='test', 
                                          languagelocalekey='en_US',
                                          localesidkey='en_US', 
                                          profileid = profile.Id,
                                          timezonesidkey='America/Chicago', 
                                          username='test_subs2@test.com');
            }
            
            return sysAdminUser;
        }
        private set;
    }
    
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
    
    private static Pagereference pageRef
    {
        get
        {
            if(pageRef == null)
            {
                pageRef = Page.AddSubscribers;
            }
            
            return pageRef;
        }
        
        private set;
    }
    
    static testMethod void page_getReports()
    {
        Test.setCurrentPage(pageRef);
        
        List<addSubscribersExtension.ReportWrapper> reports;
        ApexPages.StandardController sc;
        addSubscribersExtension extension;
        
        System.runAs(sysAdminUser)
        {
            // make sure no folder warning is thrown
            ApexPages.currentPage().getParameters().put('d_fldcnt', '0');
            sc = new ApexPages.StandardController(subscription.subscription);
            extension = new addSubscribersExtension(sc);
            reports = extension.getReports();
        }
        
        System.assertEquals(null, reports);
        
        System.runAs(sysAdminUser)
        {
            // make sure no reports warning is thrown
            ApexPages.currentPage().getParameters().put('d_fldcnt', '');
            ApexPages.currentPage().getParameters().put('d_rptcnt', '0');
            sc = new ApexPages.StandardController(subscription.subscription);
            extension = new addSubscribersExtension(sc);
            reports = extension.getReports();
        }
        
        System.assertEquals(null, reports);
        
        System.runAs(sysAdminUser)
        {
            // clear url params
            ApexPages.currentPage().getParameters().put('d_fldcnt', '');
            ApexPages.currentPage().getParameters().put('d_rptcnt', '');
            
            // check the rest of the code and that 1 report exists
            sc = new ApexPages.StandardController(subscription.subscription);
            extension = new addSubscribersExtension(sc);
            reports = extension.getReports();
        }
           
        System.assertEquals(1, reports.size());
        
        System.runAs(sysAdminUser)
        {
            Subscriber__c[] con = [SELECT Id, Contact__c FROM Subscriber__c WHERE Contact__c != NULL AND Subscription__c = :subscription.subscription.Id LIMIT 1];
            Subscriber__c[] org = [SELECT Id, Organization__c FROM Subscriber__c WHERE Organization__c != NULL AND Subscription__c = :subscription.subscription.Id LIMIT 1];
            Subscriber__c[] pos = [SELECT Id, Position__c FROM Subscriber__c WHERE Position__c != NULL AND Subscription__c = :subscription.subscription.Id LIMIT 1];
            
            // select a report
            ApexPages.currentPage().getParameters().put('d_csv', '1');
            ApexPages.currentPage().getParameters().put('d_fldcnt', '');
            ApexPages.currentPage().getParameters().put('d_rptcnt', '');
            ApexPages.currentPage().getParameters().put('d_con', con[0].Contact__c);
            ApexPages.currentPage().getParameters().put('d_org', org[0].Organization__c);
            ApexPages.currentPage().getParameters().put('d_pos', pos[0].Position__c);
            ApexPages.currentPage().getParameters().put('sid', con[0].Id);
            
            sc = new ApexPages.StandardController(subscription.subscription);
            extension = new addSubscribersExtension(sc);
            extension.getReports();
            extension.reports[0].selected = true;
            extension.reportSelected();
            
            List<addSubscribersExtension.SubscriberWrapper> subs1 = extension.getSubscribers();
            for(addSubscribersExtension.SubscriberWrapper s : subs1 )
            {
                if(s.subscriber.Id == con[0].Id)
                {
                    s.subscriber.Quantity__c = '5';
                }
            }

            extension.subscriberSelected();
            
            List<addSubscribersExtension.SubscriberWrapper> subs2 = extension.getSubscribers();
            for(addSubscribersExtension.SubscriberWrapper s : subs2)
            {
                if(s.subscriber.Id == con[0].Id)
                {
                    System.assertEquals('5', s.subscriber.Quantity__c);
                    System.assertEquals(true, s.subscriber.Sticky__c);
                    s.subscriber.Sticky__c = false;
                }
            }
            
            extension.subscriberSelected();
        }
        
        System.assertEquals(1, extension.subscription.selectedReports.size());
    }
    
    static testMethod void page_searchSubscribers()
    {
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(subscription.subscription);
        addSubscribersExtension extension = new addSubscribersExtension(sc);
        
        PageReference ref = null; 
        List<addSubscribersExtension.SubscriberWrapper> subscribers;
        System.runAs(dataAdminUser)
        {
            extension.searchFilter = 'Test';
            ref = extension.searchSubscribers();
            subscribers = extension.getSubscribers();
        }
        
        System.assertEquals(null, ref);
        System.assertEquals(2, subscribers.size());
    }
    
    static testMethod void page_getSubscribers()
    {
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(subscription.subscription);
        addSubscribersExtension extension = new addSubscribersExtension(sc);
        
        List<addSubscribersExtension.SubscriberWrapper> subscribers;
        System.runAs(dataAdminUser)
        {
            subscribers = extension.getSubscribers();
        }
        
        System.assertEquals(3, subscribers.size());
    }
    
    static testMethod void page_getSubscriberStatuses()
    {
        Test.setCurrentPage(pageRef);
        
        System.runAs(sysAdminUser)
        {
            // make sure no folder warning is thrown
            ApexPages.StandardController sc = new ApexPages.StandardController(subscription.subscription);
            addSubscribersExtension extension = new addSubscribersExtension(sc);
            
            List<SelectOption> opts = subscription.getSubscriberStatuses();

            System.assertEquals('Opt In', opts[0].getValue());
            System.assertEquals('Opt Out', opts[1].getValue());
            
            opts = subscription.getSubscriberStatuses();

            System.assertEquals('Opt In', opts[0].getValue());
            System.assertEquals('Opt Out', opts[1].getValue());
        }
    }
    
    static testMethod void page_getSubscriberQuantities()
    {
        Test.setCurrentPage(pageRef);
        
        System.runAs(sysAdminUser)
        {
            // make sure no folder warning is thrown
            ApexPages.StandardController sc = new ApexPages.StandardController(subscription.subscription);
            addSubscribersExtension extension = new addSubscribersExtension(sc);
            
            List<SelectOption> qtys = subscription.getSubscriberQuantities();

            System.assertEquals('1', qtys[0].getValue());
            System.assertEquals('2', qtys[1].getValue());
            System.assertEquals('3', qtys[2].getValue());
            System.assertEquals('4', qtys[3].getValue());
            System.assertEquals('5', qtys[4].getValue());
            System.assertEquals('6', qtys[5].getValue());
            System.assertEquals('7', qtys[6].getValue());
            System.assertEquals('8', qtys[7].getValue());
            System.assertEquals('9', qtys[8].getValue());
            System.assertEquals('10', qtys[9].getValue());
            
            qtys = subscription.getSubscriberQuantities();

            System.assertEquals('1', qtys[0].getValue());
            System.assertEquals('2', qtys[1].getValue());
            System.assertEquals('3', qtys[2].getValue());
            System.assertEquals('4', qtys[3].getValue());
            System.assertEquals('5', qtys[4].getValue());
            System.assertEquals('6', qtys[5].getValue());
            System.assertEquals('7', qtys[6].getValue());
            System.assertEquals('8', qtys[7].getValue());
            System.assertEquals('9', qtys[8].getValue());
            System.assertEquals('10', qtys[9].getValue());
        }
    }
    
    static testMethod void page_navigate()
    {
        Test.setCurrentPage(pageRef);
        
        System.runAs(sysAdminUser)
        {
            // make sure no folder warning is thrown
            ApexPages.StandardController sc = new ApexPages.StandardController(subscription.subscription);
            addSubscribersExtension extension = new addSubscribersExtension(sc);

            System.assertEquals(false, subscription.hasNext);
            subscription.next();
            subscription.last();
            subscription.previous();
            System.assertEquals(false, subscription.hasPrevious);
            subscription.first();
            System.assertEquals(1, subscription.pageNumber);
        }
    }
}