/* Rocky: 05/26/2011
    Trigger UnitTest: Contact_UpperCaseName.
*/


@isTest
private class UT_Contact_UpperCaseName 
{
    static testMethod void Contact_UpperCaseName() 
    {
        String firstName = 'rocky';
        String lastName = 'assad';
        String middleName = 'ian';
        
        firstName = Util.toUpperCase(1, firstName);
        lastName = Util.toUpperCase(1, lastName);
        middleName = Util.toUpperCase(1, middleName);
        
        System.assertEquals(firstName, 'Rocky');
        System.assertEquals(lastName, 'Assad');
        System.assertEquals(middleName, 'Ian');
    }
    
    static testMethod void Contact_UpperCaseName_As_Users() 
    {
    	Profile dataAdministratorProfile = [select id from profile where name='System Administrator' limit 1]; 
        User dataAdministrator = new User(alias = 'testda', 
								          email='test@test.com',
								          emailencodingkey='UTF-8', 
								          lastname='test', 
								          languagelocalekey='en_US',
								          localesidkey='en_US', 
								          profileid = dataAdministratorProfile.Id,
								          timezonesidkey='America/Chicago', 
								          username='testDataAdministrator@test.com'
        ); 
        
        System.runAs(dataAdministrator) 
        {        	
	        String firstName = 'rocky';
	        String lastName = 'assad';
	        String middleName = 'ian';
	        
	        firstName = Util.toUpperCase(1, firstName);
	        lastName = Util.toUpperCase(1, lastName);
	        middleName = Util.toUpperCase(1, middleName);
	        
	        System.assertEquals(firstName, 'Rocky');
	        System.assertEquals(lastName, 'Assad');
	        System.assertEquals(middleName, 'Ian');
        }
    }
}