public with sharing class WorkOrderProducts {
    @auraEnabled
    public static void createIssueFailureMode(List<String> selectedRecordList,
                                              String issueId,
                                              List<Failure_Mode__c> allFailureMode,
                                              Boolean isAllSelected,
                                              String failureComponent){
        try{                                          
            List<Issue_Failure_Mode__c> listIssueFailureMode = new List<Issue_Failure_Mode__c>();
            List<Issue__c> listIssuesToUpdate = new List<Issue__c>();
            Set<String> setselectedFailureMode = new Set<String>(selectedRecordList);
            Issue__c issueToUpdate = new Issue__c();

            if(!selectedRecordList.isEmpty()){
                for(String failureModeId :selectedRecordList){
                    Issue_Failure_Mode__c ifm = new Issue_Failure_Mode__c();
                    ifm.Failure_Mode__c = failureModeId;
                    ifm.Issue__c = issueId;
                    ifm.Failure_Component__c = failureComponent;
                    listIssueFailureMode.add(ifm);
                }
            }
            if(!listIssueFailureMode.IsEmpty()){
                Database.SaveResult[] srList= database.insert(listIssueFailureMode,true);    
                Boolean updateIssue;
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()){
                        updateIssue = true;
                        break;
                    }
                }                                         
                if(updateIssue ){
                    If(!allFailureMode.isEmpty()){
                        issueToUpdate.Failure_Mode_Under_Warranty__c = 'No';
                        issueToUpdate.Id =issueId;
                        for(Failure_Mode__c fm : allFailureMode){
                            if(setselectedFailureMode.contains(fm.Id)){                        
                                if(fm.In_Warranty__c){
                                    issueToUpdate.Failure_Mode_Under_Warranty__c = 'Yes';
                                }
                                if(fm.Name.contains('Customer Objection')){
                                    issueToUpdate.Failure_Mode_of_Customer_Objection__c = true;
                                }
                            }
                        }
                                       
                        if(issueToUpdate.Id != null){
                            if(issueToUpdate.Failure_Mode_Under_Warranty__c=='Yes'){
                                Issue__c getIssueDetails  = new Issue__C();
                                getIssueDetails =[select id,Product_Under_Warranty__c,Manually_updated_Warranty_Type__c from Issue__c where id =:issueToUpdate.Id limit 1];
                                if(getIssueDetails.Product_Under_Warranty__c =='Yes' && !getIssueDetails.Manually_updated_Warranty_Type__c){
                                  //  issueToUpdate.Warranty_Type__c  ='Warranty';
                                }
                            }
                            database.update(issueToUpdate);
                        }
                    } 
                }            
            }            
        }
        catch(Exception e){
            system.debug('e.getMessage()'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }                                         
    }
    @auraEnabled
    public static List<Failure_Mode__c> getProductList(String failureID){
        List<Failure_Mode__c> productlist = new List<Failure_Mode__c>();
        Boolean hasCustomPermission = FeatureManagement.checkPermission('Add_Failure_Modes');
        if(hasCustomPermission){
            if(failureID!= null && failureID!=''){
                list<Issue__c> listIssue = new List<Issue__c>();
                Set<Id> setExistingFailureMode = new Set<Id>();
                listIssue =[select id,Failure_Component__c,Ownership__c,(select id,Failure_Mode__c from Defect_Root_Causes__r)  from Issue__c where id =: failureID limit 1];
                if(!listIssue.IsEmpty()){
                    for(Issue_Failure_Mode__c ifm : listIssue.get(0).Defect_Root_Causes__r){
                        if(ifm.Failure_Mode__c != null){
                            setExistingFailureMode.add(ifm.Failure_Mode__c);
                        }
                    }
                    productlist = [select id,Name,In_Warranty__c,Failure_Component__c 
                                   from Failure_Mode__c 
                                   where Failure_Component__c =: listIssue.get(0).Failure_Component__c
                                    
                                   and id not in: setExistingFailureMode];    //and Ownership__c =: listIssue.get(0).Ownership__c                    
                }
            }
        }
        else{
            throw new AuraHandledException(Label.AddFailureModesAccessError);
        }
        return productlist;
    }
    public static void updateIssueOnFailureModeDelete(List<Issue_Failure_Mode__c> listIssueFailureMode){
        try{
            Set<Id> setFailureModeTodelete = new Set<Id>();
            for(Issue_Failure_Mode__c ifm : listIssueFailureMode){
                if(ifm.Issue__c!= null){
                    setFailureModeTodelete.add(ifm.Issue__c);
                }
            }
            if(!setFailureModeTodelete.IsEmpty()){
                List<Issue__c> listIssueToUpdate = new List<Issue__c>();
                Map<Id,Issue__c> mapIssueToUpdate = new Map<Id,Issue__c>();
                for(Issue__c issue : [select id,Warranty_Type__c,Failure_Mode_Under_Warranty__c,Product_Under_Warranty__c,
                                      (select id,Failure_Mode__r.In_Warranty__c,Failure_Mode__r.Name 
                                       from Defect_Root_Causes__r
                                       where id not in : listIssueFailureMode ) ,Failure_Mode_of_Customer_Objection__c
                                      from Issue__c where (id in : setFailureModeTodelete) 
                                      limit 200]){
                                          if(!issue.Defect_Root_Causes__r.IsEmpty() 
                                             && (issue.Failure_Mode_Under_Warranty__c  == 'Yes' || issue.Failure_Mode_of_Customer_Objection__c)){
                                                 Boolean failureModeInWarranty = false;
                                                 Boolean failureModeOfCustomerObjection = false;
                                                 for(Issue_Failure_Mode__c  ifm : issue.Defect_Root_Causes__r){
                                                     if(ifm.Failure_Mode__r.In_Warranty__c){
                                                         failureModeInWarranty = true;
                                                     }
                                                     if(ifm.Failure_Mode__r.Name!=null && ifm.Failure_Mode__r.Name.contains('Customer Objection')){
                                                         failureModeOfCustomerObjection = true;
                                                     }
                                                 }
                                                 if(!failureModeInWarranty){
                                                     issue.Failure_Mode_Under_Warranty__c = 'No';
                                                     mapIssueToUpdate.put(issue.id,issue);                        
                                                 }     
                                                 if(!failureModeOfCustomerObjection){
                                                     issue.Failure_Mode_of_Customer_Objection__c = false;
                                                     mapIssueToUpdate.put(issue.id,issue);                        
                                                 }
                                             }
                                          else if(issue.Defect_Root_Causes__r.IsEmpty()){
                                              issue.Failure_Mode_of_Customer_Objection__c = false;
                                              issue.Failure_Mode_Under_Warranty__c = null;
                                              mapIssueToUpdate.put(issue.id,issue);                        
                                          }             
                                      }
                if(!mapIssueToUpdate.IsEmpty()){
                    listIssueToUpdate.addall(mapIssueToUpdate.values());
                    database.update(listIssueToUpdate);
                }
            }
        }
        catch(Exception e){}
    }
}