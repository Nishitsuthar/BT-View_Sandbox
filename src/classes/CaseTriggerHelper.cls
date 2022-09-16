/*
Name : CaseTriggerHelper
Author : Magnet360
*/
public class CaseTriggerHelper {
    /*
closeMilestonewhenCaseIsClosed : This method collects all the case which are closed .
*and send the cases to MilestoneUtils class for updating milestones.
*/
    public static void closeMilestonewhenCaseIsClosed(List<Case> listNewCases,Map<Id,Case> mapOldCases){
        try{
            if(!listNewCases.IsEmpty()){
                List<Id> listClosedCases = new List<Id>();
                DateTime completionDate = System.now(); 
                for(Case newCase : listNewCases){
                    Case oldCase;
                    if(mapOldCases.containsKey(newCase.Id)){
                        oldCase = mapOldCases.get(newCase.Id);
                    }
                    if((newCase.isClosed || newCase.Status == 'Closed')
                       && newCase.isClosed != oldCase.isClosed){
                           listClosedCases.add(newCase.Id);
                       }
                }
                if(!listClosedCases.IsEmpty()){
                    MilestoneUtils.completeMilestone(listClosedCases,completionDate );
                }
            }
        }
        catch(exception e){
        }
    }
    @InvocableMethod
    public static void unlockApprovalLockedRecords(list<Id> caseIds){
        for(Id caseId: caseIds){
            if(Approval.isLocked(caseId)){
                Approval.unlock(caseId);
            }
        }
    }   
    /*
     * checkCaseForBoxFolderCreation :check for cases record eligibility for creation of box folder
     */    
     public static void checkCaseForBoxFolderCreation(List<Case> listNewCases,Map<Id,Case> mapOldCases){
        try{
            if(!listNewCases.IsEmpty()){
                List<Id> listCasesForBoxCreation = new List<Id>();
                Set<Id> setRecordTypeIds = new Set<Id>();
                for(String s : Label.RecordtypeForBoxFolderCreation.split(';')){
                    setRecordTypeIds.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(s).getRecordTypeId());
                }
                for(Case newCase : listNewCases){
                    Case oldCase;
                    if(mapOldCases!= null && mapOldCases.containsKey(newCase.Id)){
                        oldCase = mapOldCases.get(newCase.Id);
                    }
                    if(oldCase != null){
                        if((oldCase.BOX_Folder_Id__c == null
                           && oldCase.Opportunity__c != newCase.Opportunity__c )
                           && newCase.Opportunity__c!= null
                           && oldCase.Opportunity__c == null
                           && setRecordTypeIds.contains(newCase.RecordTypeId)
                           ){
                               listCasesForBoxCreation.add(newCase.Id);
                        }
                    }
                    else if(newCase.Opportunity__c != null
                           && setRecordTypeIds.contains(newCase.RecordTypeId)){
                        listCasesForBoxCreation.add(newCase.Id);
                    }
                }
                if(!listCasesForBoxCreation.IsEmpty()){
                    CreateBoxFolder(listCasesForBoxCreation);
                }
            }
        }
        catch(exception e){
            System.debug('exception=='+e);
        }    
    }    
    /*
     * CreateBoxFolder : Creates a BOX folder for case and opportunity.
     */     @future (callout=true)
    public static void CreateBoxFolder(List<Id> listCases){
        try{
            if(!listCases.isEmpty()){
                Map<Id,List<Case>> mapOppIdWithCases           = new Map<Id,List<Case>>();
                Map<Id,Opportunity> mapOpportunityIdFolderId   = new Map<Id,Opportunity>();
                Map<Id,String> mapOpportunityIdFolderName      = new Map<Id,String>();
                box.Toolkit boxToolkit                         = new box.Toolkit();
                List<Case> listCaseToUpdate                    = new List<Case>();
                List<box__FRUP__c> listFRUPToCreate            = new List<box__FRUP__c>();
                List<Opportunity> listOpportunityToUpdate      = new List<Opportunity>();                
                for(Case newCase : [select id,CaseNumber,Opportunity__c,Opportunity__r.BOX_Folder_Id__c,
                                    Opportunity__r.Name,Opportunity__r.Cases_Box_Folder_Id__c,Opportunity__r.Opportunity_ID__c 
                                    from case where id in : listCases]){
                    if(newCase.Opportunity__c != null){
                        mapOpportunityIdFolderName.put(newCase.Opportunity__c,newCase.Opportunity__r.Opportunity_ID__c + '_' + newCase.Opportunity__r.Name);
                        if(mapOppIdWithCases.containskey(newCase.Opportunity__c)){
                            mapOppIdWithCases.get(newCase.Opportunity__c).add(newCase);
                        }else{
                            mapOppIdWithCases.put(newCase.Opportunity__c,new List<Case>{newCase});
                        }
                        if(!mapOpportunityIdFolderId.containskey(newCase.Opportunity__c)){ 
                            if( newCase.Opportunity__r.BOX_Folder_Id__c!= null){
                                string opportunityFolderKey =  newCase.Opportunity__r.BOX_Folder_Id__c + '_' + newCase.Opportunity__r.Cases_Box_Folder_Id__c;
                                Opportunity oppRec = new opportunity(BOX_Folder_Id__c =newCase.Opportunity__r.BOX_Folder_Id__c,
                                                                    Cases_Box_Folder_Id__c= newCase.Opportunity__r.Cases_Box_Folder_Id__c);
                                mapOpportunityIdFolderId.put(newCase.Opportunity__c,oppRec );
                            }
                        }
                    }
                }                
                for(Id oppId : mapOppIdWithCases.keySet()){
                    String oppFolderId;
                    String casesFolderId;
                    if(mapOpportunityIdFolderId.containskey(oppId)){
                        oppFolderId= mapOpportunityIdFolderId.get(oppId).BOX_Folder_Id__c ;
                        
                        casesFolderId= mapOpportunityIdFolderId.get(oppId).Cases_Box_Folder_Id__c;
                        
                    }
                    if(oppFolderId == null){
                        String folderName = mapOpportunityIdFolderName.get(oppId);
                        oppFolderId = boxToolkit.createFolderForRecordId(oppId, folderName , true);
                    }
                    if(oppFolderId != null){
                         if(casesFolderId == Null)
                         {
                            casesFolderId= boxToolkit.createFolder('Cases', oppFolderId, null);
                         }      
                         listOpportunityToUpdate.add(new Opportunity(Id = oppId, BOX_Folder_Id__c=oppFolderId,Cases_Box_Folder_Id__c=casesFolderId ));
                      }
                    
                    if(oppFolderId!= null){
                        for(Case caseRec: mapOppIdWithCases.get(oppId)){
                            String caseFolderId;
                            if(casesFolderId != null){
                                caseFolderId = boxToolkit.createFolder(caseRec.CaseNumber +'_'+caseRec.Opportunity__r.Name, casesFolderId, null);
                            }
                            if(caseFolderId != null){
                                caseRec.BOX_Folder_Id__c = caseFolderId;
                                box__FRUP__c frupRec = new box__FRUP__c();
                                frupRec.box__Folder_ID__c = caseFolderId;
                                frupRec.box__Object_Name__c = 'Case';
                                frupRec.box__Record_ID__c = caseRec.Id;
                                frupRec.box__Permission__c ='Read/Write';
                                listFRUPToCreate.add(frupRec);
                                listCaseToUpdate.add(caseRec);
                            }
                        }
                    }
                }
                boxToolkit.commitChanges(); 
                if(!listCaseToUpdate.isEmpty()){
                    database.update(listCaseToUpdate);
                }
                if(!listOpportunityToUpdate.IsEmpty()){
                    database.update(listOpportunityToUpdate);
                }
                if(!listFRUPToCreate.IsEmpty()){
                    database.insert(listFRUPToCreate);
                }
            }
        }
        catch(Exception e){}
    }
}