global class CSSProjectPhasebatch implements Database.Batchable<sObject>, Database.Stateful{

    private Map<String,Order_Entry_Line__c > customerRefOERMap; 
    private list<Project_Phase__c> finalListprojphase = new list<Project_Phase__c>();
    public CSSProjectPhasebatch (Map<String,Order_Entry_Line__c > customerRefOERMapparam){
   customerRefOERMap= customerRefOERMapparam; 
   system.debug('@batch run'+customerRefOERMap);
   //system.debug('@batch run22'+customerRefOERMap.get('LV-0303-180917015').Order_Entry_Release__r.Status__c);          
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator('SELECT id,Customer_reference_Id__c,Status__c,Order_Entry_Release__c FROM Project_Phase__c where Customer_reference_Id__c !=null');
   }

   global void execute(Database.BatchableContext BC,List<Project_Phase__c> scope){
       system.debug('@batch run'+customerRefOERMap);
      for(Project_Phase__c s : scope){
      
          if(customerRefOERMap.containskey(s.Customer_reference_Id__c)){
              s.Order_Entry_Release__c=customerRefOERMap.get(s.Customer_reference_Id__c).Order_Entry_Release__c;
              s.Status__c=customerRefOERMap.get(s.Customer_reference_Id__c).Order_Entry_Release__r.Status__c;
              system.debug('@batch run'+customerRefOERMap.get(s.Customer_reference_Id__c).Order_Entry_Release__r.Status__c);
          }
          else
             s.Order_Entry_Release__c=null;
              s.Status__c='';
      }      
      update scope;
   }

   global void finish(Database.BatchableContext BC){
   system.debug('@batch run'+customerRefOERMap);

   }

}