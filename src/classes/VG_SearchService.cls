public with sharing class VG_SearchService {

  // Retrieve primary knowledge articles based on URL search parameter
  @AuraEnabled
  public static  List<SObject>  searchArticles(String queryString, String lang, Integer recordLimit) {
      System.debug(queryString);
      
    List<SObject> sObjectList = null;
      try{
    String articleTypes = getSearchArticleTypes('Search');
    if (String.isBlank(lang)) return sObjectList;

    // Search All the article of the language if queryString is empty
    if (String.isBlank(queryString)) return queryAllArticles(lang, articleTypes);


    // Query KnowledgeArticleVersions based on the querySting and langauge
    sObjectList = queryArticles(queryString, lang, articleTypes, recordLimit);
          
          
           System.debug('sObjList2-->'+sObjectList);
      } catch(Exception e){
          System.debug('Exception'+e.getMessage());
           System.debug(e.getStackTraceString());
      }
    return sObjectList;
  }
     @AuraEnabled
    public static  List<ConnectApi.KnowledgeArticleVersion>  getTrendingArticles(String queryString, String lang, Integer recordLimit) {
        String nwid = Network.getNetworkId();
        ConnectApi.KnowledgeArticleVersionCollection kac = ConnectApi.Knowledge.getTrendingArticles(nwid, 5);
        return kac.items;
    }
    

  // Retrieve the article based on the queryString and the language
  @testVisible
  private static List<SObject> queryArticles(String queryString, String lang, String articleTypes, Integer recordLimit) {
    lang = String.escapeSingleQuotes( lang );
    queryString = escapeReservedCharacters(String.escapeSingleQuotes(
        EncodingUtil.urlDecode(queryString, 'UTF-8') ));

    String sFields = 'Id, Title, ArticleNumber, Language,UrlName,LastPublishedDate,ValidationStatus';
    Schema.sobjectfield field = Schema.sObjectType.KnowledgeArticleVersion.fields.getMap().get('MasterVersionId');
    //Uncomment this code if the Multiple language is enabled for Articles
   /* if (field != null) {
      sFields = sFields + ',MasterVersionId';
    }*/
    String sWhere = ' WHERE publishStatus=\'Online\'';//' AND language=\'' + lang + '\'';
   // sWhere += String.isBlank(articleTypes) ? '' : ' AND ArticleType IN (' + articleTypes + ')';
    String sLimit = (recordLimit == null || recordLimit == 0 || recordLimit >= 2000) ? '' :
                    ( ' LIMIT ' + String.valueOf(recordLimit));
    return VG_KnowledgeDataAccess.findKnowledgeArticleVersion(queryString, sLimit, sFields, sWhere);
   
  }

  // Query all the article based on the language
  @testVisible
  private static List<SObject> queryAllArticles(String lang, String articletypes) {
    lang = String.escapeSingleQuotes( lang );
    String sFields = 'Id,  Title, ArticleNumber, Language, ArticleType,UrlName,LastPublishedDate,ValidationStatus';
    Schema.sobjectfield field = Schema.sObjectType.KnowledgeArticleVersion.fields.getMap().get('MasterVersionId');
     //Uncomment this code if the Multiple language is enabled for Articles
   /* if (field != null) {
      sFields = sFields + ',MasterVersionId';
    }*/

    List<SObject> sObjList = new List<SObject>();
    try {
      sObjList = VG_KnowledgeDataAccess.getArticlesByLanguageAndType(sFields, lang, articleTypes);
    } catch (Exception e) {
      //QueryException: Invalid language code. Check that the language is included in your Knowledge language settings.
    }
      System.debug('sObjList-->'+sObjList);
    return sObjList;
  }
@testVisible
  private static String getSearchArticleTypes(String typeString) {
    String articleTypes = '';
    String namespace = VG_Constants.NAMESPACE_PREFIX;
    Map<String, List<EC_Settings__c>> articleTypeMap = VG_Settings.getSettingsByType(typeString, namespace + 'Text1__c');

    if (articleTypeMap.isEmpty()) return articleTypes;
    for (String str : articleTypeMap.keySet()) {
      articleTypes += '\'' + String.escapeSingleQuotes(namespace + str) + '\', ';
    }
    articleTypes = String.isNotBlank(articleTypes) ? articleTypes.left(articleTypes.lastIndexOf(',')) : '';
    return articleTypes;
  }
@testVisible
  private static List<SObject> retrieveArticleTypes(List<SObject> allArticles) {
    List<SObject> articles = new List<SObject>();
    Map<Id, SObject> articleMap = retrieveArticleTypesMap(allArticles);
    for (SObject sObj : allArticles) {
      if (articleMap.isEmpty()) break;
      if (!articleMap.containsKey(sObj.Id)) continue;

      articles.add(articleMap.get(sObj.Id));
    }
    return articles;
  }

  // Based on the KnowledgeArticleVersion Retrieve the Article Types and build the Map of Id, SObject
 @testVisible
    private static Map<Id, SObject> retrieveArticleTypesMap(List<SObject> allArticles) {
    Map<Id, SObject> articleTypeMap = new Map<Id, SObject>();
    if (allArticles == null || allArticles.isEmpty()) return articleTypeMap;

    // Build and Retrieve the Article Type Records for the masterVersionId List
    Map<String, List<Id>> masterVersionSObjectMap = getArticleTypeMap(allArticles, 'MasterVersionId');
    List<sObject> masterVersionList = new List<SObject>();
    for (String articleType : masterVersionSObjectMap.keySet()) {
      masterVersionList.addAll(retrieveArticleTypeVersionRecords(masterVersionSObjectMap.get(articleType), true).values());
    }
    Map<Id, SObject> masterVersionMap = new Map<Id, SObject>(masterVersionList);

    // Build and retrieve the Article Type Wrappers based on the KnowledgeArticleVersions
    Map<String, List<Id>> sObjectMap = getArticleTypeMap(allArticles, 'Id');
    for (String articleType : sObjectMap.keySet()) {

      articleTypeMap.putAll(retrieveMasterArticles(
                              retrieveArticleTypeVersionRecords(sObjectMap.get(articleType), false).values(), masterVersionMap));
    }
    return articleTypeMap;
  }

  // Build and add the Article Type Wrapper to the list of Article Wrappers.
  @testVisible
    private static Map<Id, SObject> retrieveMasterArticles(List<SObject> articleTypes, Map<Id, SObject> masterVersionMap) {
    Map<Id, SObject> articleTypeMap = new Map<Id, SObject>();
    List<String> fieldList = new List<String> {'Title', 'Summary', 'UrlName'};

    for (SObject sObj : articleTypes) {
      SObject newSObj = sObj;
      Schema.sobjectfield field = sobj.getSobjectType().getDescribe().fields.getMap().get('MasterVersionId');
       //Uncomment this code if the Multiple language is enabled for Articles
     /* if (field != null) {
        Id masterId = (Id) sObj.get('MasterVersionId');

        if (!masterVersionMap.isEmpty() && masterVersionMap.containsKey(masterId)) {
          newSObj = masterVersionMap.get(masterId);
          newSObj = updateLangFields(fieldList, newSObj, sObj);
        }
      }*/
      articleTypeMap.put(sObj.Id, newSObj);
    }
    return articleTypeMap;
  }

  // Retrieve the Article Type records based  on the list of ids.
 @testVisible
    private static Map<Id, SObject> retrieveArticleTypeVersionRecords(List<Id> articleIds, Boolean withDataCategories) {
      Map<Id, SObject> sObjectMap = new Map<Id, SObject>();
 
      try {
          sObjectMap = VG_KnowledgeDataAccess.getMapByArticles(articleIds);
          return sObjectMap;
      } catch (Exception e) {
          return sObjectMap;
      }
  }

  // Build a Map<Key, List<Id>> from the List of articles, field name
 @testVisible
    private static Map<String, List<Id>> getArticleTypeMap(List<SObject> articles, String key) {
    Map<String, List<Id>> articleTypeMap = new Map<String, List<Id>>();
    if (articles == null || articles.isEmpty()) return articleTypeMap;

    String objName = null;
    Id keyId = null;

    // Build the map with the key as field name passed and the value to List of Id's

    for (SObject sObj : articles) {
      Schema.sobjectfield field = sobj.getSobjectType().getDescribe().fields.getMap().get(key);
      if (field != null) {
        keyId = (Id) sObj.get(key);
        objName = keyId.getSObjectType().getDescribe().getName();
        if (articleTypeMap.containsKey(objName)) {
          articleTypeMap.get(objName).add(keyId);
        } else {
          articleTypeMap.put(objName, new List<Id> {keyId});
        }
      }
    }
    return articleTypeMap;
  }
    
@testVisible
  private static String escapeReservedCharacters(String searchString) {
    String reservedCharecters = '? & | ! { } [ ] ( ) ^ ~ * : " + -';
    for (String reservedChar : reservedCharecters.split(' ')) {
      if (!searchString.contains(reservedChar)) continue;
      searchString = searchString.replace(reservedChar, '\\' + reservedChar);
    }
    return searchString;
  }

 
  
 
  

  

 
}