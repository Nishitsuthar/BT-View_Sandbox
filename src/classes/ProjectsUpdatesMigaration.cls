global class ProjectsUpdatesMigaration implements Database.Batchable<sObject>, Database.Stateful{ 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT id,Project_Update__c,Weekly_Updates__c FROM Opportunity');
    }
    
    global void execute(Database.BatchableContext BC,List<Opportunity> scope){ 
        List<Opportunity> lstUpdatedOpp = new List<Opportunity>();
        List<Project_Weekly_Update__c> lstWeeklyUpdates = new List<Project_Weekly_Update__c>();
        for(Opportunity opp : scope){ 
            if(opp.Project_Update__c != NULL){
                lstWeeklyUpdates.add(new Project_Weekly_Update__c(Opportunity__c = opp.Id, Project_Weekly_Update__c = opp.Project_Update__c));
                string[] dataSplit = opp.Project_Update__c.split('<br>'); 
                system.debug('No Of Splits ' + dataSplit.size());
                //system.debug('After Splits ' + dataSplit[0]);
                if(dataSplit.size() > 1) {
                    String prjWeeklyUpdate = '';
                    for(String eachUpdate : dataSplit){
                        if(eachUpdate.trim() != '' && eachUpdate != NULL){
                             prjWeeklyUpdate+= eachUpdate.replaceAll('<[^>]+>',' ') + '\n';
                        }else if(prjWeeklyUpdate != ''){
                            break;
                        }	
                    }
                    opp.Weekly_Updates__c = prjWeeklyUpdate;
                } else {
                    opp.Weekly_Updates__c = opp.Project_Update__c.replaceAll('<[^>]+>',' ');
				}
                
                system.debug('Original  ' + opp.Project_Update__c);
                system.debug('Split Values  ' + opp.Weekly_Updates__c);
                
                lstUpdatedOpp.add(opp);
            }
        }  
        
        if(lstWeeklyUpdates.size() > 0 ){
            database.insert(lstWeeklyUpdates,false) ;
        }
        
        if(lstUpdatedOpp.size() > 0 ){
            database.Update(lstUpdatedOpp,false) ;
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}