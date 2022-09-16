/****************************************************************************
Created By : ENP Solutionz
Date       : 03/11/19

Description : This class contains utility methods that invoke Smartsheet API.

*****************************************************************************/
public without sharing class SmartSheetUtil {
    
    Static SmartsheetApi ssAPI;
    
    Static Integer INDEX_OPP_MILESTONE = 1;
    Static Integer INDEX_DURATION = 2;
    Static Integer INDEX_START_DATE = 3;
    Static Integer INDEX_END_DATE = 4;
    Static Integer INDEX_PREDECESSORS = 5;
    Static Integer INDEX_PERCENT_COMPLETE = 6;
    Static Integer INDEX_COMMENTS = 7;
    Static Integer INDEX_ASSIGNED_TO = 8;
    Static Integer INDEX_FUNC_RESPONSIBILITY = 9;
    Static Integer INDEX_OPP_ID = 10;
    Static Integer INDEX_ROW_TYPE = 11;
    Static Integer INDEX_ORDER = 12;
    Static Integer INDEX_DEADLINE = 13;
    public static boolean isSmartSheetAPITransaction = false;  

    public static boolean isBulkUpdateJob = false;  

    public static String validationContext;
    
    public static Boolean isSmartsheetSyncJobContext = false;
    
    
    public class RowData{
        Long rowId;
        Long parentId;
        String name;
        String duration;
        Date startDate;
        Date endDate;
        String assignedTo;
        Decimal percentComplete;
        String comments;
        String funcResponsibility;
        String rowType;
        String entityId;
        String order;
        Date deadline;
        String percentCompleteColId;
        ColumnIds allColumnIds;
    }
    
    public class ColumnIds{
        String percentCompleteColId;
        String commentsColId;
        String deadlineColId;
        String durationColId;
        String endDateColId;
        String functionalResponsibilityColId;
        String orderColId;
        String startDateColId;
        String taskNameColId;
    }
    
    public class sheetWrapper {
        String entityId;
        String entityType;
        String sheetUrl;
        Long sheetId;
        ColumnIds allColumnIds;
        String percentCompleteColId;
        String weeklyUpdates;
        Map<Long, Project_Milestones__c> map_rowId_MileStones;
        Map<Long, Project_Tasks__c> map_rowId_projTasks;
        
        Map<Long, Service_Project_Milestones__c> map_rowId_Service_MileStones;
        Map<Long, Service_Project_Tasks__c> map_rowId_ServiceTasks;
        
        Map<Long, RowData> map_rowId_rowData;
        sheetWrapper(String entityId,String entityType,String sheetUrl, Long sheetId, String percentCompleteColId, String weeklyUpdates,
         Map<Long, Project_Milestones__c> map_rowId_MileStones, Map<Long, Project_Tasks__c> map_rowId_projTasks, Map<Long, 
         Service_Project_Milestones__c> map_rowId_Service_MileStones, Map<Long,
         Service_Project_Tasks__c> map_rowId_ServiceTasks,Map<Long, RowData> map_rowId_rowData,ColumnIds allColumnIds) {
            this.entityId = entityId;
            this.entityType = entityType;
            this.sheetUrl = sheetUrl;
            this.sheetId = sheetId;
            this.percentCompleteColId = percentCompleteColId;
            this.weeklyUpdates = weeklyUpdates;
            this.map_rowId_MileStones = map_rowId_MileStones;
            this.map_rowId_projTasks = map_rowId_projTasks;
            this.map_rowId_Service_MileStones = map_rowId_Service_MileStones;
            this.map_rowId_ServiceTasks = map_rowId_ServiceTasks;
            this.map_rowId_rowData = map_rowId_rowData;
            this.allColumnIds = allColumnIds;
        }
    }
    
    public static Map<long,Smartsheet.SheetsHeader> mapSheetDetails;
    public static List<SmartSheet_Exceptions__c> allExceptions;

    static {
        ssAPI = new SmartsheetApi();
        mapSheetDetails = new Map<long,Smartsheet.SheetsHeader>();
        allExceptions = new List<SmartSheet_Exceptions__c>();
    }
    
    @future(callout = true)
    public static void syncSmartSheets(Datetime dt) {
        
        //Get all updated sheets since given time.
        List<long> updatedSheetIds;
        updatedSheetIds = getAllSheetIdsUpdatedSince(dt);
        system.debug('updatedSheetIds : ' + updatedSheetIds);
        List<sheetWrapper> allSheetWrappers = new List<sheetWrapper>();
        
        for(Long sheetId : updatedSheetIds) {
            system.debug('Number of callouts left:' + Limits.getLimitCallouts());
            if(Limits.getCallouts() <= Limits.getLimitCallouts()){
                sheetWrapper sw;
                try{
                    sw = getSmartSheetMilestoneAndTasks(sheetId);
                    system.debug('Sheet Wrapper Data sw : ' + sw);
                }Catch(Exception e){
                    system.debug('SMART SHEET ERROR LOG:' + e.getMessage());
                }  
                if(sw != NULL) { allSheetWrappers.add(sw); }
            }
        }
        system.debug('Sheet Wrapper Data sw : ' + allSheetWrappers);
        allSheetWrappers = checkIfOpptyExist(allSheetWrappers);  

        if(allExceptions.size() > 0)
            upsert allExceptions External_Id__c;  
        
        updateData(allSheetWrappers);
    }
    
    public static List<sheetWrapper> checkIfOpptyExist(List<sheetWrapper> allSheetWrappers) {
        
        List<sheetWrapper> filteredSheetWrapperList = new List<sheetWrapper>();
        
        List<Id> oppIds = new List<Id>();
        for(sheetWrapper eachSheetWrapper : allSheetWrappers)
            if(eachSheetWrapper.entityId != NULL) { oppIds.add(eachSheetWrapper.entityId); }
        system.debug('oppIds : '+oppIds);
        if(oppIds.size() > 0) {  
            Map<Id, Opportunity> map_oppId_oppty = new Map<Id, Opportunity>([SELECT Id FROM Opportunity WHERE Id IN :oppIds]);
            Map<Id, Case> map_oppId_Case = new Map<Id, Case>([SELECT Id FROM Case WHERE Id IN :oppIds]);
            
            system.debug('map_oppId_oppty sw : ' + map_oppId_oppty);
            
            system.debug('map_oppId_Case sw : ' + map_oppId_Case);
            
            for(sheetWrapper eachSheetWrapper : allSheetWrappers){
                
                if(map_oppId_oppty.containsKey(eachSheetWrapper.entityId)) {
                    filteredSheetWrapperList.add(eachSheetWrapper);
                }
                
                if(map_oppId_Case.containsKey(eachSheetWrapper.entityId)) {
                    filteredSheetWrapperList.add(eachSheetWrapper);
                }
            }
                
        }  
        system.debug('filteredSheetWrapperList sw : ' + filteredSheetWrapperList);
        return filteredSheetWrapperList;
    }
    
    /*
     public static void getAllSheets() {
       
        Smartsheet.IndexResultOrgSheets result = ssAPI.getOrgSheets(1);  
        system.debug('result : '+ result);  
        system.debug('result : '+ result.totalPages );
        List<SmartSheet_Sync_Details__c> lstSheets = new List<SmartSheet_Sync_Details__c>();
        for(Integer indx = 0; indx < result.data.size(); indx++) {
            Smartsheet.SheetsHeader eachSheetHeader = result.data[indx];
            system.debug('eachSheetHeader : '+ eachSheetHeader);
            lstSheets.add(new SmartSheet_Sync_Details__c(Smartsheet_Id__c = string.valueOf(eachSheetHeader.id),SmartSheet_Name__c = eachSheetHeader.name , Is_Synced__c = false));
        }
        
        for(Integer pageNo = 2; pageNo <= result.totalPages; pageNo++){
            Smartsheet.IndexResultOrgSheets resultPageWise = ssAPI.getOrgSheets(pageNo);  
            system.debug('result : '+ resultPageWise );                 
            for(Integer indx = 0; indx < resultPageWise.data.size(); indx++) {
                Smartsheet.SheetsHeader eachSheetHeader = resultPageWise.data[indx];
                system.debug('eachSheetHeader : '+ eachSheetHeader);
                lstSheets.add(new SmartSheet_Sync_Details__c(Smartsheet_Id__c = string.valueOf(eachSheetHeader.id),SmartSheet_Name__c = eachSheetHeader.name, Is_Synced__c = false));
            }
        }
        system.debug(lstSheets.size());
        if(lstSheets.size()>0){
            upsert lstSheets Smartsheet_Id__c;
        }
        
    }
    */
    
    public static List<Long> getAllSheetIdsUpdatedSince(Datetime dt) {
        
        //String modifiedSince = System.now().addHours(hours * -1).format('yyyy-MM-dd\'T\'HH:mm:ss\'z\'', 'London');
        String modifiedSince = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'z\'', 'London');
        Smartsheet.IndexResultOrgSheets result;

        if(!Test.isRunningTest()) {
            result = ssAPI.getOrgSheets(modifiedSince);
        } else {
            Smartsheet.SheetsHeader sh = new Smartsheet.SheetsHeader();
            sh.id = Long.valueOf('12345');
            sh.name = 'Test';
            sh.owner = 'Test';
            sh.ownerId = 'Test';

            Smartsheet.IndexResultOrgSheets res = new Smartsheet.IndexResultOrgSheets();
            res.pageNumber = 1;
            res.pageSize = 1;
            res.totalCount = 1;
            res.totalPages = 1;
            res.data = new Smartsheet.SheetsHeader[1];
            res.data[0] = sh ;
            result = res;
        }
        
        List<Long> sheetIds = new List<Long>();
        if(result.data != Null){
            for(Integer indx = 0; indx < result.data.size(); indx++) {
                Smartsheet.SheetsHeader eachSheetHeader = result.data[indx];
                sheetIds.add(eachSheetHeader.id);
                mapSheetDetails.put(eachSheetHeader.id, eachSheetHeader);
            }
        }
        system.debug('Updated Sheets' + sheetIds);
        return sheetIds;
    }
    
    public static void syncSmartSheetWithOpp(Long sheetId) {
        sheetWrapper obj = getSmartSheetMilestoneAndTasks(sheetId);

        if(obj == NULL) {
            return;
        }
        
        system.debug('Sheet Wrapper Data : '+obj);
        
        List<sheetWrapper> filteredSheetWrappers = checkIfOpptyExist(new List<sheetWrapper>{obj});
        if(filteredSheetWrappers.size() > 0) { obj = filteredSheetWrappers[0]; }
        
        Map<Long, Project_Milestones__c> map_rowId_MileStones = obj.map_rowId_MileStones;
        Map<Long, Project_Tasks__c> map_rowId_projTasks = obj.map_rowId_projTasks;
        Map<Long, RowData> map_rowId_rowData = obj.map_rowId_rowData;
        
        system.debug('Sheet Wrapper Data : '+obj);
        
        updateData(new List<sheetWrapper>{obj});
    }
    
    public static void updateData(List<sheetWrapper> allSheetWrappers){
        
        system.debug('Sheet Wrapper Data Start : '+allSheetWrappers);
        
        Map<Long, Project_Milestones__c> map_rowId_MileStones = new Map<Long, Project_Milestones__c>();
        Map<Long, Project_Tasks__c> map_rowId_projTasks = new Map<Long, Project_Tasks__c>();
        
        Map<Long, Service_Project_Milestones__c> map_RowId_ServiceMileStones = new map<Long, Service_Project_Milestones__c>();
        Map<Long, Service_Project_Tasks__c> map_RowId_ServiceTasks = new map<Long, Service_Project_Tasks__c>();
        
        Map<Long, RowData> map_rowId_rowData = new Map<Long, RowData>();
        Set<Opportunity> oppts = new Set<Opportunity>();
        Set<Case> lstCases = new Set<Case>();

        Set<Id> entityIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        string entityType;
        system.debug('allSheetWrappers : '+allSheetWrappers);
        for(sheetWrapper eachSheetWrapper : allSheetWrappers) {
            //system.debug('eachSheetWrapper.percentCompleteColId : '+eachSheetWrapper.percentCompleteColId);
            //system.debug('eachSheetWrapper.allColumnIds : '+eachSheetWrapper.allColumnIds);
            if(eachSheetWrapper.entityId != NULL && eachSheetWrapper.entityType == 'Opportunity' && eachSheetWrapper.sheetId != NULL) {
                
                Opportunity opptyNew = new Opportunity(Id = eachSheetWrapper.entityId, Smartsheet_Id__c = String.valueOf(eachSheetWrapper.sheetId),
                                            Smartsheet_percent_complete_col_Index__c = eachSheetWrapper.allColumnIds.percentCompleteColId,
                                            Smartsheet_Comments_Col_Index__c = eachSheetWrapper.allColumnIds.commentsColId,
                                            SmartSheet_Url__c = eachSheetWrapper.sheetUrl);
                if(eachSheetWrapper.weeklyUpdates != NULL && eachSheetWrapper.weeklyUpdates != '') {
                    opptyNew.Weekly_Updates__c = eachSheetWrapper.weeklyUpdates;
                }
                oppts.add(opptyNew);
                                            
                                            //Smartsheet_Deadline_Col_Index__c = eachSheetWrapper.allColumnIds.deadlineColId,
                                            //Smartsheet_Duration_Col_Index__c = eachSheetWrapper.allColumnIds.durationColId,
                                            //Smartsheet_End_Date_Col_Index__c = eachSheetWrapper.allColumnIds.endDateColId,
                                            //Smartsheet_Functional_Responsibility_Col__c = eachSheetWrapper.allColumnIds.functionalResponsibilityColId,
                                            //Smartsheet_Order_Col_Index__c = eachSheetWrapper.allColumnIds.orderColId,
                                            //Smartsheet_Start_Date_Col_Index__c = eachSheetWrapper.allColumnIds.startDateColId,
                                            //Smartsheet_Task_Name_Col_Index__c = eachSheetWrapper.allColumnIds.taskNameColId,
                                          
            }
            else if(eachSheetWrapper.entityId != NULL && eachSheetWrapper.entityType == 'Case' && eachSheetWrapper.sheetId != NULL) {
                
                Case newCase = new Case(Id = eachSheetWrapper.entityId, Smartsheet_Id__c = String.valueOf(eachSheetWrapper.sheetId),
                                          Smartsheet_percent_complete_col_Index__c = eachSheetWrapper.allColumnIds.percentCompleteColId,
                                          Smartsheet_Start_Date_Col_Index__c = eachSheetWrapper.allColumnIds.startDateColId,
                                          Smartsheet_End_Date_Col_Index__c = eachSheetWrapper.allColumnIds.endDateColId,
                                          Smartsheet_Duration_Col_Index__c = eachSheetWrapper.allColumnIds.durationColId,
                                          Smartsheet_Comments_Col_Index__c = eachSheetWrapper.allColumnIds.commentsColId,
                                          SmartSheet_Url__c = eachSheetWrapper.sheetUrl);
                
                lstCases.add(newCase);
            }
            entityIds.add(eachSheetWrapper.entityId);
            map_rowId_rowData.putAll(eachSheetWrapper.map_rowId_rowData);
            if(eachSheetWrapper.entityType == 'Opportunity'){
                map_rowId_MileStones.putAll(eachSheetWrapper.map_rowId_MileStones);
                map_rowId_projTasks.putAll(eachSheetWrapper.map_rowId_projTasks); 
                oppIds.add(eachSheetWrapper.entityId);
            }
            
            else if(eachSheetWrapper.entityType == 'Case'){
                map_RowId_ServiceMileStones.putAll(eachSheetWrapper.map_rowId_Service_MileStones);
                map_RowId_ServiceTasks.putAll(eachSheetWrapper.map_rowId_ServiceTasks); 
                caseIds.add(eachSheetWrapper.entityId); 
            }     
        }
        system.debug('map_rowId_MileStones : ' + map_rowId_MileStones);
        system.debug('map_rowId_projTasks : ' + map_rowId_projTasks);
        if(oppIds.size() > 0){              
            
            Map<string, Project_Milestones__c> map_Existing_PmMilestones = new Map<string, Project_Milestones__c>();
            for(Project_Milestones__c pmM : [SELECT Id,External_ID__c,Is_Active__c FROM Project_Milestones__c WHERE Opportunity__c = : oppIds and External_ID__c != null]){
                map_Existing_PmMilestones.put(pmM.External_ID__c, pmM);
            }
            system.debug('map_Existing_PmMilestones ' + map_Existing_PmMilestones.size() );
            system.debug('map_Existing_PmMilestones ' + map_Existing_PmMilestones);
            
            set<Project_Milestones__c> finalProjactManagerMileStones = new set<Project_Milestones__c>();
            if(map_Existing_PmMilestones.size()>0){
                for(string eachRowId : map_Existing_PmMilestones.keySet()) {
                    system.debug('Each Row Id : '+eachRowId);
                    if(!map_rowId_MileStones.containsKey(long.valueOf(eachRowId))){
                        Project_Milestones__c pmM = map_Existing_PmMilestones.get(string.valueOf(eachRowId));
                        pmM.Is_Active__c = false;
                        finalProjactManagerMileStones.add(pmM);
                    }
                    else{
                        Project_Milestones__c pmMExist = map_rowId_MileStones.get(long.valueOf(eachRowId));
                        pmMExist.Is_Active__c = True;
                        finalProjactManagerMileStones.add(pmMExist);
                    }
                }
            }
            else{
                system.debug('map_rowId_MileStones' + map_rowId_MileStones);
                for(Project_Milestones__c pmM : map_rowId_MileStones.values()){
                    pmM.Is_Active__c = true;
                    finalProjactManagerMileStones.add(pmM);
                }
            }
           
				for(Long eachRowId : map_rowId_MileStones.keySet()) {
                    if(!map_Existing_PmMilestones.containsKey(String.valueOf(eachRowId)) && !finalProjactManagerMileStones.contains(map_rowId_MileStones.get(eachRowId))){
                        finalProjactManagerMileStones.add(map_rowId_MileStones.get(eachRowId));
                    }
                }
            
            
            if(finalProjactManagerMileStones.size() > 0) {
                List<Project_Milestones__c> final_PMList = new List<Project_Milestones__c>();
                final_PMList.addAll(finalProjactManagerMileStones);
                system.debug('finalProjactManagerMileStones : ' + finalProjactManagerMileStones);
                //upsert finalProjactManagerMileStones External_ID__c;
                Database.upsert(final_PMList, Project_Milestones__c.Fields.External_ID__c, false);
            }
            system.debug('Current  oppIds : ' + oppIds);
            Map<string, Project_Tasks__c> map_Existing_PMTask = new Map<string, Project_Tasks__c>();
            for(Project_Tasks__c pmt : [SELECT Id,External_ID__c,Is_Active__c FROM Project_Tasks__c WHERE Project_Milestones__r.Opportunity__c = : oppIds]){
                map_Existing_PMTask.put(pmt.External_ID__c, pmt);
            }
            system.debug('map_Existing_PMTask  :' + map_Existing_PMTask );
                   
            
            for(Long eachRowId : map_rowId_projTasks.keySet()) {
                if(map_rowId_rowData.containsKey(eachRowId) && map_rowId_MileStones.containsKey(map_rowId_rowData.get(eachRowId).parentId)) {
                    map_rowId_projTasks.get(eachRowId).Project_Milestones__c = map_rowId_MileStones.get(map_rowId_rowData.get(eachRowId).parentId).Id;
                    map_rowId_projTasks.get(eachRowId).Is_Active__c = true;
                }
                
            }
            List<Project_Tasks__c> finalProjactManagerTask = new List<Project_Tasks__c>();
            for(string eachRowId : map_Existing_PMTask.keySet()) {
                if(!map_rowId_projTasks.containsKey(long.valueOf(eachRowId))){
                    Project_Tasks__c pm = map_Existing_PMTask.get(string.valueOf(eachRowId));
                    pm.Is_Active__c = false;
                    finalProjactManagerTask.add(pm);
                }
            }
            
            if(map_rowId_projTasks.values().size() > 0) {
                system.debug('map_rowId_projTasks' + map_rowId_projTasks);
                isSmartSheetAPITransaction = true;
                finalProjactManagerTask.addAll(map_rowId_projTasks.values());
                //upsert map_rowId_projTasks.values() External_ID__c;
                //upsert finalProjactManagerTask External_ID__c;
                Database.upsert(finalProjactManagerTask, Project_Tasks__c.Fields.External_ID__c, false);
            }
            
            
        }
        else if(caseIds.size() > 0){
                        
            Map<string, Service_Project_Milestones__c> map_Existing_ServiceMilestones = new Map<string, Service_Project_Milestones__c>();
            for(Service_Project_Milestones__c cM : [SELECT Id,External_ID__c,Is_Active__c FROM Service_Project_Milestones__c WHERE Case__c = : caseIds]){
                map_Existing_ServiceMilestones.put(cM.External_ID__c, cM);
            }
            system.debug('map_Existing_ServiceMilestones ' + map_Existing_ServiceMilestones.size() );
                        
            if(map_Existing_ServiceMilestones.size()>0){
                for(string eachRowId : map_Existing_ServiceMilestones.keySet()) {
                    if(!map_RowId_ServiceMileStones.containsKey(long.valueOf(eachRowId))){
                        Service_Project_Milestones__c pmM = map_Existing_ServiceMilestones.get(string.valueOf(eachRowId));
                        pmM.Is_Active__c = false;
                        map_RowId_ServiceMileStones.put(long.valueOf(eachRowId),pmM);
                    }
                }
            }
            
            if(map_RowId_ServiceMileStones.size() > 0) {
                system.debug('map_RowId_ServiceMileStones' + map_RowId_ServiceMileStones.values());
                //upsert map_RowId_ServiceMileStones.values() External_ID__c;
                Database.upsert(map_RowId_ServiceMileStones.values(), Service_Project_Milestones__c.Fields.External_ID__c, false);
            }
            
            
            
            Map<string, Service_Project_Tasks__c> map_Existing_ServiceTask = new Map<string, Service_Project_Tasks__c>();
            for(Service_Project_Tasks__c ct : [SELECT Id,External_ID__c,Is_Active__c FROM Service_Project_Tasks__c WHERE Service_Project_Milestones__r.Case__c = : caseIds]){
                map_Existing_ServiceTask.put(ct.External_ID__c, ct);
            }
            system.debug('map_Existing_ServiceTask  :' + map_Existing_ServiceTask );
                   
            
            
            for(Long eachRowId : map_RowId_ServiceTasks.keySet()) {
                if(map_rowId_rowData.containsKey(eachRowId) && map_RowId_ServiceMileStones.containsKey(map_rowId_rowData.get(eachRowId).parentId)) {
                    map_RowId_ServiceTasks.get(eachRowId).Service_Project_Milestones__c = map_RowId_ServiceMileStones.get(map_rowId_rowData.get(eachRowId).parentId).Id;
                }
            }
            
            
            for(string eachRowId : map_Existing_ServiceTask.keySet()) {
                if(!map_RowId_ServiceTasks.containsKey(long.valueOf(eachRowId))){
                    Service_Project_Tasks__c st = map_Existing_ServiceTask.get(string.valueOf(eachRowId));
                    st.Is_Active__c = false;
                    map_RowId_ServiceTasks.put(long.valueOf(eachRowId),st);
                }
            }
            
            
            if(map_RowId_ServiceTasks.values().size() > 0) {
                system.debug('map_RowId_ServiceTasks' + map_RowId_ServiceTasks.values());
                isSmartSheetAPITransaction = true;
                //upsert map_RowId_ServiceTasks.values() External_ID__c;
                Database.upsert(map_RowId_ServiceTasks.values(), Service_Project_Tasks__c.Fields.External_ID__c, false);
            }
        
        }
        /*if(oppts.size() > 0) {
            update oppts;
        }
        
        if(lstCases.size() > 0) {
            update lstCases;
        }*/
        
        // Save Results
        Database.SaveResult[] oppSaveResults;
        Database.SaveResult[] caseSaveResults;
        Database.SaveResult[] smartSheetSaveResults;
    
        
        Map<String,string> mapSheetIdSfRecId = new Map<String,string>();
        List<Opportunity> listOppts = new List<Opportunity>();
        
        if(oppts.size() > 0) {
            isSmartsheetSyncJobContext = TRUE;
            listOppts.addAll(oppts);
            oppSaveResults = Database.update(listOppts, false); // update oppts;
            for(Opportunity opp : listOppts){
                mapSheetIdSfRecId.Put(opp.Smartsheet_Id__c,opp.Id);
            }
        }   
        List<Case> listcases = new List<Case>();
        if(lstCases.size() > 0) {
            isSmartsheetSyncJobContext = TRUE;
            listcases.addAll(lstCases);
            caseSaveResults = Database.update(listcases, false); // update lstCases;
            
            for(Case cs : listcases){
                mapSheetIdSfRecId.put(cs.Smartsheet_Id__c,cs.Id);
            }
        }       
        
        /*
        if(mapSheetIdSfRecId.size() > 0) {
            List<SmartSheet_Sync_Details__c> lstSmartSheets = new List<SmartSheet_Sync_Details__c>();
            
            for(string str : mapSheetIdSfRecId.keySet()){
                lstSmartSheets.add(new SmartSheet_Sync_Details__c(Smartsheet_Id__c = str,Is_Synced__c  = true,Opportunity_Id__c = mapSheetIdSfRecId.get(str)));
            }
            
            if(lstSmartSheets.size() > 0) {
                upsert lstSmartSheets Smartsheet_Id__c;
            }
        }
        */

        List<SmartSheet_Exceptions__c> lstOppErrors = new List<SmartSheet_Exceptions__c>();
        Integer i = 0;
        if (oppSaveResults != null) {
            for (Database.SaveResult sr : oppSaveResults) {
                if (!sr.isSuccess()) {
                    Opportunity opp = listOppts[i];
                    
                    for(Database.Error err : sr.getErrors()){
                        lstOppErrors.add(new SmartSheet_Exceptions__c(Opportunity__c =opp.Id, Error_Message__c = err.getMessage()  + ' -- '+err.getMessage() + ' -- ' + err.getFields(), Milestone_Task_Name__c = '' , SmartSheet_Id__c = opp.Smartsheet_Id__c ,SmartSheet_Name__c= opp.SmartSheet_Url__c, Source__c='SmartSheetUtil.updateData'));
                    }
                }
                ++i;
            }
        }
        
        if(lstOppErrors.size()>0){
            insert lstOppErrors;
        } 
    }

    public static void logSmartsheetException(Exception e, Long sheetId) {

        string sheetName = '';
        if(mapSheetDetails.containsKey(sheetId)){
            sheetName = mapSheetDetails.get(sheetId).name;
        }

        allExceptions.add(new SmartSheet_Exceptions__c(Error_Message__c = e.getMessage() + ' - ' + e.getLineNumber() + ' - '  + e.getCause() , 
                                            SmartSheet_Id__c = string.valueOf(sheetId), SmartSheet_Name__c= sheetName, External_Id__c = string.valueOf(sheetId)));
    }

    public static void logSmartsheetException(Exception e, Long sheetId, String mileStone_TaskName, Long rowId, Long columnId) {

        string sheetName = '';
        if(mapSheetDetails.containsKey(sheetId)){
            sheetName = mapSheetDetails.get(sheetId).name;
        }

        allExceptions.add(new SmartSheet_Exceptions__c(Error_Message__c = e.getMessage() + ' - ' + e.getLineNumber() + ' - '  + e.getCause() , 
                                            SmartSheet_Id__c = string.valueOf(sheetId), SmartSheet_Name__c= sheetName,
                                            Milestone_Task_Name__c = mileStone_TaskName, 
                                            External_Id__c = string.valueOf(sheetId) + '-' + string.valueOf(rowId) + '-' + string.valueOf(columnId)));
    }

    public static void logSmartsheetException(String errMsg, Long sheetId, String mileStone_TaskName, Long rowId, Long columnId) {

        string sheetName = '';
        if(mapSheetDetails.containsKey(sheetId)){
            sheetName = mapSheetDetails.get(sheetId).name;
        }

        allExceptions.add(new SmartSheet_Exceptions__c(Error_Message__c = errMsg, 
                                            SmartSheet_Id__c = string.valueOf(sheetId), SmartSheet_Name__c= sheetName,
                                            Milestone_Task_Name__c = mileStone_TaskName, 
                                            External_Id__c = string.valueOf(sheetId) + '-' + string.valueOf(rowId) + '-' + string.valueOf(columnId)));
    }
    
    public static sheetWrapper getSmartSheetMilestoneAndTasks(Long sheetId) {
        system.debug('Source sheetId:' + sheetId);
        Smartsheet.Sheet sheetInfo;
        try{
            sheetInfo = ssAPI.getSheet(sheetId);
        }
        catch(exception ex){
            
            //opportunity opp = [SELECT Id,Smartsheet_Id__c,SmartSheet_Url__c FROM opportunity WHERE Smartsheet_Id__c =: strSheetId ];
            //insert new SmartSheet_Exceptions__c(Opportunity__c = null, Error_Message__c = ex.getMessage() + ' -- '+ex.getLineNumber() + ' -- ' + ex.getCause(), Milestone_Task_Name__c = '' , SmartSheet_Id__c = string.valueOf(sheetId) ,SmartSheet_Name__c= sheetName);
            logSmartsheetException(ex, sheetId);
            return NULL;
        }

        if(!mapSheetDetails.containsKey(sheetId)){
            Smartsheet.SheetsHeader sh = new Smartsheet.SheetsHeader();
            sh.id = sheetId;
            sh.name = sheetInfo.name;
            mapSheetDetails.put(sheetId, sh);  
        }
        
        //system.debug('Source Info:' + sheetInfo.source);
        
        Map<Long, Smartsheet.Column> map_ColId_Col = new Map<Long, Smartsheet.Column>();
        Map<Long, Smartsheet.Row> map_RowId_Row = new Map<Long, Smartsheet.Row>();
        ColumnIds cData = new ColumnIds();
        for(Smartsheet.Column eachColumn : sheetInfo.columns) {
            map_ColId_Col.put(eachColumn.id, eachColumn);
            system.debug('Each Column Title : '+ eachColumn.title);
            system.debug('Each Column Index: '+ String.valueOf(eachColumn.id));
            
            if(eachColumn.title == '% Complete') {cData.percentCompleteColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Opportunity Milestones') { cData.taskNameColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Decommissioning MileStone') { cData.taskNameColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'IGU RMA MileStone') { cData.taskNameColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'IGU Troubleshooting MileStone') { cData.taskNameColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Mitigation Dispatch MileStone') { cData.taskNameColId = String.valueOf(eachColumn.id);}         
            if(eachColumn.title == 'CSS Replacement MileStone') { cData.taskNameColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Duration') {cData.durationColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Comments') {cData.commentsColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Functional Responsibility') {cData.functionalResponsibilityColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Order') {cData.orderColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Deadline') {cData.deadlineColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Start Date') {cData.startDateColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'End Date') {cData.endDateColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'Start') {cData.startDateColId = String.valueOf(eachColumn.id);}
            if(eachColumn.title == 'End') {cData.endDateColId = String.valueOf(eachColumn.id);}
        }
        system.debug('cData : '+cData);
        
        for(Smartsheet.Row eachRow : sheetInfo.rows) {
            map_RowId_Row.put(eachRow.id, eachRow);
        }
        
        Map<Long, Integer> map_ColId_ColIndex = new Map<Long, Integer>();
        for(Long eachColId : map_ColId_Col.keySet())
            map_ColId_ColIndex.put(eachColId, map_ColId_Col.get(eachColId).index);
        
        Long entityRowId;
        string entityType;
        Map<Long, Project_Milestones__c> map_rowId_MileStones = new map<Long, Project_Milestones__c>();
        Map<Long, Project_Tasks__c> map_rowId_projTasks = new map<Long, Project_Tasks__c>();
        
        Map<Long, Service_Project_Milestones__c> map_RowId_ServiceMileStones = new map<Long, Service_Project_Milestones__c>();
        Map<Long, Service_Project_Tasks__c> map_RowId_ServiceTasks = new map<Long, Service_Project_Tasks__c>();
        
        Map<Long, RowData> map_rowId_rowData = new map<Long, RowData>();
        
        Map<string,SmartSheet_Column_Index__mdt> mapSmartSheetColumnIndexes = new Map<string,SmartSheet_Column_Index__mdt>();
        for(SmartSheet_Column_Index__mdt coumnIndexes : [SELECT  DeveloperName, ASSIGNED_TO__c, COMMENTS__c, DEADLINE__c, DURATION__c, END_DATE__c, FUNC_RESPONSIBILITY__c, MILESTONE__c,Object_ID__c, Object_Name__c ,ORDER__c, PERCENT_COMPLETE__c, PREDECESSORS__c, ROW_TYPE__c, START_DATE__c FROM SmartSheet_Column_Index__mdt]){
            mapSmartSheetColumnIndexes.put(coumnIndexes.Object_Name__c, coumnIndexes);
        }
        system.debug('SmartSheet_Column_Index__mdt'+mapSmartSheetColumnIndexes);
        List<SmartSheet_Exceptions__c> lstRowErrorsAll = new List<SmartSheet_Exceptions__c>();
        for(Long eachRowID : map_RowId_Row.keySet()) {
            Smartsheet.Row thisRow = map_RowId_Row.get(eachRowID);            
            
            RowData rData = new RowData();
            rData.rowId = thisRow.id;
            rData.parentId = thisRow.parentId;
            
            Boolean isOppRow = false;
            Boolean isCaseRow = false;
            Boolean isMilestoneRow = false;
            Boolean isTaskRow = false;
            Boolean hasEntityIDReference = false;            
            
            String percentCompleteColId;
            String commentsColId;
            String deadlineColId;
            String durationColId;
            String endDateColId;
            String functionalResponsibilityColId;
            String orderColId;
            String startDateColId;
            String taskNameColId;
            
            //List<SmartSheet_Exceptions__c> lstRowErrors = new List<SmartSheet_Exceptions__c>();
            List<Exception> rowExceptions = new List<Exception>();
            Map<Exception, Long> map_exception_colId = new Map<Exception, Long>();
            Boolean assignedToFieldValid = true;
            Long assignedToColId;
            for(Smartsheet.Cell eachCell : thisRow.cells) {                
                if(eachCell.columnId != NULL && map_ColId_Col.containsKey(eachCell.columnId)
                   && eachCell.value != NULL) {                       
                       system.debug('entityRowId : '+ entityRowId);
                       if(entityRowId == NULL) {
                           
                           SmartSheet_Column_Index__mdt objectSmartSheet = new SmartSheet_Column_Index__mdt();
                           if(map_ColId_Col.get(eachCell.columnId).title == 'Opportunity ID'){
                               objectSmartSheet = mapSmartSheetColumnIndexes.get('Opportunity');
                           }
                           if(map_ColId_Col.get(eachCell.columnId).title == 'Case ID'){
                               objectSmartSheet = mapSmartSheetColumnIndexes.get('Case');
                           }
                           
                           //system.debug('objectSmartSheet : '+ objectSmartSheet);
                           //system.debug('Each Column Index : '+ map_ColId_Col.get(eachCell.columnId).index);
                           //system.debug('Column Data : '+ map_ColId_Col.get(eachCell.columnId));
                           //system.debug('Column Title Each : '+ map_ColId_Col.get(eachCell.columnId).title);
                           //system.debug('entityRowId : '+ entityRowId);
                           //system.debug('eachCell : '+ eachCell.value);
                           
                           if(map_ColId_Col.get(eachCell.columnId).title == 'Opportunity ID') {
                               //system.debug('Opp Prefix : '+ eachCell.value.substring(0,3));
                               rData.entityId = eachCell.value; 
                               if( thisRow.parentId != NULL) {
                                isOppRow = false;
                                hasEntityIDReference = true;
                                //system.debug('eachCell Secound Row '+ eachCell.value);
                               }
                               else { 
                                isOppRow = true; 
                                system.debug('eachCell First Row : '+ eachCell.value);
                               }
                               entityType = 'Opportunity';
                           }
                           
                           else if( map_ColId_Col.get(eachCell.columnId).title == 'Case ID #') {           
                               //System.debug('Case Prefix : '+ eachCell.value.substring(0,3));
                               rData.entityId = eachCell.value; 
                               if( thisRow.parentId != NULL) { 
                                    isCaseRow = false; 
                                    hasEntityIDReference = true;
                               }
                               else { isCaseRow = true; }
                               entityType = 'Case';
                           }
                       }
                       system.debug('Cell Title'+map_ColId_Col.get(eachCell.columnId).title);
                       system.debug('Cell Title'+eachCell.value);
                       if(map_ColId_Col.get(eachCell.columnId).title == 'CSS Troubleshooting/Replacement Milestone') {rData.name = eachCell.value;} 
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Decommissioning Milestone') {rData.name = eachCell.value;} 
                       if(map_ColId_Col.get(eachCell.columnId).title == 'IGU RMA Milestone') {rData.name = eachCell.value;} 
                       if(map_ColId_Col.get(eachCell.columnId).title == 'IGU Troubleshooting Milestone') {rData.name = eachCell.value;} 
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Mitigation Dispatch Milestone') {rData.name = eachCell.value;} 
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Support Milestone') {rData.name = eachCell.value;} 
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Opportunity Milestones') {rData.name = eachCell.value;}        
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Duration') {rData.duration = eachCell.value;}
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Comments') {rData.comments = eachCell.value;}
                       //if(map_ColId_Col.get(eachCell.columnId).title == 'Assigned To') {rData.assignedTo = eachCell.value;}
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Functional Responsibility') {rData.funcResponsibility = eachCell.value;}
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Order') {rData.order = eachCell.value;}
                       if(map_ColId_Col.get(eachCell.columnId).title == 'Deadline') {rData.deadline = Date.valueOf(eachCell.value);}
                       
                       /*if(map_ColId_Col.get(eachCell.columnId).title == 'Start Date') {rData.startDate = Date.valueOf(eachCell.value);}
                       if(map_ColId_Col.get(eachCell.columnId).title == 'End Date') {rData.endDate = Date.valueOf(eachCell.value);}
                       if(map_ColId_Col.get(eachCell.columnId).title == '% Complete') {
                           rData.percentComplete = Decimal.valueOf(eachCell.value) * 100; 
                           rData.percentCompleteColId = String.valueOf(eachCell.columnId);
                       }*/
						
                        if(map_ColId_Col.get(eachCell.columnId).title == 'Assigned To') {
                            if(eachCell.value == '') {
                                rData.assignedTo = eachCell.value;
                            }else {
                                String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
                                Pattern MyPattern = Pattern.compile(emailRegex);
                                Matcher MyMatcher = MyPattern.matcher(eachCell.value);

                                if (MyMatcher.matches()) {
                                    rData.assignedTo = eachCell.value;
                                }else{
                                    assignedToFieldValid = false;
                                    assignedToColId = eachCell.columnId;
                                }
                            }
                        }                        
                           
                       try{
                           if(map_ColId_Col.get(eachCell.columnId).title == 'Start Date') {rData.startDate = Date.valueOf(eachCell.value);}
                           if(map_ColId_Col.get(eachCell.columnId).title == 'Start') {rData.startDate = Date.valueOf(eachCell.value);}    
                       }
                       catch(exception ex){
                           if(entityRowId != NULL) {rowExceptions.add(ex); map_exception_colId.put(ex, eachCell.columnId);}
                           //lstRowErrors.add(new SmartSheet_Exceptions__c(Opportunity__c = rData.entityId, Error_Message__c = ex.getMessage() + ' -- ' + ex.getCause() + ' -- '+ex.getLineNumber(), Milestone_Task_Name__c = 'Start Date - ' + eachCell.columnId +' - '+ eachCell.value, SmartSheet_Id__c = string.valueOf(sheetInfo.Id) ,SmartSheet_Name__c= sheetInfo.name, Source__c='SmartSheetUtil.getSmartSheetMilestoneAndTasks'));
        
                       }
                       try{
                           if(map_ColId_Col.get(eachCell.columnId).title == 'End Date') {rData.endDate = Date.valueOf(eachCell.value);}
                           if(map_ColId_Col.get(eachCell.columnId).title == 'End') {rData.endDate = Date.valueOf(eachCell.value);}
                       }
                       catch(exception ex){
                           if(entityRowId != NULL) {rowExceptions.add(ex); map_exception_colId.put(ex, eachCell.columnId);}
                           //lstRowErrors.add(new SmartSheet_Exceptions__c(Opportunity__c = rData.entityId, Error_Message__c = ex.getMessage() + ' -- ' + ex.getCause() + ' -- '+ex.getLineNumber(), Milestone_Task_Name__c =  'End Date - ' + eachCell.columnId +' - '+ eachCell.value , SmartSheet_Id__c = string.valueOf(sheetInfo.Id) ,SmartSheet_Name__c= sheetInfo.name, Source__c='SmartSheetUtil.getSmartSheetMilestoneAndTasks'));
        
                       }
                       try{
                            
                            if(map_ColId_Col.get(eachCell.columnId).title == '% Complete') {
                               system.debug('Column Title : '+ map_ColId_Col.get(eachCell.columnId).title);
                               rData.percentComplete = Decimal.valueOf(eachCell.value) * 100; 
                               //rData.percentCompleteColId = String.valueOf(eachCell.columnId);
                           }
                       }
                       catch(exception ex){
                           if(entityRowId != NULL) {rowExceptions.add(ex); map_exception_colId.put(ex, eachCell.columnId);}
                           //lstRowErrors.add(new SmartSheet_Exceptions__c(Opportunity__c = rData.entityId, Error_Message__c = ex.getMessage() + ' -- ' + ex.getCause() + ' -- '+ex.getLineNumber(), Milestone_Task_Name__c =  '% Complete - ' + eachCell.columnId +' - '+ eachCell.value , SmartSheet_Id__c = string.valueOf(sheetInfo.Id) ,SmartSheet_Name__c= sheetInfo.name, Source__c='SmartSheetUtil.getSmartSheetMilestoneAndTasks'));
                       }
                       
                      
                   }
            }
            system.debug('rData.entityId : '+ rData.entityId); 
            system.debug('isOppRow : '+ isOppRow);  
            system.debug('isCaseRow : '+ isCaseRow);    

            if(hasEntityIDReference) { 
                entityRowId = rData.parentId;

                if(map_RowId_Row.containsKey(entityRowId)) {
                    Smartsheet.Row oppRow = map_RowId_Row.get(entityRowId);
                    RowData oppRowData = new RowData();
                    oppRowData.rowId = oppRow.id;
                    oppRowData.entityId = rData.entityId;                   
                    for(Smartsheet.Cell eachCell : oppRow.cells) {
                        if(eachCell.columnId != NULL && map_ColId_Col.containsKey(eachCell.columnId)
                           && eachCell.value != NULL) { 
                                if( map_ColId_Col.get(eachCell.columnId).index == INDEX_COMMENTS ) {oppRowData.comments = eachCell.value;}
                           }
                    }

                    map_rowId_rowData.put(oppRowData.rowId, oppRowData); 
                }
            }
            
            if(isOppRow || isCaseRow ) {entityRowId = rData.rowId;}
            else if(entityRowId != NULL && rData.parentId == entityRowId && rData.name != '') {
                isMilestoneRow = true;
                system.debug('entityType : '+ entityType);
                system.debug('rData.rowId : '+ rData.rowId);
                if(entityType == 'Opportunity'){    
                    system.debug('Opp MileStones : '+ rData.entityId);    
                    map_rowId_MileStones.put(rData.rowId, new Project_Milestones__c(Name__c = rData.name, External_ID__c = String.valueOf(rData.rowId),
                                                                                           Percent_Complete__c = rData.percentComplete, Comments__c = rData.comments, End_Date__c = rData.endDate, Deadline__c = rData.deadline,
                                                                                           Start_Date__c = rData.startDate, Duration__c = rData.duration, Functional_Responsibility__c = rData.funcResponsibility,
                                                                                           Order__c = rData.order, Opportunity__c = map_rowId_rowData.get(entityRowId).entityId, Assigned_To_email__c = rData.assignedTo, Is_Active__c = True));
                    system.debug('Opp MileStones Map : '+ map_rowId_MileStones);                                                                       
                } else if(entityType == 'Case'){   
                    system.debug('Case rData.rowId MileStones : '+ rData.rowId);
                    map_RowId_ServiceMileStones.put(rData.rowId, new Service_Project_Milestones__c(Name__c = rData.name, External_ID__c = String.valueOf(rData.rowId),
                                                                                          Percent_Complete__c = rData.percentComplete, Comments__c = rData.comments, End_Date__c = rData.endDate, Deadline__c = rData.deadline,
                                                                                          Start_Date__c = rData.startDate, Duration__c = rData.duration, Functional_Responsibility__c = rData.funcResponsibility,
                                                                                          Order__c = rData.order, Case__c = map_rowId_rowData.get(entityRowId).entityId, Assigned_To_email__c = rData.assignedTo, Is_Active__c = True));
                  system.debug('Case map_RowId_ServiceMileStones : '+ map_RowId_ServiceMileStones);
                }
            }
            else if(rData.parentId != NULL && rData.name != '' && (map_rowId_MileStones.containsKey(rData.parentId) || map_RowId_ServiceMileStones.containsKey(rData.parentId))) {
                isTaskRow = true;
                system.debug('rowId Tasks: '+ rData.parentId);
                if(entityType == 'Opportunity'){    
                    system.debug('Opp MileStones Task Map : '+ map_rowId_MileStones);               
                    map_rowId_projTasks.put(rData.rowId, new Project_Tasks__c(Task_Name__c = rData.name, Comments__c = rData.comments, End_Date__c = rData.endDate, 
                                                                                     Deadline__c = rData.deadline,Percent_Complete__c = rData.percentComplete, Start_Date__c = rData.startDate, External_ID__c = String.valueOf(rData.rowId),Duration__c = rData.duration, Functional_Responsibility__c = rData.funcResponsibility,Order__c = rData.order, Assigned_To_Email__c = rData.assignedTo, Is_Active__c = True));
                } else if(entityType == 'Case'){   
                    system.debug('Case rData.rowId Tasks: '+ rData.rowId);
                    map_RowId_ServiceTasks.put(rData.rowId, new Service_Project_Tasks__c(Task_Name__c = rData.name, Comments__c = rData.comments, End_Date__c = rData.endDate, 
                                                                                Deadline__c = rData.deadline,Percent_Complete__c = rData.percentComplete, Start_Date__c = rData.startDate, External_ID__c = String.valueOf(rData.rowId),Duration__c = rData.duration, Functional_Responsibility__c = rData.funcResponsibility,Order__c = rData.order, Assigned_To_Email__c = rData.assignedTo, Is_Active__c = True));
                                                                                
                    system.debug('Case map_RowId_ServiceTasks : '+ map_RowId_ServiceTasks);                                         
                }
            }
            
            if((isOppRow || isCaseRow || isMilestoneRow || isTaskRow)){
                //lstRowErrorsAll.addAll(lstRowErrors);
                map_rowId_rowData.put(rData.rowId, rData);  
                for(Exception e : rowExceptions) {
                    Long errorColId;
                    if(map_exception_colId.containsKey(e))
                        errorColId = map_exception_colId.get(e);
                    logSmartsheetException(e, sheetInfo.Id, rData.name, rData.rowId, errorColId);
                }
                if(!assignedToFieldValid) {
                    logSmartsheetException('Invalid Email in Assigned To column', sheetInfo.Id, rData.name, 
                                            rData.rowId, assignedToColId);
                } 
            }
                     
            
        }
        system.debug('Opp map_rowId_MileStones : '+ lstRowErrorsAll);
        if(lstRowErrorsAll.size() > 0){
            insert lstRowErrorsAll;
        }
        system.debug('Opp map_rowId_MileStones : '+ map_rowId_MileStones.size());  
        system.debug('Opp map_rowId_projTasks : '+ map_rowId_projTasks.size());
        
        system.debug('Case map_RowId_ServiceTasks : '+ map_RowId_ServiceTasks.size());  
        system.debug('Case map_RowId_ServiceMileStones : '+ map_RowId_ServiceMileStones.size());
        
        
        if(entityRowId != NULL && map_rowId_rowData.containsKey(entityRowId) && (map_rowId_MileStones.values().size() > 0 || map_RowId_ServiceMileStones.values().size() > 0)
           && (map_rowId_projTasks.values().size() > 0 || map_RowId_ServiceTasks.values().size() > 0)) {
               sheetWrapper oppWrapperObj = new sheetWrapper(map_rowId_rowData.get(entityRowId).entityId,entityType,sheetInfo.permalink, sheetId,
                map_rowId_rowData.get(entityRowId).percentCompleteColId, map_rowId_rowData.get(entityRowId).comments, map_rowId_MileStones,
                 map_rowId_projTasks,map_RowId_ServiceMileStones,map_RowId_ServiceTasks,map_rowId_rowData,cData);
               system.debug('Final Smart Sheet Info'+oppWrapperObj);
               
               return oppWrapperObj;
           }
        
        return null;
    }
    
    public static void assignOwners(List<Project_Milestones__c> projMilestones) {
        
        List<String> assignedToEmails = new List<String>();
        List<Project_Milestones__c> Pm_IdswithoutEmail = new List<Project_Milestones__c>();
        set<Id> oppId = new Set<Id>();
        Map<Id,opportunity> Opportuntymap = new Map<Id,opportunity>();
        
        for(Project_Milestones__c eachMilestone : projMilestones){
            oppId.add(eachMilestone.Opportunity__c);
            if(eachMilestone.Assigned_To_Email__c != NULL){
                assignedToEmails.add(eachMilestone.Assigned_To_Email__c);
            }
        }
         
        for(opportunity oppReord : [Select id, Project_Manager__c,CSM_Project_Manager__c from opportunity where opportunity.Id =:oppId]){
            
            Opportuntymap.put(oppReord.Id, oppReord);
        }
        Smartsheet_Config__c config = Smartsheet_Config__c.getOrgDefaults();
        Id adminUserId;
        if(config != NULL && config.Salesforce_Admin_Id__c != NULL) {
            adminUserId = Id.valueOf(config.Salesforce_Admin_Id__c);
        }else{
            adminUserId = UserInfo.getUserId();
        }
        
        user JdAdminuser =[select Id, Name from user Where Id = :adminUserId Limit 1];
        Group queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Customer Support Queue' limit 1];

        Map<String, User> map_email_user = new Map<String, User>();
        for(User u : [SELECT Id, Email FROM User WHERE Email IN :assignedToEmails])
            map_email_user.put(u.email, u);
        
        for(Project_Milestones__c eachMilestone : projMilestones){
            if(eachMilestone.Assigned_To_Email__c != NULL && map_email_user.containsKey(eachMilestone.Assigned_To_Email__c)){
                
                eachMilestone.OwnerId = map_email_user.get(eachMilestone.Assigned_To_Email__c).Id;
            }else{
                if(eachMilestone.Functional_Responsibility__c == 'PM' && Opportuntymap.containsKey(eachMilestone.Opportunity__c) && Opportuntymap.get(eachMilestone.Opportunity__c).Project_Manager__c != Null){
                    eachMilestone.OwnerId = Opportuntymap.get(eachMilestone.Opportunity__c).Project_Manager__c;
                }else if(eachMilestone.Functional_Responsibility__c == 'CSM' && Opportuntymap.containsKey(eachMilestone.Opportunity__c) && Opportuntymap.get(eachMilestone.Opportunity__c).CSM_Project_Manager__c != Null){
                    eachMilestone.OwnerId = Opportuntymap.get(eachMilestone.Opportunity__c).CSM_Project_Manager__c;
                }else if(eachMilestone.Functional_Responsibility__c == 'Site Ops' || eachMilestone.Functional_Responsibility__c == 'Customer Support'){
                    eachMilestone.OwnerId = queueId.Id;
                }else{
                    eachMilestone.OwnerId = JdAdminuser.Id;
                }
            }
        }
    }
    
    public static void assignOwners(List<Project_Tasks__c> projTasks) {
        
        List<String> assignedToEmails = new List<String>();
        List<Project_Tasks__c> task_withoutEmail = new List<Project_Tasks__c>();
        set<Id> milestoneIds = new Set<Id>();
        Map<Id,Project_Milestones__c> Pm_recordsmap = new Map<Id,Project_Milestones__c>();
        
        for(Project_Tasks__c eachprjTask : projTasks){
            milestoneIds.add(eachprjTask.Project_Milestones__c);
            if(eachprjTask.Assigned_To_Email__c != NULL){
            	assignedToEmails.add(eachprjTask.Assigned_To_Email__c);
        	}
        }
        
        system.debug('oppids'+milestoneIds);
        for(Project_Milestones__c pm_Rec : [Select id,Opportunity__r.Project_Manager__c,Opportunity__r.CSM_Project_Manager__c from Project_Milestones__c where Project_Milestones__c.Id =:milestoneIds ]){
       
            Pm_recordsmap.put(pm_Rec.Id, pm_Rec);
        }
        
        Smartsheet_Config__c config = Smartsheet_Config__c.getOrgDefaults();
        Id adminUserId;
        if(config != NULL && config.Salesforce_Admin_Id__c != NULL) {
            adminUserId = Id.valueOf(config.Salesforce_Admin_Id__c);
        }else{
            adminUserId = UserInfo.getUserId();
        }
        
        user JdAdminuser =[select Id, Name from user Where Id = :adminUserId Limit 1];
        Group queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Customer Support Queue' limit 1];
        
        Map<String, User> map_email_user = new Map<String, User>();
        for(User u : [SELECT Id, Email FROM User WHERE Email IN :assignedToEmails])
            map_email_user.put(u.email, u);
        
        for(Project_Tasks__c eachprjTask : projTasks)
            if(eachprjTask.Assigned_To_Email__c != NULL && map_email_user.containsKey(eachprjTask.Assigned_To_Email__c)){
                
                eachprjTask.OwnerId = map_email_user.get(eachprjTask.Assigned_To_Email__c).Id;
                
            }else{
                if(eachprjTask.Functional_Responsibility__c == 'PM' && Pm_recordsmap.containsKey(eachprjTask.Project_Milestones__c) && Pm_recordsmap.get(eachprjTask.Project_Milestones__c).Opportunity__r.Project_Manager__c != Null){
                    eachprjTask.OwnerId = Pm_recordsmap.get(eachprjTask.Project_Milestones__c).Opportunity__r.Project_Manager__c;
                }else if(eachprjTask.Functional_Responsibility__c == 'CSM' && Pm_recordsmap.containsKey(eachprjTask.Project_Milestones__c) && Pm_recordsmap.get(eachprjTask.Project_Milestones__c).Opportunity__r.CSM_Project_Manager__c != Null ){
                    eachprjTask.OwnerId = Pm_recordsmap.get(eachprjTask.Project_Milestones__c).Opportunity__r.CSM_Project_Manager__c;
                }else if(eachprjTask.Functional_Responsibility__c == 'Site Ops' || eachprjTask.Functional_Responsibility__c == 'Customer Support'){
                    eachprjTask.OwnerId = queueId.Id;
                }else {
                    eachprjTask.OwnerId = JdAdminuser.Id;
                }
            }
        
    }
    
    public static void assignOwners(List<Service_Project_Milestones__c> serviceMilestones) {
        
        List<String> assignedToEmails = new List<String>();
        
        for(Service_Project_Milestones__c eachMilestone : serviceMilestones)
            if(eachMilestone.Assigned_To_Email__c != NULL)
            assignedToEmails.add(eachMilestone.Assigned_To_Email__c);
        
        user userSteve = [select Id, Name from user Where Name = 'Steve Shea' Limit 1];
        Map<String, User> map_email_user = new Map<String, User>();
        for(User u : [SELECT Id, Email FROM User WHERE Email IN :assignedToEmails])
            map_email_user.put(u.email, u);
        
        for(Service_Project_Milestones__c eachServiceTask : serviceMilestones)
            if(eachServiceTask.Assigned_To_Email__c != NULL && map_email_user.containsKey(eachServiceTask.Assigned_To_Email__c)){
            	eachServiceTask.OwnerId = map_email_user.get(eachServiceTask.Assigned_To_Email__c).Id;
            }else{
                eachServiceTask.OwnerId = userSteve.Id;
            }
    }
    
    
    public static void assignOwners(List<Service_Project_Tasks__c> serviceTasks) {
        
        List<String> assignedToEmails = new List<String>();
        
        for(Service_Project_Tasks__c eachprjTask : serviceTasks)
            if(eachprjTask.Assigned_To_Email__c != NULL)
            assignedToEmails.add(eachprjTask.Assigned_To_Email__c);
        
        user userSteve = [select Id, Name from user Where Name = 'Steve Shea' Limit 1];
        Map<String, User> map_email_user = new Map<String, User>();
        for(User u : [SELECT Id,Name, Email FROM User WHERE Email IN :assignedToEmails])
            map_email_user.put(u.email, u);
        
        for(Service_Project_Tasks__c eachServiceTask : serviceTasks)
            if(eachServiceTask.Assigned_To_Email__c != NULL && map_email_user.containsKey(eachServiceTask.Assigned_To_Email__c)){
            	eachServiceTask.OwnerId = map_email_user.get(eachServiceTask.Assigned_To_Email__c).Id;
                system.debug('User Name:'+map_email_user.get(eachServiceTask.Assigned_To_Email__c).Name);
            }else{
                eachServiceTask.OwnerId = userSteve.Id;
                system.debug('Steve User : '+  userSteve.Name);
            }
    }
    
    
    @future(callout=true)
    public static void syncServiceTasksAsync(List<Id> serviceTaskIds) {
        syncServiceTasks(serviceTaskIds);
    }
    

    public static void syncServiceTasks(List<Id> serviceTaskIds) {
      
    }
    
    @future(callout=true)
    public static void syncProjectTasksAsync(List<Id> projTaskIds) {
        syncProjectTasks(projTaskIds);
    }
    
    @InvocableMethod(label='Update Project Task' description='Update the list of project tasksto the specified task IDs.')
    public static void projectTasksSync(List<Id> ids) {
        system.debug('Project Task Ids : '+ids);
        //syncProjectTasksAsync(ids);
    }
     
    public static Smartsheet.RowsResult syncProjectTasks(Project_Tasks__c projTask) {     
        Smartsheet.UpdateRequestRow row = new Smartsheet.UpdateRequestRow();
        row.id = Long.valueOf(projTask.External_ID__c);
        
        Smartsheet.UpdateRequestCell_Dec percentagecell = new Smartsheet.UpdateRequestCell_Dec();
        percentagecell.columnId = Long.valueOf(projTask.Project_Milestones__r.Opportunity__r.Smartsheet_percent_complete_col_Index__c);
        percentagecell.value = (projTask.Percent_Complete__c != null ? projTask.Percent_Complete__c : 0)/100;
        Smartsheet.UpdateRequest uRPercentageCell = percentagecell;  
        
        Smartsheet.UpdateRequestCell_Str comentcell = new Smartsheet.UpdateRequestCell_Str();
        comentcell.columnId = Long.valueOf(projTask.Project_Milestones__r.Opportunity__r.Smartsheet_Comments_Col_Index__c);
        comentcell.value = (!String.isBlank(projTask.Comments__c)? projTask.Comments__c : null);
        Smartsheet.UpdateRequest uRcomentCell = comentcell;  
        
        row.cells = new List<Smartsheet.UpdateRequest>{uRPercentageCell,uRcomentCell};     
        
        return ssAPI.updateRows(long.valueOf(projTask.Project_Milestones__r.Opportunity__r.Smartsheet_Id__c), new List<Smartsheet.UpdateRequestRow>{row});        
    }
    
    public static Smartsheet.RowsResult syncServiceProjectTasks(Service_Project_Tasks__c serviceProjTask, Service_Project_Tasks__c oldSPTask ) { 
        List<Smartsheet.UpdateRequest> updateReq = new List<Smartsheet.UpdateRequest>();    
        Smartsheet.UpdateRequestRow row = new Smartsheet.UpdateRequestRow();
        row.id = Long.valueOf(serviceProjTask.External_ID__c);
        
        if(serviceProjTask.Percent_Complete__c != null){
            Smartsheet.UpdateRequestCell_Dec cell = new Smartsheet.UpdateRequestCell_Dec();
            cell.columnId = Long.valueOf(serviceProjTask.Service_Project_Milestones__r.Case__r.Smartsheet_percent_complete_col_Index__c);
            cell.value = (serviceProjTask.Percent_Complete__c != null ? serviceProjTask.Percent_Complete__c : 0)/100;
            Smartsheet.UpdateRequest uRCell = cell;   
            updateReq.add(uRCell);
        }
        
        if(serviceProjTask.Duration__c != '' && serviceProjTask.Duration__c != oldSPTask.Duration__c && serviceProjTask.Start_Date__c != null &&
          serviceProjTask.Start_Date__c != oldSPTask.Start_Date__c ){          
            Smartsheet.UpdateRequestCell_Str cellDu = new Smartsheet.UpdateRequestCell_Str();            
            cellDu.columnId = Long.valueOf(serviceProjTask.Service_Project_Milestones__r.Case__r.Smartsheet_Duration_Col_Index__c);
            cellDu.value = serviceProjTask.Duration__c;            
            Smartsheet.UpdateRequest uRCellDue = cellDu;      
            system.debug('uRCellDue : '+uRCellDue );   
            updateReq.add(uRCellDue);
        
            Smartsheet.UpdateRequestCell_Dt cellStdDate = new Smartsheet.UpdateRequestCell_Dt();            
            cellStdDate.columnId = Long.valueOf(serviceProjTask.Service_Project_Milestones__r.Case__r.Smartsheet_Start_Date_Col_Index__c);
            cellStdDate.value = serviceProjTask.Start_Date__c;   
            Smartsheet.UpdateRequest uRCellStdDate = cellStdDate; 
            system.debug('uRCellStdDate : '+uRCellStdDate );
            updateReq.add(uRCellStdDate);           
        }
        
        if(serviceProjTask.Start_Date__c != null && serviceProjTask.Start_Date__c != oldSPTask.Start_Date__c && serviceProjTask.Duration__c == oldSPTask.Duration__c){
            Smartsheet.UpdateRequestCell_Dt cellStdDate = new Smartsheet.UpdateRequestCell_Dt();            
            cellStdDate.columnId = Long.valueOf(serviceProjTask.Service_Project_Milestones__r.Case__r.Smartsheet_Start_Date_Col_Index__c);
            cellStdDate.value = serviceProjTask.Start_Date__c;   
            Smartsheet.UpdateRequest uRCellStdDate = cellStdDate; 
            system.debug('uRCellStdDate : '+uRCellStdDate );
            updateReq.add(uRCellStdDate); 
			}
      
        if(serviceProjTask.Duration__c != '' && serviceProjTask.Duration__c != oldSPTask.Duration__c && 
           serviceProjTask.Start_Date__c == oldSPTask.Start_Date__c ){
            Smartsheet.UpdateRequestCell_Str cellDu = new Smartsheet.UpdateRequestCell_Str();            
            cellDu.columnId = Long.valueOf(serviceProjTask.Service_Project_Milestones__r.Case__r.Smartsheet_Duration_Col_Index__c);
            cellDu.value = serviceProjTask.Duration__c;            
            Smartsheet.UpdateRequest uRCellDue = cellDu;      
            system.debug('uRCellDue : '+uRCellDue );   
            updateReq.add(uRCellDue);
           }
        
        Smartsheet.UpdateRequestCell_Str comentcell = new Smartsheet.UpdateRequestCell_Str();
        comentcell.columnId = Long.valueOf(serviceProjTask.Service_Project_Milestones__r.Case__r.Smartsheet_Comments_Col_Index__c);
        comentcell.value = (!String.isBlank(serviceProjTask.Comments__c)? serviceProjTask.Comments__c : null);
        Smartsheet.UpdateRequest uRcomentCell = comentcell; 
        updateReq.add(uRcomentCell); 
        
        row.cells = updateReq;     
        
        return ssAPI.updateRows(long.valueOf(serviceProjTask.Service_Project_Milestones__r.Case__r.Smartsheet_Id__c), new List<Smartsheet.UpdateRequestRow>{row});        
    }
    
    public static void syncProjectTasks(List<Id> projTaskIds) {
        List<Project_Tasks__c> projTasks = [SELECT Id,Functional_Responsibility__c, Percent_Complete__c,Comments__c,Deadline__c,Duration__c, External_ID__c,End_Date__c,Order__c, Project_Milestones__r.Opportunity__r.Smartsheet_Id__c,Start_Date__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_percent_complete_col_Index__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_Comments_Col_Index__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_Deadline_Col_Index__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_Duration_Col_Index__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_End_Date_Col_Index__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_Start_Date_Col_Index__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_Order_Col_Index__c,
                                                   Project_Milestones__r.Opportunity__r.Smartsheet_Functional_Responsibility_Col__c
                                                   FROM Project_Tasks__c
                                                   WHERE Id IN :projTaskIds];
        
        
        Map<Long, List<Smartsheet.UpdateRequestRow>> map_sheetId_Rows = new Map<Long, List<Smartsheet.UpdateRequestRow>>();
        for(Project_Tasks__c eachTask : projTasks) {
            Smartsheet.UpdateRequestRow row = new Smartsheet.UpdateRequestRow();
            row.id = Long.valueOf(eachTask.External_ID__c);
            Smartsheet.UpdateRequestCell_Dec cell = new Smartsheet.UpdateRequestCell_Dec();
            cell.columnId = Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_percent_complete_col_Index__c);
            cell.value = (eachTask.Percent_Complete__c != null ? eachTask.Percent_Complete__c : 0)/100;
            Smartsheet.UpdateRequest uRCell = cell;
            
            Smartsheet.UpdateRequestCell_Str cellCmt = new Smartsheet.UpdateRequestCell_Str();            
            cellCmt.columnId = Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_Comments_Col_Index__c);
            cellCmt.value = eachTask.Comments__c;            
            Smartsheet.UpdateRequest uRCellCmt = cellCmt;                                                
            
            Smartsheet.UpdateRequestCell_Str cellDu = new Smartsheet.UpdateRequestCell_Str();            
            cellDu.columnId = Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_Duration_Col_Index__c);
            cellDu.value = eachTask.Duration__c;            
            Smartsheet.UpdateRequest uRCellDue = cellDu;           
            
            Smartsheet.UpdateRequestCell_Dt cellStd = new Smartsheet.UpdateRequestCell_Dt();            
            cellStd.columnId = Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_Start_Date_Col_Index__c);
            cellStd.value = eachTask.Start_Date__c;            
            Smartsheet.UpdateRequest uRCellStd = cellStd;  
            
            Smartsheet.UpdateRequestCell_Str cellFr = new Smartsheet.UpdateRequestCell_Str();            
            cellFr.columnId = Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_Functional_Responsibility_Col__c);
            cellFr.value = eachTask.Functional_Responsibility__c;            
            Smartsheet.UpdateRequest uRCellFr = cellFr;
            
            
            row.cells = new List<Smartsheet.UpdateRequest>{uRCell,uRCellCmt,uRCellDue,uRCellFr,uRCellStd};
            
            system.debug('Sheet Rows : '+row);                
            if(map_sheetId_Rows.containsKey(Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_Id__c))) {
                map_sheetId_Rows.get(Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_Id__c)).add(row);
            }else{
                map_sheetId_Rows.put(Long.valueOf(eachTask.Project_Milestones__r.Opportunity__r.Smartsheet_Id__c), new List<Smartsheet.UpdateRequestRow>{row});
            }  
        }
        
        for(Long sheetId : map_sheetId_Rows.keySet()) {      
            ssAPI.updateRows(sheetId, map_sheetId_Rows.get(sheetId));
        }
        
        
    }
}