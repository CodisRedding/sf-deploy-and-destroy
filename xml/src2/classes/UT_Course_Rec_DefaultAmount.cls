/**
 Raji : removed Transcript Info and Course Record & Course Field Changes Updated
  */
@isTest
private class UT_Course_Rec_DefaultAmount 
{
    static testMethod void Course_Record_DefaultAmountPaid_Single()
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        // Grab Advanced COS Record Type
        RecordType rtAdvCOS = Util.getRecordType('Course_Record__c', 'Advanced Course of Study');
        
        // Create a Contact in order to create a Transcript Information record
        Contact contact = new Contact(FirstName = 'Rocky', 
                                       LastName = 'Assad_01',
                                       Salutation = 'Mr.');
                                       
        insert contact;
         RecordType recordType1 = Util.getRecordType('Courses__c', 'Advanced Course of Study');
        Courses__c course = new Courses__c(RecordTypeId = recordType1.Id,
                                           Name__c = 'Some Course',
                                           Status__c = 'Active');
                                           
        insert course;
        
                            
        // Create Course Record with Advanced COS Record Type and Class Type of Online
        Course_Record__c courseRecord = new Course_Record__c(Contact__c = contact.Id,
                                                             GBHEM_DataCenter_grade__c = 'test',
                                                             Grade__c = 'A',
                                                             Credit_Hour_Types__c = 'Quarter Hours',
                                                             Credit_Hours__c = 10,
                                                             Course__c = course.Id,
                                                             RecordTypeId = rtAdvCOS.Id,
                                                             Class_Type__c = 'Online',
                                                             Amount_Paid__c = null);

        test.startTest();
        
        // Should update Amount Paid to 175
        insert courseRecord;
        
        // Query Course Record with Amount Paid in order to Assert Amount Paid
        courseRecord = [SELECT Id, Amount_Paid__c FROM Course_Record__c WHERE Id = :courseRecord.Id];
        
        System.assertEquals('175.00', courseRecord.Amount_Paid__c);
        
        // Change Class Type to Correspondence
        courseRecord.Class_Type__c = 'Correspondence';
        courseRecord.Amount_Paid__c = null;
        
        // Should update Amount Paid to 150 
        update courseRecord;
        
        // Query Course Record with Amount Paid in order to Assert Amount Paid
        courseRecord = [SELECT Id, Amount_Paid__c FROM Course_Record__c WHERE Id = :courseRecord.Id];
        
        System.assertEquals('150.00', courseRecord.Amount_Paid__c);
        
        test.stopTest();
    }
}