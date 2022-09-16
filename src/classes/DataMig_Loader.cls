public class DataMig_Loader {
    public static void DataMig_Loader1(){

    }
    /* where ever * / is present remove the space between
    public static void generateCode(){
        String commentString;
        String SrcDesMaPs;
        String srcDestDescRecultsMap;
        String srcDestSchemaFieldResults;
        String FieldMappingString;
        String ObjectDefs;
        String MapsToStoreData;
        String loopString;
        String AssigningDataToDesRecords; 
        String migrationCode;
        string describeString;
        string destvalue; 
        String MethodName;
        String PickListMapping;
        String BatchClassName;
        String BatchClassStartMethod;
        String DynamicQueryString;
        String BatchClassExecuteMethodString;
        
        //Select Object Mappings
        List<ObjectMapping__c> objMaps = new List<ObjectMapping__c>([
            SELECT ID, Name, SourceObject__c, 
            SourceObject__r.APIName__c, DestinationObject__c, 
            DestinationObject__r.APIName__c, Migrationcode__c  
            From ObjectMapping__c where DestinationObject__c != NUll
        ]);
        
        //Iterate through Object Mappings to create query, 
        //Source and Destination Lists and Schema Describe Strings
        for(objectMapping__c objMappingRec : objMaps){
            
            //Prepare Strings
            commentString ='// ***    Generated Code for Migrating '+ 
                objMappingRec.SourceObject__r.APIName__c +
                ' To '+objMappingRec.DestinationObject__r.APIName__c+
                '    ***     \r\r';
            String srcObjectName = String.valueOf(objMappingRec.SourceObject__r.APIName__c);
            String destobjectName = String.valueOf(objMappingRec.DestinationObject__r.APIName__c);
            String srcobjName;
            String destObjName;
            if(srcObjectName.endsWith('__c')){
            	srcobjName = objMappingRec.SourceObject__r.APIName__c.substring(0,objMappingRec.SourceObject__r.APIName__c.length()-3);
                srcobjName = srcobjName.replace('__', '_');
                srcobjName = srcobjName.abbreviate(15);
                srcobjName = srcobjName.remove('.');
            }else{
                srcobjName = srcObjectName.replace('__', '_');
                srcobjName = srcobjName.abbreviate(15);
                srcobjName = srcobjName.remove('.');
            }
            if(destobjectName.endsWith('__c')){
            	destObjName = objMappingRec.DestinationObject__r.APIName__c.substring(0,objMappingRec.DestinationObject__r.APIName__c.length()-3);
                destObjName = destObjName.replace('__', '_');
                destObjName = destObjName.abbreviate(15);
                destObjName = destObjName.remove('.');
            }else{
                destObjName = destobjectName.replace('__', '_');
                destObjName = destObjName.abbreviate(15);
                destObjName = destObjName.remove('.');
            }
            
            MethodName =  'public static void migrate_'+srcobjName+'_To_'+destObjName+'(List<'+objMappingRec.SourceObject__r.APIName__c+'> srcDataList, Id dataMigBatchJobId){ \r';
            BatchClassName = 'global class '+srcobjName+'_To_'+destObjName+'_Batch implements Database.Batchable<sObject>{ \r';
            objMappingRec.MethodName__c = MethodName;
            BatchClassStartMethod = 'global Database.QueryLocator start(Database.BatchableContext BC){ \r'+
            'ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = \''+objMappingRec.SourceObject__r.APIName__c+'\']; \r'+
        	'ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = \''+objMappingRec.DestinationObject__r.APIName__c+'\']; \r'+
        	'ObjectMapping__c objMappingRec = [SELECT ID From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; \r';
            BatchClassStartMethod = BatchClassStartMethod + 'List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, WhereOperator__c, WhereValue__c, SourceField__c, ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =: objMappingRec.Id  AND (DestinationField__c != NULL OR (WhereOperator__c != NULL AND WhereValue__c != NULL AND WhereValue__c != \''+''+'\' )) ]; \r';
            
            //Construct String to generate Map to hold Source Object Field Tockens and Destination Object Filed Tockens
            SrcDesMaPs ='Set<Id> srcRecordIds = new Set<Id>();\r'+'for('+objMappingRec.SourceObject__r.APIName__c+' srcRec : srcDataList ){ \r'+'srcRecordIds.add(srcRec.Id); \r'+'}\r'+
                'ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = \''+objMappingRec.SourceObject__r.APIName__c+'\']; \r'+
       			'ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = \''+objMappingRec.DestinationObject__r.APIName__c+'\']; \r'+
        		'ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; \r'+
                'List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];\r'+
                'Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();\r' +
                'Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); \r';
            
            // Construct String To Store Source and Destination Field Descriptions
            srcDestDescRecultsMap = 'Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); \r' +
                'Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); \r'+
                'Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); \r'+
        		'for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ \r'+
                'srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); \r'+'} \r';
            //Get schema Field Tockens and Description results for source and Destination Objects
            srcDestSchemaFieldResults = 'if(srcObjFieldTokensMap != null){ \r'+
                'for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ \r'+
                'Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); \r'+
                'srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); \r' +'} \r' + '} \r'+
                'if(destObjFieldTokensMap != Null){ \r'+
                'for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ \r'+
                'Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); \r'+
                'destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); \r'+'} \r'+ '} \r';
            //Construct string to obtain schema information for Object and Fields
            //Get ObjectDefs Record for Source and Destination Objects
            //Get all field mappings related to object mapping.
            FieldMappingString = 'List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; \r';
            PickListMapping = 'Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); \r'+
                'for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { \r'+
                'srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); \r'+'} \r'+
                'Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); \r'+
                'for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { \r'+
                ' if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { \r'+
                'if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { \r'+
                'fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); \r'+
                '} \r'+'fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); \r'+
                '} \r'+ '} \r';
            //Get Reference to object types for source and destination.
            MapsToStoreData = 'Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); \r'+
                'Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); \r'+
                'Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); \r'+
                'List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); \r'+
                'Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();\r'+
                'Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); \r'+
                'Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); \r'+
                'Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();\r'+
                'Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();\r'+
                'Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();\r';
            loopString = 'for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { \r'+
                '//SOURCE \r'+'List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); \r'+
                'SObjectType srcRefFldParentObjType; \r'+'srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); \r'+
                'if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == \''+'REFERENCE'+'\'){ \r'+
                'srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); \r'+
                'Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); \r'+
                'srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; \r'+
                'srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); \r'+'} \r';
            loopString = loopString+ '//DESTINATION \r'+
                'SObjectType destRefFldParentObjType;\r'+
                'destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); \r'+
                'if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == \''+'REFERENCE'+'\'){ \r'+
                'Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); \r'+
                'if(destFieldDescResultMap.containsKey(destRefFieldToken)){ \r'+
                'destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; \r'+
                'srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); \r'+
                'destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); \r'+'} \r'+ '} \r';
            
            loopString = loopString+ 'if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {\r'+
                'String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); \r'+
                'String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();\r'+
                'Id srcRefFldParentObjDefId; \r'+
                'List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];\r'+
                'if(srcRefFldParentObjDef.size() > 0) { \r'+
                'srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; \r'+'} \r'+
                'Id destRefFldParentObjDefId; \r'+
                'List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];\r'+
                'if(destRefFldParentObjDef.size() > 0) { \r'+
                'destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; \r'+ '} \r';
                
            
            loopString = loopString+ 'if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { \r'+
                'parentRefMigrationExist.put(eachFieldMapping, TRUE); \r'+
                'for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { \r'+
                'if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + \''+'-'+'\' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { \r'+
                ' parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + \''+'-'+'\' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); \r'+
                '} else { \r'+
                ' List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + \''+'-'+'\' + eachDatMigStepRec.DestinationObject__r.APIName__c); \r'+
                'existingMigStepRecs.add(eachDatMigStepRec); \r'+
                'parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + \''+'-'+'\' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); \r'+
                '} \r'+'} \r' +'} \r' +'}\r'+'} \r';
        
            DynamicQueryString = '//Need Dynamic Query \r'+
                'String srcDataQryString = \''+'SELECT ' + '\'; \r'+
                'String fieldNames; \r'+
                'String whereClause = \''+''+'\'; \r'+
                'Set<String> fieldSet = new Set<String>(); \r'+
                'for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { \r'+
                'if(!fieldSet.contains(eachFieldMapping.SourceField__r.APIName__c)) { \r'+
                'if(fieldNames != NULL) { \r'+
                ' fieldNames+= \''+','+'\'; \r'+' } \r'+
                'if(fieldNames == NULL) { \r'+
                'fieldNames = eachFieldMapping.SourceField__r.APIName__c; \r'+
                '} else { \r'+
                'fieldNames+= eachFieldMapping.SourceField__r.APIName__c; \r'+'} \r'+ 
                'fieldSet.add(eachFieldMapping.SourceField__r.APIName__c); \r'+
                'if(eachFieldMapping.WhereOperator__c != NULL ) { \r'+
                    'if(whereClause != \''+''+'\') { \r'+
                        'whereClause+= \''+' AND '+'\'; \r'+
                   '} \r'+
                    'whereClause+= eachFieldMapping.SourceField__r.APIName__c + \''+' '+'\' + eachFieldMapping.WhereOperator__c + \''+' '+'\' + eachFieldMapping.WhereValue__c;\r'+
                '} \r'+
                '}\r'+'} \r'+
                ' if(!fieldSet.contains(\''+'Name'+'\')){ \r'+
                ' fieldNames+= \''+', Name'+'\'; \r'+ '} \r'+
                'if(!fieldSet.contains(\''+'Id'+'\')){ \r'+
                ' fieldNames+= \''+', Id'+'\'; \r'+ '} \r'+
                'String fromClause = \''+' FROM '+objMappingRec.SourceObject__r.APIName__c+'\'; \r'+
                'srcDataQryString+= fieldNames + fromClause ; \r'+
                'if(whereClause != \''+''+'\'){\r'+
            	'srcDataQryString+= \''+' WHERE '+'\'+ whereClause; \r'+'} \r';
            
            	BatchClassStartMethod = BatchClassStartMethod + DynamicQueryString ;
            	BatchClassStartMethod = BatchClassStartMethod + 'return Database.getQueryLocator(srcDataQryString); \r'+' } \r';
            	BatchClassExecuteMethodString = 'global void execute(Database.BatchableContext BC,'+' List<'+objMappingRec.SourceObject__r.APIName__c+'> srcDataList){ \r'+
                    'DataMig_Loader.'+'migrate_'+srcobjName+'_To_'+destObjName+'(srcDataList, BC.getJobId()); \r'+'}\r'+
                    ' global void finish(Database.BatchableContext BC){ \r'+
                    ' DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, No_of_Records_Migrated__c, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: BC.getJobId() Limit 1];\r'+
                    'dataMigStepLogRec.Job_Status__c = \''+'Completed'+'\'; \r'+
                    'dataMigStepLogRec.No_of_Records_Migrated__c = [select Id,DataMigStep__c from DataMigStepRecLog__c where DataMigStep__c =: dataMigStepLogRec.Id].size();\r'+
                    ' Update dataMigStepLogRec;\r'+'} \r'+'} \r';
            
                AssigningDataToDesRecords = 'Boolean processingCompleted; \r'+
                'Boolean limitExceeded; \r'+
                'List<'+objMappingRec.DestinationObject__r.APIName__c+'> destData = new List<'+objMappingRec.DestinationObject__r.APIName__c+'>();\r'+
                'for('+objMappingRec.SourceObject__r.APIName__c+' srcRecord: srcDataList){ \r'+
                 objMappingRec.DestinationObject__r.APIName__c+' destNewRecord = new '+objMappingRec.DestinationObject__r.APIName__c+'(); \r'+
                'for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { \r'+
                ' Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); \r'+
                'switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { \r'+
                ' when \''+'PICKLIST'+'\' { \r'+
                'destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); \r'+'} \r'+
                ' when \''+'REFERENCE'+'\' { \r' +
                'srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); \r'+
                'if(eachFieldMapping.SourceField__r.APIName__c == \''+'RecordTypeId'+'\'){ \r'+
                'if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ \r'+
                'destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));\r'+
                '} \r'+' }else{ \r'+
                'if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { \r'+
                'if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+\''+'-'+'\'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { \r'+
                'destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+\''+'-'+'\'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);\r'+
                 '} \r'+' } else { \r'+
                 'destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); \r'+
                 '}\r'+ '} \r'+ '} \r'+
                'when \''+ 'ID'+ '\'{ \r'+
                'destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); \r'+
                '}when else { \r'+
                'destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); \r'+'} \r'+ '} \r'+'} \r'+
                'limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; \r'+
                'destData.add(destNewRecord); \r'+'if(limitExceeded) {break;} \r'+'} \r'+ 
                'Database.UpsertResult[] saveResultList = Database.Upsert(destData,'+objMappingRec.DestinationObject__r.APIName__c+'.DataMig_ExternalId__c, false); \r'+
                'List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();\r'+
                'Integer saveResultListSize = saveResultList.Size(); \r'+
                'String totalErrorMessage ; \r'+
                'DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];\r'+
                'for (Integer i = 0 ; i < saveResultListSize ; i ++) { \r'+
                'DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + \''+'-'+'\' + objMappingRec.Id); \r'+
                
                'if(saveResultList[i].isSuccess()) { \r'+
                'dataMigStepRecLog.StatusCode__c = \''+'Success'+'\'; \r'+
                
                '}else { \r'+
                'string ErrorMessage; \r'+
                'for(Database.Error err : saveResultList[i].getErrors()){ \r'+
                'ErrorMessage = ErrorMessage + err.getMessage(); \r'+
                'totalErrorMessage += err.getMessage(); \r'+ '} \r'+
                'dataMigStepRecLog.ErrorMessage__c = ErrorMessage; \r'+
                'dataMigStepRecLog.StatusCode__c = \''+'Error'+'\'; \r'+'} \r'+
                'dataMigStepRecLogList.add(dataMigStepRecLog); \r'+'} \r'+
                'system.debug(\''+'dataMigStepRecLogList: '+'\'+ dataMigStepRecLogList); \r'+
                'Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; \r'+
                '} \r \r \r \r';
            objMappingRec.Migrationcode__c = MethodName+ commentString + SrcDesMaPs + srcDestDescRecultsMap + srcDestSchemaFieldResults+ FieldMappingString + PickListMapping + MapsToStoreData + loopString + AssigningDataToDesRecords ;
            objMappingRec.Batch_Class_Migrated_Code__c = BatchClassName + BatchClassStartMethod + BatchClassExecuteMethodString;
        }
        
        //Store Generated code in ObjectMapping__c.MigrationCode__c 
        update objMaps;      
    }
    public static void migrate_SVMXC_Site_To_Building_Acc(List<SVMXC__Site__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating SVMXC__Site__c To Building_Account__c    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(SVMXC__Site__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'SVMXC__Site__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Building_Account__c']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<Building_Account__c> destData = new List<Building_Account__c>();
        for(SVMXC__Site__c srcRecord: srcDataList){ 
            Building_Account__c destNewRecord = new Building_Account__c(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,Building_Account__c.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }  
    
    
    
    public static void migrate_SVMXC_Servic_To_WorkOrder(List<SVMXC__Service_Order__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating SVMXC__Service_Order__c To WorkOrder    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(SVMXC__Service_Order__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'SVMXC__Service_Order__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'WorkOrder']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<WorkOrder> destData = new List<WorkOrder>();
        for(SVMXC__Service_Order__c srcRecord: srcDataList){ 
            WorkOrder destNewRecord = new WorkOrder(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,WorkOrder.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }
    
    
    
    public static void migrate_SVMXC_Servic_To_WorkOrderLin(List<SVMXC__Service_Order_Line__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating SVMXC__Service_Order_Line__c To WorkOrderLineItem    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(SVMXC__Service_Order_Line__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'SVMXC__Service_Order_Line__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'WorkOrderLineItem']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<WorkOrderLineItem> destData = new List<WorkOrderLineItem>();
        for(SVMXC__Service_Order_Line__c srcRecord: srcDataList){ 
            WorkOrderLineItem destNewRecord = new WorkOrderLineItem(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,WorkOrderLineItem.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }
    
    /*
    public static void migrate_SVMXC_Servic_To_Case(List<SVMXC__Service_Order__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating SVMXC__Service_Order__c To Case    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(SVMXC__Service_Order__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'SVMXC__Service_Order__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Case']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                
                if(destFieldDescResultMap.size() > 0 && destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    system.debug('destRefFieldToken'+ destRefFieldToken);
                    system.debug('destFieldDescResultMap'+ destFieldDescResultMap);
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<Case> destData = new List<Case>();
        for(SVMXC__Service_Order__c srcRecord: srcDataList){ 
            Case destNewRecord = new Case(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,Case.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }* / 
    
    
    public static void migrate_Customer_Inc_To_Case(List<Customer_Incident__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating Customer_Incident__c To Case    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(Customer_Incident__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Customer_Incident__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Case']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<Case> destData = new List<Case>();
        for(Customer_Incident__c srcRecord: srcDataList){ 
            Case destNewRecord = new Case(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,Case.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }
    
	/*    
    public static void migrate_Halo_Profile_To_Issue(List<Halo_Profile__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating Halo_Profile__c To Issue__c    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(Halo_Profile__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Halo_Profile__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Issue__c']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String, List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                	destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c , new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                            //system.debug('parentRecOldIdToDataMigStepRecMap'+parentRecOldIdToDataMigStepRecMap);
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    }
                    System.debug('parentRecOldIdToDataMigStepRecMap@@'+parentRecOldIdToDataMigStepRecMap);
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<Issue__c> destData = new List<Issue__c>();
        for(Halo_Profile__c srcRecord: srcDataList){ 
            Issue__c destNewRecord = new Issue__c(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                system.debug('error'+((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()));
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    system.debug('dest field @@'+eachFieldMapping.DestinationField__r.APIName__c);
                                    system.debug('field value @@'+parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else {
                        if(eachFieldMapping.SourceField__r.SFFieldtypeID__c == 'DOUBLE' && eachFieldMapping.DestinationField__r.SFFieldtypeID__c == 'STRING'){
                            
                            destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                        }else{
                            
                        	destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                        }
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,Issue__c.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }
    */
    
    /*
    public static void migrate_IGU_Defects_To_Issue(List<IGU_Defects__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating IGU_Defects__c To Issue__c    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(IGU_Defects__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'IGU_Defects__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Issue__c']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<Issue__c> destData = new List<Issue__c>();
        for(IGU_Defects__c srcRecord: srcDataList){ 
            Issue__c destNewRecord = new Issue__c(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,Issue__c.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }
    * /
    
    public static void migrate_IGU_Replacem_To_Issue(List<IGU_Replacement_RMA__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating IGU_Replacement_RMA__c To Issue__c    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(IGU_Replacement_RMA__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'IGU_Replacement_RMA__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Issue__c']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<Issue__c> destData = new List<Issue__c>();
        for(IGU_Replacement_RMA__c srcRecord: srcDataList){ 
            Issue__c destNewRecord = new Issue__c(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,Issue__c.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }
    
    
    public static void migrate_Asset_To_Asset(List<Asset__c> srcDataList, Id dataMigBatchJobId){ 
        // ***    Generated Code for Migrating Asset__c To Asset    ***     
        
        Set<Id> srcRecordIds = new Set<Id>();
        for(Asset__c srcRec : srcDataList ){ 
            srcRecordIds.add(srcRec.Id); 
        }
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Asset__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'Asset']; 
        ObjectMapping__c objMappingRec = [SELECT ID, Name, SourceObject__c, SourceObject__r.APIName__c, DestinationObject__c, DestinationObject__r.APIName__c, Migrationcode__c From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<RecordTypeMapping__c>  recordTypeRecList = [SELECT Id, Name, ObjectMapping__c, SourceRecordTypeID__c, SourceObjectName__c, DestinationRecordTypeID__c From RecordTypeMapping__c WHERE ObjectMapping__c =: objMappingRec.Id];
        Map<String, Schema.SObjectField> srcObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.SourceObject__r.APIName__c).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> destObjFieldTokensMap = Schema.getGlobalDescribe().get(objMappingRec.DestinationObject__r.APIName__c).getDescribe().fields.getMap(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> srcFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<Schema.SObjectField, Schema.DescribeFieldResult> destFieldDescResultMap = new Map<Schema.SObjectField, Schema.DescribeFieldResult>(); 
        Map<String, String> srcToDestRecdTypeIds = new Map<String, String>(); 
        for(RecordTypeMapping__c RecTypeRec : recordTypeRecList){ 
            srcToDestRecdTypeIds.put(RecTypeRec.SourceRecordTypeID__c, RecTypeRec.DestinationRecordTypeID__c); 
        } 
        if(srcObjFieldTokensMap != null){ 
            for(Schema.SObjectField srcObjFieldToken : srcObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult srcObjFieldDescRes = srcObjFieldToken.getDescribe(); 
                srcFieldDescResultMap.put(srcObjFieldToken, srcObjFieldDescRes); 
            } 
        } 
        if(destObjFieldTokensMap != Null){ 
            for(Schema.SObjectField destObjFieldToken : destObjFieldTokensMap.values()){ 
                Schema.DescribeFieldResult destObjFieldDescRes = destObjFieldToken.getDescribe(); 
                destFieldDescResultMap.put(destObjFieldToken, destObjFieldDescRes); 
            } 
        } 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, SourceField__c,ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =:objMappingRec.Id AND DestinationField__c != NULL]; 
        Set<Id> srcFieldDefIdsFromFieldMappings = new Set<Id>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            srcFieldDefIdsFromFieldMappings.add(eachFieldMapping.SourceField__c); 
        } 
        Map<Id, Map<String, String>> fldSrcPicklistToDestPicklistMap = new Map<Id, Map<String, String>>(); 
        for(PicklistValueDef__c eachSrcFieldspickListFieldValDefs : [SELECT Id, FieldDef__c, PicklistValue__c,(SELECT Id, DestinationPicklistValue__r.PicklistValue__c FROM PicklistValueSourceMappings__r WHERE DestinationPicklistValue__r.PicklistValue__c != NULL LIMIT 1)FROM PicklistValueDef__c WHERE FieldDef__c IN :srcFieldDefIdsFromFieldMappings]) { 
            if(eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r.size() > 0) { 
                if(!fldSrcPicklistToDestPicklistMap.containsKey(eachSrcFieldspickListFieldValDefs.FieldDef__c)) { 
                    fldSrcPicklistToDestPicklistMap.put(eachSrcFieldspickListFieldValDefs.FieldDef__c, new Map<String, String>()); 
                } 
                fldSrcPicklistToDestPicklistMap.get(eachSrcFieldspickListFieldValDefs.FieldDef__c).put(eachSrcFieldspickListFieldValDefs.PicklistValue__c, eachSrcFieldspickListFieldValDefs.PicklistValueSourceMappings__r[0].DestinationPicklistValue__r.PicklistValue__c); 
            } 
        } 
        Map<Id,String> srcObjFieldDefIdToAPINameMap = new Map<Id,String>(); 
        Map<Id, SObjectType> srcRefFieldDefIdToRefObjType = new Map<Id, SObjectType>(); 
        Map<Id,String> srcObjRefFieldDefIdToAPINameMap = new Map<Id,String>(); 
        List<Schema.SObjectType> srcRefFieldReferredToObjType = new List<Schema.SObjectType>(); 
        Map<Id, SObjectType> destRefFieldDefIdToRefObjType = new Map<Id, SObjectType>();
        Map<Id,String> destObjRefFieldDefIdToAPINameMap = New Map<Id, String>(); 
        Map<SObjectType, SObjectType> srcRfFldParObjTodestRfFldParObjType = New Map<SObjectType, SObjectType>(); 
        Map<String, List<DataMigStepRecLog__c>> parentRecOldIdToDataMigStepRecMap = New Map<String,List<DataMigStepRecLog__c>>();
        Map<String, string> srcPickToDestPickValueMap = new Map<String, string>();
        Map<FieldMapping__c, Boolean> parentRefMigrationExist = new Map<FieldMapping__c, Boolean>();
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            //SOURCE 
            List<PicklistValueMapping__c> PicklistValueMap = new List<PicklistValueMapping__c>(); 
            SObjectType srcRefFldParentObjType; 
            srcObjFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
            if(eachFieldMapping.SourceField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                srcObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.SourceField__c,string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                Schema.SobjectField srcRefFieldToken = srcObjFieldTokensMap.get(string.valueof(eachFieldMapping.SourceField__r.APIName__c)); 
                srcRefFldParentObjType = srcFieldDescResultMap.get(srcRefFieldToken).getReferenceTo()[0]; 
                srcRefFieldDefIdToRefObjType.put(eachFieldMapping.SourceField__c, srcRefFldParentObjType); 
            } 
            //DESTINATION 
            SObjectType destRefFldParentObjType;
            destObjRefFieldDefIdToAPINameMap.put(eachFieldMapping.DestinationField__c, string.valueof(eachFieldMapping.DestinationField__r.APIName__c)); 
            if(eachFieldMapping.DestinationField__r.SFFieldTypeID__c == 'REFERENCE'){ 
                Schema.SobjectField destRefFieldToken = destObjFieldTokensMap.get(eachFieldMapping.DestinationField__r.APIName__c); 
                if(destFieldDescResultMap.containsKey(destRefFieldToken)){ 
                    destRefFldParentObjType = destFieldDescResultMap.get(destRefFieldToken).getReferenceTo()[0]; 
                    srcRfFldParObjTodestRfFldParObjType.put(srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c), destRefFldParentObjType); 
                    destRefFieldDefIdToRefObjType.put(eachFieldMapping.DestinationField__c, destRefFldParentObjType); 
                } 
            } 
            if(srcRefFldParentObjType != NULL && destRefFldParentObjType != NULL) {
                String srcRefFldParentObjName = srcRefFldParentObjType.getDescribe().getName(); 
                String destRefFldParentObjName = destRefFldParentObjType.getDescribe().getName();
                Id srcRefFldParentObjDefId; 
                List<ObjectDef__c> srcRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:srcRefFldParentObjName];
                if(srcRefFldParentObjDef.size() > 0) { 
                    srcRefFldParentObjDefId = srcRefFldParentObjDef[0].Id; 
                } 
                Id destRefFldParentObjDefId; 
                List<ObjectDef__c> destRefFldParentObjDef = [SELECT Id FROM ObjectDef__c WHERE APIName__c =:destRefFldParentObjName];
                if(destRefFldParentObjDef.size() > 0) { 
                    destRefFldParentObjDefId = destRefFldParentObjDef[0].Id; 
                } 
                if(srcRefFldParentObjDefId != NULL && destRefFldParentObjDefId != NULL && [SELECT Id From ObjectMapping__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c =: destRefFldParentObjDefId].size() > 0) { 
                    parentRefMigrationExist.put(eachFieldMapping, TRUE); 
                    for(DataMigStepRecLog__c eachDatMigStepRec : [SELECT DestinationObject__c, DestinationObject__r.APIName__c, DestinationRecordID__c, SourceObject__c, SourceRecordID__c FROM DataMigStepRecLog__c WHERE SourceObject__c =: srcRefFldParentObjDefId AND DestinationObject__c = :destRefFldParentObjDefId]) { 
                        if(!parentRecOldIdToDataMigStepRecMap.containsKey(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c)) { 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, new List<DataMigStepRecLog__c>{eachDatMigStepRec}); 
                        } else { 
                            List<DataMigStepRecLog__c> existingMigStepRecs = parentRecOldIdToDataMigStepRecMap.get(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c); 
                            existingMigStepRecs.add(eachDatMigStepRec); 
                            parentRecOldIdToDataMigStepRecMap.put(eachDatMigStepRec.SourceRecordID__c + '-' + eachDatMigStepRec.DestinationObject__r.APIName__c, existingMigStepRecs); 
                        } 
                    } 
                } 
            }
        } 
        Boolean processingCompleted; 
        Boolean limitExceeded; 
        List<Asset> destData = new List<Asset>();
        for(Asset__c srcRecord: srcDataList){ 
            Asset destNewRecord = new Asset(); 
            for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
                Schema.SObjectField srcFieldSObjType = srcObjFieldTokensMap.get(eachFieldMapping.SourceField__r.APIName__c); 
                switch on eachFieldMapping.SourceField__r.SFFieldtypeID__c { 
                    when 'PICKLIST' { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, fldSrcPicklistToDestPicklistMap.get(eachFieldMapping.SourceField__c).get((string)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)) ); 
                    } 
                    when 'REFERENCE' { 
                        srcRefFieldDefIdToRefObjType.get(eachFieldMapping.SourceField__c); 
                        if(eachFieldMapping.SourceField__r.APIName__c == 'RecordTypeId'){ 
                            if(srcToDestRecdTypeIds.containsKey((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))){ 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcToDestRecdTypeIds.get((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)));
                            } 
                        }else{ 
                            if(parentRefMigrationExist.containsKey(eachFieldMapping) && parentRefMigrationExist.get(eachFieldMapping)) { 
                                if(parentRecOldIdToDataMigStepRecMap.containsKey((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))) { 
                                    destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, parentRecOldIdToDataMigStepRecMap.get((String)((Id)srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)+'-'+(destRefFieldDefIdToRefObjType.get(eachFieldMapping.DestinationField__c)).getDescribe().getName()))[0].DestinationRecordID__c);
                                } 
                            } else { 
                                destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                            }
                        } 
                    } 
                    when 'ID'{ 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, String.valueOf(srcRecord.get(eachFieldMapping.SourceField__r.APIName__c))); 
                    }when else { 
                        destNewRecord.put(eachFieldMapping.DestinationField__r.APIName__c, srcRecord.get(eachFieldMapping.SourceField__r.APIName__c)); 
                    } 
                } 
            } 
            limitExceeded = Limits.getDMLStatements() >= Limits.getLimitDMLStatements()* 0.8 || Limits.getCpuTime() >= Limits.getLimitCpuTime() * 0.8 || Limits.getHeapSize() >= Limits.getLimitHeapSize()* 0.8 || Limits.getQueries() >= Limits.getLimitQueries()* 0.8; 
            destData.add(destNewRecord); 
            if(limitExceeded) {break;} 
        } 
        Database.UpsertResult[] saveResultList = Database.Upsert(destData,Asset.DataMig_ExternalId__c, false); 
        List<DataMigStepRecLog__c> dataMigStepRecLogList = new List<DataMigStepRecLog__c>();
        Integer saveResultListSize = saveResultList.Size(); 
        String totalErrorMessage ; 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: dataMigBatchJobId Limit 1];
        for (Integer i = 0 ; i < saveResultListSize ; i ++) { 
            DataMigStepRecLog__c dataMigStepRecLog = new DataMigStepRecLog__c(Name = srcDataList[i].Name.abbreviate(80), DestinationObject__c = destObjectDef.Id, SourceObject__c = srcObjectDef.Id, DestinationRecordID__c = saveResultList[i].getId(), SourceRecordID__c = srcDataList[i].Id, DataMigStep__c = dataMigStepLogRec.Id, DataMigStepRecExternalId__c =  srcDataList[i].Id + '-' + objMappingRec.Id); 
            if(saveResultList[i].isSuccess()) { 
                dataMigStepRecLog.StatusCode__c = 'Success'; 
            }else { 
                string ErrorMessage; 
                for(Database.Error err : saveResultList[i].getErrors()){ 
                    ErrorMessage = ErrorMessage + err.getMessage(); 
                    totalErrorMessage += err.getMessage(); 
                } 
                dataMigStepRecLog.ErrorMessage__c = ErrorMessage; 
                dataMigStepRecLog.StatusCode__c = 'Error'; 
            } 
            dataMigStepRecLogList.add(dataMigStepRecLog); 
        } 
        system.debug('dataMigStepRecLogList: '+ dataMigStepRecLogList); 
        Upsert dataMigStepRecLogList DataMigStepRecExternalId__c; 
    }*/
}