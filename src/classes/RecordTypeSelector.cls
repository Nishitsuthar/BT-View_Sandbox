/*
 * RecordTypeSelector : This class is used in lightning component : CreateCase,CreateIssue,CreateCaseFromCustomerSite
 */
public with Sharing class RecordTypeSelector{    
/*
* This function will fetch the RecordTypes of
* provided object and will return a map of
* recordTypeId and recordTypeNames
* it excludes 'master' record type
* */
    public static Map<Id, String> recordtypemap;
    @AuraEnabled        
    /*
    fetchRecordTypeValues : retuns record type id with its name for object selected
    */
    public static Map<Id, String> fetchRecordTypeValues(String objectName,string defaultRecordType){
        List<Schema.RecordTypeInfo> recordtypes = new List<Schema.RecordTypeInfo>();
       
        try{
            recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();    
            recordtypemap = new Map<Id, String>();
            string defaultRecordtypeId,defaultRecordtypeLabel;
            for(RecordTypeInfo rt : recordtypes){
                //check for active record type and it should be available for selected user.
                if(rt.isAvailable() && rt.isActive() && !rt.isMaster() && rt.getName().trim() != ''){
                    if(rt.getDeveloperName() != defaultRecordType){
                      
                            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
                        
                        
                    }
                    else{
                        defaultRecordtypeId = rt.getRecordTypeId();
                        defaultRecordtypeLabel =  rt.getName();
                    }
                }
            }
           
            if(defaultRecordtypeId != null && defaultRecordtypeLabel != null){
                recordtypemap.put(defaultRecordtypeId, defaultRecordtypeLabel);
            }
            system.debug(recordtypemap.size());
            system.debug(recordtypemap);
        }
        catch(Exception e){}
        return recordtypemap;
    }
    
     @AuraEnabled        
    public static Map<Id, String> fetchRecordTypeValuesforcustomersite(String objectName,string defaultRecordType){
        List<Schema.RecordTypeInfo> recordtypes = new List<Schema.RecordTypeInfo>();
        string Rtypes = system.label.Case_Record_types_for_Custom_sites;
        list<string> Rlist=Rtypes.split(',');
        set<string> Rset=New set<string>();
        Rset.addall(Rlist);
        system.debug('objectName---'+objectName);
        try{
            recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();    
            recordtypemap = new Map<Id, String>();
            string defaultRecordtypeId,defaultRecordtypeLabel;
            for(RecordTypeInfo rt : recordtypes){
                //check for active record type and it should be available for selected user.
                if(rt.isAvailable() && rt.isActive() && !rt.isMaster() && rt.getName().trim() != ''){
                    if(rt.getDeveloperName() != defaultRecordType){
                        if(Rset.contains(rt.getDeveloperName())){
                            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
                        }
                        
                    }
                    else{
                        defaultRecordtypeId = rt.getRecordTypeId();
                        defaultRecordtypeLabel =  rt.getName();
                    }
                }
            }
            system.debug(recordtypemap.size());
            if(defaultRecordtypeId != null && defaultRecordtypeLabel != null){
                recordtypemap.put(defaultRecordtypeId, defaultRecordtypeLabel);
            }
            system.debug(recordtypemap.size());
            system.debug(recordtypemap);
        }
        catch(Exception e){}
        return recordtypemap;
    }
    
    @AuraEnabled     
    /*
     * getOpportunityDetail : User in lightning component CreateCase to get the opportunitydetail to be auto populated
     */ 
    public static Opportunity getOpportunityDetail(String opportunityId){
        Opportunity oppDetails = new opportunity();
        try{
            if(opportunityId != null){
                oppDetails =[select id,AccountId from Opportunity where id=: opportunityId];
            }
        }
        catch(Exception e){}
        return oppDetails;
    }
    /*
     * getCustomerSiteDetail: User in lightning component CreateCaseFromcustomerSite to get the Customer site detail
     *  to be auto populated
     */
    @AuraEnabled     
    public static Building_Account__c getCustomerSiteDetail(String customerSiteId){
        Building_Account__c caseDetails = new Building_Account__c();
        try{
            if(customerSiteId != null){
                caseDetails =[select id,Opportunity__c,Account__c from Building_Account__c where id=: customerSiteId];
            }
        }
        catch(Exception e){}
        return caseDetails;
    }    
    /*
     * getIssueDetail : User in lightning component CreateIssue to get the work order detail to be auto populated
     */
    @AuraEnabled     
    public static WorkOrder getIssueDetail(String workOrderId){
        WorkOrder workOrderDetails= new WorkOrder();
        try{
            if(workOrderId!= null){
                workOrderDetails =[select id,CaseId,Case.Intelligence_Start_Date__c,Case.AccountId,Case.Account.Shippingcity,
                Case.Account.ShippingState,Case.ContactId ,Case.Account.ShippingCountry,Case.Account.ShippingPostalCode,Case.Account.ShippingStreet
                from WorkOrder where id=: workOrderId];
            }
        }
        catch(Exception e){}
        return workOrderDetails;
    }
    /*
     * getCaseDetailForIssue : User in lightning component CreateIssue to get the case detail to be auto populated
     */
    @AuraEnabled     
    public static Case getCaseDetailForIssue(String CaseId){
        Case CaseDetails= new Case();
        try{
            if(CaseId!= null){
                CaseDetails =[select id,Opportunity__c,Intelligence_Start_Date__c,AccountId,ContactId,Account.Shippingcity,
                Account.ShippingState,Account.ShippingCountry,Account.ShippingPostalCode,Account.ShippingStreet
                from Case where id=: CaseId];
            }
        }
        catch(Exception e){}
        return CaseDetails;
    }    
}