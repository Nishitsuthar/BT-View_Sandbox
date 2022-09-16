/*
    @ PURPOSE : HANDLES THE EVENTS TRIGGERED FROM WorkOrderTrigger.
*/
public without sharing class WorkOrderTriggerHandler {
    public static Boolean runcurrentTrigger(string triggerName){
       Case_to_order_Trigger_Enable_Disable__mdt mtdat=[SELECT MasterLabel, QualifiedApiName, Is_Trigger_Enabled__c FROM Case_to_order_Trigger_Enable_Disable__mdt where MasterLabel=:triggerName limit 1];
    system.debug('mtdat'+mtdat.Is_Trigger_Enabled__c);
        return mtdat.Is_Trigger_Enabled__c;
    }
    public static void updateCaseIssuesWithWorkOrders( List<WorkOrder> listOfNewWorkOrders ) {
        
        if( listOfNewWorkOrders == NULL || listOfNewWorkOrders.isEmpty() ) {
            return;
        }
        
        Map<ID,WorkOrder> caseIdToWorkOrderRecord = getCaseIdToWorkOrderRecord( listOfNewWorkOrders );
        if( caseIdToWorkOrderRecord.isEmpty() ) {
            return;
        }
        
        List<Issue__c> listOfIssues = getListOfIssues( caseIdToWorkOrderRecord.keySet() );
        system.debug('listOfIssues-returned-'+listOfIssues);
        if( listOfIssues.isEmpty() ) {
            return;
        }
        
        WorkOrder recordWorkOrder;
        for( Issue__c recordIssue : listOfIssues ) {
            recordWorkOrder = caseIdToWorkOrderRecord.get( recordIssue.Case__c );
            if( recordWorkOrder != NULL ) {
                recordIssue.Source_Work_Order__c = recordWorkOrder.Id;
            }
        }
        
        System.debug( 'updateCaseIssuesWithWorkOrders:-\n' + JSON.serialize( listOfIssues ) );
        Database.SaveResult[] updateIssueResults = Database.update( listOfIssues, FALSE );
        for( Database.SaveResult uir : updateIssueResults ) {
            if ( !uir.isSuccess() ) {
                for( Database.Error err : uir.getErrors() ) {
                    System.debug( 'The following error has occurred:-\n' + err.getStatusCode() + ': ' + err.getMessage() );
                    System.debug( 'Issue fields that affected this error: ' + err.getFields() );
                }
            }
        }
        
    }
    
    
    
    private static Map<ID,WorkOrder> getCaseIdToWorkOrderRecord( List<WorkOrder> listOfWorkOrders ) {
        
        Map<ID,WorkOrder> caseIdToWorkOrderRecord = new Map<ID,WorkOrder>();
         if( listOfWorkOrders == NULL || listOfWorkOrders.isEmpty() ) {
            return caseIdToWorkOrderRecord;
        }
        system.debug('listOfWorkOrders =='+listOfWorkOrders );
        for( WorkOrder recordWorkOrder : listOfWorkOrders ) {
        system.debug('recordWorkOrder.CaseId--'+recordWorkOrder.CaseId);
            if( recordWorkOrder.CaseId != NULL ) {
                caseIdToWorkOrderRecord.put( recordWorkOrder.CaseId, recordWorkOrder );
            }
        }
        System.debug( 'caseIdToWorkOrderRecord:-\n' + JSON.serialize( caseIdToWorkOrderRecord ) );
        return caseIdToWorkOrderRecord;
    }
    
  
    
    private static List<Issue__c> getListOfIssues( Set<ID> setOfCaseIds ) {
        
        List<Issue__c> listOfIssues = new List<Issue__c>();
        if( setOfCaseIds == NULL || setOfCaseIds.isEmpty() ) {
            return listOfIssues;
        }
        
        listOfIssues = [ SELECT ID, Name, Start_Date__c, End_Date__c, Window_Id__c, Issue_Status__c,Failure_Component__c,
                         Work_Type__c, Control_Panel__c, Description__c, Case__c, Case__r.Subject,Comments__c
                         FROM Issue__c
                         WHERE Case__c IN : setOfCaseIds AND Source_Work_Order__c = ''
                       ];
        System.debug( 'listOfIssues:-\n' + JSON.serialize( listOfIssues ) );
        return listOfIssues;
    }
    
    // Delete Entity Subscriptions when the Status moves to Closed/Rejection
    public static void deleteEntitySubscriptions(List<WorkOrder> listOfWOSubToDelete,Map<Id,WorkOrder> oldWorkorder)
    {
        Set<Id> idsToDelete = new Set<Id>();
        
        for(WorkOrder woD : listOfWOSubToDelete)
        {	
            WorkOrder oldWO = oldWorkorder.get(woD.Id);
            if((oldWO.Status !='Closed' && woD.Status == 'Closed') || ( oldWO.Status !='Rejected' && woD.Status == 'Rejected'))
            {
                idsToDelete.add(woD.Id);
            }
        }
        
        if (idsToDelete.Size() > 0){
            List<EntitySubscription> listToDelete = [Select id,ParentId from EntitySubscription where ParentId IN: idsToDelete];
            if(!listToDelete.isEmpty())
            {
                Delete listToDelete;
            }           
        }
    }
   
}