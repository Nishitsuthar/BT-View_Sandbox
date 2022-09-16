public class VG_DynamicDataAccess {
    
    public static List<SObject> getAllRecords(String objectName, String searchField, String selectFields)
    {
        String query = 'SELECT Id, ' + selectFields + ' FROM ' + objectName + ' ORDER BY ' + searchField + ' LIMIT 50000';
        List<String> fieldsList = selectFields.split(',');
        Set<String> fieldSet = new Set<String>();
        fieldSet.addAll(fieldsList);
        VG_Util.checkCRUD_FLS(objectName, fieldSet, VG_Constants.DML_OPERATION_READ);
        return  Database.query(query);
    }
    
    public static List<SObject> getRecordsBySearch(String objectName, String searchField, String selectFields, String searchClause)
    {   String query = '';
      String nwid = Network.getNetworkId();
     if(objectName.equalsIgnoreCase('USER')){
         query =  'SELECT Id, ' + selectFields + ' ' +
                        'FROM ' + objectName + ' ' +
                        'WHERE ' + searchField + ' LIKE \'' + searchClause + '\' ' + ' AND isActive=true and id in (SELECT MemberId FROM NetworkMember where NetworkId =\''+nwid+'\') '+
                        'ORDER BY ' + searchField + ' ' +
                        'LIMIT 50000';
     } else {
         query =  'SELECT Id, ' + selectFields + ' ' +
                        'FROM ' + objectName + ' ' +
                        'WHERE ' + searchField + ' LIKE \'' + searchClause + '\' ' +
                        'ORDER BY ' + searchField + ' ' +
                        'LIMIT 50000';
     }
       
        List<String> fieldsList = selectFields.split(',');
        Set<String> fieldSet = new Set<String>();
        fieldSet.addAll(fieldsList);
        VG_Util.checkCRUD_FLS(objectName, fieldSet, VG_Constants.DML_OPERATION_READ);
     System.debug('query-->'+query);
        return  Database.query(query);
    }
    
    public static List<SObject> getRecordsByGlobalSearch(String objectName, String searchField, String selectFields, String searchClause)
    {
        String query ='';
        if(objectName=='EC_Content__c'){
            string annrecordType='Sub Announcements';
        query=  'SELECT Id, ' + selectFields + ' ' +
                        'FROM ' + objectName + ' ' +
                        'WHERE ' + searchField + ' LIKE \'' + searchClause + '\' ' +
                        ' AND recordType.name =:annrecordType '+
                        ' ORDER BY ' + searchField + ' ' +
                        'LIMIT 2';
        }
        else{
             query =  'SELECT Id, ' + selectFields + ' ' +
                        'FROM ' + objectName + ' ' +
                        'WHERE ' + searchField + ' LIKE \'' + searchClause + '\' ' +
                        'ORDER BY ' + searchField + ' ' +
                        'LIMIT 2';
        }
        system.debug('@@ query'+query);
        List<String> fieldsList = selectFields.split(',');
        Set<String> fieldSet = new Set<String>();
        fieldSet.addAll(fieldsList);
        VG_Util.checkCRUD_FLS(objectName, fieldSet, VG_Constants.DML_OPERATION_READ);
        return  Database.query(query);
    }


}