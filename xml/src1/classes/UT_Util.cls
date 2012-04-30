/* Rocky: 05/26/2011
    Class Function UnitTest: Util.toUpperCase(Integer, String).
*/

@isTest
private class UT_Util 
{
	public static testMethod void getRecordType() 
	{
		UnitTest_Exception_Manager.ThrowException = true;
			
		System.debug('Record Type Default For Account (hard-coded): 012K0000000ChNdIAK');
		
		RecordType rt = Util.getRecordType('Account', 'Default');
		
		// Rocky Assad
		// Id is going to fail if you try to hardcode (if not now, then later)
		//System.assertEquals(rt.Id, '012K0000000ChNdIAK');
		System.assertEquals(rt.Name, 'Default');
	}

    public static testMethod void toUpperCase() 
    {
        UnitTest_Exception_Manager.ThrowException = true;
        
        System.debug('Uppercasing the first 5 characters of the \'one twothree\' string.');

        string result = Util.toUpperCase(5, 'one twothree');
        System.assertEquals('ONE Twothree', result);
        
        System.debug('Uppercasing the first character of the \'onetwothree\' string.');
    
        result = Util.toUpperCase(1, 'onetwothree');
        System.assertEquals('Onetwothree', result);
        
        System.debug('Uppercasing the first 100 characters of the \'onetwothree\' string.');
        
        result = Util.toUpperCase(100, 'onetwothree');
        System.assertEquals('ONETWOTHREE', result);
        
        System.debug('Uppercasing the first 0 characters of the \'onetwothree\' string.');
        
        result = Util.toUpperCase(0, 'onetwothree');
        System.assertEquals('onetwothree', result);
        
        System.debug('Uppercasing the first 0 characters of the \'\' string.');
        
        result = Util.toUpperCase(0, '');
        System.assertEquals('', result);
        
        System.debug('Uppercasing the first 100 characters of the \'\' string.');
        
        result = Util.toUpperCase(100, '');
        System.assertEquals('', result);
    }
}