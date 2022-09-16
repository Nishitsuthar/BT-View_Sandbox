global class SmartSheetSyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts , Database.Stateful{ 

   global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator('SELECT id,Smartsheet_Id__c, SmartSheet_Url__c FROM Opportunity WHERE Smartsheet_Id__c != NULL');
   }

   global void execute(Database.BatchableContext BC,List<Opportunity> scope){
       List<SmartSheet_Exceptions__c> errorLogList = New List<SmartSheet_Exceptions__c>();
       //try{  
              
          for(Opportunity opp : scope){      
              if(opp.Smartsheet_Id__c != null){
                 system.debug('opp.Smartsheet_Id__c : '+opp.Smartsheet_Id__c);
                 SmartSheetUtil.syncSmartSheetWithOpp(Long.valueOf(opp.Smartsheet_Id__c));
                 if(SmartSheetUtil.allExceptions.size() > 0)
                    upsert SmartSheetUtil.allExceptions External_Id__c;
              }
          }  
      //}
      /*
      catch(Exception ex) {
          errorLogList.add(new SmartSheet_Exceptions__c(Opportunity__c = scope[0].Id, Error_Message__c = ex.getMessage() + ' -- '+ex.getLineNumber() + ' -- ' + ex.getCause(), Milestone_Task_Name__c = '' , SmartSheet_Id__c = scope[0].Smartsheet_Id__c , SmartSheet_Name__c= scope[0].SmartSheet_Url__c, Source__c='SmartSheetSyncBatch.execute'));
      }
       finally{
           Database.insert(errorLogList,false);
       }
       */
   }

   global void finish(Database.BatchableContext BC){

   }

}