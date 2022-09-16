@IsTest(SeeAlldata=TRUE)
public class TestUpdatetrackingURL {
    
    public static testmethod void UpdatetrackingURL(){
        
        list<Issue__c> issuelist=[SELECT Id, Order_Entry_Release__c,Case__c FROM Issue__c WHERE Work_Type__c<>null and Case__c<>null and Order_Entry_Release__c <> null LIMIT 1 ];
        Map<ID,String> m = new Map<ID,String>{issuelist[0].Order_Entry_Release__c=> 'dscbdsjndskndc'};
            IssueUpdateTrackingURLBatch b = new IssueUpdateTrackingURLBatch( m );
        Database.executeBatch(b,2000);
    }
    
    public static testmethod void orderentrylinetrigger() {
		
		List<Issue__c> listOfIssues = [ SELECT ID, Order_Entry_Release__c FROM Issue__c WHERE
									    Trunk__c != NULL
											AND
										Product__c != NULL
											AND
										Order_Entry_Release__c != NULL
										LIMIT 1 
									  ];
									  
        Map<ID,Order_Entry_Line__c> mapOEl=new Map<ID,Order_Entry_Line__c>([ SELECT Id, Order_Entry_Release__c,Product__c,Status__c,Quantity_Shipped__c
											FROM Order_Entry_Line__c 
											WHERE
											Order_Entry_Release__c<>null
											and 
                                            Product__c<>null 
											and
											Status__c =:'Shipped'
											AND
											Quantity_Shipped__c<>null
                                            AND 
											Order_Entry_Release__c =: listOfIssues.get( 0 ).Order_Entry_Release__c
											LIMIT 1
											]);
        OrderEntryLineTriggerHelper.adjustQuantitiesOnProductItems(mapOEl.values());
		OrderEntryLineTriggerHelper.adjustQuantitiesOnProductItems(mapOEl.values(),mapOEl); 
    }
}