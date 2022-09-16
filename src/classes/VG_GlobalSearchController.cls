public with sharing class VG_GlobalSearchController {
	 
	@AuraEnabled
    public static List<SObject> searchArticle(String searchStr, String recordLimit ){
        system.debug('@@ searchArticle'+searchStr);
        return VG_SearchService.searchArticles(searchStr, UserInfo.getLanguage(),  integer.valueof(recordLimit));
    }
	
	@AuraEnabled
    public static List<User> searchPeople(String searchStr, String recordLimit ){
        system.debug('@@ searchPeople'+searchStr);
        return VG_UserDataAccess.searchUsersByFilters(searchStr, null,null,null,null, null, integer.valueof(recordLimit));
    }
	
	@AuraEnabled
    public static List<SObject> searchAnnouncements(String searchStr, String recordLimit ){
        system.debug('@@ searchAnnouncements'+searchStr);
        return VG_AnnouncementsController.getAllAnnouncements(searchStr, null,null,null,null,null,  integer.valueof(recordLimit));
    }
	
	@AuraEnabled
	public static List<Event> getEventsBySearchTerm(string searchTerm, integer numOfRecords){
      system.debug('@@ searchTerm events'+searchTerm);
	  List<User> userList = VG_UserDataAccess.getDetailsById(new List<Id> {UserInfo.getUserId()});                
        User loggedInUser = new User();
        if (userList.size() > 0) {
            loggedInUser = userList[0];
        }
        
	  return getEventsByFiltersAndRecordType('Company_Event', String.valueOf(loggedInUser.Employee_Department__c),
                                                String.valueOf(loggedInUser.Employee_Office_Location__c),
                                                String.valueOf(loggedInUser.Employee_Role__c),searchTerm,numOfRecords);
		}	 
  
	public static List<Event> getEventsByFiltersAndRecordType(String recordType, String department,String location, String role,string searchTerm,integer numOfRecords) {
        List<Event> allFilteredEvents = new List<Event>();
        Set<String> fieldList = Schema.getGlobalDescribe().get('Event').getDescribe().fields.getMap().keySet();
		 //construct Dynamic filters
        String dynamicFilter = '';
        String All = 'All';
        String globalLocation = 'Global';
        dynamicFilter += ' RecordType.DeveloperName = \'' + recordType + '\'';
        dynamicFilter += (String.isNotBlank(department) && !department.containsIgnoreCase('All')) ? ' AND ( Department__c includes (\''+ department + '\') OR Department__c includes (\''+ All + '\'))' : '';
        dynamicFilter += (String.isNotBlank(role) && !role.containsIgnoreCase('All')) ? ' AND (Role__c includes (\''+ role + '\') OR Role__c includes (\''+ All + '\'))' : '';
        dynamicFilter += (String.isNotBlank(location)) ? ' AND (Location__c includes (\''+ location + '\') OR Location__c includes (\'' + globalLocation + '\'))' : '';
        
		String qStr = 'FIND {' + searchTerm + '*} IN ALL FIELDS' + ' RETURNING Event( Id, Subject, StartDateTime, EndDateTime  where '
            + dynamicFilter+' limit '+numOfRecords+' )'  ;        
            
		System.debug('search query:'+qStr);
		List<List<SObject>> results = Search.query(qStr);
		System.debug('@@ search query reult:'+results[0]);
		if(results[0]!= null || !results[0].isEmpty()) 
			return results[0];
		else
			return null;
		
    }
	            
 
}