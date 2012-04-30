public class overrideSave {

   public Pastoral_Acts__c newRec {get;set;}
        
    public overrideSave(ApexPages.StandardController stdController) {
        newRec = new Pastoral_Acts__c();     
        
    }
    public pageReference save(){
       try{
        insert newRec;
        newRec = new Pastoral_Acts__c();

        UnitTest_Exception_Manager.HandleUnitTestException();        
          }
       catch(Exception e){
           return Page.PastrolActs;
       }           
       
       return Page.PastrolActs;       
    }
    public pageReference cancel(){
        newRec = new Pastoral_Acts__c();
        return Page.PastrolActs;
    }
public static testmethod void test(){

        Pastoral_Acts__c testRec = new Pastoral_Acts__c();
        Insert testRec;
        Test.startTest();
        Test.setCurrentpage(new PageReference('/apex/pastrolacts'));
        overrideSave testObj = new overrideSave(new ApexPages.StandardController(testRec));
        testObj.Save();
        
        UnitTest_Exception_Manager.ThrowException = true;    
        testObj.Save();   
        testObj.Cancel();
        Test.stopTest();
        }
}