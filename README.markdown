# I love when you test me. #

prerequisite: Java 1.6+

Windows|Mac|Linux|Gameboy

1. Download the application > 

2. Open a terminal and CD to the app.

3. run 'java -jar deployAndDestroy.jar --install-only'

4. Open the environment DIR shown

5. Copy salesforce-example.env 2 times and rename to:

salesforce-org-from.env
salesforce-org-to.env

open each file and fill in the needed config info. If it's a production org put production instead of test for 'sf.environment'. Make sure the 'sf.login' is an admin or user that has a similar profile.

[example]
type=salesforce
sf.environment=test
sf.environment.server=cs11
sf.login=rocky@gmail.org.rocky
sf.password=MyPassword
sf.security.token=YourSecToken
sf.include.packages=false 

6. Run a test run. Open a terminal and CD to the app.

7. run 'java -jar deployAndDestroy.jar salesforce-org-from salesforce-org-to --print-only'

The entire process should take less than 2 minutes, but really depends on the size of your orgs. 

You should see a list of differences in deployable metadata if there is any. The list shown is all of the components that would be destroyed in the salesforce-org-to.env org if you weren't running a test run. I will supply the jar option for actually syncing once I hear some feedback.
