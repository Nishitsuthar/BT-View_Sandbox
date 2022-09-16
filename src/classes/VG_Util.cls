public class VG_Util {
 //Flatten list for a dynamic query
    public static String flattenListForQuery(List<Object> incoming)
    {
        //Empty lists will cause an invalid query
        if(incoming.size() == 0)
        {
            throw new VG_UtilException('Empty List Passed To List Flattener');
        }
        String query = '';  
        for(Object addToString : incoming)
        {
            query += '\'' + String.valueOf(addToString) + '\',';            
        }
        
        if(query != '')
        {
            query = query.substring(0, query.length()-1);

            query = '(' + query + ') ';
        }
        
        return query;
    }
    
    public static void checkCRUD_FLS(String objectApiName, Set<String> fieldListForCRUD, String dmlOperationType) {
        List<String> noAccessFieldList = VG_AccessController.getInstance().returnNoPermissionFieldsNameList(objectApiName, dmlOperationType, fieldListForCRUD);
    if (!noAccessFieldList.isEmpty()){   
             throw new VG_AccessController.AccessControlDmlException( String.format(System.Label.MSG_CRUD_FLS_ERR, new String[] {dmlOperationType, objectApiName + ':'+String.valueOf(noAccessFieldList)}));
    }
  }
  
  public static String stripNamespace(String stringWithNamespace)
  {
    return stringWithNamespace.replace(VG_Constants.NAMESPACE_PREFIX, '');
  }
}