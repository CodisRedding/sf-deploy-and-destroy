/* Raji: 05.25.2011
    Trigger for 
    1.  Confidential Mailing Address,
    2.  Email Confidential Only,
    3.  Primary Mailing address Functionality,
    4.  (NOT USED)Primary Phone functionality and 
    5.  PrimaryEmail functionality. 
    6.  Each Contact type only have one Address Record Type.(Not Using)
    7.  Fax,URL and Phone Extension Fields pop up Automatically when values entered on Address Object    
*/

trigger Address on Address__c (before insert, before update) {

    Set<Id> conIds = new Set<Id>();
    RecordType OrgLoc = Util.getRecordType('Address__c', 'Organization Location');
    RecordType OrgMail = Util.getRecordType('Address__c', 'Organization Mailing');
    RecordType ContactMilitary = Util.getRecordType('Address__c', 'Contact Military Address');
    RecordType ConWork = Util.getRecordType('Address__c', 'Contact Work Address');
    RecordType ConHome = Util.getRecordType('Address__c', 'Contact Home Address');
        
    for(Address__c address : Trigger.new){
        if(address.contact__c != null)
        {
            conIds.add(address.contact__c);
        }
        System.debug('conIds = '+conIds +'  '+conIds.size()); 
    }
    
    Map<Id,contact> contactMap = new Map<Id,Contact>([Select id, Contact_Address_Line1__c,Contact_Address_Line2__c,Phone_Extension__c, Contact_City__c, Contact_State__c, Contact_Zip_Postal_Code__c,URL__c,Fax,Contact_Country__c,Phone,MobilePhone,Email from contact where Id IN :conIds]);
    system.debug('conmap = '+contactMap + '  '+contactMap.size());
    
    //Map<Id,boolean> confidentialMap = new Map<Id,boolean>();
    Set<Id> conIdsSet = new Set<Id>();
    Set<Id> conIdsEmailSet = new Set<Id>();
    Set<Id> conIdsPrimAddSet = new Set<Id>();
    Set<Id> conIdsPrimLandlineSet = new Set<Id>();
    Set<Id> conIdsPrimMobileSet = new Set<Id>();
    Set<Id> conIdsPrimEmailSet = new Set<Id>();
    Set<Id> conIdsActiveAddressTypeSet = new Set<Id>();
     
    
    
    Map<Id,Set<Id>> addressRecTypeMap = new Map<Id,Set<Id>>();
    
    for(Address__c address : [Select id, Confidential_Mailing_Address__c,Email_Confidential_Only__c,Primary_Mailing_Address__c,Primary_Email_Address__c,contact__c from Address__c where contact__c IN : conIds AND (Confidential_Mailing_Address__c = true OR Email_Confidential_Only__c = true OR Primary_Mailing_Address__c = true OR Primary_Email_Address__c = true)]){
        if(address.Confidential_Mailing_Address__c){
            conIdsSet.add(address.contact__c); 
        }
        if(address.Email_Confidential_Only__c){
            conIdsEmailSet.add(address.contact__c); 
        }
        if(address.Primary_Mailing_Address__c){
            conIdsPrimAddSet.add(address.contact__c); 
        }
        /*raji if(address.Primary_Phone__c == 'Landline'){
            conIdsPrimLandlineSet.add(address.contact__c); 
        }
        if(address.Primary_Phone__c == 'Mobile'){
            conIdsPrimMobileSet.add(address.contact__c); 
        }raji */
        if(address.Primary_Email_Address__c){
            conIdsPrimEmailSet.add(address.contact__c); 
        }
        
                    
       /* Commented to have Multiple Record types
       if(addressRecTypeMap.containsKey(address.Contact__c)){
            Set<Id> recTypeSet = addressRecTypeMap.get(address.Contact__c);
            recTypeSet.add(address.recordTypeId);
            addressRecTypeMap.put(address.contact__c,recTypeSet);
        } 
        else{
            Set<Id> recTypeSet = new Set<Id>();
            recTypeSet.add(address.RecordTypeId);
            addressRecTypeMap.put(address.contact__c,recTypeSet);
        }*/
        
    }
    Map<Id,Contact> updatedContactMap = new Map<id,Contact>();
    
    if(Trigger.isUpdate){
        for(Address__c address : Trigger.new){
            if(Trigger.oldMap.get(address.Id).Primary_Mailing_Address__c == true && Trigger.newMap.get(address.Id).Primary_Mailing_Address__c == false){
                Contact con = contactMap.get(address.contact__c);
                con.Contact_Address_Line1__c = null;
                con.Contact_Address_Line2__c = null;
                con.Contact_City__c = null;
                con.Contact_State__c = null;
                con.Contact_Zip_Postal_Code__c = null;
                con.Contact_Country__c = null;
                con.Phone = null;
                con.MobilePhone = null;
                con.Phone_Extension__c = null;
                updatedContactMap.put(con.id,con) ;       
            }
            if(Trigger.oldMap.get(address.Id).Primary_Email_Address__c == true && Trigger.newMap.get(address.Id).Primary_Email_Address__c == false){
                Contact con = contactMap.get(address.contact__c);
                con.Email = null;
                updatedContactMap.put(con.Id,con) ;       
            }
            /*raji if (address.RecordTypeId != OrgLoc.Id && address.RecordTypeId != OrgMail.Id){
                if(Trigger.oldMap.get(address.Id).Primary_Phone__c == 'Landline' && (Trigger.newMap.get(address.Id).Primary_Phone__c == null || Trigger.newMap.get(address.Id).Primary_Phone__c == 'Mobile' )){
                    Contact con = contactMap.get(address.contact__c);
                    con.Phone = null;
                    updatedContactMap.put(con.Id,con) ;       
                }
                else if(Trigger.oldMap.get(address.Id).Primary_Phone__c == 'Mobile' && (Trigger.newMap.get(address.Id).Primary_Phone__c == null || Trigger.newMap.get(address.Id).Primary_Phone__c == 'Landline' )){
                    Contact con = contactMap.get(address.contact__c);
                    con.Phone = null;
                    updatedContactMap.put(con.Id,con) ;      
                }
            }raji*/
        }   
    }
    
        
    for(Address__c address : Trigger.new){
        if(((Trigger.isUpdate && Trigger.oldMap.get(address.Id).Confidential_Mailing_Address__c != address.Confidential_Mailing_Address__c)  || Trigger.isInsert) &&
         address.Confidential_Mailing_Address__c && conIdsSet.contains(address.Contact__c)){
            address.addError('Confidential Mailing Address : Only one confidential postal address may be selected');
        }
        if(((Trigger.isUpdate && Trigger.oldMap.get(address.Id).Email_Confidential_Only__c != address.Email_Confidential_Only__c )  || Trigger.isInsert) &&
         address.Email_Confidential_Only__c && conIdsEmailSet.contains(address.Contact__c)){
            address.addError('Email Confidential : Only one confidential email address may be selected');
        }
        
        if(((Trigger.isUpdate && Trigger.oldMap.get(address.Id).Primary_Mailing_Address__c != address.Primary_Mailing_Address__c )  || Trigger.isInsert) &&
         address.Primary_Mailing_Address__c && conIdsPrimAddSet.contains(address.Contact__c)){
            address.addError('Primary Mailing Address : Only one Primary Mailing Address may be selected');
        }
        else if(address.Primary_Mailing_Address__c){
            Contact con = contactMap.get(address.contact__c);
            //Raji(No Military logic) if (address.RecordTypeId != ContactMilitary.Id){
                //For United states of America & Canada
                if(address.Country__c == 'UNITED STATES OF AMERICA' || address.Country__c == 'CANADA'){
                   
                    //Address Line 1 & Address Line 2
                    if (address.Address_Line1__c != null){con.Contact_Address_Line1__c = address.Address_Line1__c;}
                    if (address.Address_Line2__c != null){con.Contact_Address_Line2__c = address.Address_Line2__c;}
                    If(address.City__c !=null){con.Contact_City__c = address.City__c;}                    
                    If(address.State__c !=null){con.Contact_State__c = address.State__c;}
                    If(address.Zip_Postal_Code__c!=null){con.Contact_Zip_Postal_Code__c = address.Zip_Postal_Code__c;}
                    //Phone
                    If(address.Phone__c !=null){con.Phone = address.Phone__c;}
                    If(address.Mobile__c!=null){con.MobilePhone = address.Mobile__c;}
                    If(address.Phone_Extension__c !=null){con.Phone_Extension__c = address.Phone_Extension__c;} 
                    }//Countries are USA & Canada
                //If Countries are not Unites States of America & Canada
                else if(address.Country__c != 'UNITED STATES OF AMERICA' || address.Country__c != 'CANADA'){
                    
                    //Address Line 1 & Address Line 2
                    if (address.Address_Line1__c != null){con.Contact_Address_Line1__c = address.Address_Line1__c;}
                    if (address.Address_Line2__c != null){con.Contact_Address_Line2__c = address.Address_Line2__c;}
                    If(address.City__c !=null){con.Contact_City__c = address.City__c;}
                    If(address.State_Other__c !=null){con.Contact_State__c = address.State_Other__c;}
                    If(address.Zip_Postal_Code__c!=null){con.Contact_Zip_Postal_Code__c = address.Zip_Postal_Code__c;}
                    If(address.Country__c!=null){con.Contact_Country__c = address.Country__c;}
                    //Phone
                    If(address.Phone__c !=null){con.Phone = address.Phone__c;}
                    If(address.Mobile__c!=null){con.MobilePhone = address.Mobile__c;}
                    If(address.Phone_Extension__c !=null){con.Phone_Extension__c = address.Phone_Extension__c;} 
                    }//Countries are not USA & CANADA
                //Raji(No Military logic)}
            
           /* Raji : Military Address Does not have different logic so commented 
               else if(address.RecordTypeId == ContactMilitary.Id){
               //For United states of America & Canada
                if(address.Country__c == 'UNITED STATES OF AMERICA' || address.Country__c == 'CANADA'){
                   
                    //Address Line 1 & Address Line 2
                  if (address.Address_Line1__c != null){con.Contact_Address_Line1__c = address.Address_Line1__c;}
                    if (address.Address_Line2__c != null){con.Contact_Address_Line2__c = address.Address_Line2__c;}
                    If(address.City__c !=null){con.Contact_City__c = address.City__c;}                    
                    If(address.State__c !=null){con.Contact_State__c = address.State__c;}
                    if(address.Military_Post_Office__c!=null){con.Contact_State__c = address.Military_Post_Office__c; }
                    If(address.Zip_Postal_Code__c!=null){con.Contact_Zip_Postal_Code__c = address.Zip_Postal_Code__c;}
                    
                    }//Countries are USA & Canada
                //If Countries are not Unites States of America & Canada
                else if(address.Country__c != 'UNITED STATES OF AMERICA' || address.Country__c != 'CANADA'){
                    
                    //Address Line 1 & Address Line 2
                    if (address.Address_Line1__c != null){con.Contact_Address_Line1__c = address.Address_Line1__c;}
                    if (address.Address_Line2__c != null){con.Contact_Address_Line2__c = address.Address_Line2__c;}
                    If(address.City__c !=null){con.Contact_City__c = address.City__c;}
                    If(address.State_Other__c !=null){con.Contact_State__c = address.State_Other__c;}
                    If(address.Zip_Postal_Code__c!=null){con.Contact_Zip_Postal_Code__c = address.Zip_Postal_Code__c;}
                    if(address.Military_Post_Office__c!=null){con.Contact_State__c = address.Military_Post_Office__c; }
                    If(address.Country__c!=null){con.Contact_Country__c = address.Country__c;} 
                    }//Countries are not USA & CANADA
                
            }Raji Commented*/
            
            updatedContactMap.put(con.Id,con) ;       
        }
        if(((Trigger.isUpdate && Trigger.oldMap.get(address.Id).Primary_Email_Address__c != address.Primary_Email_Address__c  )  || Trigger.isInsert) &&
          address.Primary_Email_Address__c && conIdsPrimEmailSet.contains(address.Contact__c)){
            address.addError('Primary Email Address : Only one primary Email address may be selected');
        }
        else if(address.Primary_Email_Address__c && address.contact__c != null){
            Contact con = contactMap.get(address.contact__c);
            con.Email = address.Email__c;
            updatedContactMap.put(con.Id,con) ;       
        }
       /*raji if (address.RecordTypeId != OrgLoc.Id && address.RecordTypeId != OrgMail.Id){
            if(((Trigger.isUpdate && Trigger.oldMap.get(address.Id).Primary_Phone__c != address.Primary_Phone__c)  || Trigger.isInsert) &&
              address.Primary_Phone__c != null && address.Primary_Phone__c != 'Mobile' && conIdsPrimLandlineSet.contains(address.Contact__c)){
                System.debug(' address.Primary_Phone__c = '+ address.Primary_Phone__c );
                System.debug(' conIdsPrimLandlineSet = '+ conIdsPrimLandlineSet + conIdsPrimLandlineSet.size() );  
                address.addError('Primary Phone : Only one Landline Phone may be selected');
            }
            else if(address.Primary_Phone__c == 'Landline'){
                Contact con = contactMap.get(address.contact__c);
                con.Phone = address.Phone__c;
                updatedContactMap.put(con.Id,con) ;       
            }
            if(((Trigger.isUpdate && Trigger.oldMap.get(address.Id).Primary_Phone__c != address.Primary_Phone__c)  || Trigger.isInsert) &&
              address.Primary_Phone__c != 'Landline' && address.Primary_Phone__c != null && conIdsPrimMobileSet.contains(address.Contact__c)){
                System.debug(' address.Primary_Phone__c = '+ address.Primary_Phone__c );
                System.debug(' conIdsPrimMobileSet = '+ conIdsPrimMobileSet );                
                System.debug(' address.Contact__c = '+ address.Contact__c);     
                address.addError('Primary Phone : Only one Mobile Phone may be selected');
            }
            else if(address.Primary_Phone__c == 'Mobile'){
                Contact con = contactMap.get(address.contact__c);
                con.MobilePhone = address.Mobile__c;
                updatedContactMap.put(con.Id,con) ;       
            }raji*/
            
        if (address.RecordTypeId != OrgLoc.Id && address.RecordTypeId != OrgMail.Id && address.contact__c != null){
        if(address.URL__c != null){ 
                Contact con = contactMap.get(address.contact__c);
                con.URL__c = address.URL__c;
                updatedContactMap.put(con.id,con);
        }
        if(address.Fax__c != null){
                Contact con = contactMap.get(address.contact__c);
                con.Fax = address.Fax__c;
                updatedContactMap.put(con.id,con);
        }
       
        if(address.End_Date__c != null){
            address.Status__c = 'InActive';}
        else{
            address.Status__c = 'Active';}
        
        }
    }
    //Address Record types
       /* if(Trigger.isInsert ){
        for(Address__c address : Trigger.new){
            Set<Id> recTypeSet = new Set<Id>();
            recTypeSet = addressRecTypeMap.get(address.contact__c);
            if(recTypeSet != null && recTypeSet.contains(address.RecordTypeId)){
                address.addError('Address Type already Exists :Each Contact can have only one Active Address type');
            }
        }   
    } */
        
    if(updatedContactMap.size() > 0){
        update updatedContactMap.values();
    }
   

}