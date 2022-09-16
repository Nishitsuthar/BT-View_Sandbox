public with sharing class CaseStatusChangeTriggerHandler {
    
    public static void OnAfterInsert(Case[] newObjects){
        
        List<Case_Status_Change__c> statusChanges = new List<Case_Status_Change__c>();
        statusChanges.addAll(createCaseStatus(newObjects, null));
        
        //check if user has permission to create Case_Status_Change__c records
        if (!Schema.sObjectType.Case_Status_Change__c.fields.Status_From__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Name.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Case__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_Name__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Current_Case_Owner__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Set_Time__c.isCreateable()){
                throw new DmlException('Insufficient permissions to create Case Status Change');
            }
        
        insert statusChanges;
    }
    public static void OnAfterInsertOwner(Case[] newObjects){
        
        List<Case_Status_Change__c> statusChanges = new List<Case_Status_Change__c>();
        statusChanges.addAll(createCaseStatusForOwnerChange(newObjects, null));
        
        //check if user has permission to create Case_Status_Change__c records
        if (!Schema.sObjectType.Case_Status_Change__c.fields.Owner_From__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Name.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Case__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Current_Case_Owner__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Set_Time__c.isCreateable()){
                throw new DmlException('Insufficient permissions to create Case Status Change');
            }
        
        insert statusChanges;
    }
    /*
checkFieldUpdate : method to verify if owner/Status is changed
*/
    public static void checkFieldUpdate(List<Case> newCaseList, Map<Id,Case> oldCaseMap){
        try{
            List<Case> listCaseWithOwnerChange = new List<Case>();
            List<Case> listCaseWithStatusChange = new List<Case>();
            for(Case newCase: newCaseList){    
                if(oldCaseMap.containskey(newCase.id)){
                    Case oldCase = oldCaseMap.get(newCase.id);
                    if(newCase.Status != oldCase.Status){
                        listCaseWithStatusChange.add(newCase);
                    }
                    if(newCase.ownerId!= oldCase.OwnerId){
                        listCaseWithOwnerChange.add(newCase);
                    }
                }
            }
            if(!listCaseWithStatusChange.IsEmpty()){
                CaseStatusChangeTriggerHandler.OnAfterUpdate(listCaseWithStatusChange,oldCaseMap);
            }
            if(!listCaseWithOwnerChange.IsEmpty()){
                CaseStatusChangeTriggerHandler.OnAfterUpdateOwner(listCaseWithOwnerChange,oldCaseMap);
            }
        }
        catch(Exception e){
        }
    }
    public static void OnAfterUpdate(Case[] updatedObjects, Map<Id, Case> oldObjectMap){
        
        List<Case_Status_Change__c> statusChanges = new List<Case_Status_Change__c>();
        List<Case_Status_Change__c> statusChangesToUpdate = new List<Case_Status_Change__c>();
        List<String> oldStatuses = new List<String>();
        List<Id> caseIds = new List<Id>();
        
        statusChanges.addAll(createCaseStatus(updatedObjects, oldObjectMap));
        for (Case_Status_Change__c statusChange: statusChanges) {
            
            oldStatuses.add(statusChange.Status_From__c);
            caseIds.add(statusChange.Case__c);            
        }
        
        
        //CRUD/FLS checks
        if (!Schema.sObjectType.Case_Status_Change__c.isAccessible() 
            ||!Schema.sObjectType.Case_Status_Change__c.fields.Name.isAccessible() 
            || !Schema.sObjectType.Case_Status_Change__c.fields.Set_Time__c.isAccessible()
            || !Schema.sObjectType.BusinessHours.isAccessible()){
                throw new QueryException('Insufficient access to Case Status Change or business hours objects');
            }
        
        if (caseIds.size()>0 && oldStatuses.size()>0) {
            Id recTypeId = Schema.SObjectType.Case_Status_Change__c.getRecordTypeInfosByName().get('Status Change').getRecordTypeId();
            List<Case_Status_Change__c> oldStatusChanges = [select Id, Name, Set_Time__c from Case_Status_Change__c 
                                                            where Status_Name__c IN :oldStatuses 
                                                            and Case__c IN :caseIds and Change_Time__c=null
                                                            and recordtypeid =: recTypeId];
            BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
            
            for (Case_Status_Change__c oldStatusChange: oldStatusChanges) {
                
                // calculate business hours               
                oldStatusChange.Change_Time__c = Datetime.now();
                Double milliseconds = BusinessHours.diff(bh.Id, oldStatusChange.Set_Time__c, oldStatusChange.Change_Time__c);                 
                oldStatusChange.Status_Time__c = (Decimal.valueOf(milliseconds)).Divide((60*60*1000), 2);
                oldStatusChange.Age__c = getAge(milliseconds);
                statusChangesToUpdate.add(oldStatusChange);
            }
        }
        
        //check if user has permission to create Case_Status_Change__c records
        if (!Schema.sObjectType.Case_Status_Change__c.fields.Status_From__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Name.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Case__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_Name__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Current_Case_Owner__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Set_Time__c.isCreateable()){
                throw new DmlException('Insufficient permissions to create Case Status Change');
            }
        
        insert statusChanges;
        
        //check if user has permission to update
        if (!Schema.sObjectType.Case_Status_Change__c.fields.Change_Time__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_Time__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Age__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_From__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Name.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Case__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_Name__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Current_Case_Owner__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Set_Time__c.isUpdateable()
           ){
               throw new DmlException('Insufficient permissions to update Case Status Change');
           }
        
        update statusChangesToUpdate;
        
    }   
    private static void OnAfterUpdateOwner(Case[] updatedObjects, Map<Id, Case> oldObjectMap){
        
        List<Case_Status_Change__c> ownerchanges = new List<Case_Status_Change__c>();
        List<Case_Status_Change__c> ownerChangesToUpdate = new List<Case_Status_Change__c>();
        List<String> oldOwners = new List<String>();
        List<Id> caseIds = new List<Id>();
        
        ownerchanges.addAll(createCaseStatusForOwnerChange(updatedObjects, oldObjectMap));
        for (Case_Status_Change__c statusChange: ownerchanges) {
            
            oldOwners.add(statusChange.Owner_From__c);
            caseIds.add(statusChange.Case__c);            
        }
        
        //CRUD/FLS checks
        if (!Schema.sObjectType.Case_Status_Change__c.isAccessible() 
            ||!Schema.sObjectType.Case_Status_Change__c.fields.Name.isAccessible() 
            || !Schema.sObjectType.Case_Status_Change__c.fields.Owner_Start_Time__c.isAccessible()
            || !Schema.sObjectType.BusinessHours.isAccessible()){
                throw new QueryException('Insufficient access to Case Status Change or business hours objects');
            }
        
        if (caseIds.size()>0 && oldOwners.size()>0) {
            Id recTypeId = Schema.SObjectType.Case_Status_Change__c.getRecordTypeInfosByName().get('Owner Change').getRecordTypeId();
            List<Case_Status_Change__c> oldStatusChanges = [select Id, Name, Owner_Start_Time__c from Case_Status_Change__c 
                                                            where Current_Case_Owner__c IN :oldOwners 
                                                            and Case__c IN :caseIds and Owner_End_Time__c=null
                                                            and recordtypeid =: recTypeId ];
            BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
            
            for (Case_Status_Change__c oldOwnerchange: oldStatusChanges) {
                
                // calculate business hours               
                oldOwnerchange.Owner_End_Time__c = Datetime.now();
                Double milliseconds = BusinessHours.diff(bh.Id, oldOwnerchange.Owner_Start_Time__c, oldOwnerchange.Owner_End_Time__c);                 
                oldOwnerchange.Owner_Time_numeric_hours__c = (Decimal.valueOf(milliseconds)).Divide((60*60*1000), 2);
                oldOwnerchange.Owner_Time_in_days_hrs_mins_secs__c = getAge(milliseconds);
                ownerChangesToUpdate.add(oldOwnerchange);
            }
        }
        
        //check if user has permission to create Case_Status_Change__c records
        if (!Schema.sObjectType.Case_Status_Change__c.fields.Status_From__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Name.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Case__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_Name__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Current_Case_Owner__c.isCreateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Owner_Start_Time__c.isCreateable()){
                throw new DmlException('Insufficient permissions to create Case Status Change');
            }
        if(!ownerchanges.IsEmpty()){
            insert ownerchanges;
        }
        
        //check if user has permission to update
        if (!Schema.sObjectType.Case_Status_Change__c.fields.Owner_End_Time__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Owner_Time_numeric_hours__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Owner_Time_in_days_hrs_mins_secs__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_From__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Name.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Case__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Status_Name__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Current_Case_Owner__c.isUpdateable()
            || !Schema.sObjectType.Case_Status_Change__c.fields.Owner_Start_Time__c.isUpdateable()
           ){
               throw new DmlException('Insufficient permissions to update Case Status Change');
           }
        if(!ownerChangesToUpdate.IsEmpty()){
            update ownerChangesToUpdate;
        }
        
    }
    private static List<Case_Status_Change__c> createCaseStatusForOwnerChange(Case[] caseObjects, Map<Id, Case> oldObjectMap){
        
        List<Case_Status_Change__c> statusChanges = new List<Case_Status_Change__c>();
        Map<Id,String> mapOwnerIdName = new Map<Id,String>();
        Set<Id> setoldOwnerId = new Set<Id>();
        Set<Id> setoldQueueId = new Set<Id>();
        //CRUD/FLS checks
        if (!Schema.sObjectType.Case.isAccessible() 
            ||!Schema.sObjectType.Case.fields.OwnerId.isAccessible() 
            || !Schema.sObjectType.User.isAccessible()
            || !Schema.sObjectType.User.fields.Name.isAccessible()){
                throw new QueryException('Insufficient access to Case or User objects');
            }
        Map<Id,Case> cases = new Map<Id,Case>([select CaseNumber,OwnerId, Owner.Name,Owner.Profile.Name from Case where Id in: caseObjects]);
        Id recTypeId = Schema.SObjectType.Case_Status_Change__c.getRecordTypeInfosByName().get('Owner Change').getRecordTypeId();
        if (oldObjectMap!=null){            
            for(Case oldCase: oldObjectMap.values()){
                if(oldCase.OwnerId!=null && oldCase.OwnerId.getSObjectType() == User.SObjectType) {
                    setOldOwnerId.add(oldCase.ownerId);
                }
                else if(oldCase.OwnerId!=null){
                    setoldQueueId.add(oldCase.ownerId);
                }
                else if(oldCase.OwnerId ==null && oldCase.createdbyid == null){
                    setOldOwnerId.add(userInfo.getUserId());
                }
            }
        }
        if(!setoldOwnerId.IsEmpty()){
            for(user oldOwner : [select id,name from user where id in : setOldOwnerId]){
                mapOwnerIdName.put(oldOwner.Id,oldOwner.Name);
            }
        }
        if(!setoldQueueId.IsEmpty()){
            for(Group oldGroup : [select id,name from group where id in : setoldQueueId]){
                mapOwnerIdName.put(oldGroup.Id,oldGroup.Name);
            }
        }
        for (Case caseObject: caseObjects) {
            
            Case_Status_Change__c  statusChange = null;
            
            if (!cases.IsEmpty() && cases.containskey(caseObject.Id)) {
                //this is the update case, check if the owner has changed or not, if changed
                //a new case status change record is created 
                if (oldObjectMap!=null && oldObjectMap.containskey(caseObject.Id)){
                    Case oldObject = oldObjectMap.get(caseObject.Id);
                    if (caseObject.OwnerId != oldObject.OwnerId) { 
                        statusChange = new Case_Status_Change__c();
                        if(mapOwnerIdName.containskey(oldObject.OwnerId)){
                            statusChange.Owner_From__c  = mapOwnerIdName.get(oldObject.OwnerId);
                        }
                        if(oldObject.OwnerId!= null && oldObject.OwnerId.getSObjectType() == User.SObjectType) {
                            statusChange.Owner_From_User__c = oldObject.OwnerId;
                        }
                        if(oldObject.OwnerId== null && mapOwnerIdName.containskey(userInfo.getUserId())){
                            statusChange.Owner_From_User__c = userInfo.getUserId();
                            statusChange.Owner_From__c  = mapOwnerIdName.get(userInfo.getUserId());
                        }
                        statusChange.Name = cases.get(caseObject.id).CaseNumber+' from ';
                        statusChange.Name +=statusChange.Owner_From__c +' to '+cases.get(caseObject.Id).Owner.Name;
                    }
                }
                // this is the new case, the first case status change record is created
                else{
                    statusChange = new Case_Status_Change__c();
                    statusChange.Name = caseObject.CaseNumber+' owner: '+cases.get(caseObject.Id).Owner.Name;                 
                }
                
                //populate the rest of fields, add it to the result list to return 
                if (statusChange!=null) {
                    statusChange.RecordTypeId = recTypeId;
                    statusChange.Case__c = caseObject.Id;
                    if(caseObject.OwnerId.getSObjectType() == User.SObjectType) {
                        statusChange.Case_Owner__c = caseObject.OwnerId;
                        statusChange.Owner_Profile__c=cases.get(caseObject.Id).Owner.Profile.Name;
                    }
                    statusChange.Current_Case_Owner__c = cases.get(caseObject.id).owner.name;
                    statusChange.Owner_Start_Time__c = Datetime.now();
                    statusChanges.add(statusChange);
                }   
            }
        }
        return statusChanges;
    }    
    
    private static List<Case_Status_Change__c> createCaseStatus(Case[] caseObjects, Map<Id, Case> oldObjectMap){
        
        List<Case_Status_Change__c> statusChanges = new List<Case_Status_Change__c>();
        
        //CRUD/FLS checks
        if (!Schema.sObjectType.Case.isAccessible() 
            ||!Schema.sObjectType.Case.fields.CaseNumber.isAccessible() 
            || !Schema.sObjectType.User.isAccessible()
            || !Schema.sObjectType.User.fields.Name.isAccessible()){
                throw new QueryException('Insufficient access to Case or User objects');
            }
        Map<Id,Case> cases = new Map<Id,Case>([select CaseNumber,OwnerId,Owner.Name from Case where Id in: caseObjects]);
        Id recTypeId = Schema.SObjectType.Case_Status_Change__c.getRecordTypeInfosByName().get('Status Change').getRecordTypeId();
        for (Case caseObject: caseObjects) {            
            Case_Status_Change__c  statusChange = null;
            
            if (cases.size()>0) {
                //this is the update case, check if the status has changed or not, if changed
                //a new case status change record is created 
                if (oldObjectMap!=null){
                    Case oldObject = oldObjectMap.get(caseObject.Id);
                    if (caseObject.Status != oldObject.Status) { 
                        
                        statusChange = new Case_Status_Change__c();
                        statusChange.Status_From__c  = oldObject.Status;
                        statusChange.Name = cases.get(caseObject.Id).CaseNumber+' from '+oldObject.Status +' to '+caseObject.Status;
                    }
                }
                // this is the new case, the first case status change record is created
                else{
                    statusChange = new Case_Status_Change__c();
                    statusChange.Name = cases.get(caseObject.Id).CaseNumber+' status: '+caseObject.Status;                 
                }
                
                //populate the rest of fields, add it to the result list to return 
                if (statusChange!=null) {
                    statusChange.RecordTypeId = recTypeId;
                    statusChange.Case__c = caseObject.Id;
                    statusChange.Status_Name__c = caseObject.Status;
                    statusChange.Current_Case_Owner__c = cases.get(caseObject.Id).Owner.Name;
                    statusChange.Set_Time__c = Datetime.now();
                    statusChanges.add(statusChange);
                }   
            }
        }
        return statusChanges;
    }
    
    private static String getAge(Double milliseconds) {
        
        Double duration = milliseconds;
        Double d = Math.floor(duration/86400000); //Get whole days
        duration -= d*86400000;
        Double h = Math.floor(duration/3600000); //Get whole hours
        duration -= h*3600000;
        Double m = Math.floor(duration/60000);
        duration -= m*60000;
        Double s = Math.floor(duration/1000);
        return d.format()+' days '+h.format()+' hours '+ m.format() + ' minutes ' + s.format() +' seconds';
    }
 
}