public class searchController
{
    public String resp {get; set;}
    
    //Default Constructor
    public searchController() 
    {

        resp = '';
        String query = '';
        // Check if parameter was passed, then do the search
        if (ApexPages.currentPage().getParameters().get('q') != null) 
        {
            query += ApexPages.currentPage().getParameters().get('q');
            
            try{
            RecordType recType = [Select Id from RecordType where Name = 'Collegiate Ministrey' 
                                                 and SobjectType = :'Account'
                                                 and isActive = true];   
            if(recType!=null)      
            {
            List<Account> students = [select Id, Name
                                            From Account 
                                            Where Name like :(query+'%')
                                            and RecordTypeId = :recType.Id];
                                           

            for (Integer i=0;i<students.size();i++) 
            {
                resp += students[i].Name + '<div style=\'display:none\'>' + students[i].Id+'</div>';  
                if(i<(students.size()-1))
                    resp += '\n';
            }
            }
            }
            Catch(QueryException e)
            { 
                System.debug('Exception caught:'+e.getMessage());
            }
        }      
    }
}