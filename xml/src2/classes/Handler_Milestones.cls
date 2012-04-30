public with sharing class Handler_Milestones
{
    /*Raji : 06.09.2011
        Functionality : to pop the fields from Milestones Object to Contact
    */
    public static void UpdateContactAge(List<Milestones__c> newMilestones)
    {
        
         RecordType milestoneDeath = Util.getRecordType('Milestones__c', 'Death Date');
         RecordType milestoneBirth= Util.getRecordType('Milestones__c', 'Birth Date');
        
        Set<Id> conIds = new Set<Id>();
        for(Milestones__c milestone : newMilestones)
        {
            conIds.add(milestone.contact__c);
        }
        
        Map<Id,contact> contactMap = new Map<Id,Contact>([Select id, Age__c,Death_Date__c,DOB_Month__c,Date_of_Birth__c,Status__c from contact where Id IN :conIds]);
        Map<Id,Contact> updatedContactMap = new Map<id,Contact>();
        
        //Milestone Age
        for(Milestones__c milestone : newMilestones)
        {
            if((milestone.RecordTypeId == milestoneBirth.Id ||milestone.RecordTypeId == milestoneDeath .Id )&& milestone.Age__c != null)
            {
                Contact con = contactMap.get(milestone.contact__c);
                con.Age__c = milestone.Age__c;
                updatedContactMap.put(con.id,con);
            }
            
            
            //Milestone Death 
            if(milestone.RecordTypeId == milestoneDeath .Id && milestone.Milestone__c == 'Death Date'){
                Contact con = contactMap.get(milestone.contact__c);
                if(milestone.Death_Date__c !=null)con.Death_Date__c = milestone.Death_Date__c;
                con.Status__c = 'Inactive';
                updatedContactMap.put(con.id,con);
            }
            //Milestone Birth
            if(milestone.RecordTypeId == milestoneBirth.Id && milestone.Milestone__c == 'Birth Date'){
                Contact con = contactMap.get(milestone.contact__c);
                if(milestone.Birth_Date__c !=null)
                con.Date_of_Birth__c = milestone.Birth_Date__c.month()+ '/'+ milestone.Birth_Date__c.Day();
                con.DOB_Month__c = milestone.Birth_Date__c.month();
                
                
                updatedContactMap.put(con.id,con);
            }
       
        }
        if(updatedContactMap.size() > 0)
        {
            update updatedContactMap.values();
        }
    }
        
 }