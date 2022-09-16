public without sharing class VG_FetchCalendarEvents {

    @AuraEnabled
    public static List<Event> fetchAllEvents() {
        List<User> userList = VG_UserDataAccess.getDetailsById(new List<Id> {UserInfo.getUserId()});
        
        
        User loggedInUser = new User();
        if (userList.size() > 0) {
            loggedInUser = userList[0];
        }
        
        List<Event> eventList  = retrieveEvents('Company_Event', String.valueOf(loggedInUser.Employee_Department__c),
                                                String.valueOf(loggedInUser.Employee_Office_Location__c),
                                                String.valueOf(loggedInUser.Employee_Role__c));
        return eventList;
    }
    
    @TestVisible
    private static List<Event> retrieveEvents(String recordType, String department,String location, String role) {
        return getEventsByFiltersAndRecordType(recordType, department, location, role);
    }
    
    @TestVisible
    private static List<Event> getEventsByFiltersAndRecordType(String recordType, String department,String location, String role) {
        List<Event> allFilteredEvents = new List<Event>();
        Set<String> fieldList = Schema.getGlobalDescribe().get('Event').getDescribe().fields.getMap().keySet();
        String dynamicSOQL = 'SELECT Id, Subject, StartDateTime, EndDateTime FROM Event ';
        
        //construct Dynamic filters
        String dynamicFilter = '';
        String All = 'All';
        String globalLocation = 'Global';
        dynamicFilter += ' RecordType.DeveloperName = \'' + recordType + '\'';
        dynamicFilter += (String.isNotBlank(department) && !department.containsIgnoreCase('All')) ? ' AND ( Department__c includes (\''+ department + '\') OR Department__c includes (\''+ All + '\'))' : '';
        dynamicFilter += (String.isNotBlank(role) && !role.containsIgnoreCase('All')) ? ' AND (Role__c includes (\''+ role + '\') OR Role__c includes (\''+ All + '\'))' : '';
        dynamicFilter += (String.isNotBlank(location) && !location.containsIgnoreCase('Global')) ? ' AND (Location__c includes (\''+ location + '\') OR Location__c includes (\'' + globalLocation + '\'))' : '';
        
        if (String.isNotBlank(dynamicFilter)) {
            dynamicSOQL += 'WHERE ' + dynamicFilter;
        }
        System.debug(dynamicSOQL);
        allFilteredEvents =  Database.query(dynamicSOQL);
        System.debug(allFilteredEvents);
        return allFilteredEvents;
    }
}