public class CustomerSatisfactionVisit{
    
    public Void populateRecentCSVisitREquest(List<Id> OppIdList){
        Map<Id,Id> csvOppIdMap = new Map<Id,Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Opportunity> updateOppList = new List<Opportunity>();
        //system.debug('##OppIdList###'+OppIdList);
        for(Customer_Satisfaction_Visit__c obj : [Select Id, Name, Visit_Date__c, Customer_Sentiment_Value__c, Related_Opportunity__r.Id 
                                                        FROM Customer_Satisfaction_Visit__c WHERE Related_Opportunity__c in :OppIdList Order By Visit_Date__c DESC LIMIT 1]){                                    
            csvOppIdMap.put(obj.Related_Opportunity__r.Id, obj.Id);
            //system.debug('##csvOppIdMap###'+csvOppIdMap); 
        }
        if(OppIdList.size()>0){         
            oppList = [Select Id from Opportunity Where Id in :OppIdList];
            //system.debug('##oppList###'+oppList);            
        }
        if(oppList.size()>0 && csvOppIdMap.size()>0){         
            for(Opportunity obj : oppList){
                if(csvOppIdMap.get(obj.Id)!=null){
                     //system.debug('##csvOppIdMap.get(obj.Id)###'+csvOppIdMap.get(obj.Id));
                     obj.Customer_Satisfaction_Visit__c = csvOppIdMap.get(obj.Id);
                     updateOppList.add(obj);
                }
            }
        }
        
        if(updateOppList.size()>0){
            //system.debug('##updateOppList###'+updateOppList);
            try{                
                update updateOppList;
                
            }catch(Exception ex){               
                System.debug('Exception from CustomerSatisfactionVisit '+ex);
            }
            
        }
    }
}