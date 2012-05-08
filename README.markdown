# Deploy & Destroy #
	
This project is a module created to allow automatic destructive changes between your SFDC orgs. This module can be used within your deployment process to auto generate a destructiveChanges.xml file to include in your deployment package. If you use a source control system that allows branching you'll be able to branch without having to manually destroy components in the web UI that are not yet in a branch.  

see issues/milestones for dev tasks

# Example #

This [destructiveChanges.xml](https://gist.github.com/2572054) file is an example generated using deployAndDestroy. (Notice the picklistValues, they also include recordtype picklist values ;) )

*Note** this is just an example, so if you're wondering why there are standard objects, fields, etc. it's because I ran deployAndDestroy against an empty org.

# Try it Out #

As changes are made I'll update the steps needed to test out the current version.

setup

1. Create a .env file in the environments dir. The name should be the name of your org and letters and numbers only. (Example: devorg1.env)

2. Configure your orgs properties. The easiest why is to copy one of the example .env files and will in your info instead.

3. Repeat steps 1 and 2 for all orgs that you want to available to deploy between.

4. run the program by passing the name of the org you want to deploy from (the name of the .env file minus '.env') as the first arg, and the name of the org to be deployed to as the second arg.

5. At the moment the the environment metadata ignores list isn't being taken into consideration so it may fail on final deploy. But if you just want to run the program to see what it is deploying between orgs, and inspect the destructive changes, then this just let it fail for now. You can view the .zip file that is used to deploy in the environments dir in a folder named the same as the org your deploying from. Change out the destructiveChanges.xml to see what will be removed on the deploy to org.

woo