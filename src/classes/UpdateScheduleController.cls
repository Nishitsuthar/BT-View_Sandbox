public class UpdateScheduleController {
    
    
     public static void decommissionMilestone(){
			
    }
    /*
    private Opportunity opp;

    public UpdateScheduleController(ApexPages.StandardController controller) {
        opp=(Opportunity)controller.getRecord();
    }
    
    public pagereference updateSchedule(){
        SavePoint sp = Database.setSavePoint();
        try{
            List<Id> lineItemIds = new List<Id>();
            List<OpportunityLineItemSchedule> oppLineItemSchedules = new  List<OpportunityLineItemSchedule>();
            
            for(OpportunityLineItem opplineItem : [
                                                      SELECT
                                                           Id
                                                       FROM
                                                            OpportunityLineItem 
                                                       WHERE 
                                                            OpportunityId=:opp.Id]){
                                                            
                lineItemIds.add(opplineItem.Id);
            }
            
            if(!lineItemIds.isEmpty()){
                DELETE [
                            SELECT
                                Id
                            FROM
                                OpportunityLineItemSchedule
                            WHERE
                                OpportunityLineItemId IN :lineItemIds
                        ];
                                                            
                for(Milestone1_Milestone__c m:[
                                                SELECT 
                                                    Id,
                                                    Opportunity__r.Glass_Price_per_Square_Foot__c,
                                                    Quantity__c,Ship_Date__c,
                                                    Deadline__c  
                                                FROM 
                                                    Milestone1_Milestone__c 
                                                WHERE 
                                                    Opportunity__c=:opp.Id 
                                                    AND 
                                                    Type__c='IGU Ship Phase' 
                                                    AND 
                                                    Phase__c != NULL
                                                ]){
                    
                    if( m.Deadline__c !=null){                            
                        OpportunityLineItemSchedule newOppLineItemSchedule = new OpportunityLineItemSchedule();
                        newOppLineItemSchedule.OpportunityLineItemId = lineItemIds[0];
                        newOppLineItemSchedule.Revenue = replaceNullWithZero(m.Opportunity__r.Glass_Price_per_Square_Foot__c) * replaceNullWithZero(m.Quantity__c);
                        newOppLineItemSchedule.Quantity = m.Quantity__c;
                        newOppLineItemSchedule.Type = 'Both';
                        newOppLineItemSchedule.ScheduleDate = m.Deadline__c;
                        oppLineItemSchedules.add(newOppLineItemSchedule); 
                    }
                    else{
                        Database.rollback(sp);
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please make sure all Milestone have deadline');
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                }
                if(!oppLineItemSchedules.isEmpty()){
                   insert oppLineItemSchedules; 
                }
            }    
                        
            return new pagereference('/'+opp.Id);
        }catch(Exception e){
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    private static Decimal replaceNullWithZero(Decimal d){
        return d == NULL ? 0 : d;
    }
*/

}