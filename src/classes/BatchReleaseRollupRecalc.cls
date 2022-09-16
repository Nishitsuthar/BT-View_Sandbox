global class BatchReleaseRollupRecalc implements Database.Batchable<sObject>
{

    //Query String
    global String query;
    // Set to Add all the Shipped To AccountIDs 
    global  Set<String> actIdsSet;
    String queryCondition = System.Label.OER_Rollup_Query_Condition;
    String rollupOK = '\'Draft\', \'Pre-Release Review\', \'Confirmation Pending\', \'Confirmed\', \'Pre-Production\', \'In Production\', \'Partially Shipped\', ' +
    '\'Shipped\', \'Complete\', \'Hold\', \'Cancelled\'';
    global Map<Id, RecordType> rtMap = Order_Entry_Trigger_Helper_2.getRecordTypeMap('Order_Entry_Line__c');
    
    global BatchReleaseRollupRecalc()
    {
        query = 'SELECT Id, Name, Status__c, Integration_Status__c, Trigger_Source__c, Integration_Scope__c, Integration_Action_Requested__c, ' +
            'IGU_Count__c, IGU_Area_Sq_Ft__c, IGU_Open_Count__c, IGU_Open_Area_Sq_Ft__c, IGU_Area_Sq_M__c, IGU_Open_Area_Sq_M__c, Extended_Price_Total__c, ' +
            'Extended_Price_Open__c FROM Order_Entry_Release__c WHERE Status__c IN (' + rollupOK + ')';
        if(queryCondition != null && queryCondition != 'None')
        {
            query = query + ' AND ' + queryCondition;
        }
        System.debug('OER Query: ' + query);
    }
           
    /*
     * Method name  : start
     * Description  : Batch Class start Method - collects the Account records to be passed
                      to the interface method execute
     * Return Type  : Database.QueryLocator
     * Parameter    : Database.BatchableContext
    */
     
    global Database.QueryLocator start(Database.BatchableContext BC)  
    {  
        Database.QueryLocator ql;
        System.debug('start query = ' + query);
        ql = Database.getQueryLocator(query);
//          System.abortJob(BC.getJobId());
        return ql;       
    }  

    /*
     * Method name  : execute
     * Description  : Batch Class execute Method - called for each batch of records passed 
                      to the method. Processes each chunk of data 
     * Return Type  : nil 
     * Parameters   : Database.BatchableContext
                      List<Order_Entry_Release__c>
     */
     
    global void execute(Database.BatchableContext BC, List<Order_Entry_Release__c> oerList)  
    {   
        
        Map<Id, OrderEntryReleaseWrapper> oerwMap = new Map<Id, OrderEntryReleaseWrapper>();
        List<Id> oerIds = new List<Id>();
        List<Database.SaveResult> saveResultList = new List<Database.SaveResult>();
        for (Order_Entry_Release__c oer :  oerList)
        {
            oerIds.add(oer.Id);
            oerwMap.put(oer.Id,new OrderEntryReleaseWrapper(oer));
        }
        
        for (Order_Entry_Line__c oel : [SELECT Id, RecordTypeId , Status__c, Quantity__c, Area_Sq_Ft__c, Line_Number__c, Unit_Price__c,
            Open_Quantity__c, Unit_Area_Sq_Ft__c, Unit_Area_Sq_M__c, Total_Area_Sq_M__c, Extended_Price__c,  Order_Entry_Release__c FROM Order_Entry_Line__c WHERE
            Order_Entry_Release__c in :oerIds])
        {
            oerwMap.get(oel.Order_Entry_Release__c).addOrderEntryLine(oel, rtMap.get(oel.RecordTypeID).DeveloperName);
        }
        
        for (OrderEntryReleaseWrapper oerw : oerwMap.values())
        {
            oerw.reCalculateRollups();
            oerw.oer.Trigger_Source__c = 'Integration';         
        }
        
        saveResultList = Database.update(oerList,false);
        //
        // Handle any update errors
        //
        Integer i = 0;
        for (Database.SaveResult saver : saveResultList) 
        {                       
            if(!saver.isSuccess()) 
            {
                for (Database.Error dbe : saver.getErrors()) 
                {
                    System.debug('*** Error - Order Entry Release Update failed: ' + String.valueOf(saveResultList[i].Id) + ' ' + dbe.getMessage());
                }
            }
            i++;                        
        }                                         
    }
    
    /*
     * Method name  : finish
     * Description  : Batch Class finish Method. Called after all batches are processed. 
     * Return Type  : nil
     * Parameter    : Database.BatchableContext
     */
     
    global void finish(Database.BatchableContext BC)  
    {  
       System.Debug('Batch Job Finished');
    } 
    
}