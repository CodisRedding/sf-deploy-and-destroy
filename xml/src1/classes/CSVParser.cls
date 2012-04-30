public class CSVParser
{
    private String content;
    public Integer ORGANIZATION = -1;
    public Integer CONTACT = -1;
    public Integer POSITION = -1;
    
    public CSVParser(String content)
    {
        this.content = content;
    }
    
    // a new comment
    public List<String[]> parse()
    {
        if(this.content == null)
        {
            System.debug('content is null');
            return null;
        }
        
        System.debug('content: ' + this.content);
        
        this.content = this.content.replace('\n', '^^^');
        this.content = this.content.replace('"^^^"', '"\n"');
        this.content = this.content.replace('"^', '"\n');
        String[] records = this.content.split('\n', 0);
        
        if(records.size() > 1)
        {
             if(records[0].toUpperCase().contains('"CONTACT ID"') || records[0].toUpperCase().contains('"ORGANIZATION ID"') || records[0].toUpperCase().contains('"POSITION ID"'))
             {
                 String[] header = records[0].split('","', 0);
                 for(Integer i = 0; i < header.size(); i++)
                 {
                     if(header[i].toUpperCase().replace('"', '') == 'CONTACT ID')
                     {
                         CONTACT = i;
                     } 
                     else if(header[i].toUpperCase().replace('"', '') == 'ORGANIZATION ID')
                     {
                         ORGANIZATION = i;
                     }
                     else if(header[i].toUpperCase().replace('"', '') == 'POSITION ID')
                     {
                         POSITION = i;
                     }
                 }
             }
             else
             {
                System.debug('header does not contain ids');
                return null; 
             }
             
             List<String[]> records2 = new List<String[]>();
             for(Integer i = 1; i < records.size(); i++)
             {
                 String[] tmp = new String[3];
                 String[] tmp2 = records[i].split('","', 0);

                 if(ORGANIZATION > -1 && (tmp2.size() - 1) >= ORGANIZATION)
                 {
                     tmp[0] = tmp2[ORGANIZATION].replace('"', '');
                 }
                 
                 if(POSITION > -1 && (tmp2.size() - 1) >= POSITION)
                 {
                     tmp[1] = tmp2[POSITION].replace('"', '');
                 }
                 
                 if(CONTACT > -1 && (tmp2.size() - 1) >= CONTACT)
                 {
                     tmp[2] = tmp2[CONTACT].replace('"', '');
                 }
                 
                 if((ORGANIZATION > -1 && (tmp2.size() - 1) >= ORGANIZATION) || 
                    (POSITION > -1 && (tmp2.size() - 1) >= POSITION) ||
                    (CONTACT > -1 && (tmp2.size() - 1) >= CONTACT))
                 {
                     records2.add(tmp);
                 }
             }
             
             ORGANIZATION = 0;
             POSITION = 1;
             CONTACT = 2;
             records = null;
             
             return records2;
        }
        
        System.debug('returning null');
        return null;
    } 
}
