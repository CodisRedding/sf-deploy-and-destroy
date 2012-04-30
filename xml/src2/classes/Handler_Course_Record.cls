public with sharing class Handler_Course_Record
{
    // Use @future methods when possible in AFTER operations. Note that the future method will 
    // not accept strongly typed collections... use Set<Id> and re-query the data. You can then 
    // pass in the keySet()
    
    /*Raji : Commenting to Hide Award Functionality
    @future
    public static void CreateCourseAwardAysnc(Set<Id> newCourseRecIds)
    {
        // local vars
        Set<Id> contactIds = new Set<Id>();
        List<Course_Record__c> courseRecsToAdd = new List<Course_Record__c>();
        List<Awards__c> awardsToAdd = new List<Awards__c>();
        
        // pre-process
        List<Course_Record__c> newCourseRecs = [select Id, RecordType.Name, Scholarship_Status__c, Scholarship_Date__c, Contact__c from Course_Record__c where Id in :newCourseRecIds];
        
        // grab all contact id's
        for(Course_Record__c course : newCourseRecs)
        {
            contactIds.Add(course.Contact__c);
        }
        
        List<Awards__c> contactsWithAwards = [select Id, Contact__c from Awards__c where Name__c = 'Course Scholarship' and Contact__c in :contactIds];
        
        // loop through all course records
        for(Course_Record__c courseRec : newCourseRecs)
        {
            // check if can recieve award
            if((courseRec.Scholarship_Status__c == 'Approved') && 
                (courseRec.RecordType.Name == 'Advanced Course of Study' || courseRec.RecordType.Name == 'Cert in Specialized Ministry' || courseRec.RecordType.Name == 'BGTS'))
            {
                // check if contact already has an award
                Boolean add = true;
                for(Awards__c contactWithAward : contactsWithAwards)
                {
                    if(courseRec.Contact__c == contactWithAward.Contact__c)
                    {
                        add = false;
                    }
                }
                
                if(add)
                {
                    // create award
                    Awards__c award = new Awards__c(Name__c = 'Course Scholarship', 
                                                    Course_Record__c = courseRec.Id, 
                                                    Contact__c = courseRec.Contact__c, 
                                                    Date_Awarded__c = courseRec.Scholarship_Date__c);
                    awardsToAdd.Add(award);
                }
            }
        }
        
        // insert awards
        insert awardsToAdd;
    }Raji*/
    
    public static void RemoveHistoricalGrade(List<Course_Record__c> newCourseRecs, Map<Id, Course_Record__c> oldCourseRecs)
    {
        for(Course_Record__c courseRecord : newCourseRecs) 
        {
            if((courseRecord.Grade__c != oldCourseRecs.get(courseRecord.id).Grade__c) &&
                courseRecord.GBHEM_DataCenter_grade__c != null) 
            {
                
                courseRecord.GBHEM_DataCenter_grade__c = null;
            }
        }
    }
    
    public static void DefaultAmountPaid(List<Course_Record__c> newCourseRecs)
    {
        RecordType recordType = Util.getRecordType('Course_Record__c', 'Advanced Course of Study');

        for(Course_Record__c courseRecord : newCourseRecs) {
            
            if(recordType.Id == courseRecord.RecordTypeId) {
                
                if(courseRecord.Class_Type__c == 'Online') {
                    
                    if(courseRecord.Amount_Paid__c == null || courseRecord.Amount_Paid__c == '') {
                        
                        courseRecord.Amount_Paid__c = '175.00';
                    }
                } else if (courseRecord.Class_Type__c == 'Correspondence') {
                    
                    if(courseRecord.Amount_Paid__c == null || courseRecord.Amount_Paid__c == '') {
                        
                        courseRecord.Amount_Paid__c = '150.00';
                    }
                }
            }
        }
    }
    
    //Raji : 2/20/2012
    //Rocky Assad : 2/29/2012 
    //Logic to avoid Lookup Filter Limitation Validation rule
    public static void CR_LookupFilterValidation(List<Course_Record__c> newCR)
    {
        for(Course_Record__c corRec : newCR)
        {
            if((corRec.Course__c != null) && (corRec.RecordType.Name != corRec.Course__r.RecordType.Name))
            {
                corRec.addError('The course\'s record type should match that of the course.');
            }
        }
    }
}