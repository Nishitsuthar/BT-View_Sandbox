public with sharing class VG_ContentDataAccess {
    
    public static List<EC_Content__c> getContentByRecordType(Set<String> fieldSet, List<String> recordTypes) {
        List<EC_Content__c> contentList = new List<EC_Content__c> ();
        String namespace = VG_Constants.NAMESPACE_PREFIX;
        String soql = 'SELECT ';
        for(String field : fieldSet){
            soql += field + ', ';
        }
        VG_Util.checkCRUD_FLS(namespace + 'EC_Content__c', fieldSet, VG_Constants.DML_OPERATION_READ);
        soql = soql.left(soql.lastIndexOf(','));
        
        String recordTypeStr = '';
        if(recordTypes.size() > 0) {
            List<String> recordTypesNew = new List<String>();
            for(String recordType :  recordTypes){
                String formattedStr = '\'' + recordType + '\'';
                recordTypesNew.add(formattedStr);
            }
            recordTypeStr = ' RecordType.DeveloperName IN ' + recordTypesNew;
        }
        
        soql += ' FROM ' + namespace + 'EC_Content__c' + ' WHERE ' + recordTypeStr;
        contentList = Database.query(soql);
        return contentList;
    }
    
    public static List<EC_Content__c> getActiveContentByFiltersAndRecordType(boolean includePreview, String site, String department,String location, String role, String country,String locale, String profile, String recordType, Boolean includeAttachments){
        List<EC_Content__c> ecContentList = new List<EC_Content__c>();
        String now = DateTime.Now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String namespace = VG_Constants.NAMESPACE_PREFIX;
        String objName = namespace +  'EC_Content__c';
        
        Set<String> fieldList = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().keySet();
        VG_Util.checkCRUD_FLS(objName, fieldList, VG_Constants.DML_OPERATION_READ);
        String soql = 'SELECT ';
        for(String fieldName : fieldList) {
            soql += fieldName + ', ';
        }
        soql = includeAttachments ? soql + '(Select ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks order by ContentDocument.lastmodifieddate desc LIMIT 1) ' : soql.left(soql.lastIndexOf(','));
        
        System.debug('@@ recordType'+recordType);
        if(recordType=='Announcement' || recordType=='Sub_Announcements' || recordType=='Quick_Links' || recordType=='Tiles' || recordType=='Quick_Document_Links' ){
           System.debug('------site--'+Site+'-----Dept---'+department+'----objName---'+objName);
            soql += ' FROM ' + objName + ' WHERE   RecordType.DeveloperName = \'' + recordType + '\'';
            system.debug('---soql Ann1----'+soql);
            soql = includePreview ? soql + ' AND Status__c in( \'Published\',\'Draft\')':soql + ' AND Status__c=\'Published\'';
            soql +=' AND '+namespace+'Start_Date__c <= '
                + now + ' AND '+namespace+'End_Date__c > ' + now
                +' AND '+namespace+ VG_Constants.EC_CONTENT_DEPARTMENT + ' includes (\''+ department + '\',\''+getDefault(VG_Constants.EC_DEFAULT_DEPARTMENT)+'\')' 
                + ' AND '+ namespace+VG_Constants.EC_CONTENT_ROLE + ' includes (\''+ role + '\',\''+getDefault(VG_Constants.EC_DEFAULT_ROLE)+ '\')' 
                + ' AND ' + namespace+VG_Constants.EC_CONTENT_LOCATION + ' includes (\''+ location + '\',\''+getDefault(VG_Constants.EC_DEFAULT_LOCATION)+ '\')' 
                +' AND '+namespace+ VG_Constants.EC_CONTENT_SITE + ' = \'' + site + '\''			
                + ' ORDER BY '+namespace+'Order__c ASC, LastModifiedDate DESC';
             system.debug('---soql Ann2---'+soql);
        }
        else if(recordType=='Footer'){
            soql += ' FROM ' + objName + ' WHERE   RecordType.DeveloperName = \'' + recordType + '\' ORDER BY '+namespace+'Order__c ASC, LastModifiedDate DESC';
        }
        
        else{
            soql += ' FROM ' + objName + ' WHERE   RecordType.DeveloperName = \'' + recordType + '\''
                + ' AND '+namespace+'Department__c =\''+ department +'\''+' AND '+namespace+'Start_Date__c <= '
                + now + ' AND '+namespace+'End_Date__c > ' + now
                +' AND '+namespace+ VG_Constants.EC_CONTENT_DEPARTMENT + ' includes (\''+ department + '\')' 
                + ' AND '+ namespace+VG_Constants.EC_CONTENT_ROLE + ' includes (\''+ role + '\')' 
                + ' AND ' + namespace+VG_Constants.EC_CONTENT_LOCATION + ' includes (\''+ location + '\')' 
                +' AND '+namespace+ VG_Constants.EC_CONTENT_SITE + ' = \'' + site + '\''
                
                + ' ORDER BY '+namespace+'Order__c ASC, LastModifiedDate DESC';
        }
        System.debug('------datasoql1-----'+soql);
        ecContentList =  Database.query(soql);
        
        
        System.debug('------data-----'+ecContentList);
        
        return ecContentList;
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