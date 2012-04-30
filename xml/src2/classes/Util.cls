/* Raji: 05/13/2011
    Collection of general purpose functions
    1. Phone
    2. SSN Format (formatSSN)
    3. Uppercase word(s) method
    4. Picklist All Value
*/
global class Util 
{
    /* Rocky: 06/27/2011
        Gets the string id from a given object and record type name.
    */
    public static RecordType getRecordType(string objectName, string recordTypeName) 
    {
        try
        { 
            RecordType recordType = [
                SELECT 
                    Id, Name
                FROM 
                    RecordType 
                WHERE 
                    IsActive = true 
                AND 
                    sObjectType = :objectName
                AND 
                    Name = :recordTypeName];
                   
            return recordType;
        } catch(Exception ex) {
            return  null;
        }
    }
    
    /* Rocky: 05/23/2011
        Upper cases any number of charaters in a string start at the zero index
         
        one two three = ONE Two three if the 5 characters are told to be upper chase.
    */
    public static string toUpperCase(integer firstHowManyLetters, string word) 
    {
        if(word == null || word.length() == 0) {
            
            return '';
        }
        
        if(word.length() <= firstHowManyLetters) {
            
            firstHowManyLetters = word.length();
        }
        
        return (word.substring(0, firstHowManyLetters)).toUpperCase() + word.substring(firstHowManyLetters);
    }
    
    public static string formatSSN(string ssn) 
    {
         /*rocky code
        // Rocky Assad
        // May 17, 2011
        // Format Social Security Number provided.
         
        // 999-99-9999 or 999999999.
        
        // Remove all dashes
        string ssnStripped = ssn.replaceAll('-', '');
        
        
        // Check to see if length of ssn string is 0 or greater than 9 or not numeric.
        // If so return an empty string.
        Pattern numericPattern = Pattern.compile('[0-9]');
        Matcher matcher = numericPattern.matcher(ssnStripped);
        
        if(ssnStripped.length() == 0 || ssnStripped.length() > 9 || !matcher.matches()) {
            return '';
        }
        
        // Return ssn in correct format.
        return ssnStripped.substring(0, 3) + '-' + 
               ssnStripped.substring(3, 2) + '-' + 
               ssnStripped.substring(5, 4);   
        Rocky Code*/
               
        //Raji Code
        string ssnnumber;
        string nonnumbers = '[^0-9]';
        if (ssn == null ) return ssn;
        if (ssn == '' ) return ssn;
        
        ssnnumber = ssn.replaceAll(nonnumbers,'');
       
        if (ssnnumber.length() == 9) 
                    return ssnnumber.substring(0,3) + '-' +
                            ssnnumber.substring(3,5) + '-' +
                            ssnnumber.substring(5,9);
        else 
        return ssn;
        
    }
    

public static string formatPC(String pc)
    {
         /*Manohar code
        
        // Format Zip/Postalcode provided.
         
        // 99999 or 99999-9999.(If we give 9 digit number then it takes '-'after 5 digits)
        
        // Remove all dashes
        string pcStripped = pc.replaceAll('-', '');
        
        
        // Check to see if length of pc string is 0 or greater than 9 or not numeric.
        // If so return an empty string.
        Pattern numericPattern = Pattern.compile('[0-9]');
        Matcher matcher = numericPattern.matcher(pcStripped);
        
        if(pcStripped.length() == 0 || pcStripped.length() > 9 || !matcher.matches()) {
            return '';
        }
        
        // Return pc in correct format.
        return pcStripped.substring(0, 5) + '-' + 
               pcStripped.substring(5, 9);   
        */
               
        //Manohar Code
        string postalCode;
        string nonnumbers = '[^0-9]';
        if (pc == null ) return pc;
        if (pc == '' ) return pc;
        
        postalCode = pc.replaceAll(nonnumbers,'');
       
        if (postalCode.length() == 9) 
                    return postalCode.substring(0,5) + '-' +
                           postalCode.substring(5,9);
        else if (postalCode.length() == 5)
                    return postalCode;
        else
        return PC;
        
    }
        
    public static string formatPhone(string phone, string country) 
    {
        // Format a phone number according to the country
        // In general two format may be expected, with and without country code
        // e.g. '11 2222-3333' and  +55 11 2222-3333      ' for Brazil
        
        // If phone does not apply to country Like wrong number of digits,phone is returned
        
        string phonenumber;
        string nonnumbers = '[^0-9]';
        
        if (phone == null || country == null) return phone;
        if (phone == '' || country == '') return phone;
        
        if (country == 'Brazil') {
            phonenumber = phone.replaceAll(nonnumbers,'');

            if (phonenumber.length() == 10) 
                return phonenumber.substring(0,2) + ' ' +
                        phonenumber.substring(2,6) + '-' +
                        phonenumber.substring(6,10);

            if (phonenumber.length() == 12) {
                if (phonenumber.substring(0,2) == '55') {
                    return '+55 ' +
                            phonenumber.substring(2,4) + ' ' +
                            phonenumber.substring(4,8) + '-' +
                            phonenumber.substring(8,12);
                }
            }

        } else {
             if (country == 'UNITED STATES OF AMERICA' || country == 'Canada') {
                phonenumber = phone.replaceAll(nonnumbers,'');
    
                if (phonenumber.length() == 10) 
                    return '(' + phonenumber.substring(0,3) + ') ' +
                            phonenumber.substring(3,6) + '-' +
                            phonenumber.substring(6,10);

                if (phonenumber.length() == 11) {
                    if (phonenumber.substring(0,1) == '1') {
                        return '+1 ' +
                                '(' + phonenumber.substring(1,4) + ') ' +
                                phonenumber.substring(4,7) + '-' +
                                phonenumber.substring(7,11);
                    }
                }
            }            
        }
        
        // If we get here it is either an error or an unsupported country
        return phone;
        
    }   
}