/***********************************************************************************************************
* Name         : CSS_OERMassUpdateController.cls
* Created By   : ENP Team
* Purpose      : This class is used for Mass updating Scheduled Ship Date for Order Entry Line Records 
* Created Date : 16 Jan 2019
*
* Date Modified                Modified By             Description of the update
----------------------------------------------------------------------------------------------------------
* 
**********************************************************************************************************/
public class CSS_OERMassUpdateController {
    
    public List<Order_Entry_Release__c> getOrders{get;set;} 
    public List<SelectOption> releaseNames{get;set;}
    public List<SelectOption> referenceIds{get;set;}
    public List<SelectOption> productSKU{get;set;}
    public String selectedSKU{get;set;}
    public String selectedName{get;set;}
    public String selectedReferenceId{get;set;}
    public boolean isshowEdit{get;set;}
    public boolean isshowEditTable{get;set;}
    public boolean isshowprocess{get;set;}
    public String oppId{get;set;}
    public boolean isshowSave{get;set;}
    public List<Order_Entry_Line__c> selectedlines;
    public Order_Entry_Line__c oel1{get;set;}
    public Set<String> statusSet= new set<String>();
    public Boolean allBool {get;set;}
    public List<WrapperClass> listWrapper {get;set;}
    public List<WrapperClass> updatedlistWrapper {get;set;}
    public Map<Id,Order_Entry_Line__c> mapWrapperOld {get;set;}
    public List<WrapperClass> listWrapperNonEditable {get;set;}
    public List<Order_Entry_Line__c> listForSave;
    public List<Order_Entry_Line__c> oelLines;
    public User userRecord;
    public Boolean enablePage {get;set;}
    public Boolean enableShipDate {get;set;}
    public Boolean enableRequestDate {get;set;}
    public Boolean validationMsg {get;set;}
    public Boolean requestDateUpdateCheck{get;set;}
    public Boolean scheduledDateUpdateCheck{get;set;}
    public Boolean isContinue{get;set;}
    public set<Id> UpdatedIds{get;set;}
    public Map<Id,WrapperClass> mapUpdatedOEL;
    public Boolean isIntial;
    public Boolean isChanged;
    public Boolean DisplayPageBlock{get; set;}
    Public Map<Id,Order_Entry_Release__c> mapoerUpdateLst = new Map<Id,Order_Entry_Release__c>();
    public set<string> processHeaders = new set<string>();
    /**
    @ Constructor Name  - CSS_OERMassUpdateController
    @ Created By - ENP Team
    @ Params -StandardSetController
    @ Return - No Return
    @ Description - "This Constructor is used for initialization of variables while loading page"
    **/
    public CSS_OERMassUpdateController(ApexPages.StandardSetController controller) {
        validationMsg = false;
        isChanged = false;
        counter = 0;
        requestDateUpdateCheck = false;
        scheduledDateUpdateCheck = false;
        oppId = ApexPages.currentPage().getParameters().get('id');
        releaseNames = new List<SelectOption>();
        referenceIds=new List<SelectOption>();
        productSKU=new List<SelectOption>();
        oel1=new Order_Entry_Line__c();
        updatedlistWrapper = new List<WrapperClass>();
        mapUpdatedOEL = new Map<Id,WrapperClass>();
        releaseNames.add(new SelectOption('--None--','--None--'));
        productSKU.add(new SelectOption('--None--','--None--'));
        referenceIds.add(new SelectOption('--None--','--None--'));
        set<String> uniqueSkuIds = new set<String> ();
        UpdatedIds = new set<Id>();
        enableShipDate=false;
        enableRequestDate=false;
        DisplayPageBlock= false;
        system.debug('++++ oppId ++ : '+oppId);
        getOrders=[select id,Name,Integration_Status__c,Status__c,Opportunity__c,Release_Name__c,RecordType.DeveloperName,
                   (select Id,SKU__C,Name,Reference_ID__c,Customer_Reference_Description__c,Scheduled_Ship_Date__c,Status__c,
                    Request_Date__c,Request_Date_Change_Reason__c,Request_Date_Change_Comments__c ,Schedule_Ship_Date_Change_Comments__c,Schedule_Ship_Date_Change_Reason__c,Product_Description__c,
                    Quantity__c  from Order_Entry_Lines__r) from 
                   Order_Entry_Release__c where Opportunity__c =: oppId 
                   and RecordType.DeveloperName=:Label.CSS_Hardware and  (NOT Status__c LIKE 'Cancel%')];
        userRecord=[select id,CSS_OER_Mass_Update_Permission__c,Profile.Name from user where Id=:userInfo.getUserId() limit 1];
        List<String> scheduleDateProfiles=(Label.MassUpdateScheduleDateProfiles).split(',');
        List<String> requestDateProfiles=(Label.MassUpdateRequestDateProfiles).split(',');
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                 FROM PermissionSetAssignment
                                                                 WHERE AssigneeId = :Userinfo.getUserId() and permissionSet.Name='Schedule_Ship_Date_Update_Permission'];
        
