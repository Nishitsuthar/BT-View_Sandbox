public with sharing class VG_LookupController {
  /*  @AuraEnabled
    public static String getPrefix()
    {
        Id communityId = Network.getNetworkId();
        if(String.isBlank(communityId)) return null;
        List<Network> networkList = VG_NetworkDataAccess.getDetailById(new List<Id>{communityId});
        return networkList[0].urlPathPrefix;
    }
 */

    @AuraEnabled
    public static List<List<String>> searchRecords(String objectName,
                                                   String searchField,
                                                   String searchTerm,
                                                   Boolean startsWith,
                                                   String selectFields) {
        String searchClause;
        searchTerm = String.escapeSingleQuotes(searchTerm);                                               
        if (startsWith) {
            searchClause = searchTerm + '%';
        } else {
           searchClause = '%' + searchTerm + '%';
        }

        List<String> fieldsList = selectFields.split(',');
        List<List<String>> records = new List<List<String>>();
        List<sObject> dynamicList = VG_DynamicDataAccess.getRecordsBySearch(objectName, searchField, selectFields, 
            searchClause);
        
        for (sObject s: dynamicList) {
            List<String> lst = new List<String>{s.get('Id')+''};
            for(String fl : fieldsList){

                if(s.get(fl) != null){
                    lst.add(s.get(fl)+'');
                } else {
                    lst.add('');
                }
            }
            records.add(lst);
           // records.add(new List<String>{s.get('Id')+'', s.get(searchField)+''});
        }

		return records;
    }
}