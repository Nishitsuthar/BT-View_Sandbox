public class VG_EmployeeDirectoryController {
    @AuraEnabled
    public static DirectoryFilters getAllFilters() {
        DirectoryFilters filterObj = new DirectoryFilters();
        filterObj.lUsersGroupedByLoc = getLocations();
        filterObj.lUsersGroupedByDep = getDepartments();
        filterObj.lUsersGroupedByRoles=getRoles();
        return filterObj;
    }
    @AuraEnabled
    public static List <String> getRoles() {
        return VG_UserDataAccess.getRoles();
    }
    
    @AuraEnabled
    public static List <String> getLocations() {
        return VG_UserDataAccess.getLocations();
    }
    
    @AuraEnabled
    public static void getTestUsers() {
        
    }
    
    @AuraEnabled
    public static List <String> getDepartments() {
        return VG_UserDataAccess.getDepartments();
    }
    
    @AuraEnabled
    public static Map<String,List<User>> getAllUsers(String searchKey, List<String> depFilters, List<String> locFilters, Boolean showmore, String sortBy, String sortOrder,List<String> roleFilter) {
        integer listSize=(showmore)?5:1000;
        System.debug('@@ roleFilter'+roleFilter);
        if(sortBy == null || String.isBlank(sortBy)){
            sortBy = VG_Constants.EC_ED_DEFAULT_SORT_FIELD;
        }
        
        if(sortOrder == null || String.isBlank(sortOrder)){
            sortOrder = VG_Constants.EC_ED_DEFAULT_SORT_ORDER;
        }
        
        //if showmore is true it calling for component dInIt  method
       // if(showmore){
            List<User> allUser=VG_UserDataAccess.searchUsersByFilters(searchKey, depFilters, locFilters, sortBy, sortOrder,roleFilter,1000);
            Map<string,  List<User>> depUserMap=new  Map<string, List<User>>();
            System.debug(' @@depUserMap ' +depUserMap);
            List<User> limitedUserdata=new  List<User>();
            //MAP of user with department
            for(User us:allUser){
                if(us.Employee_Department__c!=null){
                    if( depUserMap.containsKey(us.Employee_Department__c) ){
                        list<user> temp=depUserMap.get(us.Employee_Department__c);
                        if(temp.size() <listSize){
                            temp.add(us);
                            depUserMap.put(us.Employee_Department__c,temp);
                        }
                    }
                    else{
                        list<user> temp=new list<user>();
                        temp.add(us);
                        depUserMap.put(us.Employee_Department__c,temp);
                        System.debug(' @@depUserMap new list ' +depUserMap);
                    }
                }
            }
            return depUserMap;
       /* } else {
            return VG_UserDataAccess.searchUsersByFilters(searchKey, depFilters, locFilters, sortBy, sortOrder,roleFilter,1000);
        }*/
        
    }
    
    @AuraEnabled
    public static String getSortOptions() {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        Schema.SObjectType ObjectSchema = schemaMap.get('User');
        
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        
        Set<String> fields = new Set<String>{'FirstName','LastName','Title','AboutMe','UserType','Department','City'};
            List<SelectOption> fieldNames = new List<SelectOption>();
        for (String fieldName: fields)
        {
            String fName = fieldMap.get(fieldName).getDescribe().getLabel();
            fieldNames.add(new SelectOption(fieldName, fName));
            
        }
        return JSON.serialize(fieldNames);
        
    }
    
    public class SelectOption {
        public SelectOption(String value, String label) {
            this.value = value;
            this.label = label;
            this.disabled = false;
            this.escapeItem = false;
        }
        
        public SelectOption(String value, String label, Boolean isDisabled) {
            this.value = value;
            this.label = label;
            this.disabled = isDisabled;
            this.escapeItem = false;
        }
        
        @AuraEnabled
        public String label { get;set; }
        @AuraEnabled
        public String value { get;set; }
        @AuraEnabled
        public Boolean disabled { get;set; }
        @AuraEnabled
        public Boolean escapeItem { get;set; }
    }
    
    // Wrapper class for filters
    public class DirectoryFilters {
        public @AuraEnabled List <String> lUsersGroupedByLoc;
        public @AuraEnabled List <String> lUsersGroupedByDep;
        public @AuraEnabled List <String> lUsersGroupedByRoles;
    }
    
    
    
}