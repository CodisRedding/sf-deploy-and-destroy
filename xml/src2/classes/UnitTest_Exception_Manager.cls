public with sharing class UnitTest_Exception_Manager 
{
	public static Boolean ThrowException = false;
	
	public static void HandleUnitTestException()
	{
		if(ThrowException)
		{
			throw new UnitTest_Exception('Unit Test Exception');
		}
	}
	
	public class UnitTest_Exception extends exception { }
}