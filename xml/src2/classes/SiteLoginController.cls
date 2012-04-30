/**
 * An apex page controller that exposes the site login functionality
 */
public class SiteLoginController {
    public String username {get; set;}
    public String password {get; set;}

    public PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
   	public SiteLoginController () {}
    
    public static testMethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}