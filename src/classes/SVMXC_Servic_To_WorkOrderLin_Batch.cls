global class SVMXC_Servic_To_WorkOrderLin_Batch {
    public static void SVMXC_Servic_To_WorkOrderLin_Batch1(){

    }
/*implements Database.Batchable<sObject>{ 
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        ObjectDef__c srcObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'SVMXC__Service_Order_Line__c']; 
        ObjectDef__c destObjectDef = [SELECT Id, Name, APIName__c FROM ObjectDef__c WHERE APIName__c = 'WorkOrderLineItem']; 
        ObjectMapping__c objMappingRec = [SELECT ID From ObjectMapping__c WHERE SourceObject__c =: srcObjectDef.Id  AND DestinationObject__c =: destObjectDef.Id]; 
        List<FieldMapping__c> objMappingRelFieldMappings = [SELECT DestinationField__c, DestinationField__r.APIName__c, WhereOperator__c, WhereValue__c, SourceField__c, ObjectMapping__r.SourceObject__c, ObjectMapping__r.DestinationObject__c, SourceField__r.APIName__c, SourceField__r.SFFieldtypeID__c, DestinationField__r.SFFieldtypeID__c FROM FieldMapping__c WHERE ObjectMapping__c =: objMappingRec.Id  AND (DestinationField__c != NULL OR (WhereOperator__c != NULL AND WhereValue__c != NULL AND WhereValue__c != '' )) ]; 
        //Need Dynamic Query 
        String srcDataQryString = 'SELECT '; 
        String fieldNames; 
        String whereClause = ''; 
        Set<String> fieldSet = new Set<String>(); 
        for(FieldMapping__c eachFieldMapping : objMappingRelFieldMappings) { 
            if(!fieldSet.contains(eachFieldMapping.SourceField__r.APIName__c)) { 
                if(fieldNames != NULL) { 
                    fieldNames+= ','; 
                } 
                if(fieldNames == NULL) { 
                    fieldNames = eachFieldMapping.SourceField__r.APIName__c; 
                } else { 
                    fieldNames+= eachFieldMapping.SourceField__r.APIName__c; 
                } 
                fieldSet.add(eachFieldMapping.SourceField__r.APIName__c); 
                if(eachFieldMapping.WhereOperator__c != NULL ) { 
                    if(whereClause != '') { 
                        whereClause+= ' AND '; 
                    } 
                    whereClause+= eachFieldMapping.SourceField__r.APIName__c + ' ' + eachFieldMapping.WhereOperator__c + ' ' + eachFieldMapping.WhereValue__c;
                } 
            }
        } 
        if(!fieldSet.contains('Name')){ 
            fieldNames+= ', Name'; 
        } 
        if(!fieldSet.contains('Id')){ 
            fieldNames+= ', Id'; 
        } 
        String fromClause = ' FROM SVMXC__Service_Order_Line__c'; 
        srcDataQryString+= fieldNames + fromClause ; 
        if(whereClause != ''){
            srcDataQryString+= ' WHERE '+ whereClause; 
        } 
        return Database.getQueryLocator(srcDataQryString); 
    } 
    global void execute(Database.BatchableContext BC, List<SVMXC__Service_Order_Line__c> srcDataList){ 
        DataMig_Loader.migrate_SVMXC_Servic_To_WorkOrderLin(srcDataList, BC.getJobId()); 
    }
    global void finish(Database.BatchableContext BC){ 
        DataMigStepLog__c dataMigStepLogRec = [SELECT Id, Name, No_of_Records_Migrated__c, DataMig_Batch_Job_Id__c from DataMigStepLog__c where DataMig_Batch_Job_Id__c =: BC.getJobId() Limit 1];
        dataMigStepLogRec.Job_Status__c = 'Completed'; 
        dataMigStepLogRec.No_of_Records_Migrated__c = [select Id,DataMigStep__c from DataMigStepRecLog__c where DataMigStep__c =: dataMigStepLogRec.Id].size();
        Update dataMigStepLogRec;
    } */
}