public class VG_MyDataAccess {
public static List<EC_UserData__c> getByDynamic(List<String> recordTypes, String userId,
      String recordId, Integer maxRows, String filterConditions, Set<String> additionalFieldSet) 
    {
    	System.debug('recordTypes '+recordTypes);
         List<EC_UserData__c> ecUserData = new List<EC_UserData__c>();
         if (recordTypes.IsEmpty() || String.isBlank(recordTypes[0]))
         {
             return ecUserData;
         }
         String namespace = VG_Constants.NAMESPACE_PREFIX;
         
         String soql = 'SELECT ';
         for (String fieldName : Schema.getGlobalDescribe().get(namespace + 'EC_UserData__c').getDescribe().fields.getMap().keySet()) {
             soql += fieldName + ', ';
             additionalFieldSet.add(fieldName);
         }
         additionalFieldSet.add(namespace+'User__c');
         additionalFieldSet.add(namespace+'Record_Id__c');
        // VG_Util.checkCRUD_FLS(namespace+'EC_UserData__c', additionalFieldSet, VG_Constants.DML_OPERATION_READ);
   
         soql = soql + 'CreatedBy.FullPhotoUrl, RecordType.DeveloperName ';
         soql += ' FROM ' + namespace + 'EC_UserData__c' + ' WHERE RecordType.DeveloperName in ' + VG_Util.flattenListForQuery( recordTypes );
         soql += String.isNotBlank(userId) ? ' AND '+namespace+'User__c=\'' + userId + '\' ' : '';
         soql += String.isNotBlank(recordId) ? ' AND '+namespace+'Record_Id__c = \'' + recordId + '\' ' : '';
         soql += String.isNotBlank(filterConditions) ? ' AND ' + filterConditions + ' ' : '';
         soql += ' ORDER BY LastModifiedDate DESC';
         soql += maxRows != null ? ' LIMIT ' + maxRows : '';
         System.debug('soql===' + soql);
         ecUserData = (List<EC_UserData__c>) Database.query(soql);
         System.debug('ecUserData-->'+ecUserData);
         return ecUserData;
        
    }
    
    public static List<EC_UserData__c> getUserDataByRecordTypeIdUrlUser(String recordTypeId, String recordId, String url, String user)
    {
        String namespace = VG_Constants.NAMESPACE_PREFIX;
        Set<String> fieldSet = new Set<String>{VG_Constants.OBJ_UD_ID, VG_Constants.OBJ_UD_RECORD_TYPE,
            namespace+VG_Constants.OBJ_UD_RECORD_ID, namespace+VG_Constants.OBJ_UD_URL, namespace+VG_Constants.OBJ_UD_USER};
        VG_Util.checkCRUD_FLS(namespace+VG_Constants.OBJ_USER_DATA, fieldSet, VG_Constants.DML_OPERATION_READ);
        System.debug('recordTYpe '+recordTypeId + ' record '+recordId + ' user '+user);
        return [select Id from EC_UserData__c where RecordTypeId = :recordTypeId
                                            and Record_Id__c = :recordId 
                                            and Url__c = :url 
                                            and User__c = :user];
                                            
                                            
    }
    
    public static void insertUserData(Set<String> fieldSet, List<EC_UserData__c> userData)
    {
       // VG_Util.checkCRUD_FLS(VG_Constants.NAMESPACE_PREFIX+VG_Constants.OBJ_USER_DATA, fieldSet, VG_Constants.DML_OPERATION_INSERT);    	
    	System.debug(' @@ insert data '+ userData);
        insert userData;
    }
    
    public static void updateUserData(Set<String> fieldSet, List<EC_UserData__c> userData)
    {
        //VG_Util.checkCRUD_FLS(VG_Constants.NAMESPACE_PREFIX+VG_Constants.OBJ_USER_DATA, fieldSet, VG_Constants.DML_OPERATION_UPDATE);    	
    	update userData;
    }
}