public class ProjectTaskEditCtrl {

    public Project_Tasks__c prjTask{get;set;}
    public Project_Tasks__c oldPrjTask{get;set;}
    
    public ProjectTaskEditCtrl(ApexPages.StandardController controller) {
        prjTask = (Project_Tasks__c) controller.getRecord();
        oldPrjTask = prjTask.clone(false, false, false, false);
    }
    
    public PageReference saveProjectTask(){
    
        Project_Tasks__c objTask = [SELECT Id,External_ID__c,Project_Milestones__r.Opportunity__r.Smartsheet_percent_complete_col_Index__c,
                                    Project_Milestones__r.Opportunity__r.Smartsheet_Comments_Col_Index__c,
                                    Project_Milestones__r.Opportunity__r.Smartsheet_Id__c
                                    From Project_Tasks__c WHERE ID =: prjTask.Id  ];
        objTask.Percent_Complete__c = prjTask.Percent_Complete__c ;
        objTask.Comments__c = prjTask.Comments__c;
        
        system.debug('Percent_Complete__c Old : '+ oldPrjTask.Percent_Complete__c);
        system.debug('Percent_Complete__c New : '+ objTask.Percent_Complete__c);
        system.debug('Comments__c Old : '+ oldPrjTask.Comments__c);
        system.debug('Comments__c New : '+ objTask.Comments__c);
       
        
        if(oldPrjTask.Percent_Complete__c != objTask.Percent_Complete__c || oldPrjTask.Comments__c != objTask.Comments__c){
        
            Smartsheet.RowsResult objSheet = SmartSheetUtil.syncProjectTasks(objTask );
            //system.debug('objSheet : '+objSheet.message );
            
            if(objSheet.message == 'SUCCESS'){            
                update prjTask;
                return new PageReference('/' + String.valueOf(objTask.ID));                
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objSheet.message));
                return null;
            }
        }
        else{
            return new PageReference('/' + String.valueOf(objTask.ID));
        }
        
    }

}