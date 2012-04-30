/* Rocky: 05/26/2011
    Trigger UnitTest: Account_RestrictAccountDel
*/


@isTest
Private class UT_Account_RestrictAccountDel {

    static testMethod void Account_RestrictAccountDel() {
    
    	// Rocky Assad
    	Contact contact = new Contact(FirstName = 'Test', 
                                      LastName = 'User',
                                      Salutation = 'Mr.');
                                      
		insert contact;
                                          
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'GBHEM Constituent'];
        
        // Start the test, this changes governor limit context to   
        // that of trigger rather than test.   
        test.startTest(); 
        
        try {
            
            delete account;
        } catch(DmlException ex) {
            
            System.assert(ex.getMessage().contains(String.format('Cannot delete account: {0}', new String[] { account.Name })), ex.getMessage());
        } finally {
            
            // Stop the test, this changes limit context back to test from trigger.
            test.stopTest();
        }
    }
}