        if(lstcurrentUserPerSet.size()>0){
            enablePage=true;
            enableShipDate=true;
            //scheduledDateUpdateCheck = true;
        }
        else if(userRecord.Profile.Name=='System Administrator'){
            enablePage=true;
            enableShipDate=true;
            enableRequestDate=true;
            //requestDateUpdateCheck = true;
            //scheduledDateUpdateCheck = true;
        }else if(requestDateProfiles.contains(userRecord.Profile.Name)){
            enablePage=true;
            enableRequestDate=true;
            //requestDateUpdateCheck = true;
        }
        else if(scheduleDateProfiles.contains(userRecord.Profile.Name)){
            enablePage=true;
            enableShipDate=true;
        }
        else{
            enablePage=false;
        }
              
        system.debug('++++'+getOrders);
        isshowEditTable=false;
        isshowSave=false;
        Map<String,String> referenceList=new Map<String,String>();
        Set<String> uniqueReferenceIds = new Set<String>();
        //Map<Id,Set<string>> orderIdCr = new Map<Id,Set<string>>();
        for(Order_Entry_Release__c  oer:getOrders){
             if (oer.Integration_Status__c != null && oer.Integration_Status__c != 'Initial' && oer.Integration_Status__c != 'Complete' && 
                        oer.Integration_Status__c != 'Error' )
                {
                    processHeaders.add(oer.Release_Name__c);
                }    
            releaseNames.add(new SelectOption(oer.Release_Name__c,oer.Release_Name__c));
            system.debug('OEL Size'+oer.Order_Entry_Lines__r.size());
            /*for(Order_Entry_Line__c oel:oer.Order_Entry_Lines__r){
        if(!uniqueSkuIds.contains(oel.SKU__C)){
                productSKU.add(new SelectOption(oel.SKU__C,oel.SKU__C));   
        
        }
        uniqueSkuIds.add(oel.SKU__C);        
                /*if(oel.Customer_Reference_Description__c<>null && !referenceList.containsKey(oel.Customer_Reference_Description__c)){
                    if(!uniqueReferenceIds.contains(oel.Reference_ID__c)){
                        referenceIds.add(new SelectOption(oel.Customer_Reference_Description__c,oel.Customer_Reference_Description__c));
                    }
                    uniqueReferenceIds.add(oel.Customer_Reference_Description__c);
                    
                }
                referenceList.put(oel.Customer_Reference_Description__c,oel.Customer_Reference_Description__c);
            }*/
            //orderIdCr.put(oer.Id,uniqueReferenceIds);
        } 
        isIntial = true;
        isContinue = false;
        orderItemReferenceonLoadMethod();
    }
    
   
    public boolean isHeaderEditable(Order_Entry_Line__c oel, string orderStatus){
        string recTypeId = oel.RecordTypeId;
        Map<ID,Schema.RecordTypeInfo> oelRecordTypeMapSchema = Schema.SObjectType.Order_Entry_Line__c.getRecordTypeInfosById(); 
        
        system.debug('Release status '+ orderStatus);
        system.debug('Record Type Name : '+ oelRecordTypeMapSchema.get(recTypeId).getDeveloperName());
        
        Set<String> oerUpdateOK = new Set<String> {'Draft','Pre-Release Review', 'Confirmation Pending', 'Pre-Production', 'In Production', 'Integration Error', 'Change Confirmation Required',
        'Change Confirmed', 'Change Requested', 'Hold','Partially Shipped'};
        
        
        Set<String> oerUpdateCSSOK = new Set<String> {'Draft','Integration Error','Change Requested','Invoiced','Planned' , 'Approved-to-Ship','Change Confirmation Pending','Change Confirmation Requested','Partially Shipped'};
        
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
            //oelw.addValidationError('Update is not permitted while integration is in process');
            //hasErrors = true;
            isUpdateAllowed = false;
            system.debug('CSS_Software Status '+ isUpdateAllowed + ': Update is not permitted while integration is in process'  );
        }
        system.debug('Status '+ isUpdateAllowed );
        return isUpdateAllowed;
    }
    
    
    /**
    @ Class Name  - WrapperClass
    @ Created By - ENP Team
    @ Params -No Params
    @ Return - No Return
    @ Description - "This Class is a wrapper Class to identify selected records for update."
    **/
    public class WrapperClass {
        public Boolean checked {get;set;}
        public Order_Entry_Line__c oel{get;set;}
        public WrapperClass(Order_Entry_Line__c oel) {
            this.oel= oel;
        }
    }
    
    /**
    @ Method Name  - selectAll
    @ Created By - ENP Team
    @ Params -No Params
    @ Return - Void
    @ Description - "This method is used to select all records for update of Scheduled ship Date."
    **/ 
    public integer counter {get;set;}
    public void selectIndividual() {
        for(WrapperClass w : listWrapper) {
            if(w.checked){
                system.debug('CCCCCCCCCCCCCCCCCCCCCCCCCCC');
                counter += 1;
            }
        }
        system.debug('CCCCCCCCCCCCCCCCCCCCCCCCCCC'+counter);
    }
    public void selectAll() {
        if(allBool) {
            
            for(WrapperClass w : listWrapper) {
                w.checked = true;
            }
            
        } else {
            for(WrapperClass w : listWrapper) {
                w.checked = false;
            }
        }
    }   
    
    public pageReference dummyCall(){
        return null;
    }
    
    /**
    @ Method Name  - SelectSaveRecordsInlineEdit
    @ Created By - ENP Team
    @ Params -No Params
    @ Return - PageReference
    @ Description - "This method is used to update selected records for update of Scheduled ship Date."
    **/ 
    public pageReference SelectSaveRecordsInlineEdit(){
        listForSave = new List<Order_Entry_Line__c>();
        List<WrapperClass> listTempWrapper = new List<WrapperClass>();
        set<Id> headerIds =new set<Id>();
         List<Order_Entry_Release__c> oerUpdateLst=new List<Order_Entry_Release__c>();
        if(selectedName=='--None--' && isContinue){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please first select an Order Entry Release name from the dropdown list'));
            return null;
       }
        for(WrapperClass w : listWrapper) {
            if(w.checked) {
                listForSave.add(w.oel);
            } else {
                listTempWrapper.add(w);
            }
        }
        
        
       /* if(allBool){
            if(enableShipDate &&  enableRequestDate){
                if(oel1.Scheduled_Ship_Date__c != null && string.isBlank(oel1.Schedule_Ship_Date_Change_Reason__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the scheduled ship date'));
                    return null;
                }
                if(oel1.Request_Date__c != null && string.isBlank(oel1.Request_Date_Change_Reason__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the request date'));
                    return null;
                }
                
            }
            else if(enableRequestDate){
                if(oel1.Request_Date__c != null && string.isBlank(oel1.Request_Date_Change_Reason__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the request date'));
                    return null;
                }
            }
            else if(enableShipDate){
                if(oel1.Scheduled_Ship_Date__c != null && string.isBlank(oel1.Schedule_Ship_Date_Change_Reason__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the scheduled ship date'));
                    return null;
                }
            }
        }*/
        
        
        /*isshowEditTable=true;
        isShowSave=true;
        isshowprocess=true;*/
        system.debug('++++listForSave before to update+++'+listForSave);
        //system.debug('++++ Reason +++' + [select Id,Schedule_Ship_Date_Change_Reason__c from Order_Entry_Line__c where id =: listForSave[0].Id]);
       oelLines=new List<Order_Entry_Line__c>();
        for(Order_Entry_Line__c oelLine : listForSave){
            system.debug('++++ oelLine +++'+oelLine );
            if(enableRequestDate==true && enableShipDate==true){
                // if(!allBool){                    
                     if(oel1.Request_Date__c != null && string.isBlank(oel1.Request_Date_Change_Reason__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the request date'));
                        return null;
                    }
                    
                    if(oel1.Scheduled_Ship_Date__c != null && string.isBlank(oel1.Schedule_Ship_Date_Change_Reason__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the scheduled ship date'));
                        return null;
                    }
                    if(oel1.Scheduled_Ship_Date__c != null && oel1.Schedule_Ship_Date_Change_Reason__c!=null && oel1.Schedule_Ship_Date_Change_Reason__c=='Other' && string.isBlank(oel1.Schedule_Ship_Date_Change_Comments__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Scheduled Ship Date Change Comments when Other is selected as schedule ship date change reason'));
                        return null;                        
                        
                    }
                    if(oel1.Request_Date__c != null && oel1.Request_Date_Change_Reason__c!=null && oel1.Request_Date_Change_Reason__c=='Other' && string.isBlank(oel1.Request_Date_Change_Comments__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Request Date Change Comments when Other is selected as request date change reason'));
                        return null;                        
                        
                    }
                //}        
                
                if(allBool || !allBool){
                    if(oel1.Request_Date__c != null)
                    oelLine.Request_Date__c=oel1.Request_Date__c;
                    if(!string.isBlank(oel1.Request_Date_Change_Reason__c))
                    oelLine.Request_Date_Change_Reason__c=oel1.Request_Date_Change_Reason__c;
                    if(oel1.Request_Date_Change_Comments__c!=null)
                    oelLine.Request_Date_Change_Comments__c = oel1.Request_Date_Change_Comments__c;

                     if(oel1.Scheduled_Ship_Date__c != null)
                        oelLine.Scheduled_Ship_Date__c=oel1.Scheduled_Ship_Date__c;
                    if(!string.isBlank(oel1.Schedule_Ship_Date_Change_Reason__c))
                        oelLine.Schedule_Ship_Date_Change_Reason__c=oel1.Schedule_Ship_Date_Change_Reason__c;
                    if(oel1.Schedule_Ship_Date_Change_Comments__c !=null)
                        oelLine.Schedule_Ship_Date_Change_Comments__c = oel1.Schedule_Ship_Date_Change_Comments__c;
                        
                    
                }
               
            }else if(enableRequestDate==true){
                //if(!allBool){
                     if(oel1.Request_Date__c != null && string.isBlank(oel1.Request_Date_Change_Reason__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the request date'));
                        return null;
                    }
                    if(oel1.Request_Date__c != null && oel1.Request_Date_Change_Reason__c!=null && oel1.Request_Date_Change_Reason__c=='Other' && string.isBlank(oel1.Request_Date_Change_Comments__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Request Date Change Comments when Other is selected as request date change reason'));
                        return null;                        
                        
                    }
                //} 
                if(allBool || !allBool){
                    if(oel1.Request_Date__c != null)
                    oelLine.Request_Date__c=oel1.Request_Date__c;
                    if(!string.isBlank(oel1.Request_Date_Change_Reason__c))
                    oelLine.Request_Date_Change_Reason__c=oel1.Request_Date_Change_Reason__c;
                    if(oel1.Request_Date_Change_Comments__c!=null)
                        oelLine.Request_Date_Change_Comments__c = oel1.Request_Date_Change_Comments__c;
                        
                    
                }
                
            }else if(enableShipDate==true){
                //if(!allBool){
                    if(oel1.Scheduled_Ship_Date__c != null && string.isBlank(oel1.Schedule_Ship_Date_Change_Reason__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Change Reason for updating the scheduled ship date'));
                        return null;
                    }
                    if(oel1.Scheduled_Ship_Date__c != null && oel1.Schedule_Ship_Date_Change_Reason__c!=null && oel1.Schedule_Ship_Date_Change_Reason__c=='Other' && string.isBlank(oel1.Schedule_Ship_Date_Change_Comments__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Scheduled Ship Date Change Comments when Other is selected as schedule ship date change reason'));
                        return null;                        

                    }                   
                //}  
                if(allBool || !allBool){
                    if(oel1.Scheduled_Ship_Date__c != null)
                        oelLine.Scheduled_Ship_Date__c=oel1.Scheduled_Ship_Date__c;
                    if(!string.isBlank(oel1.Schedule_Ship_Date_Change_Reason__c))
                        oelLine.Schedule_Ship_Date_Change_Reason__c=oel1.Schedule_Ship_Date_Change_Reason__c;
                    if(oel1.Schedule_Ship_Date_Change_Comments__c !=null)
                        oelLine.Schedule_Ship_Date_Change_Comments__c = oel1.Schedule_Ship_Date_Change_Comments__c;
                }
                
            }
            else{}
            if(enableRequestDate && oelLine.Request_Date_Update_Needed__c)
                oelLine.Request_Date_Update_Needed__c= false;
            if(enableShipDate && oelLine.Is_Schedule_Date_Updated__c)
                oelLine.Is_Schedule_Date_Updated__c = false;
            oelLine.Trigger_Source__c='UI';
            oelLines.add(oelLine);
            UpdatedIds.add(oelLine.Id);
            //send order to integration automatically
            headerIds.add(oelline.Order_Entry_Release__c);
        }
        for(Order_Entry_Release__c  oer:getOrders){
            system.debug('@@@oerint'+oer.Integration_Status__c+''+oer.Id);
            if (headerIds.contains(oer.Id) && oer.Integration_Status__c != null && oer.Integration_Status__c != 'Requested' && oer.Integration_Status__c != 'Initial' && oer.Integration_Status__c != 'Complete' && 
                        oer.Integration_Status__c != 'Error' )
                {
                    system.debug('@@@oerint1'+oer.Integration_Status__c);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Update is not permitted while integration is in process on header'));
                    return null;
                }       
            if(headerIds.contains(oer.Id)){
                
                oer.status__c = 'Change Integration Requested';
                oer.Trigger_Source__c='UI';
                
                mapoerUpdateLst.put(oer.Id,oer);
                
                
            }
        }
        //if(!allBool){
           //if(!isChanged){
                for(Order_Entry_Line__c oelLine : listForSave){      
                    if(oelLine.Request_Date__c != mapWrapperOld.get(oelLine.id).Request_Date__c || oelLine.Scheduled_Ship_Date__c != mapWrapperOld.get(oelLine.id).Scheduled_Ship_Date__c){
                        
                        isChanged = true;
                    }
                    else{
                        if(!Test.isRunningTest())
                        DisplayPageBlock = true;
                    }
                    
                    
                }
           // }
            
            
            if(DisplayPageBlock){
                
                //isContinue= false;
                DisplayPageBlock = true; 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have indicated the date for one or more lines should stay the same. Please click "Confirm" to approve current dates otherwise click "Cancel".'));           
                
                
                return null;
            }
        //}
        system.debug('++++oellines to update+++'+oelLines);
        system.debug('++++listForSave to update+++'+listForSave);
        if(listForSave.size() > 0) {
            
            isshowEditTable=true;
            isShowSave=true;
            isshowprocess=true;
            
            try{
                if(!DisplayPageBlock)
                update oelLines;
                system.debug('++++oellines to update1+++'+oelLines);
                if(isContinue && isChanged && !DisplayPageBlock)
                {
                    //isReadHeader = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successful'));
                    selectedReferenceId = '--None--';       
                    selectedSKU = '--None--';
                    if(!DisplayPageBlock)
                    orderItemReferenceonLoadMethod();
                    return null;
                }
               if(!mapoerUpdateLst.isEmpty() && isChanged && !DisplayPageBlock)
                   update mapoerUpdateLst.values();
                String urlRedirect='/';
                PageReference pageRef = new PageReference(urlRedirect+oppId);
                pageRef.setRedirect(true);
                if(!DisplayPageBlock)
                return pageRef;
                
                
            }catch(DMLException de) { 
                ApexPages.addMessages(de); 
                return NULL;
            }
        }
        else if(!updatedlistWrapper.isEmpty() && !isContinue)
        {
            if(isChanged)
            update mapoerUpdateLst.values();
            PageReference pageRef = new PageReference('/'+oppId);
            pageRef.setRedirect(true);
            if(!DisplayPageBlock)
            return pageRef;
        }
        else{
            if(enableShipDate==true || enableRequestDate==true){
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Order Entry Line to update'));
                return null;
            }
        }
        
        return null;       
    }
    public void orderItemReferenceonLoadMethod(){
        //system.debug('@@selectedName@@'+selectedName);
        
        listWrapper = new List<WrapperClass>();
        mapWrapperOld = new Map<Id,Order_Entry_Line__c>();
        oel1 = new Order_Entry_Line__c();
        oel1.RecordTypeId= Schema.SObjectType.Order_Entry_Line__c.getRecordTypeInfosByName().get('Control Hardware').getRecordTypeId();//'0120h000000QiWj'; 
        allBool = false;
        listWrapperNonEditable = new List<WrapperClass>();
        
        if(selectedName=='--None--'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please first select an Order Entry Release name from the dropdown list'));
             
       }
       if(isContinue){
            releaseNames.clear();
            releaseNames.add(new SelectOption(selectedName,selectedName));
       }
        //if(selectedReferenceId=='--None--'){
          //  selectedReferenceId=null;
       // }
        List<String> statuses=(Label.CSS_OERMassUpdateNotAllowed).split(',');
        Set<String> uniqueStatus = new Set<String>();
        uniqueStatus.AddAll(statuses);
        
        string oelQuery = 'select Id,Previous_Scheduled_Ship_Date__c,Previous_Request_Ship_Date__c,Product_Description__c,Request_Date_Update_Needed__c,Is_Schedule_Date_Updated__c,Integration_Status__c,Order_Entry_Release__c,RecordTypeId,Order_Entry_Release__r.Status__c ,Quantity__c,SKU__C,Request_Date_Change_Reason__c,Schedule_Ship_Date_Change_Reason__c, Status__c,Request_Date__c,Request_Date_Change_Comments__c ,Schedule_Ship_Date_Change_Comments__c,Name,Reference_ID__c,Customer_Reference_Description__c,Scheduled_Ship_Date__c, Order_Entry_Release__r.Release_Name__c from Order_Entry_Line__c';
        
        
        oelQuery += ' WHERE  RecordType.DeveloperName = \''+ Label.CSS_Hardware +'\' and Order_Entry_Release__r.Opportunity__c = \''+oppId+'\'';
        
        string whereFilters = '';
        system.debug('selectedReferenceId@@' + selectedReferenceId);
        String refId;
        if(selectedReferenceId!=null && selectedReferenceId!='--None--'){
             refId = String.escapeSingleQuotes(selectedReferenceId);
            whereFilters += ' and Customer_Reference_Description__c = \''+ refId +'\'';
        }
        
        system.debug('selectedName' + selectedName);
        if(selectedName!=null && selectedName!='--None--')
            whereFilters += ' and Order_Entry_Release__r.Release_Name__c = \''+ selectedName +'\'';
        
        system.debug('selectedSKU' + selectedSKU);
        system.debug('@@enableRequestDate@'+enableRequestDate);
        system.debug('@@enableRequestDate@'+enableShipDate);
        system.debug('@@requestDateUpdateCheck@'+requestDateUpdateCheck);
        system.debug('@@scheduledDateUpdateCheck@'+scheduledDateUpdateCheck);
        if(selectedSKU!=null && selectedSKU != '--None--')
            whereFilters += ' and SKU__C = \''+ selectedSKU +'\'';
        /*if(requestDateUpdateCheck ==false){
            whereFilters += ' and Request_Date_Update_Needed__c = false';           
        }*/
        if(requestDateUpdateCheck ==true){
            whereFilters += ' and Request_Date_Update_Needed__c = true';            
        }
        /*if(enableShipDate==true && scheduledDateUpdateCheck ==false){
            whereFilters += ' and Is_Schedule_Date_Updated__c = false';         
        }*/
        if(scheduledDateUpdateCheck ==true){
            whereFilters += ' and Is_Schedule_Date_Updated__c = true';          
        }
        system.debug('Query Val' + oelQuery);
        system.debug('whereFilters' + whereFilters);
        oelQuery += whereFilters;
        system.debug('Query Val Final@@' + oelQuery);
        oelQuery = oelQuery + ' limit 400';
        List<Order_Entry_Line__c> oelList = new List<Order_Entry_Line__c>();
        oelList = Database.query(oelQuery);
         system.debug('++oel++'+oelList );
         if(selectedName=='--None--'){
         releaseNames.clear();
         releaseNames.add(new SelectOption('--None--','--None--'));
         }
         if(selectedReferenceId=='--None--'){            
         referenceIds.clear();      
         referenceIds.add(new SelectOption('--None--','--None--'));
         }
         if(selectedSKU=='--None--'){
         productSKU=new List<SelectOption>();
         productSKU.add(new SelectOption('--None--','--None--'));
         }
        //Set<String> orderentryNameset = new Set<String>();
        Set<String> uniqueReferenceIds = new Set<String>();
        Set<String> unitqueOERName = new Set<String>();
        set<String> uniqueprodSkuset  = new set<String>();
        Map<String,String> referenceList=new Map<String,String>();
        for(Order_Entry_Line__c oel:  oelList){
            system.debug('@@oel.Order_Entry_Release__r.Release_Name__c@@'+oel.Order_Entry_Release__r.Release_Name__c);
            system.debug('unitqueOERName Set@@'+unitqueOERName);
            //orderentryNameset.add(oel.Order_Entry_Release__r.Release_Name__c);
            if(selectedName=='--None--'){
                if(oel.Order_Entry_Release__c!=null && !unitqueOERName.contains(oel.Order_Entry_Release__r.Release_Name__c)){
                    system.debug('@@unitqueOERName@@'+unitqueOERName);
                releaseNames.add(new SelectOption(oel.Order_Entry_Release__r.Release_Name__c,oel.Order_Entry_Release__r.Release_Name__c));
                unitqueOERName.add(oel.Order_Entry_Release__r.Release_Name__c);

                }
            }
            if(oel.SKU__C!=null){
                
                if(!uniqueprodSkuset.contains(oel.SKU__C)){
                if(selectedSKU=='--None--')
                productSKU.add(new SelectOption(oel.SKU__C,oel.SKU__C));
                uniqueprodSkuset.add(oel.SKU__C);
                }
            }
            
             
            boolean isEditable = isHeaderEditable(oel,oel.Order_Entry_Release__r.Status__c);
           system.debug('Integration Status : '+ oel.Integration_Status__c);
           system.debug('Change Reason : '+ oel.Request_Date_Change_Reason__c);
           system.debug('IsEditable Val : '+ isEditable );
            if(!isEditable && oel.status__c!='Cancelled' && !oel.status__c.contains('Cancel')){
                listWrapperNonEditable.add(new WrapperClass(oel));
            }
            else{
                if(oel.status__c!='Cancelled' && !oel.status__c.contains('Cancel')){
                    if(uniqueStatus.contains(oel.Status__c)){               
                        listWrapperNonEditable.add(new WrapperClass(oel));
                    }
                    else{
                        
                        system.debug('Release status Editable '+ oel.Order_Entry_Release__r.Status__c);
                        
                        if(!UpdatedIds.contains(oel.Id)){
                            if(processHeaders .contains(oel.Order_Entry_Release__r.Release_Name__c))
                            {
                                listWrapperNonEditable.add(new WrapperClass(oel));
                            }
                            else{
                                listWrapper.add(new WrapperClass(oel));   
                                Order_Entry_Line__c oelClone  = oel.clone(false, false, false, false);
                                mapWrapperOld.put(oel.Id, oelClone);
                            }
                        }
                        else{
                            mapUpdatedOEL.put(oel.Id,new WrapperClass(oel));   
                            updatedlistWrapper=mapUpdatedOEL.values();
                        }

                    }
                }               
            }
            if(oel.Customer_Reference_Description__c<>null && !referenceList.containsKey(oel.Customer_Reference_Description__c)){
                    if(!uniqueReferenceIds.contains(oel.Reference_ID__c)){
                        if(selectedReferenceId=='--None--')
                        referenceIds.add(new SelectOption(oel.Customer_Reference_Description__c,oel.Customer_Reference_Description__c));
                    }   

             
                    uniqueReferenceIds.add(oel.Customer_Reference_Description__c);
                    
                }
                referenceList.put(oel.Customer_Reference_Description__c,oel.Customer_Reference_Description__c);
                
        }
        /*if(!orderentryNameset.isEmpty()){
            for(String st: orderentryNameset){
                if(selectedName=='--None--')
                releaseNames.add(new SelectOption(st,st));
                

            }
            
            
        }     */  
        
            isshowEdit=true;
            isshowprocess=true;
            isIntial = false;
            isContinue = false;
    }
    public pageReference resetData() {
        
        if(!updatedlistWrapper.isEmpty())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please click on "Update Dates & Finish" because some Order Entry Lines have been updated'));
            return null;
        }
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
     public pageReference CancelFunc() {
            
        if(!updatedlistWrapper.isEmpty())
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please click on "Update Dates & Finish" because some Order Entry Lines have been updated'));
            return null;
        }
        PageReference pageRef = new PageReference('/'+oppId);
        pageRef.setRedirect(true);
        return pageRef;
    }
     public pageReference approvedDates() {
         DisplayPageBlock= false;
         validationMsg  = false;
        /*listForSave = new List<Order_Entry_Line__c>();    
        if(isChanged)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please click on Finish button because few records already updated'));
            return null;
        }
        for(WrapperClass w : listWrapper) {
            if(w.checked ) {
                if(w.checked && w.oel.Request_Date_Update_Needed__c)
                w.oel.Request_Date_Update_Needed__c= false;
                if(w.checked && w.oel.Is_Schedule_Date_Updated__c)
                w.oel.Is_Schedule_Date_Updated__c = false;
                listForSave.add(w.oel);
            } 
        }
        if(!listForSave.isEmpty())
            update listForSave;
        PageReference pageRef = new PageReference('/'+oppId);
        pageRef.setRedirect(true);
        return pageRef;*/
         update oelLines;
         for(Order_Entry_Line__c oelLine : listForSave){      
                    if(oelLine.Request_Date__c != mapWrapperOld.get(oelLine.id).Request_Date__c || oelLine.Scheduled_Ship_Date__c != mapWrapperOld.get(oelLine.id).Scheduled_Ship_Date__c){
                        
                        isChanged = true;
                    }
                    else{
                        mapUpdatedOEL.put(oelLine.Id,new WrapperClass(oelLine));   
                        updatedlistWrapper=mapUpdatedOEL.values();
                        
                    }
                    
                    
                }
        if(isContinue){
        selectedReferenceId = '--None--';       
                    selectedSKU = '--None--';
                    //isContinue=true;
                    orderItemReferenceonLoadMethod();
                    return null;
       }
       else{
            if(!updatedlistWrapper.isEmpty() && isChanged)           
            update mapoerUpdateLst.values();
           PageReference pageRef = new PageReference('/'+oppId);
            pageRef.setRedirect(true);
            return pageref;
       }
    }
    public PageReference GoBack()
    {
        DisplayPageBlock= false;
        //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        //pageRef.setRedirect(true);
        //return pageRef;
        return null;
    }
    
}