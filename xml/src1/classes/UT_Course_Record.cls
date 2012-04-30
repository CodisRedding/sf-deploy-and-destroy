@isTest
//Raji : Commented To Hide Awards Functionality
private class UT_Course_Record
{   
   static testMethod void CreateCourserecord() 
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
                                           Name__c = 'Some Course',
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
        
      //  Integer cnt = [select COUNT() from Awards__c where Contact__c = :contact.Id];
        Course_Record__c courserecord1record = [SELECT Credit_Hours__c ,Course__c ,Credit_Hour_Types__c  FROM Course_Record__c WHERE Id =: record .Id];
        System.debug(courserecord1record.Credit_Hours__c );
        System.debug(courserecord1record.Course__c );
        
        delete record;
        delete course;
    }
    static testMethod void Courserecord_CourseLookupFilter(){
    UnitTest_Exception_Manager.ThrowException = true;
        
        // create contact
        Contact contact = new Contact(FirstName = 'fname', 
                                      LastName = 'Lname',
                                      Salutation = 'Mr.');
                                      
        insert contact;
        
    
        // create course
        RecordType RT_ACS = Util.getRecordType('Courses__c', 'Advanced Course of Study');
        RecordType RT_BGTS = Util.getRecordType('Courses__c', 'BGTS');
        RecordType RT_CSM = Util.getRecordType('Courses__c', 'Cert in Specialized Ministry');

        Courses__c course_BGTS = new Courses__c(RecordTypeId = RT_BGTS.Id,
                                           Name__c = 'Course BGTS',
                                           Status__c = 'Active');
                                           
        insert course_BGTS;
        Courses__c course_ACS = new Courses__c(RecordTypeId = RT_ACS.Id,
                                           Name__c = 'Course ACS',
                                           Status__c = 'Active');
                                           
        insert course_ACS;
        Courses__c course_CSM = new Courses__c(RecordTypeId = RT_CSM.Id,
                                           Name__c = 'Course CSM',
                                           Status__c= 'Active');
                                           
        insert course_CSM;
        System.debug('course_ACS' + course_ACS);
        
        //Course Record
        RecordType RT_ACS1 = Util.getRecordType('Course_Record__c', 'Advanced Course of Study');
        RecordType RT_BGTS1 = Util.getRecordType('Course_Record__c', 'BGTS');
        RecordType RT_CSM1 = Util.getRecordType('Course_Record__c', 'Cert in Specialized Ministry');
        
        Course_Record__c cr_bgts = new Course_Record__c(RecordTypeId = RT_BGTS1.Id,
                                                       Contact__c = contact.Id,
                                                       Credit_Hours__c = 10,
                                                       Credit_Hour_Types__c = 'Quarter Hours',
                                                       Course__c = course_ACS.Id
                                                       );
        test.startTest();
        try{
                insert cr_bgts;
            }
            catch (DmlException e){
                System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                    'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION'),
                    e.getMessage());
            }
        Course_Record__c cr_acs = new Course_Record__c(RecordTypeId = RT_ACS1 .Id,
                                                       Contact__c = contact.Id,
                                                       Credit_Hours__c = 10,
                                                       Credit_Hour_Types__c = 'Quarter Hours',
                                                       Course__c = course_ACS .Id
                                                       );   
        insert cr_acs;
        Course_Record__c cr_acs1 = new Course_Record__c(id = cr_acs.id,
                                                       Course__c = course_BGTS.Id
                                                       ); 
        try{
                update cr_acs1;
            }
            catch (DmlException e){
                System.debug('Course Record Type should be Advanced Course of Study' + e);
            }                                                                                             
        test.stopTest();
    }
}