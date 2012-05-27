# Deploy & Destroy #
	
This project is a module created to allow automatic destructive changes between your SFDC orgs. This module can be used within your deployment process to auto generate a destructiveChanges.xml file to include in your deployment package. If you use a source control system that allows branching you'll be able to branch without having to manually destroy components in the web UI that are not yet in a branch.  

see issues/milestones for dev tasks

# Example #

This [destructiveChanges.xml](https://gist.github.com/2572054) file is an example generated using deployAndDestroy. (Notice the picklistValues, they also include recordtype picklist values ;) )

# Try it Out #

As changes are made I'll update the steps needed to test out the current version.

setup

1. You will need java 1.6 installed and you will need ant installed on your machine so run 'sudo yum install ant' then cd into the project root dir and run 'ant'.

1. Create a .env file in the environments dir. The name should be the name of your org and letters and numbers only. (Example: devorg1.env)

2. Configure your orgs properties. The easiest why is to copy one of the example .env files and will in your info instead.

3. Repeat steps 1 and 2 for all orgs that you want to available to deploy between.

4. run the program by passing the name of the org you want to deploy from (the name of the .env file minus '.env') as the first arg, and the name of the org to be deployed to as the second arg.

5. In a command prompt run 'java -jar deploy/project/deployAndDestroy.jar envFile1 envFile2 print-only' the first parameter is the org you're deploying from, and the second is the org you're deploying to. remeber for the parameter names,  just use the name of the file you created in the environemnts dir with the .env extension.

Cheers,

I'll be adding the .jar to the download section for those we don't want to build and just want to run it.