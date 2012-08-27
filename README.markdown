# Deploy & Destroy #

Compare and sync your Salesforce orgs. 
	
# How is this useful to me? #

As a Developer this means that you can branch your Salesforce tasks using a single dev org. This is possible since this app will compare your current branch to your dev org, creating a deployment package and including a destructive changes file that will sync your current branch in to you org.

As a Deployer (responsible for releasing versions, or pushing between non-prod life-cycle orgs) this means that you don't have to spend hours picking through metadata, and crappy release notes to figure out exactly what has changed. You can run this app with the '--print-only' option and it will show you the differences between to orgs, or between a branch and an org without actually syncing. You can then run it with the '--destroy-only' (all explained below) once you know the changes that will be applied.

As a Continuious Integration service you can setup your task to run this app to preform your CI directly from Github or another org. (Support for other VCS is in the works).

setup

Binary:
1. Download the jar.
2. Move it into any directory you want.
3. Open a terminal and cd to the directory in step 2.
4. Install the system configuration files by running the following command: 

[for Windows] 'java -jar ./deployAndDestroy.jar --install-only'
[non-Windows] './deployAndDestroy.jar --install-only'

Open the directory shown in the terminal that contains your newly installed environment configuration files. There will be 2 examples installed, one for github branches and one for salesforce orgs.

5. TODO:...

1. You will need java 1.6 installed and you will need ant installed on your machine so run 'sudo yum install ant' then cd into the project root dir and run 'ant'.

1. Create a .env file in the environments dir. The name should be the name of your org and letters and numbers only. (Example: devorg1.env)

2. Configure your orgs properties. The easiest why is to copy one of the example .env files and will in your info instead.

3. Repeat steps 1 and 2 for all orgs that you want to available to deploy between.

4. run the program by passing the name of the org you want to deploy from (the name of the .env file minus '.env') as the first arg, and the name of the org to be deployed to as the second arg.

5. In a command prompt run 'java -jar deploy/project/deployAndDestroy.jar envFile1 envFile2 print-only' the first parameter is the org you're deploying from, and the second is the org you're deploying to. remeber for the parameter names,  just use the name of the file you created in the environemnts dir with the .env extension.