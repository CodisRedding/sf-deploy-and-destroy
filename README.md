
[![Build Status](https://travis-ci.org/fourq/ploggly.png?branch=master)](https://travis-ci.org/fourq/ploggly)

# I love when you test me. #

What the hell is this?: Compare and sync Salesforce orgs. This readme only shows how to view the diffs, but not actually sync. You can compare orgs a few different ways. 1> Github repo - Salesforce org. 2> FileSystem dir - Salesforce org. 3> Salesforce org - Salesforce org. This readme only explains #3.

prerequisite: Java 1.6+

Windows|Mac|Linux|Gameboy

1. Download the application > https://github.com/Fourqio/sf-deploy-and-destroy/zipball/master 

2. Open a terminal and CD to the app.

3. run 'java -jar deployAndDestroy.jar --install-only'

4. Open the environment DIR shown

5. Copy salesforce-example.env 2 times and rename to:

salesforce-org-from.env

salesforce-org-to.env

open each file and fill in the needed config info. If it's a production org put production instead of test for 'sf.environment'. Make sure the 'sf.login' is an admin or user that has a similar profile. Relace the 'sf.environment.server' with your server obviously. 

[example]

type=salesforce

sf.environment=test

sf.environment.server=cs11

sf.login=rocky@gmail.org.rocky

sf.password=MyPassword

sf.security.token=YourSecToken

sf.include.packages=false 

6. Run a test run. Open a terminal and CD to the app.

7. run 'java -jar deployAndDestroy.jar -e salesforce-org-from salesforce-org-to --print-only'

The entire process should take less than 2 minutes, but really depends on the size of your orgs. 

You should see a list of differences in deployable metadata if there is any. The list shown is all of the components that would be destroyed in the salesforce-org-to.env org if you weren't running a test run. I will supply the jar option for actually syncing once I hear some feedback.
