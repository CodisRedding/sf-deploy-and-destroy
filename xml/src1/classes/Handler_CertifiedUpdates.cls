/*
Raji : 01/19/2012
Certified Updates : Certified renewal status & Status Functionality for Reports.
*/
public with sharing class Handler_CertifiedUpdates{

  public static void UpdateStatus(List<Certification_Updates__c> newUpdate){  
    for(Certification_Updates__c cu : newUpdate){
        if(cu.Certification_Renewal_Status__c != null){
            if(cu.Certification_Renewal_Status__c == 'Discontinued' || cu.Certification_Renewal_Status__c == 'Involuntarily Declined Renewal'
                        || cu.Certification_Renewal_Status__c == 'Voluntarily Declined Renewal'){
                cu.Status__c = 'InActive';
                }
            if(cu.Certification_Renewal_Status__c == 'Reinstated' || cu.Certification_Renewal_Status__c == 'Renewed'){
                cu.Status__c = 'Active';
                }
            }    
        }
    }
    
    public static void UpdateCertifiedStatus(List<Certification_Updates__c> newCU){
        Set<Id> ecIds = new Set<Id>();
        for(Certification_Updates__c cu : newCU){
            ecIds .add(cu.Education_Certification__c);
        }
        Map<Id,Certification_in_Specialized_Ministry__c> ECMap = new Map<Id,Certification_in_Specialized_Ministry__c>([Select id,EC_Certification_Renewal_Status__c from Certification_in_Specialized_Ministry__c where Id IN :ecIds ]);
        Map<Id,Certification_in_Specialized_Ministry__c> updatedECMap = new Map<id,Certification_in_Specialized_Ministry__c>();
        
        for(Certification_Updates__c cu : newCU)
        {
            if(cu.Certification_Renewal_Status__c != null)
            {
                Certification_in_Specialized_Ministry__c ec = ECMap.get(cu.Education_Certification__c);
                ec.EC_Certification_Renewal_Status__c  = cu.Certification_Renewal_Status__c;
                updatedECMap .put(ec.id,ec);
            }
        }
        if(updatedECMap.size() > 0){
            update updatedECMap.values();
        }
}
}