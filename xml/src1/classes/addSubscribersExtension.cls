public class addSubscribersExtension
{
    public final SubscriptionManager subscription { get; set; }
    public List<ReportWrapper> reports { get; set; }
    public String searchFilter { get; set; }   
    
    public addSubscribersExtension(ApexPages.StandardController stdController) 
    {
        this.subscription = new SubscriptionManager((Subscription__c)stdController.getRecord());
        this.subscription.selectedReports = new List<ReportWrapper>();
        System.debug('page load');
    }
    
    public List<SubscriberWrapper> getSubscribers()
    {
        return this.subscription.getSubscribers();
    }
    
    public List<ReportWrapper> getReports()
    {
        String d_fldcnt = System.currentPageReference().getParameters().get('d_fldcnt');
        String d_rptcnt = System.currentPageReference().getParameters().get('d_rptcnt');
        
        if(this.reports != null)
        {
            return this.reports;
        }
        else
        {
            this.reports = new List<ReportWrapper>();
        }
        
        List<String> selReports = (this.subscription.subscription.Mailing_Reports__c != null) ? this.subscription.subscription.Mailing_Reports__c.split(';') : new List<String>();
        //List<String> selReports = this.subscription.subscription.Mailing_Reports__c.split(';');
        
        String subName = this.subscription.subscription.Name;
        Integer folderCount = [SELECT COUNT() FROM Folder WHERE Name = :subName];
        
        if(folderCount == 0 || d_fldcnt == '0')
        {
            ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'A report folder named ' + subName + ' must be created before you can add subscibers from reports. You can still add subscribers manually by clicking Add Subscriber below.'));
            return null;
        }
        
        Integer reportCount = [SELECT COUNT() FROM Report WHERE OwnerId IN (SELECT Id FROM Folder WHERE Name = :subName)];
        
        if(reportCount == 0 || d_rptcnt == '0')
        {
            ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There are no reports in the ' + subName + ' reports folder. You can still add subscribers manually by clicking Add Subscriber below.'));
            return null;
        }
        
        for(Report report : [SELECT Id, Name FROM Report WHERE OwnerId IN (SELECT Id FROM Folder WHERE Name = :subName) ORDER BY Name])
        {
            ReportWrapper reportWrap = new ReportWrapper(report);
            
            for(String rep : selReports)
            {
                if(rep == report.Name)
                {
                    reportWrap.selected = true;
                }
            }
            
            this.reports.add(reportWrap);
        }
        
        return this.reports;
    }
    
    public PageReference searchSubscribers()
    {
        this.subscription.searchFilter = this.searchFilter;

        return null;
    }
    
    public void updateSelectedReports()
    {
        List<ReportWrapper> reportsToKeep = new List<ReportWrapper>();
        
        for(ReportWrapper report : this.reports)
        {
            if(report.selected)
            {
                reportsToKeep.add(report);
                
                if(this.subscription.subscription.Mailing_Reports__c == null)
                {
                    this.subscription.subscription.Mailing_Reports__c = report.report.Name + ';';
                }
                else if(!this.subscription.subscription.Mailing_Reports__c.contains(report.report.Name))
                {
                    this.subscription.subscription.Mailing_Reports__c += report.report.Name + ';';
                }
            }
        }

        this.subscription.selectedReports.clear();
        this.subscription.selectedReports.addAll(reportsToKeep);
        //reportsToKeep = null;
    }
    
    public PageReference reportSelected()
    {   
        this.subscription.searchFilter = this.searchFilter = '';
        this.subscription.subscription.Mailing_Reports__c = '';
        
        updateSelectedReports();
        
        this.subscription.addSubscribersFromReports();
        
        if(this.subscription.selectedReports.size() > 0)
        {
            ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, this.subscription.selectedReports.size() + ' report(s) selected'));
        }
        
        update this.subscription.subscription;
        return null;
    }
    
    public PageReference subscriberSelected()
    {
        String sid = System.currentPageReference().getParameters().get('sid');
        updateSelectedReports();
        
        if(sid != '')
        {
            for(SubscriberWrapper sub : this.subscription.subscribers)
            {   
                if(sub.subscriber.Id == sid)
                {
                    Boolean updateSub = false;
                    
                    // if subscriber's status is opt out and is not sticky 
                    if(sub.subscriber.status__c == 'Opt In' && !sub.subscriber.sticky__c)
                    {
                        // if subscriber is not in a selected report then remove from subscription
                        Boolean inReport = false;
                        
                        // mark subscriber as sticky if quantity is to be tracked
                        if(sub.subscriber.Quantity__c != '1')
                        {
                            String stickyclicked = System.currentPageReference().getParameters().get('stickyclicked');
                            
                            if(stickyclicked != null && stickyclicked == '1')
                            {
                                sub.subscriber.Quantity__c = '1';
                            }
                            else
                            {
                                sub.subscriber.sticky__c = true;
                            }
                        }
                        
                        ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'this.subscription.selectedReports  : ' + this.subscription.selectedReports.size()));
                        
                        List<SubscriberWrapper> subsFromReports = new List<SubscriberWrapper>();
                        for(ReportWrapper report : this.subscription.selectedReports)
                        {
                            List<SubscriberWrapper> tmp = report.getSubscribers(this.subscription.subscription);
                            
                            if(tmp != null)
                            {
                                subsFromReports.addAll(tmp);
                            }
                        }
                        
                        for(SubscriberWrapper sub2 : subsFromReports)
                        {
                            if((sub2.subscriber.Contact__c != null && sub2.subscriber.Contact__c == sub.subscriber.Contact__c) || 
                                (sub2.subscriber.Organization__c  != null && sub2.subscriber.Organization__c == sub.subscriber.Organization__c) || 
                                (sub2.subscriber.Position__c != null && sub2.subscriber.Position__c == sub.subscriber.Position__c))
                            {
                                inReport = true;
                                break;
                            }
                        }
                        
                        if(!inReport)
                        {
                            delete [SELECT Id FROM Subscriber__c WHERE Id = :sid];
                            
                            for(Integer i = 0; i < this.subscription.subscribers.size(); i++)
                            {
                                if(this.subscription.subscribers.get(i).subscriber.Id == sid)
                                {
                                    this.subscription.subscribers.remove(i);
                                    break;
                                }
                            }
                            
                            this.subscription.recordDeleted = true;
                            ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Removed Subscriber'));
                            break;
                        }
                        else
                        {
                            updateSub = true;
                        }
                    }
                    else
                    {  
                        updateSub = true;
                    }
                    
                    if(updateSub)
                    {
                        update sub.subscriber;
                        ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Updated Subscriber'));
                        break;
                    }
                }
            }
        }
        
        return null;
    }

    // Wrapper class for Report
    public class ReportWrapper
    {
        public Report report { get; private set; }
        public Boolean selected { get; set; }
        
        public ReportWrapper(Report report)
        {
            this.report = report;
            this.selected = false;
        }
        
        public List<SubscriberWrapper> getSubscribers(Subscription__c subscription)
        {
            String d_csv = System.currentPageReference().getParameters().get('d_csv');
            String d_con = System.currentPageReference().getParameters().get('d_con');
            String d_org = System.currentPageReference().getParameters().get('d_org');
            String d_pos = System.currentPageReference().getParameters().get('d_pos');
            
            List<SubscriberWrapper> subscribers = new List<SubscriberWrapper>();
            CSVParser parser;
            
            if(d_csv == '1')
            {
                String content = '';
                
                content += '"CONTACT ID","ORGANIZATION ID","POSITION ID"\n';
                content += '"' + d_con + '","' + d_org + '","' + d_pos + '"\n';
                
                parser = new CSVParser(content);
            }
            else
            {
                PageReference page = new PageReference('/' + this.report.Id + '?export=1&enc=UTF-8&xf=csv');
                parser = new CSVParser(page.getContent().toString());
            }
            
            List<String[]> csv = parser.parse();
            
            if(csv == null)
            {
                return null;
            }
            
            for(Integer i = 0; i < csv.size() - 1; i++)
            {
                try
                {
                    if(csv.get(i)[parser.CONTACT] != null)
                    {
                        subscribers.add(new SubscriberWrapper(new Subscriber__c(Contact__c = (Id)csv.get(i)[parser.CONTACT], Subscription__c = subscription.Id, Sticky__c = false)));
                    }
                }
                catch(TypeException exp) { }
                
                try
                {
                    if(csv.get(i)[parser.ORGANIZATION] != null)
                    {
                        subscribers.add(new SubscriberWrapper(new Subscriber__c(Organization__c = (Id)csv.get(i)[parser.ORGANIZATION], Subscription__c = subscription.Id, Sticky__c = false)));
                    }
                }
                catch(TypeException exp) { }
                
                try
                {
                    if(csv.get(i)[parser.POSITION] != null)
                    {
                        subscribers.add(new SubscriberWrapper(new Subscriber__c(Position__c = (Id)csv.get(i)[parser.POSITION], Subscription__c = subscription.Id, Sticky__c = false)));
                    }
                }
                catch(TypeException exp) { }
            }
            
            return subscribers;
        }
    }
    
    public class SubscriptionManager
    {
        public Subscription__c subscription { get; set; }
        public List<SubscriberWrapper> subscribers { get; set; }
        public List<ReportWrapper> selectedReports { get; set; }
        public List<SelectOption> subscriberQuantities;
        public List<SelectOption> subscriberStatuses;
        public Boolean recordDeleted = false;
        private Boolean filterChanged = false;
        
        public String searchFilter 
        { 
            get;
            set
            {
                //filterChanged = (value != searchFilter && value != '' && value != null);
                filterChanged = (value != searchFilter);
                searchFilter = value;
            }
        }
        
        public SubscriptionManager(Subscription__c subscription)
        {
            this.subscription = [SELECT Id, Mailing_Reports__c, Name FROM Subscription__c WHERE Id = :subscription.Id];            
        }
        
        public List<SelectOption> getSubscriberStatuses()
        {
            if(this.subscriberStatuses != null)
            {
                return this.subscriberStatuses;
            }
            
            this.subscriberStatuses = new List<SelectOption>();
            this.subscriberStatuses.add(new SelectOption('Opt In', 'Opt In'));
            this.subscriberStatuses.add(new SelectOption('Opt Out', 'Opt Out'));
            
            return this.subscriberStatuses;
        }
        
        public List<SelectOption> getSubscriberQuantities()
        {
            if(this.subscriberQuantities != null)
            {
                return this.subscriberQuantities;
            }
            
            this.subscriberQuantities = new List<SelectOption>();
            
            String[] quantites = new String[] { '1', '2', '3', '4', '5', '6', '7', '8', '9', '10' };
            for(String quantity : quantites)
            {
                this.subscriberQuantities.add(new SelectOption(quantity, quantity));
            }
            
            return this.subscriberQuantities;
        }
        
        public ApexPages.StandardSetController conn
        {
            get
            {
                if(this.conn == null || this.recordDeleted || this.filterChanged)
                {
                    this.recordDeleted = false;
                    
                    String filter = '';
                    String orderBy = '';
                    if(this.searchFilter != '' && this.searchFilter != null)
                    {
                        filter = ' AND (Contact__r.Name LIKE \'%' + this.searchFilter + '%\'';
                        filter += ' OR Organization__r.Name LIKE \'%' + this.searchFilter + '%\'';
                        filter += ' OR Position__r.Position_Title__c LIKE \'%' + this.searchFilter + '%\')';
                        
                        //ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, filter));
                        //filter = '';
                    }
                    
                    orderBy = ' ORDER BY SortName__c';
                                        
                    String query = 'SELECT Id, SortName__c, Sticky__c, Quantity__c, Status__c, Contact__r.Name, Organization__r.Name, Position__r.Position_Title__c FROM Subscriber__c WHERE Subscription__c = \'' + this.subscription.Id + '\'';
                    query += filter + orderBy;
                    
                    //ApexPAges.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, query));
            
                    this.conn = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                    this.conn.setPageSize(10);
                }
                
                return this.conn;
            }
            private set;
        }

        public List<SubscriberWrapper> getSubscribers()
        {
            this.subscribers = new List<SubscriberWrapper>();

            // Get all current subscribers from subscription
            List<Subscriber__c> subs = this.conn.getRecords();
            for(Subscriber__c subscriber : subs)
            {
                this.subscribers.add(new SubscriberWrapper(subscriber));
            }

            return this.subscribers;
        }
        
        public void addSubscribersFromReports()
        {
            Boolean subExists = false;
            
            // remove all subscribers that were not manually added (this is done since a report can be de-selected)
            delete [SELECT Id FROM Subscriber__c WHERE Subscription__c = :this.subscription.Id AND (Sticky__c = false AND Status__c = 'Opt In')];
    
            List<SubscriberWrapper> subsFromReportAll = new List<SubscriberWrapper>();
            List<Subscriber__c> insertNewSubs = new List<Subscriber__c>();
    
            // iterate through all selected reports
            List<SubscriberWrapper> subsFromReport = new List<SubscriberWrapper>();
            Set<Id> ids = new Set<Id>();

            for(ReportWrapper report : this.selectedReports)
            {
                List<SubscriberWrapper> tmp = report.getSubscribers(this.subscription);
                
                if(tmp != null)
                {
                    subsFromReport.addAll(tmp);
                }
            }
            
            for(SubscriberWrapper sub : subsFromReport)
            {
                ids.add((sub.subscriber.Contact__c == null) ? ((sub.subscriber.Organization__c == null) ? sub.subscriber.Position__c : sub.subscriber.Organization__c) : sub.subscriber.Contact__c);
            }
            
            if(ids.size() > 0)
            {
                List<Subscriber__c> currentSubs = [SELECT Id, Contact__c, Organization__c, Position__c FROM Subscriber__c WHERE Subscription__c = :this.subscription.Id AND (Organization__c IN :ids OR Position__c IN :ids OR Contact__c IN :ids)];
                Map<Id, String> rep = new Map<Id, String>();
        
                // iterate through all subscribers in this report
                for(SubscriberWrapper sub : subsFromReport)
                {
                    // iterate through all subscribers already in this subscription
                    subExists = false;
                    for(Subscriber__c currentSub : currentSubs)
                    {
                        // check if subsriber already exists
                        if((currentSub.Contact__c != null && sub.subscriber.Contact__c == currentSub.Contact__c) || 
                           (currentSub.Organization__c != null && sub.subscriber.Organization__c == currentSub.Organization__c) || 
                           (currentSub.Position__c != null && sub.subscriber.Position__c == currentSub.Position__c))
                        {
                            subExists = true;
                            break;
                        }
                    }
                    
                    if(sub.subscriber.Id == null && !subExists)
                    {
                        if(!rep.containsKey((sub.subscriber.Contact__c == null) ? ((sub.subscriber.Organization__c == null) ? sub.subscriber.Position__c : sub.subscriber.Organization__c) : sub.subscriber.Contact__c))
                        {
                            rep.put((sub.subscriber.Contact__c == null) ? ((sub.subscriber.Organization__c == null) ? sub.subscriber.Position__c : sub.subscriber.Organization__c) : sub.subscriber.Contact__c, '');
                            insertNewSubs.add(sub.subscriber);
                        }
                    }
                }
            }
    
            if(insertNewSubs.size() > 0)
            {
                insert insertNewSubs;
                
                //Integer lim = Limits.getScriptStatements();
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'script statements: ' + lim));
            }
            
            Integer cnt = [SELECT COUNT() FROM Subscriber__c WHERE Subscription__c = :this.subscription.Id];
            this.recordDeleted = true;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, this.selectedReports.size() + ' report(s) selected'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, cnt + ' total subscriber(s)'));
        }
        
        // indicates whether there are more records after the current page set.
        public Boolean hasNext 
        {
            get 
            {
                return this.conn.getHasNext();
            }
            set;
        }
     
        // indicates whether there are more records before the current page set.
        public Boolean hasPrevious 
        {
            get 
            {
                return this.conn.getHasPrevious();
            }
            set;
        }
     
        // returns the page number of the current page set
        public Integer pageNumber 
        {
            get 
            {
                return this.conn.getPageNumber();
            }
            set;
        }
     
        // returns the first page of records
        public void first() 
        {
            try
            {
                this.conn.first();
            }
            catch(VisualforceException e)
            {
                this.conn.save();
                this.conn.first();
            }
        }
     
        // returns the last page of records
        public void last() 
        {
            try
            {
                this.conn.last();
            }
            catch(VisualforceException e)
            {
                this.conn.save();
                this.conn.last();
            }
        }
     
        // returns the previous page of records
        public void previous() 
        {
            try 
            {
                this.conn.previous();
            }
            catch(VisualforceException e)
            {
                this.conn.save();
                this.conn.previous();
            }
        }
     
        // returns the next page of records
        public void next() 
        {
            try
            {
                this.conn.next();
            }
            catch(VisualforceException e)
            {
                this.conn.save();
                this.conn.next();
            }
        }
    }
    
    // Wrapper class for Subscriber
    public class SubscriberWrapper
    {
        public Subscriber__c subscriber { get; set; }
        public String linkRecordId { get; private set; }
        public String linkRecordText { get; private set; }
        public String objectType { get; private set; }
        
        public SubscriberWrapper(Subscriber__c subscriber)
        {
            this.subscriber = subscriber;
            
            if(this.subscriber.Contact__c != null)
            {
                this.linkRecordId = this.subscriber.Contact__c;
                this.linkRecordText = this.subscriber.Contact__r.Name;
                this.objectType = 'Contact';
            }
            else if(this.subscriber.Organization__c != null)
            {
                this.linkRecordId = this.subscriber.Organization__c;
                this.linkRecordText = this.subscriber.Organization__r.Name;
                this.objectType = 'Organization';
            }
            else if(this.subscriber.Position__c != null)
            {
                this.linkRecordId = this.subscriber.Position__c;
                this.linkRecordText = this.subscriber.Position__r.Position_Title__c;
                this.objectType = 'Position';
            }
        }
    }
}