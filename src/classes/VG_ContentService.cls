public with sharing class VG_ContentService {
    // This the method called from for the LightningComponents
    @AuraEnabled
    public static String getPrefix()
    {
        Id communityId = Network.getNetworkId();
        if(String.isBlank(communityId)) return null;
        List<Network> networkList = VG_NetworkDataAccess.getDetailById(new List<Id>{communityId});
         System.debug('-----networkList[0].urlPathPrefix;-----'+networkList[0].urlPathPrefix);
        return networkList[0].urlPathPrefix;
    }
    
  
    
    @AuraEnabled
    public static String retrieveContent(String type,String siteName, boolean includePreview){
        if(siteName==null){
           siteName=VG_Constants.EC_DEFAULT_SITE; 
        }
       
        if(String.isBlank(type)) return null;
         System.debug('----type-----'+type);
        List<EC_Content__c> ecContentList = new List<EC_Content__c>();
        List<Task> pendingTasks = new List<Task>();
        
        if (type.equalsIgnoreCase(VG_Constants.EC_CONTENT_Mission_Statement)) {
            ecContentList =  retrieveContent(VG_Constants.EC_CONTENT_Mission_Statement, false,siteName,includePreview);
        }
        else if (type.equalsIgnoreCase(VG_Constants.EC_CONTENT_Announcement)) {
            system.debug('@@ in ec constant check announcement');
            ecContentList =  retrieveContent(VG_Constants.EC_CONTENT_Announcement, true,siteName,includePreview);
        }
        else if (type.equalsIgnoreCase(VG_Constants.EC_CONTENT_Sub_Announcements)) {
            ecContentList =  retrieveContent(VG_Constants.EC_CONTENT_Sub_Announcements, true,siteName,includePreview);
        }
        else if (type.equalsIgnoreCase(VG_Constants.EC_CONTENT_Quick_Links)) {
            ecContentList =  retrieveContent(VG_Constants.EC_CONTENT_Quick_Links, true,siteName,includePreview);
        }
         else if (type.equalsIgnoreCase(VG_Constants.EC_CONTENT_Quick_Document_Links)) {
            ecContentList =  retrieveContent(VG_Constants.EC_CONTENT_Quick_Document_Links, true,siteName,includePreview);
        }
        else if (type.equalsIgnoreCase(VG_Constants.EC_CONTENT_Tiles)) {
            ecContentList =  retrieveContent(VG_Constants.EC_CONTENT_Tiles, true,siteName,includePreview);
        }
         else if (type.equalsIgnoreCase(VG_Constants.EC_CONTENT_Footer)) {
            ecContentList =  retrieveContent(VG_Constants.EC_CONTENT_Footer, true,siteName,includePreview);
        }
        if(ecContentList.isEmpty()) return null;

        // Retrieve the Article Data associated with the EC Content Data
        List<SObject> articleList = retrieveArticles(
        buildArticleNumberString(ecContentList), VG_Constants.ARTICLE_TYPE_POLICIES_AND_PROCEDURES);

        List<VG_ContentWrapper> ecContentWrapperList = new List<VG_ContentWrapper>();
        if(articleList.isEmpty()) {
            ecContentWrapperList = buildECContentWrapperList(ecContentList, null, null);
            String serializedWrapperList = JSON.serialize(ecContentWrapperList);
            if (!type.equalsIgnoreCase(VG_Constants.EC_CONTENT_MENU))
            {
                    serializedWrapperList = VG_Util.stripNamespace(serializedWrapperList);
            }
            return serializedWrapperList;
        }

        // Build a Map of Article Number to List<Article> map
        Map<String, List<SObject>> articleNumToSObjMap = buildMapWithKey(articleList, 'ArticleNumber');

        // Build the EC_ContectWrapper based on the EC_Content
        ecContentWrapperList = buildECContentWrapperList( ecContentList, articleNumToSObjMap, pendingTasks);
        String serializedContent = JSON.serialize(ecContentWrapperList);
        if (!type.equalsIgnoreCase(VG_Constants.EC_CONTENT_MENU))
        {
                serializedContent = VG_Util.stripNamespace(serializedContent);
        }
        return serializedContent; 
    }

    @AuraEnabled
    public static String retrieveContentForMenu(String type, Boolean showTilesInMenu){
        List<VG_ContentWrapper> ecContentWrapperNewList = new List<VG_ContentWrapper>();
        String ecContentString = retrieveContent(type,null,null);
       
        List<VG_ContentWrapper> ecContentWrapperList = (List<VG_ContentWrapper>) JSON.deserialize(ecContentString, List<VG_ContentWrapper>.class);

        if(!showTilesInMenu){
            ecContentWrapperNewList = filterTilesFromMenu(ecContentWrapperList);
            return VG_Util.stripNamespace(JSON.serialize(ecContentWrapperNewList));
        }
       
        return VG_Util.stripNamespace(ecContentString);
    }
     @AuraEnabled
    public static  Mission_Statement__mdt  missionStatement()
    {
        Mission_Statement__mdt mst=[SELECT Id, Mission_Heading__c, Heading_1__c, Primary_Text__c, Heading_2__c, secondary_text__c FROM Mission_Statement__mdt limit 1];
      
        return mst;
    }
        
     @AuraEnabled
    public static  VG_Contact__mdt  contactus()
    {
        VG_Contact__mdt cons=[SELECT Id,Support_Emial__c,Support_Phone__c,Support_Phone_2__c FROM VG_Contact__mdt limit 1];
      
        return cons;
    }
    @TestVisible
    private static List<VG_ContentWrapper> filterTilesFromMenu(List<VG_ContentWrapper> ecContentWrapperList){
        List<VG_ContentWrapper> ecContentWrapperNewList = new List<VG_ContentWrapper>();
        Set<String> tileNames = new Set<String>();
        String namespace = VG_Constants.NAMESPACE_PREFIX;
        List<EC_Content__c> tilesList = VG_ContentDataAccess.getContentByRecordType(
            new Set<String>{'Name', namespace+'Primary_Text__c'}, new List<String>{VG_Constants.EC_CONTENT_TILE});
        for(EC_Content__c ect : tilesList){
            tileNames.add(ect.Primary_Text__c);
        }

        for(VG_ContentWrapper ec : ecContentWrapperList){
            EC_Content__c ecList = (EC_Content__c) ec.content;
            if(!tileNames.contains(ecList.Primary_Text__c)){
                ecContentWrapperNewList.add(new VG_ContentWrapper(ec.articles, ecList, ec.hasPendingTask));
            }
        }
        return ecContentWrapperNewList;
    }

  // Retrieve the HRP Content Data for the specified profile else return the default HRP Content for default counrty and profile
  @TestVisible
  private static List<EC_Content__c> retrieveContent(String recordType, Boolean includeAttachments, String siteName, boolean includePreview){
      List<User> userList = VG_UserDataAccess.getDetailsById(new List<Id> {UserInfo.getUserId()});
      User usr = new User();
      if(userList.size() > 0) usr = userList[0];
    system.debug('-----'+usr);
    //List<EC_Content__c> ecContentList = retrieveECContentData(String.valueOf(usr.Department),String.valueOf(usr.Country),String.valueOf(usr.LanguageLocaleKey), usr.Profile.Name, recordType, includeAttachments);
     List<EC_Content__c> ecContentList  = retrieveECContentData(includePreview,siteName,String.valueOf(usr.Employee_Department__c),String.valueOf(usr.Employee_Office_Location__c),String.valueOf(usr.Employee_Role__c),getDefault(VG_Constants.EC_DEFAULT_COUNTRY),getDefault(VG_Constants.EC_DEFAULT_LOCALE), getDefault(VG_Constants.EC_DEFAULT_PROFILE), recordType, includeAttachments);

      if(!ecContentList.isEmpty()) return ecContentList;

   // ecContentList = retrieveECContentData(String.valueOf(usr.Department),getDefault(VG_Constants.EC_DEFAULT_COUNTRY),getDefault(VG_Constants.EC_DEFAULT_LOCALE), getDefault(VG_Constants.EC_DEFAULT_PROFILE), recordType, includeAttachments);
  ecContentList  = retrieveECContentData(includePreview,siteName,getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT),getDefault(VG_Constants.EC_DEFAULT_LOCATION),getDefault(VG_Constants.EC_DEFAULT_ROLE),getDefault(VG_Constants.EC_DEFAULT_COUNTRY),getDefault(VG_Constants.EC_DEFAULT_LOCALE), getDefault(VG_Constants.EC_DEFAULT_PROFILE), recordType, includeAttachments);

    return ecContentList;
  }

  // Build the soql query and return the List of HRP Content records
  @TestVisible
  public static List<EC_Content__c> retrieveECContentData(boolean includePreview, String site, String department,String location, String role,String country,String locale, String profile, String recordType, Boolean includeAttachments){
    return VG_ContentDataAccess.getActiveContentByFiltersAndRecordType(includePreview,site, department,location,role,country, locale, profile, recordType, includeAttachments);
  }

   // Build the soql query based on the articletype, user's language and article numbers and return the article records
  @TestVisible
  private static List<SObject> retrieveArticles(String articleNums, String articleType){
    return VG_KnowledgeDataAccess.getArticleTypeByArticleNumbers(articleNums, articleType);

    // List<SObject> articleList = new List<SObject>();
    // if(String.isBlank(articleNums)) return articleList;
    //
    // Set<String> fieldSet = Schema.getGlobalDescribe().get(articleType).getDescribe().fields.getMap().keySet();
    // String soql = 'SELECT ';
    // for(String fieldName : fieldSet) {
    //   soql += fieldName + ', ';
    // }
    // soql = soql.left(soql.lastIndexOf(','));
    // soql += ' FROM '  + articleType + ' WHERE publishStatus=\'Online\' AND language=\'' + UserInfo.getLanguage() + '\'' + ' AND ArticleNumber IN (' + articleNums + ') ';
    //
    // System.debug('soql==='+soql);
    //
    // articleList = (List<SObject>) Database.query(soql);
    // return articleList;
  }

  // Build a comma separated string of article number based on the HRP Content records
  @TestVisible
  private static String buildArticleNumberString(List<EC_Content__c> ecContentList){
    String articleNums = '';
    if(ecContentList.isEmpty()) return articleNums;
    for(EC_Content__c ec : ecContentList) {
      if (String.isBlank(ec.Article_Numbers__c)) continue;
      for(String articleNum : ec.Article_Numbers__c.split(';')){
        articleNum = articleNum.trim();
        articleNums += '\'' + articleNum + '\', ';
      }
    }
    articleNums = String.isNotBlank(articleNums) ?
      articleNums.left(articleNums.lastIndexOf(',')) : '';
    return articleNums;
  }

  // Build a map from the list of SObjects and use the field name as the key to the map
  @TestVisible
  private static Map<String, List<SObject>> buildMapWithKey(List<SObject> sObjList, String fieldName){
    Map<String, List<SObject>> sObjMap = new Map<String, List<SObject>>();
    if(sObjList.isEmpty()) return sObjMap;

    for(SObject sObj : sObjList){
      String key = String.valueOf(sObj.get(fieldName));
      if(String.isBlank(key)) continue;

      if(sObjMap.containsKey(key)) {
        sObjMap.get(key).add(sObj);
      } else {
        sObjMap.put(key, new List<SObject> {sObj});
      }
    }
    return sObjMap;
  }

  // Build a List of VG_ContentWrapper based on the List of EC_Content Records and a Map of Article Number to Article Map
  @TestVisible
  private static List<VG_ContentWrapper> buildECContentWrapperList(List<EC_Content__c> ecContentList, Map<String, List<SObject>> articleNumToSObjMap, List<Task> pendingTasks){
    List<VG_ContentWrapper> ecContentWrapperList = new List<VG_ContentWrapper>();
    if(ecContentList.isEmpty()) return ecContentWrapperList;

    for(EC_Content__c ec : ecContentList){
      boolean hasPendingTasks = false;
    //   hasPendingTasks = EC_TasksService.hasPendingTask(pendingTasks,ec.Start__c, ec.End__c );

      List<SObject> articleList = new List<SObject>();
      if(String.isNotBlank(ec.Article_Numbers__c) && articleNumToSObjMap != null && !articleNumToSObjMap.isEmpty()){
        for(String articleNum : ec.Article_Numbers__c.split(';')){
          articleNum = articleNum.trim();
          if(articleNumToSObjMap.containsKey(articleNum)){
            articleList.addAll(articleNumToSObjMap.get(articleNum));
          }
        }
      }
      ecContentWrapperList.add(new VG_ContentWrapper(articleList, ec, hasPendingTasks));
    }
    return ecContentWrapperList;
  }

  @AuraEnabled
  public static List<Site_Section__c> getRelatedLayoutRecords(String layoutId) {
      return [
          SELECT Id, Column__c, Site_Layout__c, Site_Layout__r.Site_Type__c, Widget__c ,RecordType__c, Text__c,
              Site_Layout__r.RecordType.Name
          FROM Site_Section__c
          WHERE Site_Layout__c = :layoutId
          ORDER BY createdDate desc
      ];      
  }
    
  public static String getDefault(String type){
    String defaultKey = '';
    // Map<String, List<EC_Settings__c>> ecSettingsMap = VG_Settings.getSettingsByType(type, 'Text1__c');
    Map<String, List<EC_Settings__c>> ecSettingsMap = VG_Settings.getSettingsByType(type, VG_Constants.NAMESPACE_PREFIX + 'Text1__c');
    if(ecSettingsMap.isEmpty()) return defaultKey;
    for(String str: ecSettingsMap.keySet()) {
      defaultKey +=   String.escapeSingleQuotes(str) + ', ';
    }
    defaultKey = String.isNotBlank(defaultKey) ?
      defaultKey.left(defaultKey.lastIndexOf(',')) : '';

    return defaultKey;
  }
    
  
    
}