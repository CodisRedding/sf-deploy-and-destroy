@isTest
//Raji : Commented To Hide Awards Functionality
private class UT_Course_Record_InsertAward 
{	
	/*Raji
    static testMethod void CreateCourseAwardAysnc() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        // create contact
        Contact contact = new Contact(Email = 'test@test0101010.com', 
                                      FirstName = 'Rocky', 
                                      LastName = 'Assad_01',
                                      Salutation = 'Mr.');
                                      
        insert contact;
                        
        // create course
        RecordType recordType1 = Util.getRecordType('Courses__c', 'BGTS');
        Courses__c course = new Courses__c(RecordTypeId = recordType1.Id,
                                           Name = 'Some Course',
                                           Status__c = 'Active');
                                           
        insert course;
        
        // create course record
        RecordType recordType2 = Util.getRecordType('Course_Record__c', 'BGTS');
        Course_Record__c record = new Course_Record__c(RecordTypeId = recordType2.Id,
                                                       Contact__c = contact.Id,
                                                       Credit_Hours__c = 10,
                                                       Credit_Hour_Types__c = 'Quarter Hours',
                                                       Course__c = course.Id,
                                                       Scholarship_Status__c = 'Approved',
                                                       Scholarship_Date__c = date.today());
        test.startTest();
        insert record;
        test.stopTest();
        
        Integer cnt = [select COUNT() from Awards__c where Contact__c = :contact.Id];
        
        System.assertEquals(1, cnt);
    }Raji*/
}