@isTest
private class UT_Position 
{
    static Contact contact = null;
    
    static testMethod void TestInsertDistSuper() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        test.startTest();
        InitContact();
        
        Id dsRt = [SELECT Id FROM RecordType WHERE Name = 'District' AND SObjectType = 'Position__c'].Id;
        
        // Try to insert a new district superintendent position for a contact with a district
        Position__c dsPosition = new Position__c(Contact__c = contact.Id, RecordTypeId = dsRt, Position_Title__c = 'District Superintendent');
        
        System.assertNotEquals(null, contact.District__c);
        test.stopTest();
        
        insert dsPosition;
        
        contact = [SELECT Id, District__c FROM Contact WHERE Id = :contact.Id];
        
        System.assertEquals(null, contact.District__c);
    }
    
    static testMethod void TestUpdateDistSuper() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        test.startTest();
        InitContact();
        
        Id dsRt = [SELECT Id FROM RecordType WHERE Name = 'District' AND SObjectType = 'Position__c'].Id;
        
        // Try to insert a new district superintendent position for a contact with a district
        Position__c dsPosition = new Position__c(Contact__c = contact.Id, RecordTypeId = dsRt, Position_Title__c = 'Missing');
        
        insert dsPosition;
        
        System.assertNotEquals(null, contact.District__c);
        
        dsPosition.Position_Title__c = 'District Superintendent';
        test.stopTest();
        
        update dsPosition;
        
        contact = [SELECT Id, District__c FROM Contact WHERE Id = :contact.Id];
        
        System.assertEquals(null, contact.District__c);
    }
    
    private static void InitContact()
    {
        Id rt = [SELECT Id FROM RecordType WHERE Name = 'District' AND SObjectType = 'Account'].Id;
        Account district = new Account(RecordTypeId = rt, Name = 'Test District Test');
        
        insert district;
        
        contact = new Contact(FirstName = 'Position Test', LastName = 'Tester', District__c = district.Id);
        
        insert contact;
    } 
    
     //Raji : 2/22/2012
    //Logic to avoid Lookup Filter Limitation Validation rule testing
    static testMethod void position_OrgLookupFilter(){
        UnitTest_Exception_Manager.ThrowException = true;
        
        //record types
        RecordType RT_AC = Util.getRecordType('Account', 'Annual Conference');
        RecordType RT_CM = Util.getRecordType('Account', 'Collegiate Ministry');
        RecordType RT_D = Util.getRecordType('Account', 'District');
        RecordType RT_EI = Util.getRecordType('Account', 'Educational Institutions');

        Account org_EI = new Account(
            Name='Test School 1',
            RecordTypeId = RT_EI.Id,
            Affiliation__c = 'BCF'
            );
                                      
        insert org_EI ;
        Account org_AC = new Account(
            Name='Test AC 1',
            RecordTypeId = RT_AC.Id
           );
                                      
        insert org_AC ;
        Account org_CM = new Account(
            Name='Test CM 1',
            RecordTypeId = RT_CM.Id
           );
                                      
        insert org_CM ;
        
        Contact con = new Contact(
            LastName = 'Last Name 2',
            Salutation = 'The Rev.'
         );
        insert con;
    
        //Position
        RecordType RT_AC_pos = Util.getRecordType('Position__c', 'Annual Conference');
        RecordType RT_EI_pos = Util.getRecordType('Position__c', 'Educational Institutions');
        RecordType RT_CM_pos = Util.getRecordType('Position__c', 'Collegiate Ministry');
        RecordType RT_D_pos = Util.getRecordType('Position__c', 'District');
        
        Position__c pos_ac = new Position__c(RecordTypeId = RT_AC_pos.Id,
                                                       Contact__c = con.Id,
                                                       Organization_Name__c = org_CM.Id
                                                       );
        test.startTest();
        try{
                insert pos_ac;
            }
            catch (DmlException e){
                System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
        Position__c pos_EI = new Position__c(RecordTypeId = RT_EI_pos .Id,
                                                       Contact__c = con.Id,
                                                       Organization_Name__c = org_EI .Id
                                                       );
        insert pos_EI ;
        Position__c pos_EI1 = new Position__c (id = pos_EI.id,
                                               Contact__c = con.Id,
                                                Organization_Name__c = org_CM .Id
                                                       ); 
        try{
                update pos_EI1 ;
            }
            catch (DmlException e){
                System.debug('Organization Record Type should be Educational Institutions' + e);
            }                                                                                             
        test.stopTest();
    
    delete pos_EI ;
    delete con;
    }
   
    
}