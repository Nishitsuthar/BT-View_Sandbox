public class VG_UserDataService {
  
    
  @AuraEnabled
  public static String retrieveRecentlyViewed(Integer maxRows) {
    List<EC_UserData__c> ecUserData = VG_MyDataAccess.getByDynamic(new List<String> {VG_Constants.EC_USERDATA_RECENTLY_VIEWED}, 
         UserInfo.getUserId(), null, maxRows, null, new Set<String>());
   // List<EC_UserData__c> ecUserData = retrieveUserData(VG_Constants.EC_USERDATA_RECENTLY_VIEWED, UserInfo.getUserId(), 
    //null, maxRows, null);
    Map<String, List<String>> typeToIdsMap = buildTypeToIdsMap(ecUserData);
    Map<Id, SObject> sObjMap = buildRecordMap(typeToIdsMap);
      System.debug('');
    return VG_Util.stripNamespace(JSON.serialize(buildECUserDataWrapperList(ecUserData, sObjMap)));
  }



  @AuraEnabled
    public static List<VG_UserDataWrapper> saveRecentlyViewed(String recordType, String recordId, String url, String type, String title) {
        System.debug('@@ Record type'+recordType+' @@ recordId'+recordId +' @@ url  '+url +' @@ type  '+ type+' @@ title  '+ title);
    

    EC_UserData__c userData = new EC_UserData__c();
    userData.Record_Id__c = recordId;
    userData.Type__c = type;
    userData.Url__c = url;
    userData.Title__c = title;
    userData.User__c = UserInfo.getUserId();


    String data = JSON.serialize(userData);
    List<EC_UserData__c> ecUserData = new List<EC_UserData__c>();
    ecUserData.add(saveUserData('Recently_Viewed', data));

    Map<String, List<String>> typeToIdsMap = buildTypeToIdsMap(ecUserData);

    Map<Id, SObject> sObjMap = buildRecordMap(typeToIdsMap);

    return buildECUserDataWrapperList(ecUserData, sObjMap);
  }

  
  private static EC_UserData__c saveUserData(String recordType, String data) {
    EC_UserData__c ecUserData = null;
    try {
      ecUserData = (EC_UserData__c) JSON.deserialize(data, EC_UserData__c.class);
    } catch (Exception e) {
      throw new VG_UserDataException('Invalid JSON');
    }
      System.debug('@@ record type'+recordType);
    Id recordTypeId = getECRecordType(recordType, ecUserData);
    ecUserData.RecordTypeId = recordTypeId;
    
    List<EC_UserData__c> existingRecords = VG_MyDataAccess.getUserDataByRecordTypeIdUrlUser(recordTypeId, 
        ecUserData.Record_Id__c, ecUserData.Url__c, ecUserData.User__c);
 
    String namespace = VG_Constants.NAMESPACE_PREFIX;
    if (existingRecords.size() > 0) {
      Set<String> fieldSet = new Set<String>{namespace+VG_Constants.OBJ_UD_RECORD_ID,namespace+VG_Constants.OBJ_UD_TYPE,
          namespace+VG_Constants.OBJ_UD_URL,namespace+VG_Constants.OBJ_UD_TITLE,namespace+VG_Constants.OBJ_UD_USER};
      
      EC_USerData__C oldData = existingRecords[0];
      oldData.Record_Id__c = ecUserData.Record_Id__c;
      oldData.Type__c = ecUserData.Type__c;
      oldData.Url__c = ecUserData.Url__c;
      oldData.Title__c = ecUserData.Title__c;
      oldData.User__c = ecUserData.User__c;
      VG_MyDataAccess.updateUserData(fieldSet, new List<EC_UserData__c>{oldData});
    } else {
      Set<String> fieldSet = new Set<String>{VG_Constants.OBJ_UD_RECORD_TYPE};
      VG_MyDataAccess.insertUserData(fieldSet, new List<EC_UserData__c>{ecUserData});
    }
    return ecUserData;
  }


  @TestVisible
  private static Id getECRecordType(String recordType, EC_UserData__c ecUserData) {
    if (ecUserData == null ) return null;
    Id recordTypeId = null;
    try {
          System.debug(' @@ recordType'+recordType);
      String objectType = VG_Constants.NAMESPACE_PREFIX + 'EC_UserData__c';
      List<RecordType> recordTypes = VG_RecordTypeDataAccess.getRecordTypeByDeveloperNameAndType(
          new List<String>{recordType}, new List<String>{objectType});
         System.debug(' @@ recordTypes'+recordTypes+'  @@ objectType '+objectType);
      if (!recordTypes.isEmpty())
      {
           
          recordTypeId = recordTypes[0].Id;
          System.debug(' @@ recordTypeId'+recordTypeId);
    
      } 
    } catch (Exception e) {
      throw new VG_UserDataException(recordType + ' RecordType for EC_UserData__c not found.');
    }
    return recordTypeId;

  }



  // Build a comma separated string of article number based on the HRP Content records
  @TestVisible
  private static Map<String, List<String>> buildTypeToIdsMap(List<EC_UserData__c> ecUserData) {
    Map<String, List<String>> typeToIdsMap = new Map<String, List<String>>();

    if (ecUserData.isEmpty()) return typeToIdsMap;

    String sObjType = null;
    Id recordId = null;
    for (EC_UserData__c ec : ecUserData) {
      if (String.isBlank(ec.Record_Id__c)) continue;
      recordId = ec.Record_Id__c.trim();
      sObjType = recordId.getSObjectType().getDescribe().getName();
      if (typeToIdsMap.containsKey(sObjType)) {
        typeToIdsMap.get(sObjType).add(recordId);
      } else {
        typeToIdsMap.put(sObjType, new List<String> {recordId});
      }
    }

    return typeToIdsMap;
  }

  @TestVisible
  private static Map<Id, SObject> buildRecordMap(Map<String, List<String>> typeToIdsMap) {
    Map<Id, SObject> sObjMap = new Map<Id, SObject>();
    if (typeToIdsMap == null || typeToIdsMap.isEmpty()) return sObjMap;
    for (String sObjType : typeToIdsMap.keySet()) {
      if (sObjType.equalsIgnoreCase('Case')) {
       // sObjMap.putAll(EC_CaseDataAccess.getMapById(typeToIdsMap.get(sObjType)));
      } else if (sObjType.endsWithIgnoreCase('__kav')) {
        sObjMap.putAll(VG_KnowledgeDataAccess.getKnowledgeArticleVersionMapByIds(typeToIdsMap.get(sObjType)));
      } else if (sObjType.equalsIgnoreCase('User')) {
        sObjMap.putAll(VG_UserDataAccess.getMapByIds(typeToIdsMap.get(sObjType)));
      }
    }
    return sObjMap;
  }

  // Build a List of VG_UserDataWrapper based on the List of EC_Content Records and a Map of Article Number to Article Map
  @TestVisible
  private static List<VG_UserDataWrapper> buildECUserDataWrapperList(List<EC_UserData__c> ecUserData, Map<Id, SObject> recordIdToSObjMap) {
    List<VG_UserDataWrapper> ecUserDataWrapperList = new List<VG_UserDataWrapper>();
    if (ecUserData.isEmpty()) return ecUserDataWrapperList;
    Id recordId = null;
    for (EC_UserData__c ec : ecUserData) {

      if (ec.Record_Id__c == null || String.isBlank(ec.Record_Id__c.trim()) || !recordIdToSObjMap.containsKey(ec.Record_Id__c.trim())) {
        ecUserDataWrapperList.add(new VG_UserDataWrapper(null, ec));
      } else {
        recordId = ec.Record_Id__c.trim();
        ecUserDataWrapperList.add(new VG_UserDataWrapper(recordIdToSObjMap.get(recordId), ec));
      }
    }
    return ecUserDataWrapperList;
  }


  
  
 









}