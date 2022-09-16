public with sharing class VG_AccessController {
    public with sharing class AccessControlDmlException extends Exception {}
 
    /**
    *@description private static variable referencing the class
    */
    private static VG_AccessController instance = null;
    
    /**
    *@description map of object name as key and field map as value
    */
    private static Map<String,  Map<String, Schema.SObjectField>> objectFieldInfoMap;
    
    /**
    *@description map of object name as key and object describe as value
    */
    private static Map<String, Schema.DescribeSObjectResult> describeObjectMap;
    
    /**
    *@description The constructor is private and initializes the maps
    */
    private VG_AccessController()
    {
        objectFieldInfoMap = new Map<String,  Map<String, Schema.SObjectField>>();
        describeObjectMap = new  Map<String, Schema.DescribeSObjectResult>();
    }
    
    /**
    * @description a static method that returns the instance of the CSM_Accesso Controller
    */
    public static VG_AccessController getInstance()
    {
        if(instance == null) 
        {
            instance = new VG_AccessController();
        }
        return instance;        
    }   
    
    public List<String> returnNoPermissionFieldsNameList(String objName, String operationType, Set<String> fieldNames) {
        List<String> returnNoPermissionFieldsNameList = new List<String>(); 
        Type objTypeName = Type.forName(objName);
        
        if (objTypeName != null) 
        {
            SObject sObj = (SObject)objTypeName.newInstance();             
            Schema.sObjectType objType = sObj.getSObjectType();
            
            Map<String, Schema.SObjectField> fieldInfoMap = null;
            Schema.DescribeSObjectResult objResult = null;
            if (objectFieldInfoMap.containsKey(objName))
            {
                fieldInfoMap = objectFieldInfoMap.get(objName);
                objResult = describeObjectMap.get(objName);
            }
            else
            {    
                objResult =  objType.getDescribe();         
                fieldInfoMap = objResult.fields.getMap();
                objectFieldInfoMap.put(objName, fieldInfoMap); 
                describeObjectMap.put(objName, objResult);               
            }
            
            if((operationType == VG_Constants.DML_OPERATION_READ && objResult.isAccessible())
                    || (operationType == VG_Constants.DML_OPERATION_INSERT && objResult.isCreateable())
                    || (operationType == VG_Constants.DML_OPERATION_UPDATE && objResult.isUpdateable())
                    || (operationType == VG_Constants.DML_OPERATION_UPSERT && objResult.isCreateable() && objResult.isUpdateable()))
            {           
               
                for(String fieldName :fieldNames)
                {
                    Schema.SObjectField tmpfield = fieldInfoMap.get(fieldName);
                    if( tmpfield != null ) 
                    {
                        if((operationType == VG_Constants.DML_OPERATION_READ && !(fieldInfoMap.get(fieldName).getDescribe().isAccessible()))
                                || (operationType == VG_Constants.DML_OPERATION_INSERT && !(fieldInfoMap.get(fieldName).getDescribe().isCreateable()))
                                || (operationType == VG_Constants.DML_OPERATION_UPDATE && !(fieldInfoMap.get(fieldName).getDescribe().isUpdateable()))
                                || (operationType == VG_Constants.DML_OPERATION_UPSERT && !(fieldInfoMap.get(fieldName).getDescribe().isCreateable()) 
                                        && !(fieldInfoMap.get(fieldName).getDescribe().isUpdateable())))
                        { 
                            returnNoPermissionFieldsNameList.add(tmpfield.getDescribe().getLabel());                                                
                        }
                    }
                    else
                    {
                        //throw exception Invalid field name
                        String[] arguments = new String[] {fieldName};          
                        throw new AccessControlDmlException(String.format(System.Label.MSG_INVALID_FIELD_NAME, arguments)); 
                    
                    }   
                }
           }
           else if(operationType == VG_Constants.DML_OPERATION_DELETE)
           {
               if (!objResult.isDeletable())
               {
                   // throw exception it is not deleteable
                   throw new AccessControlDmlException(objName + ' ' + System.Label.MSG_OBJECT_NOT_DELETABLE);
               }
           }
           
           else
           {
               // throw exception 
               String[] arguments = new String[] {objName}; 
               throw new AccessControlDmlException('No ' + operationType + ' for '+ objName);
           }
        }
        else 
        {
            //throw exception Invalid Object name
            String[] arguments = new String[] {objName};          
            throw new AccessControlDmlException(String.format(System.Label.MSG_INVALID_OBJECT_NAME, arguments)); 
        }
        return returnNoPermissionFieldsNameList;
    } 
}