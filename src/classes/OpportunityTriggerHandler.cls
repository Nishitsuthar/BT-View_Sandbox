public class OpportunityTriggerHandler {

    public void sumWinningProjectInfo(List<Opportunity> opportunityList){
        Id opptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Projects').getRecordTypeId();
        Set<Id> opptyId = new Set<Id>();
        for(Opportunity opptyObj : opportunityList) {
            
            if(opptyObj.MOU_Opportunity__c != null) {
                opptyId.add(opptyObj.MOU_Opportunity__c);
                
            }
        }
        
        List<Opportunity> parentOpptyList = new List<Opportunity>();
        parentOpptyList = [Select id, 
                                  (Select id, 
                                          Winning_Projects_Total_Sq_Ft__c, 
                                          Winning_Total_of_IGUs__c 
                                   from Projects__r 
                                   where RecordTypeId =: opptyRecordtype) 
                           from opportunity 
                           where Id IN :opptyId];
        for(Opportunity opptyObj :parentOpptyList) {
            decimal totalSqFeet = 0;
            decimal totalIGU = 0;
            for(Opportunity childOpptyObj : opptyObj.Projects__r) {
                if(childOpptyObj.Winning_Projects_Total_Sq_Ft__c != null) {
                    totalSqFeet += childOpptyObj.Winning_Projects_Total_Sq_Ft__c;
                }
                if(childOpptyObj.Winning_Total_of_IGUs__c != null) {
                    totalIGU += childOpptyObj.Winning_Total_of_IGUs__c;
                }
            }
            opptyObj.Winning_Projects_Total_Sq_Ft__c = totalSqFeet;
            opptyObj.Winning_Total_of_IGUs__c = totalIGU;
        }
        update parentOpptyList;
    }   
}