public class searchregistration{


Map<string,string>responseMap = new Map<string,string>();

public contact con {get;set;}
public Boolean isEmailExists{get;set;}
public Boolean isContact{get;set;}
public Boolean isAgree{get;set;}
public Boolean disableSubmit{get;set;}


public Boolean enterEmail{get;set;}
public Boolean invalidCaptcha{get;set;}
public string SelectedCountry{get;set;}
public string SelectedUSState{get;set;}
public string SelectedCAState{get;set;}

public string PSelectedCountry{get;set;}

public Contact conInfo {get;set;}
public Lead leadInfo{get;set;}
public List<string>accountNames{get;set;}
public String selectedCompany{get;set;}
public Account newAccount{get;set;}
public Education_Information__c foundAccount{get;set;}
public Boolean isCompanySelected{get;set;}
public Boolean isCompanyFound{get;set;}
public Attachment termsPdf{get;set;}
public Document pdf{get;set;}
RecordType recType,accRecType;
public Boolean renderNext{get;set;}


public string response {get;set;}
public string auid {get;set;}
public string res;
public string email {get;set;}
public string token {get;set;}
Map<string,string>interestingData;
public string dSeed {get;set;}
public Boolean turnLoadingOff {get;set;}
public Contact insertedContact{get;set;}
public string contactUserName {get;set;}
public User duplicateUser {get;set;}
public Boolean isBanned {get;set;}
Messaging.SingleEmailMessage mail;
String[] toAddresses;
public string errorMessage{get;set;}

public searchregistration()
{

    renderNext = false;
    dSeed = string.valueOf(DateTime.now().getTime());
    
    res = '';
    
    turnLoadingOff = false;
    
    con = new contact();
    
    isCompanySelected = false;
    isCompanyFound = false;
    invalidCaptcha = false;
    
    newAccount = new Account();
    isAgree = false;
    disableSubmit = true;
    
    isBanned = false;
    
    }
    
      public pageReference getCompanyDetails(){
      
          isCompanySelected = true;
          isCompanyFound = true;
          string selectedCompany = ApexPages.currentPage().getParameters().get('one');
          
          system.debug('&&&&&&&&&&&&&&&&&foundAccount&&&&&&&&&&&'+foundAccount);
          return null; 
          
       }   
       
}