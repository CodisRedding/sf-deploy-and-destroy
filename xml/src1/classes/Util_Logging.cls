global class Util_Logging 
{
    public static Set<Id> NullRecordIds = new Set<Id> { '000000000000000000' };
    
    //@future
    public static void logRecordErrors(Set<Id> recordIds, String msg) 
    {
        // declare local vars
        Global_App_Settings__c appSettings = Global_App_Settings__c.getInstance();
        
        // chatter log
        // post record error to record owners via chatter
        if(!appSettings.Suppress_Record_Errors_to_Chatter__c && appSettings != null)
        {
            List<FeedItem> itemsToCreate = new List<FeedItem>();
            
            for(Id recordId :recordIds) 
            {
                FeedItem post = new FeedItem();
                post.ParentId = recordId;
                post.Body = msg;
                
                itemsToCreate.add(post);
            }
            
            try 
            {
                insert itemsToCreate;
            } 
            catch(DMLException dml) 
            {
                System.debug('an error occurred while creating a chatter post: ' + dml);
            }
        }
    }
    
    //@future
    public static void logSystemErrors(Set<Id> recordIds, String msg, String expMsg) 
    {
        // decalre local vars
        Global_App_Settings__c appSettings = Global_App_Settings__c.getInstance();
        
        // ##########################
        // chatter log
        // ##########################
        
        // check if chatter group exists
        // post record error to record owners via chatter
        if(!appSettings.Suppress_System_Errors_to_Chatter__c && appSettings != null)
        {
            List<FeedItem> itemsToCreate = new List<FeedItem>();
            CollaborationGroup[] collabGroup = [select Id from CollaborationGroup where name = :appSettings.Developers_Chatter_Group_Name__c.trim()];
            Id collabGroupId = null;
            
            if(collabGroup.size() == 0)
            {
                // create chatter group
                CollaborationGroup chatterGroup = new CollaborationGroup(Name = appSettings.Developers_Chatter_Group_Name__c,
                                                                         CollaborationType = 'Private');

                insert chatterGroup;
                
                // add deafult memeber to chatter group
                User defaultMember = [select Id from user where username = :appSettings.Developers_Chatter_Group_Default_Member__c.trim()];
                
                Integer cnt = [select count() from CollaborationGroupMember where CollaborationGroupId = :chatterGroup.Id and MemberId = :defaultMember.Id];
                
                if(cnt == 0)
                {
                    CollaborationGroupMember chatterGroupMember = new CollaborationGroupMember(MemberId = defaultMember.Id,
                                                                                               CollaborationGroupId = chatterGroup.Id);
                
                    insert chatterGroupMember;  
                }
                
                collabGroupId = chatterGroup.Id;
            }
            else
            {
                collabGroupId = collabGroup[0].Id;
            }
            
            for(Id recordId :recordIds) 
            {
                FeedItem post = new FeedItem();
                post.ParentId = collabGroupId;
                post.Body = msg;
                
                itemsToCreate.add(post);
            }
            
            try 
            {
                insert itemsToCreate;
            } 
            catch(DMLException dml) 
            {
                System.debug('an error occurred while creating a chatter post: ' + dml);
            }
        }

        // ##########################
        // system log
        // ##########################
        
        List<System_Execptions__c> exceptions = new List<System_Execptions__c>();
        
        for(Id recordId :recordIds) 
        {
            System_Execptions__c except = new System_Execptions__c();
            
            except.Description__c = msg;
            except.Exception__c = expMsg;
            except.Record_Id__c = String.valueOf(recordId);
            
            exceptions.Add(except);
        }
        
        try 
        {
            insert exceptions;
        } 
        catch(DMLException dml) 
        {
            System.debug('an error occurred while creating a exception log: ' + dml);
        }
    }
}