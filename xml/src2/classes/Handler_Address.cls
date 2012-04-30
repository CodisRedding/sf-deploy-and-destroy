/* Raji: 05/13/2011
       Format phone number before insert/update
       Validation rule checks if the format is acceptable:Shld talk to rebecca for brazil.
       Raji : 12.09.2011
       Functionality : Organization mailing address For Reports
       Search Layouts : City & State on all Search Layouts
    */
public with sharing class Handler_Address{
    public static void FormatPhone(List<Address__c> newAddresses){
        for (Address__c address : newAddresses){
            address.Main_Switchboard__c = Util.formatPhone(address.Main_Switchboard__c, address.Country__c);
            address.Phone__c = Util.formatPhone(address.Phone__c, address.Country__c);
            address.Mobile__c = Util.formatPhone(address.Mobile__c, address.Country__c);
            address.Fax__c = Util.formatPhone(address.Fax__c , address.Country__c);
            address.Alternate_Phone__c = Util.formatPhone(address.Alternate_Phone__c, address.Country__c);
            address.Zip_Postal_Code__c =Util.formatPC(address.Zip_Postal_Code__c); 
            
                               
        }
             
    }
    //Reports to get Organization MAiling Address
    public static void ReportsOrgMailingAddress(List<Address__c> newAddresses){
        RecordType OrgMail = Util.getRecordType('Address__c', 'Organization Mailing');
        RecordType OrgLoc = Util.getRecordType('Address__c', 'Organization Location');
        
        Set<Id> OrgIds = new Set<Id>();
        for(Address__c address : newAddresses){
            OrgIds.add(address.Organization_Name__c);
        }
        Map<Id,Account> OrgMap = new Map<Id,Account>([Select id, Organization_Mailing_City__c,
                Organization_Mailing_Country__c,Organization_Mailing_State__c,Organization_Mailing_AddressLine1__c,Organization_Mailing_Address_Line2__c  ,Organization_Mailing_Zip_Postal_Code__c,
                SearchLayout_City__c,SearchLayout_State__c from Account where Id IN :OrgIds]);
        Map<Id,Account> updatedOrgMap = new Map<id,Account>();
        
        //address Organization Mailing Address
        for(Address__c address : newAddresses){
                              
            //City & State on all Search Layouts
            if(address.RecordTypeId == OrgLoc.Id){
                Account Org = OrgMap.get(address.Organization_Name__c);
                Org.SearchLayout_City__c = address.City__c;
                Org.SearchLayout_State__c = address.State__c;
                updatedOrgMap.put(Org.id,Org);
            }
            //Organization Mailing Address
            if(address.RecordTypeId == OrgMail.Id){
                Account Org = OrgMap.get(address.Organization_Name__c);
                //For United states of America & Canada
                if(address.Country__c == 'UNITED STATES OF AMERICA' || address.Country__c == 'CANADA'){
                    //Address Line 1 & Address Line 2
                    if (address.Address_Line1__c != null){Org.Organization_Mailing_AddressLine1__c = address.Address_Line1__c;}
                    if (address.Address_Line2__c != null){Org.Organization_Mailing_Address_Line2__c = address.Address_Line2__c;}
                    If(address.City__c !=null){Org.Organization_Mailing_City__c = address.City__c;}                    
                    If(address.State__c !=null){Org.Organization_Mailing_State__c = address.State__c;}
                    If(address.Zip_Postal_Code__c!=null){Org.Organization_Mailing_Zip_Postal_Code__c = address.Zip_Postal_Code__c;}
                    }//Countries are USA & Canada
                //If Countries are not Unites States of America & Canada
                else if(address.Country__c != 'UNITED STATES OF AMERICA' || address.Country__c != 'CANADA'){
                    
                    //Address Line 1 & Address Line 2
                    if (address.Address_Line1__c != null){Org.Organization_Mailing_AddressLine1__c= address.Address_Line1__c;}
                    if (address.Address_Line2__c != null){Org.Organization_Mailing_Address_Line2__c = address.Address_Line2__c;}
                    If(address.City__c !=null){Org.Organization_Mailing_City__c = address.City__c;}
                    If(address.State_Other__c !=null){Org.Organization_Mailing_State__c = address.State_Other__c;}
                    If(address.Zip_Postal_Code__c!=null){Org.Organization_Mailing_Zip_Postal_Code__c = address.Zip_Postal_Code__c;}
                    If(address.Country__c!=null){Org.Organization_Mailing_Country__c = address.Country__c;}
                    }//Countries are not USA & CANADA
                updatedOrgMap.put(Org.id,Org);
            }
            
        }
        if(updatedOrgMap.size() > 0){
            update updatedOrgMap.values();
        }
    }
    
        
}