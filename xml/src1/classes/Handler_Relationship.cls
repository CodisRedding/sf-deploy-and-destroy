/*
Raji : 11/23/2011
Functionality : Unique Spouse
*/
public with sharing class Handler_Relationship{
    public static void UpdateUniqueSpouse(List<npe4__Relationship__c> newRelSpouse){    
        RecordType RelSpouse = Util.getRecordType('npe4__Relationship__c', 'Spouse');
        for(npe4__Relationship__c rel : newRelSpouse){
            if (rel.RecordTypeId == RelSpouse.Id && rel.npe4__Contact__c != null && rel.npe4__Status__c !=null){
                rel.UniqueSpouseContact__c = RelSpouse.Name + rel.npe4__Contact__c + rel.npe4__Status__c;
            }
        }
    
    }

}