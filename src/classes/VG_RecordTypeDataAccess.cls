public class VG_RecordTypeDataAccess {
public static List<RecordType> getRecordTypeByDeveloperNameAndType(List<String> developerNames, List<String> objectTypes)
	{
	    List<RecordType> records = 	[SELECT Id 
	                                   FROM RecordType 
	                                  WHERE DeveloperName IN :developerNames 
	                                    AND SObjectType IN :objectTypes];
	    if (records == null)
	    {
	    	records = new List<RecordType>();
	    }
	    return records;
	}
	
	public static List<RecordType> getRecordTypeByDeveloperNameTypeActive(List<String> developerNames, 
	    List<String> objectTypes, Boolean isActive)
	{
	    List<RecordType> records = 	[SELECT Id,DeveloperName 
	                                   FROM RecordType
	                                  WHERE isActive= :isActive 
	                                    AND DeveloperName IN :developerNames 
	                                    AND SObjectType IN :objectTypes];
	    if (records == null)
	    {
	    	records = new List<RecordType>();
	    }
	    return records;
	}
	
}