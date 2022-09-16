global class ProMileStone_Task_ReassignBatch implements Database.Batchable<sObject>{ 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        string query = 'select id,Opportunity__r.Project_Manager__c,Opportunity__r.CSM_Project_Manager__c, Functional_Responsibility__c, Assigned_To_Email__c, OwnerId,Owner.Name from Project_Milestones__c where Opportunity__c != NUll AND Owner.Name =\'' + 'JD Admin\'';
        system.debug('query'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Project_Milestones__c> ProjectMilestoneRecds){
        system.debug('entered'+ProjectMilestoneRecds);
        SmartSheetUtil.assignOwners(ProjectMilestoneRecds);
        update ProjectMilestoneRecds;
       
     }
    
    global void finish(Database.BatchableContext BC){
    }
    
}