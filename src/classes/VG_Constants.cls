public with sharing class VG_Constants {
    public static final String EC_DEFAULT_PROFILE = 'DefaultProfile';
    public static final String EC_DEFAULT_COUNTRY = 'DefaultCountry';
    public static final String EC_DEFAULT_LOCALE = 'DefaultLocale';
    public static final String EC_DEFAULT_REGION = 'DefaultRegion';
    public static final String EC_DEFAULT_SITE = 'Landing Page';
  	public static final String EC_DEFAULT_LOCATION = 'DefaultLocation';
  	public static final String EC_DEFAULT_ROLE = 'DefaultRole';
  	public static final String EC_DEFAULT_DEPARTMENT = 'DefaultDepartment';
    public static final String EC_MAX_RECENTLY_VIEWED_COUNT = 'MaxRecentlyViewedCount';
    public static final String EC_SALESFORCE_INTERNAL_URL = 'SalesforceInternal';

    public static final String EC_CONTENT_PROFILE = 'Profile__c';
    public static final String EC_CONTENT_COUNTRY = 'Countries__c';
    public static final String EC_CONTENT_LOCALE = 'Locale__c';
    public static final String EC_CONTENT_REGION = 'Region__c';
	
    public static final String EC_CONTENT_LOCATION = 'Location__c';
  	public static final String EC_CONTENT_ROLE = 'Role__c';
  	public static final String EC_CONTENT_DEPARTMENT = 'Department__c';
  	public static final String EC_CONTENT_SITE = 'Site__c';
    
    public static final String EC_CONTENT_MENU = 'Menu';
    public static final String EC_CONTENT_TILE = 'Tile';
    public static final String EC_CONTENT_Mission_Statement = 'Mission_Statement';
    public static final string EC_CONTENT_Announcement = 'Announcement'; 
    public static final string EC_CONTENT_Sub_Announcements = 'Sub_Announcements';
    public static final string EC_CONTENT_Quick_Links = 'Quick_Links';
    public static final string EC_CONTENT_Quick_Document_Links = 'Quick_Document_Links';
     public static final string EC_CONTENT_Tiles = 'Tiles';
     public static final string EC_CONTENT_Footer = 'Footer';

    public static final String EC_USERDATA_BOOKMARK = 'Bookmark';
    public static final String EC_USERDATA_RECENTLY_VIEWED = 'Recently_Viewed';
    public static final String EC_USERDATA_ALERT = 'Alert';
    public static final String EC_USERDATA_RECOGNITION = 'Recognition';

    public static final String ARTICLE_TYPE_POLICIES_AND_PROCEDURES = 'Policies_and_Procedures__kav';

    public static final String EC_ED_DEFAULT_SORT_FIELD = 'LastName';
    public static final String EC_ED_DEFAULT_SORT_ORDER = 'ASC';

    public static final String EC_USERDATA_TYPE_ARTICLE = 'Article';
    public static final String EC_USERDATA_TYPE_PAGE = 'Page';
    public static final String EC_USERDATA_TYPE_CASE = 'Case';
    public static final String EC_USERDATA_TYPE_GROUP = 'Group';
    public static final String EC_USERDATA_TYPE_TOPIC = 'Topic';
    public static final String EC_USERDATA_TYPE_FEED = 'Feed';
    public static final String EC_USERDATA_TYPE_USER ='User';

    public static final String DML_OPERATION_UPSERT = 'Upsert';
    public static final String DML_OPERATION_INSERT = 'Insert';
    public static final String DML_OPERATION_UPDATE = 'Update';
    public static final String DML_OPERATION_DELETE = 'Delete';
    public static final String DML_OPERATION_READ = 'Read';

    private static final ApexClass cs = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'VG_Constants'];
    public static final String NAMESPACE = cs != null && String.isNotBlank(cs.NamespacePrefix) ? cs.NamespacePrefix : '';
    public static final String NAMESPACE_PREFIX = String.isNotBlank(NAMESPACE) ? NAMESPACE + '__' : '';

    //Task Object and Field List
    public static final String OBJ_TASK = 'Task';
    public static final String OBJ_T_ACTIVITYDATE = 'ActivityDate';
    public static final String OBJ_T_ID = 'Id';
    public static final String OBJ_T_DESCRIPTION = 'Description';
    public static final String OBJ_T_STATUS = 'Status';
    public static final String OBJ_T_SUBJECT = 'Subject';

    //EC_UserData__c Object and Field List
    public static final String OBJ_USER_DATA = 'EC_UserData__c';
    public static final String OBJ_UD_ID = 'Id';
    public static final String OBJ_UD_RECORD_TYPE = 'RecordTypeId';
    public static final String OBJ_UD_RECORD_ID = 'Record_Id__c';
    public static final String OBJ_UD_URL = 'Url__c';
    public static final String OBJ_UD_USER = 'User__c';
    public static final String OBJ_UD_TYPE ='Type__c';
    public static final String OBJ_UD_TITLE ='Title__c';
    public static final String OBJ_UD_TEXT_READ = 'Text_Read__c';
    public static final String OBJ_UD_TEXT_DISMISS = 'Text_Dismiss__c';
    public static final String OBJ_UD_TEXT ='Text__c';
    public static final String OBJ_UD_OWNER = 'OwnerId';

    //User Object and Field List
    public static final String OBJ_USER = 'User';
    public static final String OBJ_U_ID = 'Id';
    public static final String OBJ_U_FIRST_NAME = 'FirstName';
    public static final String OBJ_U_LAST_NAME = 'LastName';
    public static final String OBJ_U_NAME = 'Name';
    public static final String OBJ_U_MANAGER = 'ManagerId';
    public static final String OBJ_U_PHONE = 'Phone';
    public static final String OBJ_U_TITLE = 'Title';
    public static final String OBJ_U_EMAIL = 'Email';
    public static final String OBJ_U_SMALL_PHOTO_URL = 'SmallPhotoUrl';
    public static final String OBJ_U_PROFILE = 'ProfileId';
    public static final String OBJ_U_DEPARTMENT = 'Department';
    public static final String OBJ_U_CITY = 'City';
    public static final String OBJ_U_COUNTRY = 'Country';
    public static final String OBJ_U_HIRE_DATE = 'Hire_Date__c';


    //Case Object and Field List
    public static final String OBJ_CASE = 'Case';
    public static final String OBJ_C_SUBJECT = 'Subject';
    public static final String OBJ_C_STATUS = 'Status';
    public static final String OBJ_C_DISPLAY_DATE = 'Display_Date__c';
    public static final String OBJ_C_LEAVE_START_DATE = 'Leave_Start_Date__c';
    public static final String OBJ_C_LEAVE_END_DATE = 'Leave_End_Date__c';
    public static final String OBJ_C_LEAVE_TYPE = 'Leave_Type__c';
    public static final String OBJ_C_EMPLOYEE = 'Employee__c';
    public static final String OBJ_C_NUMBER = 'CaseNumber';

    //Content Object and Field List
    public static final String OBJ_EC_CONTENT = 'EC_Content__c';

    //Task status
    public static final String TASK_STATUS_COMPLETED = 'Completed';

    //Event Object and Field List
    public static final String OBJ_EVENT = 'Event';
    public static final String OBJ_E_START_DATE_TIME = 'StartDateTime';
    public static final String OBJ_E_END_DATE_TIME = 'EndDateTime';
    public static final String OBJ_E_SUBJECT = 'Subject';
    public static final String OBJ_E_LOCATION = 'Location';
    public static final String OBJ_E_SPEAKER = 'Speaker__c';

    //KnowledgeArticle Object and Field List
    public static final String OBJ_KA = 'KnowledgeArticle';
    public static final String OBJ_KA_ID = 'Id';

    //KnowledgeArticleVersion Object and Field List
    public static final String OBJ_KAV = 'KnowledgeArticleVersion';
    public static final String OBJ_KAV_ID = 'Id';
}