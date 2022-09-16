global class ProTask_OwnerRessignBatch implements Database.Batchable<sObject>{ 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        string query = 'select id,Project_Milestones__r.Opportunity__r.Project_Manager__c,Project_Milestones__r.Opportunity__r.CSM_Project_Manager__c, Functional_Responsibility__c, Assigned_To_Email__c, OwnerId,Owner.Name from Project_Tasks__c where Project_Milestones__c != null AND Owner.Name =\'' + 'JD Admin\'';
        system.debug('query'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Project_Tasks__c> ProjectTaskRecds){
        system.debug('entered'+ProjectTaskRecds);
        SmartSheetUtil.assignOwners(ProjectTaskRecds);
        Update ProjectTaskRecds;
        
     }
    
    global void finish(Database.BatchableContext BC){
    }
    
}