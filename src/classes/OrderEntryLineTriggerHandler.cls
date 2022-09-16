public class OrderEntryLineTriggerHandler {
        
     public static void processProjectPhase(Map<Id, Order_Entry_Line__c> newOELMap){
        list<Phase_Order_Line__c> juncRecords = new list<Phase_Order_Line__c>();
         Map<String,string > customerRefOERMap = new Map<String,string >(); 
         set<string> refIds= new set<string>();        
        //Get OER Map with Reference Id and Associated OER 
        for(Order_Entry_Line__c oel: newOELMap.values())
        {
            refIds.add(oel.Reference_ID__c);
        }
        for(Project_Phase__c obj: [SELECT id,Customer_Reference_id__c from Project_Phase__c where Customer_Reference_id__c in: refIds]){           
               if(obj.Customer_Reference_id__c!=null)
               customerRefOERMap.put(obj.Customer_Reference_id__c,obj.Id);
        
        }
        for(Order_Entry_Line__c oel: newOELMap.values())
        {
            
            if(customerRefOERMap.containskey(oel.Reference_ID__c)){
                Phase_Order_Line__c ob= new Phase_Order_Line__c();
                ob.Order_Entry_Line__c=oel.Id;
                ob.Project_Phase__c=customerRefOERMap.get(oel.Reference_ID__c);
                //ob.Customer_Reference_id__c = oel.Reference_ID__c;
                //ob.Customer_Reference_Description__c = oel.Customer_Reference_Description__c;
                juncRecords.add(ob);
            }
        }
        if(!juncRecords.isEmpty() && !test.isRunningTest())
            insert juncRecords;
     }
     /*public static void processPhaseOrder(Map<Id, Order_Entry_Line__c> newOELMap,Map<Id, Order_Entry_Line__c> oldOELMap){
     
         for(Order_Entry_Line__c oel: newOELMap.values())
         {
             
         }
         
     }  */   
      
}