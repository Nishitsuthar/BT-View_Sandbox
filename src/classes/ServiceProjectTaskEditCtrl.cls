public class ServiceProjectTaskEditCtrl  {

    public Service_Project_Tasks__c sPTask{get;set;}
    public Service_Project_Tasks__c oldSPTask{get;set;}
    
    public ServiceProjectTaskEditCtrl (ApexPages.StandardController controller) {
        sPTask = (Service_Project_Tasks__c) controller.getRecord();
        oldSPTask = sPTask.clone(false, false, false, false);
    }
    
    public PageReference saveServiceProjectTask(){
    
        Service_Project_Tasks__c objTask = [SELECT Id,External_ID__c,Percent_Complete__c,Start_Date__c,End_Date__c,Duration__c,Comments__c,
                                    Service_Project_Milestones__r.Case__r.Smartsheet_Id__c,
                                    Service_Project_Milestones__r.Case__r.Smartsheet_percent_complete_col_Index__c,
                                    Service_Project_Milestones__r.Case__r.Smartsheet_Start_Date_Col_Index__c,
                                    Service_Project_Milestones__r.Case__r.Smartsheet_End_Date_Col_Index__c,
                                    Service_Project_Milestones__r.Case__r.Smartsheet_Duration_Col_Index__c,
                                    Service_Project_Milestones__r.Case__r.Smartsheet_Comments_Col_Index__c
                                    From Service_Project_Tasks__c WHERE ID =: sPTask.Id  ];
                                    
        objTask.Percent_Complete__c = sPTask.Percent_Complete__c ;
        objTask.Start_Date__c = sPTask.Start_Date__c;
        objTask.End_Date__c= sPTask.End_Date__c;
        objTask.Duration__c= sPTask.Duration__c;
        objTask.Comments__c= sPTask.Comments__c;
        
        system.debug('Percent_Complete__c Old : '+ oldSPTask.Percent_Complete__c);
        system.debug('Percent_Complete__c New : '+ objTask.Percent_Complete__c);	
        
        system.debug('Start Date Old : '+ oldSPTask.Start_Date__c);
        system.debug('Start Date New : '+ objTask.Start_Date__c);
        
        system.debug('End Date Old : '+ oldSPTask.End_Date__c);
        system.debug('End Date New : '+ objTask.End_Date__c);
        
        system.debug('Duration Old : '+ oldSPTask.Duration__c);
        system.debug('Duration New : '+ objTask.Duration__c);
        
       if(oldSPTask.Percent_Complete__c != objTask.Percent_Complete__c || oldSPTask.Comments__c != objTask.Comments__c || 
           oldSPTask.Start_Date__c != objTask.Start_Date__c || oldSPTask.Duration__c != objTask.Duration__c){
            try{            
                Smartsheet.RowsResult objSheet = SmartSheetUtil.syncServiceProjectTasks(objTask, oldSPTask);
                system.debug('objSheet : '+objSheet.message );
                if(objSheet.message == 'SUCCESS'){
                    if(oldSPTask.Start_Date__c != objTask.Start_Date__c && oldSPTask.Duration__c != objTask.Duration__c){
                            sPTask.Start_Date__c = objTask.Start_Date__c;
                            sPTask.Duration__c = objTask.Duration__c;
                            String duration = objTask.Duration__c;
                            sPTask.End_Date__c = objTask.Start_Date__c + Integer.valueOf(duration.removeEnd('d'));
                        
                            }else if(oldSPTask.Start_Date__c != objTask.Start_Date__c && oldSPTask.Duration__c == objTask.Duration__c &&
                                             oldSPTask.End_Date__c == objTask.End_Date__c ){
                                            sPTask.Start_Date__c = objTask.Start_Date__c;
                                            sPTask.Duration__c = objTask.Duration__c;
                                            String duration = objTask.Duration__c;
                                            sPTask.End_Date__c = objTask.Start_Date__c + Integer.valueOf(duration.removeEnd('d'));
                                             }else if(oldSPTask.Duration__c != objTask.Duration__c && oldSPTask.Start_Date__c == objTask.Start_Date__c ){
                                                    sPTask.Start_Date__c = objTask.Start_Date__c;
                                                    sPTask.Duration__c = objTask.Duration__c;
                                                    String duration = objTask.Duration__c;
                                                    sPTask.End_Date__c = objTask.Start_Date__c + Integer.valueOf(duration.removeEnd('d'));
                                             }
                            
                    update sPTask;
                    return new PageReference('/' + String.valueOf(objTask.ID));    
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Something went wrong please check smartsheet error log table to resolve the issue '));
                    return null;
                }
            }
            catch(exception ex){
                system.debug('Duration New : '+ objTask.Duration__c);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                return null;
            }
        }
        else{
            return new PageReference('/' + String.valueOf(objTask.ID));
        }
        
    }

}