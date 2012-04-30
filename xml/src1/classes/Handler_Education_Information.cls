public with sharing class Handler_Education_Information
{
    public static void CheckLicensingProgram(List<Education_Information__c> newEducationInfos)
    {
        for(Education_Information__c info : newEducationInfos)
        {
            if(info.Education_Type__c == 'Licensing')
            {
                if(info.School__c != null)
                {
                    Account[] school = [Select Id, Programs_offered__c FROM Account WHERE Id = :info.School__c];
                    
                    if((school[0].Programs_offered__c == null) || (!school[0].Programs_offered__c.contains('Licensing Program')))
                    {
                        info.School__c.addError('Licensing Program not offered for this school');
                    }
                }
            }
        }
    }
    
    public static void CheckForOnlyOneEducationRec(List<Education_Information__c> newEducationInfos)
    {
        Map<id, Education_Information__c> contacts = new Map<id, Education_Information__c>();
        for(Education_Information__c edi : newEducationInfos) 
        {
            contacts.put(edi.Education_Detail__c, edi);
        }
        
        //Highest Education
        Education_Information__c[] existingHighestEd = [SELECT id, Education_Type__c, Education_Detail__c FROM Education_Information__c 
             WHERE Education_Type__c = 'Highest Education' AND Education_Detail__c IN :contacts.keySet()];
        
        // Loop through all records being updated/inserted for Highest education
        for(Education_Information__c edi : newEducationInfos) 
        {
            // Loop through all records being updated/inserted and already have a Highest Education listed
            for(Education_Information__c edi2 : existingHighestEd) 
            {
                // Check if this contact already has a Highest Education record
                if(edi.Education_Detail__c == edi2.Education_Detail__c && 
                   edi.Education_Type__c == 'Highest Education' ) 
                {
                    // Check if they are updating
                    if(edi.id != edi2.id) 
                    {
                        edi.Education_Type__c.addError('Highest Education may only be added once for any given contact');
                    }
                }
            }
        }
            
    }
    //Raji : 11/16/2011
    //Local pastor Licensing
    public static void CheckForOnlyOneEdLocPastorLicensing(List<Education_Information__c> newEducationInfos){
        Map<id, Education_Information__c> contacts = new Map<id, Education_Information__c>();
        for(Education_Information__c EdLocPas : newEducationInfos){
            contacts.put(EdLocPas.Education_Detail__c, EdLocPas);
        }
        Education_Information__c[] existingLocalpastor = [SELECT id, Education_Type__c, Education_Detail__c FROM Education_Information__c 
             WHERE Education_Type__c = 'Local Pastor Licensing' AND Education_Detail__c IN :contacts.keySet()];
        
        // Check if the contact already has a Local Pastor Licensing record
        for(Education_Information__c LocPas : newEducationInfos){
            for(Education_Information__c LocPas2 : existingLocalpastor){
                if(LocPas.Education_Detail__c == LocPas2.Education_Detail__c && LocPas.Education_Type__c == 'Local Pastor Licensing'){
                    if(LocPas.id != LocPas2.id){
                        LocPas.Education_Type__c.addError('Local Pastor Licensing may only be added once for any given contact');
                    } 
                }
            }
        }
            
    }
    //Report Licensing School
    public static void LicensingschoolContactUpdate(List<Education_Information__c> newEducationInfos){
        Set<Id> conIds = new Set<Id>();
        for(Education_Information__c LicEdu : newEducationInfos){
            conIds.add(LicEdu.Education_Detail__c);
        }
        
        Map<Id,contact> contactMap = new Map<Id,Contact>([Select id,R_Licensing_School__c  from contact where Id IN :conIds]);
        Map<Id,Contact> updatedContactMap = new Map<id,Contact>();
        
        //Milestone Age
        for(Education_Information__c LicEdu : newEducationInfos){
            if(LicEdu.Education_Type__c == 'Local Pastor Licensing' && LicEdu.School__c !=null){
                Contact con = contactMap.get(LicEdu.Education_Detail__c);
                con.R_Licensing_School__c = LicEdu.School__c;
                updatedContactMap.put(con.id,con);
            }
        }
        if(updatedContactMap.size() > 0){
            update updatedContactMap.values();
        }
    
    }
    
}