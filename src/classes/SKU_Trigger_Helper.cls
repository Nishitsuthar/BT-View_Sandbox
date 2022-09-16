public class SKU_Trigger_Helper
{
   
    public static String toHex(Integer intIn, Integer retLen)
    {
        List<String> hexDigit = new List<String> {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
        Integer nextInt = intIn;
        Integer remainder = 0;
        String retStr = '';
        Integer loopLimit = 18;
        integer i = 0;
        while (nextInt > 0)
        {
            retStr = hexDigit[math.mod(nextInt,16)] + retStr;
            nextInt = nextInt/16;
            i++;
            if (i>loopLimit) break;
        }
        while (retStr.length() < retLen)
        {
            retStr = 0 + retStr;
        } 
        return retStr;      
    }
    
    public static String toBase36(Integer intIn, Integer offset, Integer retLen)
    {
        return toBase36(intIn+offset, retLen);
    }
    
    public static String toBase36(Integer intIn, Integer retLen)
    {
        List<String> b32Digit = new List<String> {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        Integer nextInt = intIn;
        Integer remainder = 0;
        String retStr = '';
        Integer loopLimit = 18;
        integer i = 0;
        while (nextInt > 0)
        {
            retStr = b32Digit[math.mod(nextInt,36)] + retStr;
            nextInt = nextInt/36;
            i++;
            if (i>loopLimit) break;
        }
        while (retStr.length() < retLen)
        {
            retStr = 0 + retStr;
        } 
        return retStr;      
    }
    
    public static Map<String,String> loadMap(String elementName )
    {
        Map<String,String> newMap = new Map<String,String>();
        for (SKU_Prefix_Element_Map_Entry__c speme: [SELECT Id, Name, Map_to_Value__c, SKU_Prefix_Element_Map__r.name FROM SKU_Prefix_Element_Map_Entry__c 
            WHERE SKU_Prefix_Element_Map__r.name = :elementName])
        {
            newMap.put(speme.Name, speme.Map_to_Value__c);
        }   
        return newMap;  
    }   

}