/*
Raji : 01/19/2012
Certified Updates : Certified renewal status & Status Functionality for Reports.
*/
@isTest
private class UT_CertifiedUpdates{
    static testMethod void UpdateStatus_test(){
        UnitTest_Exception_Manager.ThrowException = true;
        
        //Insert Contact
        Contact contact1 = new Contact(
            LastName = 'Last Name 1',
            Salutation = 'Mr.'
            );
        test.starttest();
        insert contact1;
        //Education Certification
        Certification_in_Specialized_Ministry__c ec1 = new Certification_in_Specialized_Ministry__c(
            Contact__c = contact1.Id,
            Track__c = 'Professional',
            Area__c = 'Christian Education'
            );
        
        insert ec1;
        // Certification Update
        Certification_Updates__c cu1 = new Certification_Updates__c(
              Education_Certification__c = ec1.Id,
              Certification_Renewal_Status__c = 'Involuntarily Declined Renewal',
              Status__c = 'Active'
              );
        
             
        insert cu1;
        
        Certification_Updates__c cu1record = [SELECT Education_Certification__c, Certification_Renewal_Status__c,Status__c FROM Certification_Updates__c WHERE Id =: cu1.Id];
        System.assertEquals('Inactive', cu1record.Status__c); 
        
        //Update Certified Updates
        Certification_Updates__c cu2 = new Certification_Updates__c(
              Id = cu1.Id,
              Education_Certification__c = ec1.Id,
              Certification_Renewal_Status__c = 'Renewed',
              Status__c = 'InActive'
              );

        Update cu2;
        test.stoptest();
         
         
        Certification_Updates__c cu2record = [SELECT Education_Certification__c, Certification_Renewal_Status__c,Status__c FROM Certification_Updates__c WHERE Id =: cu2.Id];
        System.assertEquals('Active', cu2record.Status__c); 
        


}
}