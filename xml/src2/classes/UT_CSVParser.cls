@isTest(SeeAllData=true)
private class UT_CSVParser
{
    static testMethod void testParse()
    {  
        //PageReference page = new PageReference('/00OJ0000000SKPP?export=1&enc=UTF-8&xf=csv');
        //String content = page.getContent().toString();
        
        String content = '';
        
        content += '"CONTACT ID","ORGANIZATION ID","POSITION ID"\n';
        content += '"1","2","3"\n';
        content += '"4","5","6"\n';
        content += '"","",""\n';
        content += '"7","8","9"\n';
        
        test.startTest();
        
        CSVParser parser = new CSVParser(content);
        List<String[]> result = parser.parse();
        
        test.stopTest();
        
        System.assertNotEquals(null, result);
        System.assertEquals(5, result.size());
        System.assertEquals('7', result.get(3)[parser.CONTACT]);
        System.assertEquals('8', result.get(3)[parser.ORGANIZATION]);
        System.assertEquals('9', result.get(3)[parser.POSITION]);
    }
}