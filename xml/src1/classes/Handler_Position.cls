public with sharing class Handler_Position 
{
    public static void RemoveDistrictFromContactIfDistSuper(List<Position__c> newPositions)
    {
        Set<Id> contactIds = new Set<Id>();
        List<Contact> contacts = new List<Contact>();
        
        for(Position__c position : newPositions)
        {
            if(position.Position_Title__c == 'District Superintendent')
            {
                contactIds.add(position.Contact__c);
            }
        }
        
        for(Contact contact : [SELECT Id, District__c FROM Contact WHERE District__c != null AND Id IN :contactIds])
        {
            contact.District__c = null;
            contacts.add(contact);
        }
        
        // update contacts
        if(!contacts.isEmpty())
        {
            update contacts;
        }
    }
    
    // Raji : 2/21/2012
    // Rocky Assad : 2/24/2012 (revised)
    //Logic to avoid Lookup Filter Limitation Validation rule
    public static void Pos_LookupFilterValidation(List<Position__c> newPos)
    {
        for(Position__c pos : newPos) 
        {
            if((pos.Organization_Name__c != null) && 
                    ((pos.Organization_Name__r.RecordType.Name != 'Default') || (pos.Organization_Name__r.RecordType.Name != 'Jurisdiction')) &&
                    (pos.RecordType.Name != 'Africa University Board of Directors') &&
                    (pos.RecordType.Name != 'Chaplain Positions') &&
                    (pos.RecordType.Name != 'Connectional Table') && 
                    (pos.RecordType.Name != 'GBHEM Board of Directors') && 
                    (pos.RecordType.Name != 'General Conference') && 
                    (pos.RecordType.Name != 'IAMSCU Board') && 
                    (pos.RecordType.Name != 'NASCUMC Board') && 
                    (pos.RecordType.Name != 'UMHEF Board of Trustees') && 
                    (pos.RecordType.Name != 'University Senate'))
            {
                if((pos.RecordType.Name != pos.Organization_Name__r.RecordType.Name))
                {
                    pos.addError('Organization Record Type should be the same as the position record type.');
                }
            }
        }
    }
}