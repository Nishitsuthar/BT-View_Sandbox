public with sharing class VG_UserDataAccess
{
    public static final Map<String, EC_Settings__c> EC_SETTINGS = EC_Settings__c.getAll();

    public static Map<Id, SObject> getMapByIds(List<Id> recordIds)
    {
        Set<String> fieldSet = new Set<String>{VG_Constants.OBJ_U_ID, VG_Constants.OBJ_U_FIRST_NAME,
            VG_Constants.OBJ_U_LAST_NAME};
                // VG_Util.checkCRUD_FLS(VG_Constants.OBJ_USER, fieldSet, VG_Constants.DML_OPERATION_READ);
                Map<Id, SObject> mapObject =  new Map<Id, SObject>([SELECT Id, FirstName,  SmallPhotoUrl, FullPhotoUrl,LastName,Employee_Department__c,Employee_Role__c,Employee_Office_Location__c,Title FROM User WHERE Id IN :recordIds]);
        if (mapObject == null)
        {
            mapObject = new Map<Id, SObject>();
        }
        return mapObject;
    }
    
    public static List<User> getDetailsById(List<Id> ids)
    {
        Set<String> fieldSet = new Set<String>{VG_Constants.OBJ_U_ID, VG_Constants.OBJ_U_NAME, VG_Constants.OBJ_U_PHONE,
            VG_Constants.OBJ_U_TITLE, VG_Constants.OBJ_U_EMAIL, VG_Constants.OBJ_U_SMALL_PHOTO_URL,
            VG_Constants.OBJ_U_FIRST_NAME, VG_Constants.OBJ_U_LAST_NAME, VG_Constants.OBJ_U_DEPARTMENT, VG_Constants.OBJ_U_CITY};
                // VG_Util.checkCRUD_FLS(VG_Constants.OBJ_USER, fieldSet, VG_Constants.DML_OPERATION_READ);
                List<User> users = [SELECT Id, Name, ManagerId, Phone, Title, Email, FullPhotoUrl, SmallPhotoUrl, LanguageLocaleKey, Profile.Name, UserRole.Name, ProfileId, FirstName, LastName, Employee_Department__c,Employee_Role__c,Employee_Office_Location__c, Country, City
                                    FROM User
                                    WHERE Id IN :ids
                                    AND isActive = true
                                   ];
        if (users == null)
        {
            users = new List<User>();
        }
        return users;
    }
    
    /*  public static List<User> getDetailsByTitle(List<String> titles)
{
Set<String> fieldSet = new Set<String>{VG_Constants.OBJ_U_ID, VG_Constants.OBJ_U_NAME, VG_Constants.OBJ_U_PHONE,
VG_Constants.OBJ_U_TITLE, VG_Constants.OBJ_U_EMAIL, VG_Constants.OBJ_U_SMALL_PHOTO_URL, VG_Constants.OBJ_U_PROFILE,
VG_Constants.OBJ_U_FIRST_NAME, VG_Constants.OBJ_U_LAST_NAME, VG_Constants.OBJ_U_DEPARTMENT, VG_Constants.OBJ_U_CITY};
//  VG_Util.checkCRUD_FLS(VG_Constants.OBJ_USER, fieldSet, VG_Constants.DML_OPERATION_READ);
List<User> users = [SELECT Id, Name, ManagerId, Phone, Title, Email, FullPhotoUrl, SmallPhotoUrl, LanguageLocaleKey, Profile.Name, UserRole.Name, ProfileId, FirstName, LastName, Employee_Department__c,Employee_Role__c,Employee_Office_Location__c, Country, City
FROM User
WHERE Title IN :titles];
if (users == null)
{
users = new List<User>();
}
return users;
}*/
    
    public static List<User> getDetailsByManagers(List<Id> managerIds)
    {
        Set<String> fieldSet = new Set<String>{VG_Constants.OBJ_U_ID, VG_Constants.OBJ_U_NAME, VG_Constants.OBJ_U_PHONE,
            VG_Constants.OBJ_U_TITLE, VG_Constants.OBJ_U_EMAIL, VG_Constants.OBJ_U_SMALL_PHOTO_URL};
                //  VG_Util.checkCRUD_FLS(VG_Constants.OBJ_USER, fieldSet, VG_Constants.DML_OPERATION_READ);
                List<User> users = [SELECT Id, Name, ManagerId, Phone, Title, Email, FullPhotoUrl, SmallPhotoUrl,Employee_Department__c	, LanguageLocaleKey, Profile.Name, UserRole.Name, ProfileId, FirstName, LastName, Department, Country, City
                                    FROM User
                                    WHERE ManagerId IN :managerIds
                                    AND isActive = true
                                   ];
        if (users == null)
        {
            users = new List<User>();
        }
        return users;
    }
    
    /*
public static User retrieveHireDate(){

User tmpUser = new User();
Set<String> fieldSet = new Set<String>{VG_Constants.NAMESPACE_PREFIX + VG_Constants.OBJ_U_HIRE_DATE};

//VG_Util.checkCRUD_FLS(VG_Constants.OBJ_USER, fieldSet, VG_Constants.DML_OPERATION_READ);

tmpUser = [Select Hire_Date__c FROM User WHERE Id = :UserInfo.getUserId()];

return tmpUser;
}*/
    public static  List <String> getRoles(){
        
        List <String> rolesList = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('user');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Employee_Role__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { 
            rolesList.add(a.getValue());
        }
        System.debug(' @@ loction @@'+ rolesList);
        return rolesList;
    }
    
    
    public static  List <String> getLocations(){
        
        List <String> locationList = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('user');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Employee_Office_Location__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { 
            locationList.add(a.getValue());
        }
        System.debug(' @@ loction @@'+ locationList);
        
        
        
        return locationList;
    }
    
    public static List <String> getDepartments(){
        
        List <String> departmentList = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('user');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Employee_Department__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { 
            departmentList.add(a.getValue());
        }
        System.debug(' @@ loction @@'+ departmentList);
        
        
        
        return departmentList;
    }
    @AuraEnabled
    public static String getPrefix()
    {
        Id communityId = Network.getNetworkId();
        if(String.isBlank(communityId)) return null;
        List<Network> networkList = VG_NetworkDataAccess.getDetailById(new List<Id>{communityId});
        string baseurl =URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('@@ baseurl'+baseurl);
        system.debug('@@ networkList[0].urlPathPrefix'+networkList[0].urlPathPrefix);
        //return baseurl+'/'+networkList[0].urlPathPrefix;
        return networkList[0].urlPathPrefix;
    }
    
    public static List<User> searchUsersByFilters(String searchKey,
                                                  List<String> depFilters,List<String> locFilters, 
                                                  String sortBy, String sortOrder,List<String> roleFilters,integer recordLimit){
        String nwid = Network.getNetworkId();
  
        List<User> userList = new List<User>();
        Set<String> fieldSet = new Set<String>{VG_Constants.OBJ_U_ID, VG_Constants.OBJ_U_NAME,
            VG_Constants.OBJ_U_PHONE, VG_Constants.OBJ_U_TITLE, VG_Constants.OBJ_U_EMAIL,
            VG_Constants.OBJ_U_SMALL_PHOTO_URL, VG_Constants.OBJ_U_PROFILE, VG_Constants.OBJ_U_FIRST_NAME,
            VG_Constants.OBJ_U_LAST_NAME, VG_Constants.OBJ_U_DEPARTMENT, VG_Constants.OBJ_U_CITY};
                //  VG_Util.checkCRUD_FLS(VG_Constants.OBJ_USER, fieldSet, VG_Constants.DML_OPERATION_READ);
                
                
                //String queryStr = 'SELECT AboutMe,FirstName,LastName,Title,UserType,Department,City FROM User WHERE UserType = \'Standard\' ';
                String queryStr = 'SELECT id, Title, FirstName,LastName,Email,Department,Employee_Department__c,Employee_Office_Location__c,City,FullPhotoUrl,SmallPhotoUrl,UserRole.Name FROM User ';
                if(nwid != null){
                    queryStr = queryStr + ' where isActive=true and id in (SELECT MemberId FROM NetworkMember where NetworkId =\''+nwid+'\') '; 
                } else {
                    queryStr = queryStr + ' where isActive=true ';
                }
                                                      
        String searchQryStr = '';
        String deptQryStr = '';
        String locationQryStr = '';
        String roleQryStr = '';
        
        
        if(roleFilters!=null && roleFilters.size() > 0){
            List<String> rolesfilter = new List<String>();
            for(String dept :  roleFilters){
                String formattedStr = '\'' + dept + '\'';
                rolesfilter.add(formattedStr);
            }
            roleQryStr = ' Employee_Role__c IN ' + rolesfilter;
        }
        system.debug('@@ rollQryStr query'+roleQryStr);
        if(searchKey != null && searchKey.length() > 0){
            searchKey = String.escapeSingleQuotes(searchKey);
            String name = '\'%' + searchKey + '%\'';
            searchQryStr = ' ( FirstName LIKE ' + name + ' OR LastName LIKE ' + name + ' OR Name LIKE ' + name + '  OR Email LIKE ' + name + ' ) ';
        }
        
        if(depFilters!=null && depFilters.size() > 0){
            List<String> departments = new List<String>();
            for(String dept :  depFilters){
                String formattedStr = '\'' + dept + '\'';
                departments.add(formattedStr);
            }
            deptQryStr = ' Employee_Department__c IN ' + departments;
        }
        
        if(locFilters!=null && locFilters.size() > 0){
            List<String> locations = new List<String>();
            for(String loc :  locFilters){
                String formattedStr = '\'' + loc + '\'';
                locations.add(formattedStr);
            }
            locationQryStr = ' Employee_Office_Location__c IN ' + locations;
        }
         if(String.isNotBlank(searchQryStr)){
           queryStr = queryStr + ' AND ' +searchQryStr;                                              
         }
         if(String.isNotBlank(deptQryStr)){
           queryStr = queryStr + ' AND ' +deptQryStr;                                              
         }
          if(String.isNotBlank(locationQryStr)){
           queryStr = queryStr + ' AND ' +locationQryStr;                                              
         }  
        if(String.isNotBlank(roleQryStr)){
           queryStr=queryStr +' AND '+roleQryStr;                                             
         }                                               
       
        if(sortBy==null){
            sortBy = 'name';
        }
        if(sortOrder==null){
            sortOrder = 'ASC';
        }
                  
        //system.debug('@@ before queryStr'+result);
        system.debug('@@ before queryStr'+queryStr);
        queryStr += ' ORDER BY '+sortBy+' '+sortOrder+' NULLS FIRST LIMIT '+recordLimit;
        System.debug('Employee Directory SOQL '+queryStr);
        userList = Database.query(queryStr);
        system.debug('@@ userList'+ userList);
        return userList;
    }
    @AuraEnabled
    public static string getUserInfo(){      
        
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        if(usrProfileName!='System Administrator'){
            List<PermissionSetAssignment> psaList = [SELECT PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Intranet_Admin' and AssigneeId=: Userinfo.getUserId()];
            if(!psaList.isEmpty() && psaList.size()>0){
                return psaList[0].PermissionSet.Name;
            }
        }
        system.debug('usrProfileName'+usrProfileName);
        return usrProfileName ;
    }
    
    @AuraEnabled
    public static Map<String, String> getDepartmentNavigations() {
        Map<String, String> departmentWithNavigationMap = new Map<String, String>();
        Id deptNavigation = Schema.SObjectType.EC_Content__c.getRecordTypeInfosByName().get('Department Navigations').getRecordTypeId();
        
        List<User> userList = VG_UserDataAccess.getDetailsById(new List<Id> {UserInfo.getUserId()});
        User usr = new User();
        if(userList.size() > 0) usr = userList[0];
        
        String DefaultDepartment = VG_ContentDataAccess.getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT);
        String DefaultRole = VG_ContentDataAccess.getDefault(VG_Constants.EC_DEFAULT_ROLE);
        String DefaultLocation = VG_ContentDataAccess.getDefault(VG_Constants.EC_DEFAULT_LOCATION);
        
        for (EC_Content__c eachNavigation : [
            SELECT Name, Action_URL__c 
            FROM EC_Content__c 
            WHERE RecordtypeId = :deptNavigation
            AND Department__c Includes (:usr.Employee_Department__c, :DefaultDepartment)
            AND Role__c Includes (:usr.Employee_Role__c, :DefaultRole)
            AND Location__c Includes (:usr.Employee_Office_Location__c, :DefaultLocation)
        ]) {
            departmentWithNavigationMap.put(eachNavigation.Name, eachNavigation.Action_URL__c);
        }
        System.debug('departmentWithNavigationMap'+departmentWithNavigationMap);
        return departmentWithNavigationMap;
    }
}