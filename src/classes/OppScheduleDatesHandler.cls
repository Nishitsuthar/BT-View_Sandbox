/*
 * To modify the Scheduled_Ship_Date_IGU, Scheduled_Ship_Date_CSS dates of opportunity.
 */

public class OppScheduleDatesHandler {
    
    public static void updateScheduleShipDates(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap){
        
        Set<Id> oppIds 				= oldMap.keySet();
        List<Opportunity> opList 	= new List<Opportunity>();
        
        List<Order_Entry_Release__c> IGUList = new List<Order_Entry_Release__c>();
        List<Order_Entry_Release__c> CSSList = new List<Order_Entry_Release__c>();
               
        Order_Entry_Release__c[] oerQuery = [SELECT CreatedDate,Scheduled_Ship_Date__c,RecordTypeId, Order_Type__c
                                              FROM Order_Entry_Release__c 
                                              WHERE Opportunity__c in :oppIds ORDER BY CreatedDate ASC];
        
        Map<ID,Schema.RecordTypeInfo> oelRecordTypeMapSchema = Schema.SObjectType.Order_Entry_Release__c.getRecordTypeInfosById();
                
        for (Id opporId : oldMap.keySet()) {
            Opportunity oldOpp = oldMap.get(opporId);
        	Opportunity newOpp = newMap.get(opporId);
            
            /*if ((oldOpp.First_Request_Date_IGU__c != newOpp.First_Request_Date_IGU__c)
                ||
                (oldOpp.First_Request_Date_CSS__c != newOpp.First_Request_Date_CSS__c))
            {*/
            	for(Order_Entry_Release__c oerList : oerQuery){
                    if((oelRecordTypeMapSchema.get(oerList.RecordTypeId).getDeveloperName().contains('IGU'))
                        && oerList.Order_Type__c == 'Standard'
                      ){
                         if(oerList.Scheduled_Ship_Date__c != null){
                         	IGUList.add(oerList); 
                         }
                    }
                    if(oelRecordTypeMapSchema.get(oerList.RecordTypeID).getDeveloperName()==Label.CSS_Hardware){
                        if(oerList.Scheduled_Ship_Date__c != null){
                            CSSList.add(oerList);
                        }
                    }                                                   
                }//end: for-oerList
                if(IGUList.size() >0)
                {
                    //system.debug('Dates======='+IGUList.get(0).Scheduled_Ship_Date__c);
                    newOpp.Scheduled_Ship_Date_IGU__c = IGUList.get(0).Scheduled_Ship_Date__c; 
                } else{
                    newOpp.Scheduled_Ship_Date_IGU__c = newOpp.First_Request_Date_IGU__c;
                }
                    
                
                if(CSSList.size() >0){
                    newOpp.Scheduled_Ship_Date_CSS__c = CSSList.get(0).Scheduled_Ship_Date__c; 
                } else {
                    newOpp.Scheduled_Ship_Date_CSS__c = newOpp.First_Request_Date_CSS__c;
                }
            //}//end: IF            
        }//end:for-opporId
    }
}