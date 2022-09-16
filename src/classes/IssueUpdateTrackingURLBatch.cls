/*
 * Added by:- Sushma - 06-Dec-2019
 * Batch class to update the Tracking URL of the shipmentLine object into the Issue Object.
 */
global class IssueUpdateTrackingURLBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    Map<Id, String> trackingMap = new Map<Id, String>();
    
    global IssueUpdateTrackingURLBatch(Map<Id, String> urlMap){
        
        this.trackingMap = urlMap;
        System.debug('this.trackingMap:-\n'+ this.trackingMap);
    }
    
    global database.querylocator start(Database.BatchableContext BC){
        Set<ID> orderEntryRelIds 	= trackingMap.keySet();
        String statusChk			= String.escapeSingleQuotes('Open');
        
        string query = 'SELECT Id, Tracking_URL__c,Order_Entry_Release__c FROM Issue__c WHERE Case__c<>null and Order_Entry_Release__c in : orderEntryRelIds';
        System.debug('query:-\n' + query );
        System.debug(JSON.serialize(Database.query(query)));
        return database.getQueryLocator(query);
    } 
    
    global void execute(Database.BatchableContext BC, Sobject[] scope){
        List<Issue__c> issueList = new List<Issue__c>();
        for (Issue__c item : (List<Issue__c>)scope) {
            item.Tracking_URL__c = trackingMap.get(item.Order_Entry_Release__c);
            issueList.add(item);
        }
        update issueList;      
    }
    
    global void finish(Database.BatchableContext BC) {

	}

}