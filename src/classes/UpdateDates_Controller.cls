// Updated Date			Developer		Project 			Tracking Id         				Requirement							
    // 07-August-2020 		Srikanth        Project Concrete	REQ_INC_REC_LIMIT_TO_650     		Update dates screen is hardcoded to load 600 lines, we will have to increse this to show 650 lines. Refer the above order for reference
    // 18-Feb-2021	        Rekha           Validation on SSD   FIX_VALIDATION_ON_PAST_SSD          Update Order Entry Release Trigger to validate for OEL SSD > Today 

public without sharing class UpdateDates_Controller {
    
    @AuraEnabled    
    public static UpdateDatesWrapper onLoadCall(string oppId){
        //if(oppId==null)
        //    return null;
        
        UpdateDatesWrapper objUpdateDatesInfo = new UpdateDatesWrapper();
        
        system.debug('oppId : '+ oppId);
        List<String> scheduleDateProfiles = (Label.MassUpdateScheduleDateProfiles).split(',');
        List<String> requestDateProfiles = (Label.MassUpdateRequestDateProfiles).split(',');
        List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,AssigneeId
                                                              FROM PermissionSetAssignment
                                                              WHERE AssigneeId = :Userinfo.getUserId() 
                                                              AND permissionSet.Name='Schedule_Ship_Date_Update_Permission'];
        
        // LoggedIn user Details
        User userRecord = [select id,CSS_OER_Mass_Update_Permission__c,Profile.Name from user where Id=:userInfo.getUserId() limit 1];
        	objUpdateDatesInfo.enableShipDate =false;
        if(lstcurrentUserPerSet.size() > 0){
            objUpdateDatesInfo.enablePage = true;
            objUpdateDatesInfo.enableShipDate =true;
        }
        else if(userRecord.Profile.Name == 'System Administrator'){
            objUpdateDatesInfo.enablePage = true;
            objUpdateDatesInfo.enableShipDate = true;
            objUpdateDatesInfo.enableRequestDate = true;
        }else if(requestDateProfiles.contains(userRecord.Profile.Name)){
            objUpdateDatesInfo.enablePage = true;
            objUpdateDatesInfo.enableRequestDate = true;
        }
        else if(scheduleDateProfiles.contains(userRecord.Profile.Name)){
            objUpdateDatesInfo.enablePage = true;
            objUpdateDatesInfo.enableShipDate = true;
        }
        else{

        }
		
		if(!requestDateProfiles.contains(userRecord.Profile.Name) && userRecord.Profile.Name != 'System Administrator'){
            objUpdateDatesInfo.enableRequestDate = false;
        }
        
        List<Order_Entry_Release__c> getOrders = [SELECT id,Name,Integration_Status__c,Status__c,Opportunity__c,Release_Name__c,RecordType.DeveloperName
                                                  FROM  Order_Entry_Release__c 
                                                  WHERE Opportunity__c =: oppId 
                                                  AND RecordType.DeveloperName=:Label.CSS_Hardware AND (NOT Status__c LIKE 'Cancel%')
												  AND Status__c != 'Draft'
                                                  AND Status__c != 'Integration Requested'
												  AND Status__c != 'Cancelled'
												  AND Status__c != 'Error'];
        
        //(Integration_Status__c = 'Initial' OR Integration_Status__c = 'Complete' OR Integration_Status__c = 'Error' )AND
        
        
        List<Details> releaseNames = new List<Details>();	
        releaseNames.add(new Details('--None--','--None--'));
        for(Order_Entry_Release__c  oer:getOrders){
            releaseNames.add(new Details(oer.Release_Name__c,oer.Release_Name__c));
        } 
        
        objUpdateDatesInfo.releaseNames = releaseNames;
        objUpdateDatesInfo.selectedName = releaseNames[0].Name;
        if(releaseNames.size() > 1) {
            objUpdateDatesInfo.selectedName = releaseNames[1].Name;
        }
        
        objUpdateDatesInfo.requestDateChecked = false;
        objUpdateDatesInfo.shipDateChecked = false;
        objUpdateDatesInfo.navigateToOpp = false;
        objUpdateDatesInfo.isFinishedMethod = false;
        objUpdateDatesInfo.selectedReferenceId = '--None--';
        objUpdateDatesInfo.selectedSKU =  '--None--';
        objUpdateDatesInfo.isContinue = false;
        objUpdateDatesInfo.isChanged = false;	
        objUpdateDatesInfo.refreshPage = false;
        objUpdateDatesInfo.getOrders = getOrders;
        List<Details> defaultVal = new List<Details>();
        defaultVal.add(new Details('--None--','--None--'));
        //objUpdateDatesInfo.referenceIds = defaultVal;
        objUpdateDatesInfo.productSKU = defaultVal;
        
        objUpdateDatesInfo = filterData(true,oppId,objUpdateDatesInfo);	
        
        system.debug('objUpdateDatesInfo : '+objUpdateDatesInfo);
        return objUpdateDatesInfo;
    }
    
    @AuraEnabled    
    public static UpdateDatesWrapper filterChange(string oppId,string wrapperData){
        if(oppId==null)
            return null;
        
        UpdateDatesWrapper objData = (UpdateDatesWrapper)JSON.deserialize(wrapperData, UpdateDatesWrapper.class);
        system.debug('oppId : ' + oppId);
        system.debug('objData : ' + wrapperData);
        
        UpdateDatesWrapper objUpdateDatesInfo = filterData(false,oppId,objData);	
        
        system.debug('objData : ' + objUpdateDatesInfo);
        
        return objUpdateDatesInfo;
    }
    
    
    
    public static UpdateDatesWrapper filterData(boolean initialLoad, String oppId, UpdateDatesWrapper dataWrapper){
        
        if(dataWrapper.isContinue){
            dataWrapper.releaseNames.clear();
            dataWrapper.releaseNames.add(new Details(dataWrapper.selectedName,dataWrapper.selectedName));
        }
        
        system.debug('dataWrapper' + dataWrapper);
        
        system.debug('dataWrapper.selectedName ==> ' + dataWrapper.selectedName);
        system.debug('dataWrapper.selectedReferenceId ==> ' + dataWrapper.selectedReferenceId);
        system.debug('dataWrapper.selectedSKU ==> ' + dataWrapper.selectedSKU);
        
        system.debug('dataWrapper.selectedName' + dataWrapper.selectedName);
        List<String> statuses=(Label.CSS_OERMassUpdateNotAllowed).split(',');
        Set<String> uniqueStatus = new Set<String>();
        uniqueStatus.AddAll(statuses);	
        
        List<String> filterStatuses= new List<String>{'Picked','Shipped','Closed'};//Srikanth added for moving Picked/Closed/Shipped to NonEditable section
        
        string oelQuery = uniqueQuery(oppId);		
        string whereFilters = '';
        String selectName;
        if(dataWrapper.selectedName != '' && dataWrapper.selectedName != '--None--'){
            selectName = String.escapeSingleQuotes(dataWrapper.selectedName);
            whereFilters += ' and Order_Entry_Release__r.Release_Name__c = \''+ selectName +'\'';
        }
        
        String refId;
        if(dataWrapper.selectedReferenceId != '' && dataWrapper.selectedReferenceId != '--None--'){
            refId = String.escapeSingleQuotes(dataWrapper.selectedReferenceId);
            whereFilters += ' and Customer_Reference_Description__c = \''+ refId +'\'';
            //whereFilters += ' and Customer_Reference_Description__c IN ('+ refId +') ';
        }
        
        if(dataWrapper.selectedSKU != '' && dataWrapper.selectedSKU != '--None--'){
            whereFilters += ' and SKU__C = \''+ dataWrapper.selectedSKU +'\'';
        }
        
        if(dataWrapper.requestDateChecked == true){
            whereFilters += ' and Request_Date_Update_Needed__c = true';            
        }
        
        if(dataWrapper.shipDateChecked == true){
            whereFilters += ' and Is_Schedule_Date_Updated__c = true';          
        }
        
        
        oelQuery += whereFilters;
        system.debug('Query Val Final@@' + oelQuery);
        
        oelQuery = oelQuery + ' limit 650';		//REQ_INC_REC_LIMIT_TO_650
        
        List<Order_Entry_Line__c> oelList = new List<Order_Entry_Line__c>();
        
        oelList = Database.query(oelQuery);
        
        Set<String> uniqueReferenceIds = new Set<String>();
        set<String> uniqueprodSkuset  = new set<String>();
        Map<String,String> referenceList=new Map<String,String>();
        
        List<Details> lstReferenceIds = new List<Details>();
        lstReferenceIds.add(new Details('--None--','--None--'));
        List<Details> lstProductSKU = new List<Details>();
        lstProductSKU.add(new Details('--None--','--None--'));
        List<EditableOELWrapper> nonEditableOELs = new List<EditableOELWrapper>();
        List<EditableOELWrapper> editableOELs = new List<EditableOELWrapper>();
        Map<Id, EditableOELWrapper> mapUpdateOELs = new Map<Id, EditableOELWrapper>();
        Map<Id, Order_Entry_Line__c> mapWrapperOld = new Map<Id, Order_Entry_Line__c>();
        
        
        system.debug(' objData.updateTableOELs >>>> ' +  dataWrapper.updateTableOELs);
        if(dataWrapper.updateTableOELs != null){
            for(EditableOELWrapper oelData : dataWrapper.updateTableOELs){
                mapUpdateOELs.put(oelData.oel.Id, oelData);
            }
        }
        system.debug(' objData.updateTableOELs  >>>> ' + mapUpdateOELs);
        
        for(Order_Entry_Line__c oel:  oelList){
            // Customer Reference Collection 
            if(oel.Customer_Reference_Description__c <> null && !uniqueReferenceIds.contains(oel.Customer_Reference_Description__c)){
                if(dataWrapper.selectedReferenceId == '--None--'){
                    lstReferenceIds.add(new Details(oel.Customer_Reference_Description__c,oel.Customer_Reference_Description__c));
                    //dataWrapper.referenceIds.add(new Details(oel.Customer_Reference_Description__c,oel.Customer_Reference_Description__c));
                } 
                uniqueReferenceIds.add(oel.Customer_Reference_Description__c);
            }
            
            // SKU Collection 
            if(oel.SKU__C != null && !uniqueprodSkuset.contains(oel.SKU__C)){ 
                if(dataWrapper.selectedSKU == '--None--'){
                    lstProductSKU.add(new Details(oel.SKU__C,oel.SKU__C));
                    //dataWrapper.productSKU.add(new Details(oel.SKU__C,oel.SKU__C));
                    uniqueprodSkuset.add(oel.SKU__C);
                }
            }
            
            boolean isEditable = isHeaderEditable(oel,oel.Order_Entry_Release__r.Status__c);
            system.debug('isEditable : '+ isEditable);
            if(!isEditable && oel.status__c !='Cancelled' && !oel.status__c.contains('Cancel')){
                nonEditableOELs.add(new EditableOELWrapper(false,oel)); 
                system.debug('Non Editable : 1 '+ oel.status__c);
            }else{
                
                if(oel.status__c != 'Cancelled' && !oel.status__c.contains('Cancel')){
                    if(uniqueStatus.contains(oel.Status__c) || filterStatuses.contains(oel.Sales_Order_Line_Status__c)){
                        nonEditableOELs.add(new EditableOELWrapper(false,oel)); 
                        system.debug('Non Editable : 2 '+ oel.status__c);
                    }else{
                        system.debug('oel.Id >>>>> '+ oel.Id);
                        if(!mapUpdateOELs.containsKey(oel.Id)){
                            system.debug('Editable : 1 '+ oel.status__c);
                            editableOELs.add(new EditableOELWrapper(false,oel)); 
                            Order_Entry_Line__c oelClone  = oel.clone(false, false, false, false);
                            mapWrapperOld.put(oel.Id, oelClone);
                            
                        }
                        /*else{
system.debug('Update : 1 '+ oel.status__c);
dataWrapper.updateTableOELs.add(new EditableOELWrapper(false,oel));
}*/
                    }					
                }
            }			
        }
        
        system.debug('lstReferenceIds : '+lstReferenceIds);
        system.debug('lstProductSKU : '+lstProductSKU);
        
        if(dataWrapper.selectedReferenceId == '' || dataWrapper.selectedReferenceId == '--None--'){
            dataWrapper.referenceIds = lstReferenceIds; 
        }
        if(dataWrapper.selectedSKU == '' || dataWrapper.selectedSKU == '--None--'){
            dataWrapper.productSKU = lstProductSKU; 
        }
        
        
        dataWrapper.editableOELs = editableOELs; 
        dataWrapper.nonEditableOELs = nonEditableOELs; 
        dataWrapper.mapOldOEL = mapWrapperOld; 
        system.debug('objUpdateDatesInfo : '+dataWrapper);
        return dataWrapper; 
        
    }
    
    
    public static boolean isHeaderEditable(Order_Entry_Line__c oel, string orderStatus){
        string recTypeId = oel.RecordTypeId;
        Map<ID,Schema.RecordTypeInfo> oelRecordTypeMapSchema = Schema.SObjectType.Order_Entry_Line__c.getRecordTypeInfosById(); 
        
        system.debug('Release status '+ orderStatus);
        system.debug('Record Type Name : '+ oelRecordTypeMapSchema.get(recTypeId).getDeveloperName());
        
        Set<String> oerUpdateOK = new Set<String> {'Draft','Pre-Release Review', 'Confirmation Pending', 'Pre-Production', 'In Production', 'Integration Error', 'Change Confirmation Required','Change Confirmed', 'Change Requested', 'Hold','Partially Shipped'};
            
            
            Set<String> oerUpdateCSSOK = new Set<String> {'Draft','Integration Error','Change Requested','Invoiced','Planned' , 'Approved-to-Ship','Change Confirmation Pending','Partially Shipped'};
                
                Set<String> oerUpdateSWOK = new Set<String> {'Draft'};
                    system.debug(recTypeId + '////' + orderStatus);
        boolean isUpdateAllowed = true;
        if (oelRecordTypeMapSchema.get(recTypeId).getDeveloperName().contains('IGU') && !oerUpdateOK.contains(orderStatus)){
            isUpdateAllowed = false;
            system.debug('IGU 1 '+ isUpdateAllowed );
        }
        if (!oelRecordTypeMapSchema.get(recTypeId).getDeveloperName().contains('IGU') && !oerUpdateCSSOK.contains(orderStatus)){
            isUpdateAllowed = false;
            system.debug('IGU 2 Status '+ isUpdateAllowed );
        }
        if (oelRecordTypeMapSchema.get(recTypeId).getDeveloperName().contains(Label.CSS_Software) && !oerUpdateSWOK.contains(orderStatus)){            
            isUpdateAllowed = false;
            system.debug('CSS_Software Status '+ isUpdateAllowed );
        }   
        if (oel.Integration_Status__c != null && oel.Integration_Status__c != 'Requested' && oel.Integration_Status__c != 'Initial' && oel.Integration_Status__c != 'Complete' && oel.Integration_Status__c != 'Error' ) {
            isUpdateAllowed = false;
            system.debug('CSS_Software Status '+ isUpdateAllowed + ': Update is not permitted while integration is in process'  );
        }
        system.debug('Status '+ isUpdateAllowed );
        return isUpdateAllowed;
    }
    
    
    @AuraEnabled    
    public static UpdateDatesWrapper saveUpdateDates(string oppId,string wrapperData,date shippedDate, string shippedDateReason,date requestDate, string requestDateReason, string shippedDateCmnt, string requestDateCmnt){
        
        UpdateDatesWrapper objData = (UpdateDatesWrapper)JSON.deserialize(wrapperData, UpdateDatesWrapper.class);
        List<EditableOELWrapper> editableOELs = objData.editableOELs;
        Map<Id, Order_Entry_Line__c> mapOldOEL = objData.mapOldOEL; 
        
        system.debug('editableOELs *** '+ editableOELs);
        system.debug('mapOldOEL *** '+ mapOldOEL);
        system.debug('shippedDate *** '+ shippedDate);
        system.debug('shippedDateReason *** '+ shippedDateReason);
        system.debug('requestDate *** '+ requestDate);
        system.debug('requestDateReason *** '+ requestDateReason);
		system.debug('objData.getOrdersToUpdate *** '+ objData.getOrdersToUpdate);
        
		
		
		set<Id> headerIds = objData.headerIds == null? new set<Id>() : objData.headerIds;
        Map<Id, Order_Entry_Release__c> mapOerUpdateLst = new Map<Id, Order_Entry_Release__c>();
        List<Order_Entry_Release__c> getOrdersToUpdate = objData.getOrdersToUpdate == null? new List<Order_Entry_Release__c>() : objData.getOrdersToUpdate;
        List<EditableOELWrapper> updateTableOELs = objData.updateTableOELs == null ? new List<EditableOELWrapper>() : objData.updateTableOELs;
        List<Order_Entry_Line__c> listForSave = new List<Order_Entry_Line__c>();
        List<EditableOELWrapper> lstUnSavedOrl = new List<EditableOELWrapper>();
        for(EditableOELWrapper oelLine : editableOELs){
            if(oelLine.checked) {
                listForSave.add(oelLine.oel);
            } else {
                lstUnSavedOrl.add(oelLine);
            }
        }	
        
        
        objData.hasError = false;
        objData.DisplayPageBlock = false;
        objData.navigateToOpp = false;
        objData.refreshPage = false;
        objData.updateTableOELs = new List<EditableOELWrapper> ();
        
        
        List<Order_Entry_Line__c> oelLines = new List<Order_Entry_Line__c>();
        for(Order_Entry_Line__c oelLine : listForSave){
            if(objData.enableRequestDate == true && objData.enableShipDate == true){
                              
                if(requestDate != null && requestDateReason == '--None--'){
                    objData.errorMsg = 'Please enter the Change Reason for updating the request date';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }
 
                 //FIX_VALIDATION_ON_PAST_SSD
                 if(shippedDate != null && shippedDate < System.today()){
                    objData.errorMsg = 'Schedule Ship Date should not be in the past';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }                
                if(shippedDate != null && shippedDateReason == '--None--'){
                    objData.errorMsg = 'Please enter the Change Reason for updating the scheduled ship date';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }
                if(shippedDate != null && shippedDateReason != '--None--' && shippedDateReason == 'Other' && string.isBlank(shippedDateCmnt)){
                    objData.errorMsg = 'Please enter the Scheduled Ship Date Change Comments when Other is selected as schedule ship date change reason';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }
                if(requestDate != null && requestDateReason != '--None--' && requestDateReason == 'Other' && string.isBlank(requestDateCmnt)){
                    objData.errorMsg = 'Please enter the Request Date Change Comments when Other is selected as request date change reason';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }	
                
                if(requestDate != null)
                    oelLine.Request_Date__c = requestDate;
                
                if(!string.isBlank(requestDateReason) && requestDateReason != '--None--')
                    oelLine.Request_Date_Change_Reason__c = requestDateReason;
                
                if(!string.isBlank(requestDateCmnt))
                    oelLine.Request_Date_Change_Comments__c = requestDateCmnt;
                
                if(shippedDate != null)
                    oelLine.Scheduled_Ship_Date__c = shippedDate;
                
                if(!string.isBlank(shippedDateReason) && shippedDateReason != '--None--')
                    oelLine.Schedule_Ship_Date_Change_Reason__c = shippedDateReason;
                
                if(string.isBlank(shippedDateCmnt))
                    oelLine.Schedule_Ship_Date_Change_Comments__c = shippedDateCmnt;
                
            }else if(objData.enableRequestDate == true){
               
                if(requestDate != null && requestDateReason == '--None--'){
                    objData.errorMsg = 'Please enter the Change Reason for updating the request date';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }			
                
                if(requestDate != null && requestDateReason != '--None--' && requestDateReason =='Other' && string.isBlank(requestDateCmnt)){
                    objData.errorMsg = 'Please enter the Request Date Change Comments when Other is selected as request date change reason';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }			
                
                if(requestDate != null)
                    oelLine.Request_Date__c = requestDate;
                
                if(!string.isBlank(requestDateReason))
                    oelLine.Request_Date_Change_Reason__c = requestDateReason;
                
                if(!string.isBlank(requestDateCmnt))
                    oelLine.Request_Date_Change_Comments__c = requestDateCmnt;
                
            }else if(objData.enableShipDate == true){
                //FIX_VALIDATION_ON_PAST_SSD
                 if(shippedDate != null && shippedDate < System.today()){
                    objData.errorMsg = 'Schedule Ship Date should not be in the past';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }
                if(shippedDate != null && shippedDateReason == '--None--'){
                    objData.errorMsg = 'Please enter the Change Reason for updating the scheduled ship date';
                    system.debug(' objData >>>> '+ objData);
                    objData.hasError = true;
                    break;
                }
                if( shippedDate!= null && shippedDateReason != '--None--' && shippedDateReason =='Other' && string.isBlank(shippedDateCmnt)){
                    objData.errorMsg = 'Please enter the Scheduled Ship Date Change Comments when Other is selected as schedule ship date change reason';
                    system.debug(' objData >>>> '+ objData); 
                    objData.hasError = true;
                    break;
                }
                
                if(shippedDate != null)
                    oelLine.Scheduled_Ship_Date__c = shippedDate;
                
                if(!string.isBlank(shippedDateReason))
                    oelLine.Schedule_Ship_Date_Change_Reason__c = shippedDateReason;
                
                if(string.isBlank(shippedDateCmnt))
                    oelLine.Schedule_Ship_Date_Change_Comments__c = shippedDateCmnt;
            }
            if(objData.enableRequestDate && oelLine.Request_Date_Update_Needed__c)
                oelLine.Request_Date_Update_Needed__c= false;
            
            if(objData.enableShipDate && oelLine.Is_Schedule_Date_Updated__c)
                oelLine.Is_Schedule_Date_Updated__c = false;	
            
            oelLine.Trigger_Source__c = 'UI';
            
            oelLines.add(oelLine);
            updateTableOELs.add( new EditableOELWrapper(false, oelLine));
            headerIds.add(oelline.Order_Entry_Release__c);
        }
        
        if(!objData.hasError){
            for(Order_Entry_Line__c oelLine : listForSave){     
                system.debug('oelLine >>> '+oelLine);
                system.debug('mapOldOEL >>> '+ mapOldOEL.get(oelLine.id));
                if(oelLine.Request_Date__c != mapOldOEL.get(oelLine.id).Request_Date__c || oelLine.Scheduled_Ship_Date__c != mapOldOEL.get(oelLine.id).Scheduled_Ship_Date__c){				
                    objData.isChanged = true;
                }
                else{
                    if(!Test.isRunningTest()){
                        objData.hasError = true;
                        objData.DisplayPageBlock = true;
                    }
                    
                }
            }
            system.debug('getOrders >>> '+objData.getOrders);
			system.debug('headerIds >>> '+ headerIds);
            for(Order_Entry_Release__c oer : objData.getOrders){
                system.debug('@@@oerint'+oer.Integration_Status__c+''+oer.Id);
                if (headerIds.contains(oer.Id) && oer.Integration_Status__c != null && oer.Integration_Status__c != 'Requested' && oer.Integration_Status__c != 'Initial' && oer.Integration_Status__c != 'Complete' && oer.Integration_Status__c != 'Error' ){
                    system.debug('@@@oerint1'+oer.Integration_Status__c);
                    objData.errorMsg = 'Update is not permitted while integration is in process on header';
                    objData.hasError = true;
                    break;
                }       
                if(headerIds.contains(oer.Id) && objData.isChanged){                
                    oer.status__c = 'Change Integration Requested';
                    oer.Trigger_Source__c='UI';    
                    getOrdersToUpdate.add(oer);					
                    mapOerUpdateLst.put(oer.Id,oer);
                    
                }
            }
            
            system.debug('isChanged >>> '+objData.isChanged);
			system.debug('objData.hasError >>> '+objData.hasError);
			system.debug('objData.errorMsg >>> '+objData.errorMsg);
            system.debug('objData.DisplayPageBlock >>> '+objData.DisplayPageBlock);
            
            if(!objData.DisplayPageBlock && !objData.hasError){
                if(listForSave.size() > 0) {
                    try{				
                        system.debug('>>>>>>>>> Partial Update ' +oelLines);
                        update oelLines;
                        system.debug('isChanged >>> '+ oelLines.size());
                        system.debug('updateTableOELs Size >>> '+ updateTableOELs.size());
                        if(objData.isContinue && objData.isChanged && !objData.DisplayPageBlock){
                            objData.refreshPage = true;
                            objData.errorMsg = 'Update Successful';
                            objData.selectedReferenceId = '--None--';
                            objData.selectedSKU =  '--None--';
                        }
                        if(!getOrdersToUpdate.isEmpty() && objData.isFinishedMethod){
                            objData.navigateToOpp = true;
                                system.debug('>>>>>>>>> Final Update ' +getOrdersToUpdate);
                            //update getOrdersToUpdate;
                            //update mapoerUpdateLst.values();
                            System.enqueueJob(new UpdateDates_Queueable(mapoerUpdateLst.keySet()));
                        }
                        
                        // Opp Navigation Code Pending
                        
                    }
                    catch(DMLException de) { 
                        objData.errorMsg = de.getMessage();
                        objData.hasError = true;
                    }
                }
                else if(!objData.isContinue && objData.isFinishedMethod){
                    system.debug('>>>>>>>>>>>>> Update');
                    objData.navigateToOpp = true;
                    system.debug('>>>>>>>>> FINISH Final Update ' +getOrdersToUpdate);
                    //update getOrdersToUpdate;
                   // update mapoerUpdateLst.values();
                   System.enqueueJob(new UpdateDates_Queueable(mapoerUpdateLst.keySet()));
                }
            }
            else{
                objData.conformOrders = oelLines;
                objData.editableOELsTemp = lstUnSavedOrl;   
            }
        }
        
        objData.getOrdersToUpdate = getOrdersToUpdate;
        system.debug('Final List : '+ objData.hasError);
        system.debug('Final List : '+ oelLines);
        system.debug('Final lstUnSavedOrl List : '+ lstUnSavedOrl);
        system.debug('updateTableOELs Size >>> '+ updateTableOELs.size());
        system.debug('Final updateTableOELs List : '+ updateTableOELs);        
        system.debug(' objData >>>> '+ objData);
        objData.headerIds = headerIds;
        objData.editableOELs = lstUnSavedOrl; 
        objData.updateTableOELs = updateTableOELs;
        
        return objData;
    }
    
    
    @AuraEnabled    
    public static UpdateDatesWrapper approvedDates(string wrapperData){
        
        UpdateDatesWrapper objData = (UpdateDatesWrapper)JSON.deserialize(wrapperData, UpdateDatesWrapper.class);
        system.debug('>>>>>>>>> Partial Update ' +objData);
		system.debug('>>>>>>>>> Partial Update ' +objData.conformOrders);        
        objData.DisplayPageBlock = false;
        List<Order_Entry_Line__c> listForSave = new List<Order_Entry_Line__c>();
        List<EditableOELWrapper> lstUnSavedOrl = new List<EditableOELWrapper>();
        List<EditableOELWrapper> updateTableOELs = objData.updateTableOELs == null ? new List<EditableOELWrapper>() : objData.updateTableOELs;
        //Map<Id, Order_Entry_Release__c> mapOerUpdateLst = objData.mapOerUpdateLst;
        
        for(Order_Entry_Line__c oelLine : objData.conformOrders){
            updateTableOELs.add(new EditableOELWrapper(false,oelLine));
        }		
        
        objData.editableOELs = objData.editableOELsTemp;
        objData.updateTableOELs = updateTableOELs;
        system.debug('>>>>>>>>> Partial Update ' +objData.conformOrders);
        update objData.conformOrders;
        
        
        if(objData.isContinue){
            objData.selectedReferenceId = '--None--';       
            objData.selectedSKU = '--None--';
            objData.refreshPage = true;
            //refresh call
        }
        else if(objData.isFinishedMethod){		
            if(objData.isChanged){
                system.debug('>>>>>>>>> Final Update ' +objData.getOrdersToUpdate);
                update objData.getOrdersToUpdate;					
            }
            objData.navigateToOpp = true;
        }
        
        
        
        return objData;           
    }
    
    public class UpdateDatesWrapper{
        
        @AuraEnabled
        public List<Details> releaseNames{get;set;}
        
        @AuraEnabled
        public List<Details> allReleaseNames{get;set;}
        
        @AuraEnabled
        public List<Details> referenceIds{get;set;}
        
        @AuraEnabled
        public List<Details> productSKU{get;set;}        	
        
        @AuraEnabled
        public List<Order_Entry_Release__c> getOrders{get;set;}
        
        @AuraEnabled
        public List<Order_Entry_Release__c> getOrdersToUpdate{get;set;}
        
        @AuraEnabled
        public List<Order_Entry_Line__c> conformOrders{get;set;}
        
        @AuraEnabled
        public List<EditableOELWrapper> editableOELsTemp{get;set;}
        
        @AuraEnabled
        public List<EditableOELWrapper> nonEditableOELs{get;set;}
        
        @AuraEnabled
        public List<EditableOELWrapper> updateTableOELs{get;set;}
        
        @AuraEnabled
        public Map<Id, Order_Entry_Line__c> mapOldOEL{get;set;}
        
        @AuraEnabled
        public Map<Id, Order_Entry_Line__c> mapOerUpdateLst{get;set;}
        
        @AuraEnabled
        public List<EditableOELWrapper> editableOELs{get;set;}
        
        @AuraEnabled
        public set<string> processHeaders{get;set;}		
        
        @AuraEnabled
        public boolean enableRequestDate {get;set;}
        
        @AuraEnabled
        public boolean enableShipDate {get;set;}
        
        @AuraEnabled
        public boolean requestDateChecked {get;set;}
        
        @AuraEnabled
        public boolean shipDateChecked {get;set;}
        
        @AuraEnabled
        public boolean isContinue {get;set;}
        
        @AuraEnabled
        public boolean isFinishedMethod {get;set;}
        
        @AuraEnabled
        public boolean enablePage {get;set;}        
        @AuraEnabled
        public string selectedName {get;set;}
        @AuraEnabled
        public string selectedReferenceId {get;set;}
        @AuraEnabled
        public string selectedSKU {get;set;}
        @AuraEnabled
        public string errorMsg {get;set;}
        @AuraEnabled
        public boolean hasError {get;set;} 
        @AuraEnabled
        public boolean isChanged {get;set;} 
        @AuraEnabled
        public boolean DisplayPageBlock {get;set;}
        
        @AuraEnabled
        public boolean navigateToOpp {get;set;} 
        @AuraEnabled
        public boolean refreshPage {get;set;} 
		
		@AuraEnabled
        public Set<Id> headerIds {get;set;} 
		
		
        
        
    }
    
    public static string uniqueQuery(String oppId){
        string oelQuery = 'select Id,Sales_Order_Line_Status__c,Previous_Scheduled_Ship_Date__c,Previous_Request_Ship_Date__c,Product_Description__c,Request_Date_Update_Needed__c,Is_Schedule_Date_Updated__c,Integration_Status__c,Order_Entry_Release__c,RecordTypeId,Order_Entry_Release__r.Status__c ,Quantity__c,SKU__C,Request_Date_Change_Reason__c,Schedule_Ship_Date_Change_Reason__c, Status__c,Request_Date__c,Request_Date_Change_Comments__c ,Schedule_Ship_Date_Change_Comments__c,Name,Reference_ID__c,Customer_Reference_Description__c,Scheduled_Ship_Date__c, Order_Entry_Release__r.Release_Name__c from Order_Entry_Line__c';        
        
        oelQuery += ' WHERE  RecordType.DeveloperName = \''+ Label.CSS_Hardware +'\' and Order_Entry_Release__r.Opportunity__c = \''+oppId+'\'';
        
        return oelQuery;
        
    }
    
    public class EditableOELWrapper{
        
        @AuraEnabled
        public boolean checked {get;set;}
        
        @AuraEnabled
        public Order_Entry_Line__c oel{get;set;}
        
        public EditableOELWrapper(boolean checked, Order_Entry_Line__c nonEditableOEL){
            this.checked = checked;
            this.oel = nonEditableOEL;
        }
    }
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        if(nullRequired == true){
            optionlist.add('--None--');
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            if(field_apiname == 'Request_Date_Change_Reason__c') {
                if(pv.getValue() == 'Construction Schedule Delay' || pv.getValue() == 'Construction Schedule Pull-In' || pv.getValue() == 'Other') {
                    optionlist.add(pv.getValue());
                } 
            } else if(field_apiname == 'Schedule_Ship_Date_Change_Reason__c') {
                if(pv.getValue() == 'Request Date Change' || pv.getValue() == 'Transit Time' || pv.getValue() == 'Material Shortage' || pv.getValue() == 'Manpower Shortage' || pv.getValue() == 'Other') {
                    optionlist.add(pv.getValue());
                }
            } else {
                optionlist.add(pv.getValue());
            }  
        }
        return optionlist;
    }
    
    public class Details{
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String Id{get;set;} 
        
        public Details(String Id, String Name){
            this.Name = Name;
            this.Id = Id;
        }
    }
}